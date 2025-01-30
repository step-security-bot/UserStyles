# Function to check if a file contains "@preprocessor"
function Contains-Preprocessor {
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

# Get all files in the current directory and subdirectories
$files = Get-ChildItem -File

# List of files to format and files to skip
$filesToFormat = @()
$filesToSkip = @()

foreach ($file in $files) {
    if ($file.Extension -eq '.css' -and (Contains-Preprocessor -filePath $file.FullName -eq $true)) {
        $filesToSkip += $file.FullName
    } else {
        $filesToFormat += $file.FullName
    }
}

# Output the files to skip
Write-Host "Files that will be skipped (contain '@preprocessor' in '.css' files):"
foreach ($file in $filesToSkip) {
    Write-Host $file
}

# Ask for user confirmation before proceeding
$confirmation = Read-Host -Prompt "Do you want to continue with formatting the remaining files? (y/n)"
if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
    # Format the files
    Write-Host "`nFormatting the remaining files:"
    foreach ($file in $filesToFormat) {
        Write-Host "Formatting file: $file"
        npx prettier --write $file
    }
} else {
    Write-Host "Formatting operation canceled by user."
}
