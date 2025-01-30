# Function to check if a file contains "@preprocessor"
function Test-Preprocessor {
	param (
			[string]$filePath
	)
	$content = Get-Content -Path $filePath
	foreach ($line in $content) {
			if ($line -like '*@preprocessor*') {
					return $true
			}
	}
	return $false
}

# Get all files in the current directory (add -Recurse for subdirectories)
$files = Get-ChildItem -File

# List of files to format and files to skip
$filesToFormat = @()
$filesToSkip = @()

foreach ($file in $files) {
	if (($file.Extension -eq '.css' -and (Test-Preprocessor -filePath $file.FullName -eq $true)) -or $file.Extension -eq '.gitignore') {
			$filesToSkip += $file.FullName
	} else {
			$filesToFormat += $file.FullName
	}
}

# Output the files to skip
Write-Host "Files that will be skipped (contain '@preprocessor' in '.css' files or are .gitignore files):"
foreach ($file in $filesToSkip) {
	Write-Host $file
}

# Ask for user confirmation before proceeding
$confirmation = Read-Host -Prompt "Do you want to continue with formatting the remaining files? (y/n)"
if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
	# Format the files in parallel
	Write-Host "`nFormatting the remaining files:"
	$jobs = @()
	foreach ($file in $filesToFormat) {
			Write-Host "Queuing formatting job for file: $file"
			$jobs += Start-Job -ScriptBlock {
					param($filePath)
					$env:NODE_NO_WARNINGS = 1
					npx prettier --write $filePath
			} -ArgumentList $file
	}

	# Wait for all jobs to complete
	$jobs | ForEach-Object { $_ | Wait-Job | Receive-Job }
	Write-Host "Formatting completed."
} else {
	Write-Host "Formatting operation canceled by user."
}
