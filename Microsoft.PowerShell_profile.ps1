
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# Alias section
New-Alias boottime BootDate
New-Alias upsince BootDate
New-Alias starttime BootDate
New-Alias initdate BootDate
New-Alias poweron BootDate
New-Alias startup BootDate
New-Alias bootup BootDate
New-Alias systemstart BootDate
New-Alias poweruptime BootDate

New-Alias fixwindows Fix-All
New-Alias repairwindows Fix-All
New-Alias unfuckwindows Fix-All
New-Alias repairall Fix-All
New-Alias dismrestore Fix-All
New-Alias dismfix Fix-All

New-Alias wingetupdateall WingetUpdate
New-Alias wgu WingetUpdate

New-Alias beautifyps Edit-DTWBeautifyScript
New-Alias psbeautify Edit-DTWBeautifyScript
New-Alias powershellbeautify Edit-DTWBeautifyScript
New-Alias fixpowershellscript Edit-DTWBeautifyScript
New-Alias fixpowershellformatting Edit-DTWBeautifyScript
New-Alias fixpowershell Edit-DTWBeautifyScript
New-Alias PSBeauty Edit-DTWBeautifyScript
New-Alias beautifyscript Edit-DTWBeautifyScript
New-Alias formatpowershell Edit-DTWBeautifyScript
New-Alias formatps Edit-DTWBeautifyScript
New-Alias formatpsscript Edit-DTWBeautifyScript
New-Alias beautifypsscript Edit-DTWBeautifyScript
New-Alias psformat Edit-DTWBeautifyScript
New-Alias beautifyformat Edit-DTWBeautifyScript
New-Alias beautifycode Edit-DTWBeautifyScript
New-Alias psbeautifycode Edit-DTWBeautifyScript
New-Alias beautifyformatps Edit-DTWBeautifyScript

New-Alias prettynow pretty
New-Alias runpretty pretty
New-Alias runprettynow pretty
New-Alias prettyfiles pretty
New-Alias makepretty pretty
New-Alias beautifyfiles pretty
New-Alias prettifyfiles pretty
New-Alias makeitpretty pretty
New-Alias prettyrun pretty
New-Alias prettifyrun pretty
New-Alias beautifyrun pretty
New-Alias prettyrunfiles pretty

New-Alias notepadprofile editprofile
New-Alias editpsprofile editprofile
New-Alias editpowershellprofile editprofile
New-Alias psprofileedit editprofile
New-Alias profileedit editprofile
New-Alias profileeditor editprofile
New-Alias editprofileps editprofile
New-Alias editprofilepowershell editprofile
New-Alias profilepsedit editprofile
New-Alias profilepowershelledit editprofile
New-Alias openprofile editprofile
New-Alias editpsprofilefile editprofile
New-Alias editpowershellprofilefile editprofile
New-Alias editprofilefile editprofile

# Functions in profile:
# Remove-Images: Deletes all image files (JPG, PNG, GIF, BMP) in a specified directory.
# Clear-Temp: Clears the temporary files in $env:TEMP.
# Get-LastRun: Retrieves the last logged run of a script from a specified log file.
# Get-IPAddress: Fetches the public IP using an external API.
# Get-DiskUsage: Displays disk usage for a specified drive.
# Restart-Service: Restarts a specified Windows service.
# Show-FileSize: Shows the size of a specified file in MB.
# Convert-Size: Converts bytes to a readable format (KB, MB, GB).
# Find-ProcessByName: Lists processes that match a specified name.
# Start-Task: Starts a new task or application by command.
# Get-ProcessInfo: Lists all processes with CPU and memory information.
# Clear-EventLogs: Clears all Windows event logs.
# Get-ComputerInfo: Displays basic computer information like manufacturer, model, RAM, and OS.
# Find-LargestFiles: Finds the largest files in a specified path.
# Get-UserAccount: Retrieves a list of local user accounts.
# Export-ProcessList: Exports the list of processes to a CSV file.
# Check-ServiceStatus: Checks the status of a specified service.
# Start-ProcessAsAdmin: Runs a specified process with administrator privileges.
# Get-FileHash: Calculates the hash of a specified file.
# Schedule-Task: Creates a scheduled task with a specified time trigger.
# Get-InstalledSoftware: Lists installed software.
# Get-NetworkInfo: Displays information about network adapters.
# Show-DiskSpace: Shows disk space usage per drive.
# Kill-ProcessByName: Terminates a process by name.
# Convert-ToHtml: Creates an HTML report of files in a directory.
# Get-SystemUptime: Displays system uptime in days, hours, and minutes.
# Test-Port: Checks if a specified port is open on a host.
# Get-ProcessCPUUsage: Lists CPU usage for a specified process by name.
# Export-EventLogs: Exports specified Windows event logs to a file.
# Send-Email: Sends an email via an SMTP server.
# Fix-All: Performs a series of DISM and SFC scans to check and repair system health.
# BootDate: Retrieves the system's last boot time.
# WingetUpdate: Updates all packages using winget, including unknown ones, and displays a success message.
# pretty: Runs Prettier on all files in the current directory to format code and outputs a completion message.
# Clear-Clipboard: Clears the clipboard content.
# Get-RegistryValue: Retrieves a specified registry value and shows it if found.
# Show-DirectorySize: Calculates and displays the total size of a specified directory in MB.
# Get-Services: Lists all services on the system, showing their display names and statuses.
# Get-SystemInfo: Retrieves system information, including computer name, OS architecture, Windows version, and build.
# Get-EnvironmentVariables: Displays all environment variables with their names and values.
# Backup-Files: Copies files from a source directory to a specified destination directory for backup.
# Get-InstalledSoftware: Retrieves a list of installed software, displaying names and versions.
# Schedule-Task: Schedules a task to run a command at a specified time with system privileges.
# Get-FileHash: Computes and displays the hash of a specified file if it exists.
# editprofile: Opens the PowerShell profile in Notepad++ for editing.
# notepad++: Opens Notepad++.

function Remove-Images {
  param(
    [string]$Path = (Get-Location) # Default to current directory if no path is provided
  )

  Write-Host "Removing images from path: $Path" -ForegroundColor Yellow

  # Ensure the path exists
  if (-not (Test-Path $Path)) {
    Write-Host "The specified path does not exist: $Path" -ForegroundColor Red
    return
  }

  # Remove image files recursively from the specified path
  Write-Host "Searching for image files to remove..." -ForegroundColor Yellow
  Get-ChildItem -Path $Path -Recurse -Include *.jpg,*.jpeg,*.png,*.gif,*.bmp | Remove-Item -Force
  Write-Host "Image files removed." -ForegroundColor Green
}

function Clear-Temp {
  $tempPath = "$env:TEMP\*"
  Write-Host "Clearing temporary files from: $env:TEMP" -ForegroundColor Yellow
  Remove-Item -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "Temporary files cleared from $env:TEMP." -ForegroundColor Green
}

function Get-LastRun {
  param(
    [string]$ScriptName
  )
  $logFile = "C:\Path\To\Your\LogFile.log" # Change to your log file path
  Write-Host "Retrieving last run information for script: $ScriptName" -ForegroundColor Yellow
  Get-Content $logFile | Select-String $ScriptName | Select-Object -Last 1
}

function Get-IPAddress {
  Write-Host "Retrieving public IP address..." -ForegroundColor Yellow
  try {
    $ip = Invoke-RestMethod -Uri "https://api.ipify.org"
    Write-Host "Your public IP address is: $ip" -ForegroundColor Cyan
  } catch {
    Write-Host "Failed to retrieve IP address." -ForegroundColor Red
  }
}

function Get-DiskUsage {
  param(
    [string]$Drive = "C:"
  )

  Write-Host "Checking disk usage for drive: $Drive" -ForegroundColor Yellow
  $usage = Get-PSDrive -Name $Drive
  Write-Host "$Drive Drive Usage: $([math]::Round($usage.Used/1GB, 2)) GB used out of $([math]::Round($usage.Size/1GB, 2)) GB." -ForegroundColor Green
}

function Restart-Service {
  param(
    [string]$ServiceName
  )

  Write-Host "Restarting service: $ServiceName" -ForegroundColor Yellow
  Restart-Service -Name $ServiceName -Force
  Write-Host "Restarted service: $ServiceName" -ForegroundColor Green
}

function Show-FileSize {
  param(
    [string]$FilePath
  )

  Write-Host "Checking file size for: $FilePath" -ForegroundColor Yellow
  if (Test-Path $FilePath) {
    $size = (Get-Item $FilePath).Length
    $sizeMB = [math]::Round($size / 1MB,2)
    Write-Host ("Size of {0}: {1} MB" -f $FilePath,$sizeMB) -ForegroundColor Cyan
  } else {
    Write-Host ("File not found: {0}" -f $FilePath) -ForegroundColor Red
  }
}

function Convert-Size {
  param(
    [long]$Bytes
  )
  Write-Host "Converting size from bytes: $Bytes" -ForegroundColor Yellow
  if ($Bytes -lt 1KB) { return "$Bytes Bytes" }
  elseif ($Bytes -lt 1MB) { return "$([math]::Round($Bytes / 1KB, 2)) KB" }
  elseif ($Bytes -lt 1GB) { return "$([math]::Round($Bytes / 1MB, 2)) MB" }
  else { return "$([math]::Round($Bytes / 1GB, 2)) GB" }
}

function Find-ProcessByName {
  param(
    [string]$ProcessName
  )
  Write-Host "Finding processes by name: $ProcessName" -ForegroundColor Yellow
  Get-Process -Name $ProcessName | Format-Table Id,Name,Path
}

function Start-Task {
  param(
    [string]$Command
  )
  Write-Host "Starting task: $Command" -ForegroundColor Yellow
  Start-Process -FilePath $Command
  Write-Host "Started task: $Command" -ForegroundColor Green
}

function Get-ProcessInfo {
  Write-Host "Retrieving process information..." -ForegroundColor Yellow
  Get-Process | Select-Object Name,Id,@{ Name = 'CPU (s)'; Expression = { [math]::Round($_.CPU,2) } },@{ Name = 'Memory (MB)'; Expression = { [math]::Round($_.WorkingSet / 1MB,2) } } | Format-Table -AutoSize
}

function Clear-EventLogs {
  Write-Host "Clearing all event logs..." -ForegroundColor Yellow
  Get-EventLog -List | ForEach-Object { Clear-EventLog -LogName $_.Log }
  Write-Host "All event logs have been cleared." -ForegroundColor Green
}

function Get-ComputerInfo {
  Write-Host "Retrieving computer information..." -ForegroundColor Yellow
  Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer,Model,@{ Name = 'RAM (GB)'; Expression = { [math]::Round($_.TotalPhysicalMemory / 1GB,2) } },@{ Name = 'OS'; Expression = { (Get-WmiObject Win32_OperatingSystem).Caption } }
}

function Find-LargestFiles {
  param(
    [string]$Path,
    [int]$Count = 10 # Default to top 10 largest files
  )

  Write-Host "Finding top $Count largest files in path: $Path" -ForegroundColor Yellow
  Get-ChildItem -Path $Path -Recurse | Sort-Object Length -Descending | Select-Object -First $Count | Format-Table Name,@{ Name = 'Size (MB)'; Expression = { [math]::Round($_.Length / 1MB,2) } }
}

function Get-UserAccount {
  Write-Host "Retrieving user account information..." -ForegroundColor Yellow
  Get-LocalUser | Select-Object Name,Enabled,LastLogon | Format-Table -AutoSize
}

function Export-ProcessList {
  param(
    [string]$FilePath = "C:\Path\To\Your\Processes.csv"
  )

  Write-Host "Exporting process list to: $FilePath" -ForegroundColor Yellow
  Get-Process | Export-Csv -Path $FilePath -NoTypeInformation
  Write-Host "Process list exported to $FilePath" -ForegroundColor Green
}

function Check-ServiceStatus {
  param(
    [string]$ServiceName
  )

  Write-Host "Checking status of service: $ServiceName" -ForegroundColor Yellow
  $service = Get-Service -Name $ServiceName
  Write-Host "Service: $($service.Name) is currently $($service.Status)." -ForegroundColor Cyan
}

function Start-ProcessAsAdmin {
  param(
    [string]$FilePath
  )

  Write-Host "Starting $FilePath as administrator." -ForegroundColor Yellow
  Start-Process -FilePath $FilePath -Verb RunAs
  Write-Host "Started $FilePath as administrator." -ForegroundColor Green
}

function Get-FileHash {
  param(
    [string]$FilePath
  )

  Write-Host "Calculating file hash for: $FilePath" -ForegroundColor Yellow
  if (Test-Path $FilePath) {
    Get-FileHash -Path $FilePath | Format-Table Algorithm,Hash
  } else {
    Write-Host "File not found: $FilePath" -ForegroundColor Red
  }
}

function Schedule-Task {
  param(
    [string]$TaskName,
    [string]$Command,
    [string]$TriggerTime
  )

  Write-Host "Scheduling task '$TaskName' to run '$Command' at $TriggerTime" -ForegroundColor Yellow
  $action = New-ScheduledTaskAction -Execute $Command
  $trigger = New-ScheduledTaskTrigger -At $TriggerTime
  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -User "SYSTEM" -RunLevel Highest
  Write-Host "Scheduled task '$TaskName' created to run '$Command' at $TriggerTime." -ForegroundColor Green
}

function Get-InstalledSoftware {
  Write-Host "Retrieving installed software list..." -ForegroundColor Yellow
  Get-WmiObject -Class Win32_Product | Select-Object Name,Version,InstallDate | Format-Table -AutoSize
}

function Get-NetworkInfo {
  Get-NetAdapter | Select-Object Name,Status,MacAddress,LinkSpeed | Format-Table -AutoSize
}

function Show-DiskSpace {
  Get-PSDrive -PSProvider FileSystem | Select-Object Name,@{ Name = 'Used (GB)'; Expression = { [math]::Round($_.Used / 1GB,2) } },@{ Name = 'Free (GB)'; Expression = { [math]::Round($_.Free / 1GB,2) } },@{ Name = 'Total (GB)'; Expression = { [math]::Round($_.Used / 1GB + $_.Free / 1GB,2) } } | Format-Table -AutoSize
}

function Kill-ProcessByName {
  param(
    [string]$ProcessName
  )

  Get-Process -Name $ProcessName | Stop-Process -Force
  Write-Host "Killed process: $ProcessName" -ForegroundColor Green
}

function Convert-ToHtml {
  param(
    [string]$Path,
    [string]$OutputFile = "FileList.html"
  )

  $files = Get-ChildItem -Path $Path
  $html = $files | ConvertTo-Html -Property Name,Length,LastWriteTime -Title "File List" -PreContent "<h1>File List for $Path</h1>"
  $html | Set-Content -Path $OutputFile
  Write-Host "HTML report created: $OutputFile" -ForegroundColor Green
}

function Get-SystemUptime {
  $uptime = (Get-CimInstance -Class Win32_OperatingSystem).LastBootUpTime
  [datetime]$bootTime = [Management.ManagementDateTimeConverter]::ToDateTime($uptime)
  $uptimeDuration = New-TimeSpan -Start $bootTime -End (Get-Date)
  Write-Host "System uptime: $($uptimeDuration.Days) days, $($uptimeDuration.Hours) hours, $($uptimeDuration.Minutes) minutes." -ForegroundColor Cyan
}

function Test-PortOld {
  param(
    [string]$Host,
    [int]$Port
  )

  $tcpConnection = Test-NetConnection -ComputerName $Host -Port $Port
  if ($tcpConnection.TcpTestSucceeded) {
    Write-Host "Port $Port on $Host is open." -ForegroundColor Green
  } else {
    Write-Host "Port $Port on $Host is closed." -ForegroundColor Red
  }
}

function Get-ProcessCPUUsage {
  param(
    [string]$ProcessName
  )

  # Get all processes and perform a fuzzy search for the process name
  $processes = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$ProcessName*" }

  if ($processes) {
    foreach ($process in $processes) {
      $cpuUsage = $process | Measure-Object -Property CPU -Sum
      Write-Host ("CPU Usage for {0}: {1} seconds" -f $process.Name,$cpuUsage.Sum) -ForegroundColor Cyan
    }
  } else {
    Write-Host ("Process not found: {0}" -f $ProcessName) -ForegroundColor Red
  }
}



function Export-EventLogs {
  param(
    [string]$LogName = "Application",
    [string]$FilePath = "C:\Path\To\Your\EventLogs.evtx"
  )

  wevtutil.exe export-log $LogName $FilePath /format:evtx
  Write-Host "Exported $LogName logs to $FilePath" -ForegroundColor Green
}

function Send-Email {
  param(
    [string]$To,
    [string]$Subject,
    [string]$Body,
    [string]$SmtpServer = "smtp.yourserver.com",# Change to your SMTP server
    [string]$From = "you@yourdomain.com" # Change to your email address
  )

  $message = New-Object System.Net.Mail.MailMessage
  $message.From = $From
  $message.To.Add($To)
  $message.Subject = $Subject
  $message.Body = $Body

  $smtp = New-Object Net.Mail.SmtpClient ($SmtpServer)
  $smtp.Send($message)
  Write-Host "Email sent to $To" -ForegroundColor Green
}

function Fix-All {
  # Run the DISM commands to check, scan, and restore the health of the image
  try {
    Write-Host "Checking health of the image..."
    DISM /Online /Cleanup-Image /CheckHealth

    Write-Host "Scanning the health of the image..."
    DISM /Online /Cleanup-Image /ScanHealth

    Write-Host "Restoring the health of the image..."
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host "Running System File Checker (SFC)..."
    sfc /scannow

    # Repeat the process to ensure thoroughness
    Write-Host "Repeating the health check..."
    DISM /Online /Cleanup-Image /CheckHealth

    Write-Host "Scanning the health of the image again..."
    DISM /Online /Cleanup-Image /ScanHealth

    Write-Host "Restoring the health of the image again..."
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host "Running System File Checker (SFC) again..."
    sfc /scannow

    # Final health checks
    Write-Host "Final health check..."
    DISM /Online /Cleanup-Image /CheckHealth

    Write-Host "Final scan for health..."
    DISM /Online /Cleanup-Image /ScanHealth

    Write-Host "Final restoration of health..."
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Host "Final System File Checker (SFC) run..."
    sfc /scannow
  } catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
  }
}

# Function to display the system boot time
function BootDate {
  Write-Host "Retrieving system boot time..." -ForegroundColor Yellow
  systeminfo | findstr "System Boot Time"
  Write-Host "System boot time retrieved." -ForegroundColor Green
}

# Function to update packages using winget, including unknown packages
function WingetUpdate {
  Write-Host "Updating packages using winget, including unknown packages..." -ForegroundColor Yellow
  winget update --include-unknown
  Write-Host "Packages updated successfully." -ForegroundColor Green
}

# Function to run prettier on all files in the current directory
function pretty {
  Write-Host "Running Prettier on all files in the current directory." -ForegroundColor Yellow
  prettier --write .
  Write-Host "Finished running Prettier on all files." -ForegroundColor Green
}

# Function to clear the clipboard
function Clear-Clipboard {
  Write-Host "Clearing clipboard..." -ForegroundColor Yellow
  Set-Clipboard -Value $null
  Write-Host "Clipboard cleared." -ForegroundColor Green
}

# Function to retrieve a registry value
function Get-RegistryValue {
  param(
    [string]$Path,
    [string]$Name
  )

  Write-Host "Retrieving registry value from path: $Path, name: $Name" -ForegroundColor Yellow
  $value = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
  if ($value) {
    Write-Host "Registry value: $($value.$Name)" -ForegroundColor Cyan
  } else {
    Write-Host "Registry value not found." -ForegroundColor Red
  }
}

# Function to calculate the size of a directory
function Show-DirectorySize {
  param(
    [string]$Path
  )

  Write-Host "Calculating size of directory: $Path" -ForegroundColor Yellow
  if (Test-Path $Path) {
    $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum).Sum
    Write-Host ("Total size of directory {0}: {1} MB" -f $Path,[math]::Round($size / 1MB,2)) -ForegroundColor Cyan
  } else {
    Write-Host "Directory not found: $Path" -ForegroundColor Red
  }
}

# Function to retrieve the list of services
function Get-Services {
  Write-Host "Retrieving list of services..." -ForegroundColor Yellow
  Get-Service | Format-Table DisplayName,Status
  Write-Host "Services list retrieved." -ForegroundColor Green
}

# Function to get system information
function Get-SystemInfo {
  $os = Get-CimInstance Win32_OperatingSystem
  $cpu = Get-CimInstance Win32_Processor
  $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
  $disk = Get-CimInstance Win32_LogicalDisk

  [pscustomobject]@{
    OS = $os.Caption
    OS_Version = $os.Version
    CPU = $cpu.Name
    CPU_Cores = $cpu.NumberOfCores
    Total_Memory = [math]::Round($memory.Sum / 1GB,2)
    Disk_Space = $disk | ForEach-Object { [pscustomobject]@{ $_.DeviceID = [math]::Round($_.Size / 1GB,2) } }
  } | Format-Table -AutoSize
}

# Function to retrieve environment variables
function Get-EnvironmentVariables {
  Write-Host "Retrieving environment variables..." -ForegroundColor Yellow
  Get-ChildItem Env: | Format-Table Name,Value
  Write-Host "Environment variables retrieved." -ForegroundColor Green
}

function Backup-Files {
  param(
    [string]$SourcePath,
    [string]$DestinationPath
  )

  Write-Host "Backing up files from $SourcePath to $DestinationPath" -ForegroundColor Yellow
  Copy-Item -Path $SourcePath -Destination $DestinationPath -Recurse -Force
  Write-Host "Backup completed." -ForegroundColor Green
}

function Get-InstalledSoftware {
  Write-Host "Retrieving installed software list..." -ForegroundColor Yellow
  Get-WmiObject -Class Win32_Product | Select-Object Name,Version | Format-Table -AutoSize
}

function Schedule-Task {
  param(
    [string]$TaskName,
    [string]$Command,
    [string]$TriggerTime
  )

  Write-Host "Scheduling task '$TaskName' to run '$Command' at $TriggerTime" -ForegroundColor Yellow
  $action = New-ScheduledTaskAction -Execute $Command
  $trigger = New-ScheduledTaskTrigger -At $TriggerTime
  Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -User "SYSTEM" -RunLevel Highest
  Write-Host "Scheduled task '$TaskName' created." -ForegroundColor Green
}

function Get-FileHash {
  param(
    [string]$FilePath
  )

  Write-Host "Calculating file hash for: $FilePath" -ForegroundColor Yellow
  if (Test-Path $FilePath) {
    Get-FileHash -Path $FilePath | Format-Table Algorithm,Hash
  } else {
    Write-Host "File not found: $FilePath" -ForegroundColor Red
  }
}

function editprofile {
  Write-Host "Opening Notepad++ with your profile" -ForegroundColor Yellow
  C:\Program Files\Notepad++\notepad++.exe "C:\Users\Nick\Dropbox\PC (2)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

function notepad++ {
  Write-Host "Opening Notepad++" -ForegroundColor Yellow
  C:\Program Files\Notepad++\notepad++.exe
}

# Function to quickly open Visual Studio Code in the current directory
function Open-Code {
  code .
}

# Function to get the size of a directory
function Get-DirSize {
  param(
    [string]$path = "."
  )
  $size = (Get-ChildItem -Recurse -ErrorAction SilentlyContinue $path | Measure-Object -Property Length -Sum).Sum
  [math]::Round($size / 1MB,2)
}

# Function to list the top 10 processes by memory usage
function Get-TopProcesses {
  Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 10 | Format-Table -Property Id,ProcessName,@{ Label = "Memory (MB)"; Expression = { [math]::Round($_.WorkingSet / 1MB,2) } }
}

# Checks and displays available and used disk space for a specified drive.
function Check-DiskSpace {
  param(
    [string]$DriveLetter = "C"
  )

  Write-Host "Checking disk space on drive $DriveLetter..." -ForegroundColor Yellow
  $disk = Get-PSDrive -Name $DriveLetter
  if ($disk) {
    Write-Host ("Drive {0}: Used: {1} GB, Free: {2} GB" -f $DriveLetter,[math]::Round($disk.Used / 1GB,2),[math]::Round($disk.Free / 1GB,2)) -ForegroundColor Cyan
  } else {
    Write-Host "Drive not found." -ForegroundColor Red
  }
}

# Searches for a specified file by name in a given directory and its subdirectories.
function Search-File {
  param(
    [string]$FileName,
    [string]$DirectoryPath = "."
  )

  Write-Host "Searching for file '$FileName' in directory '$DirectoryPath'..." -ForegroundColor Yellow
  $file = Get-ChildItem -Path $DirectoryPath -Recurse -Filter $FileName -ErrorAction SilentlyContinue
  if ($file) {
    Write-Host "File found at: $($file.FullName)" -ForegroundColor Green
  } else {
    Write-Host "File not found." -ForegroundColor Red
  }
}

# Displays network adapter information, including status, IP addresses, and MAC address.
function Get-NetworkAdapterInfo {
  Write-Host "Retrieving network adapter information..." -ForegroundColor Yellow
  Get-NetAdapter | ForEach-Object {
    Write-Host "Adapter Name: $_.Name, Status: $_.Status, MAC Address: $_.MacAddress" -ForegroundColor Cyan
    $_ | Get-NetIPAddress | ForEach-Object {
      Write-Host " - IP Address: $_.IPAddress" -ForegroundColor White
    }
  }
  Write-Host "Network adapter information retrieved." -ForegroundColor Green
}

# Restarts Windows Explorer, which can help in refreshing the desktop or resolving minor issues.
function Restart-Explorer {
  Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow
  Stop-Process -Name explorer -Force
  Start-Process explorer.exe
  Write-Host "Explorer restarted." -ForegroundColor Green
}

# Deletes files in the system?s temporary folder to free up space.
function Clean-TempFiles {
  Write-Host "Cleaning temporary files..." -ForegroundColor Yellow
  Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "Temporary files cleaned." -ForegroundColor Green
}

# Pings a website to verify an active internet connection.
function Test-InternetConnection {
  param(
    [string]$Url = "www.google.com"
  )

  Write-Host "Testing internet connection..." -ForegroundColor Yellow
  if (Test-Connection -ComputerName $Url -Count 2 -Quiet) {
    Write-Host "Internet connection is active." -ForegroundColor Green
  } else {
    Write-Host "Internet connection is not available." -ForegroundColor Red
  }
}

# Changes the desktop wallpaper to a specified image file.
function Set-Wallpaper {
  param(
    [string]$ImagePath
  )

  Write-Host "Setting wallpaper to $ImagePath..." -ForegroundColor Yellow
  if (Test-Path $ImagePath) {
    Add-Type -TypeDefinition @"
      using System;
      using System.Runtime.InteropServices;
      public class Wallpaper {
          [DllImport("user32.dll", CharSet = CharSet.Auto)]
          public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
      }
"@
    [Wallpaper]::SystemParametersInfo(0x0014,0,$ImagePath,0x0001)
    Write-Host "Wallpaper set successfully." -ForegroundColor Green
  } else {
    Write-Host "Image file not found: $ImagePath" -ForegroundColor Red
  }
}

# Displays the last boot time of the system.
function Show-LastBootTime {
  Write-Host "Retrieving last boot time..." -ForegroundColor Yellow
  $bootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
  Write-Host ("Last boot time: {0}" -f $bootTime) -ForegroundColor Cyan
}

# Empties the Recycle Bin for all users on the system.
function Empty-RecycleBin {
  Write-Host "Emptying Recycle Bin..." -ForegroundColor Yellow
  (New-Object -ComObject Shell.Application).Namespace(10).Items() | ForEach-Object { $_.InvokeVerb("delete") }
  Write-Host "Recycle Bin emptied." -ForegroundColor Green
}

# Locks the workstation immediately.
function Lock-Workstation {
  Write-Host "Locking workstation..." -ForegroundColor Yellow
  rundll32.exe user32.dll,LockWorkStation
  Write-Host "Workstation locked." -ForegroundColor Green
}

# Function to monitor a log file in real-time (old)
function Monitor-LogFileOld {
  param(
    [string]$filePath
  )
  if (Test-Path $filePath) {
    Get-Content $filePath -Wait -Tail 10
  } else {
    Write-Host "File not found!"
  }
}

# Function to monitor a log file in real-time

function Monitor-LogFile {
  param(
    [string]$LogFilePath,
    [string]$Keyword
  )

  Write-Host "Monitoring $LogFilePath for occurrences of '$Keyword'..." -ForegroundColor Yellow
  if (Test-Path $LogFilePath) {
    Get-Content $LogFilePath -Wait | ForEach-Object {
      if ($_ -match $Keyword) {
        Write-Host $_ -ForegroundColor Red
      }
    }
  } else {
    Write-Host "Log file not found: $LogFilePath" -ForegroundColor Red
  }
}


# Function to search for a string in files within a directory
function Search-InFiles {
  param(
    [string]$directory,
    [string]$searchString
  )
  if (Test-Path $directory) {
    Get-ChildItem -Path $directory -Recurse -File |
    Select-String -Pattern $searchString |
    ForEach-Object {
      [pscustomobject]@{
        FilePath = $_.Path
        LineNumber = $_.LineNumber
        Line = $_.Line
      }
    } | Format-Table -AutoSize
  } else {
    Write-Host "Directory not found!"
  }
}

# Function to download a file from a URL
function Download-File {
  param(
    [string]$url,
    [string]$destinationPath
  )
  try {
    Invoke-WebRequest -Uri $url -OutFile $destinationPath
    Write-Host "File downloaded successfully to $destinationPath"
  } catch {
    Write-Host "Failed to download file: $_"
  }
}

# Function to check the status of a website
function Check-WebsiteStatus {
  param(
    [string]$url
  )
  try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    Write-Host "Website is up. Status code: $($response.StatusCode)"
  } catch {
    Write-Host "Website is down or inaccessible: $_"
  }
}

# Function to get the IP address of a hostname
function Get-IPFromHostname {
  param(
    [string]$hostname
  )
  try {
    $ip = [System.Net.Dns]::GetHostAddresses($hostname)
    Write-Host "IP Address(es) for $hostname $ip"
  } catch {
    Write-Host "Failed to resolve hostname: $_"
  }
}

# Function to archive old files in a directory
function Archive-OldFiles {
  param(
    [string]$directory,
    [int]$daysOld
  )
  $archivePath = Join-Path $directory "Archive_$(Get-Date -Format 'yyyyMMdd')"
  New-Item -ItemType Directory -Path $archivePath -Force

  Get-ChildItem -Path $directory -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(- $daysOld) } | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $archivePath
  }

  Write-Host "Files older than $daysOld days have been archived to $archivePath"
}

# Function to monitor CPU and memory usage
function Monitor-SystemUsage {
  [CmdletBinding()]
  param(
    [int]$interval = 5,
    [int]$duration = 60
  )

  $endTime = (Get-Date).AddSeconds($duration)
  while ((Get-Date) -lt $endTime) {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    $memory = Get-Counter '\Memory\Available MBytes'

    [pscustomobject]@{
      TimeStamp = Get-Date
      CPU_Usage = [math]::Round($cpu.CounterSamples.CookedValue,2)
      AvailableMemory_MB = [math]::Round($memory.CounterSamples.CookedValue,2)
    } | Format-Table -AutoSize

    Start-Sleep -Seconds $interval
  }
}

# Function to send an email with system information
function Send-SystemInfoEmail {
  param(
    [string]$to,
    [string]$from,
    [string]$smtpServer
  )

  $systemInfo = Get-SystemInfo
  $body = $systemInfo | Out-String

  $message = @{
    To = $to
    From = $from
    Subject = "System Information Report"
    Body = $body
    SmtpServer = $smtpServer
  }

  Send-MailMessage @message
  Write-Host "System information email sent to $to"
}

function Backup-And-Compress {
  param(
    [string]$SourcePath,
    [string]$DestinationFolder,
    [string]$ArchiveName = "Backup"
  )

  Write-Host "Creating compressed backup of $SourcePath..." -ForegroundColor Yellow
  if (Test-Path $SourcePath) {
    $timestamp = (Get-Date -Format "yyyyMMdd_HHmmss")
    $zipPath = Join-Path -Path $DestinationFolder -ChildPath "${ArchiveName}_$timestamp.zip"
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourcePath,$zipPath)
    Write-Host "Backup created: $zipPath" -ForegroundColor Green
  } else {
    Write-Host "Source path not found: $SourcePath" -ForegroundColor Red
  }
}

# function provides system uptime details and warns the user if the uptime exceeds a specified threshold, prompting them to restart the machine.
function Check-SystemUptime {
  param(
    [int]$RestartThresholdHours = 72
  )

  Write-Host "Checking system uptime..." -ForegroundColor Yellow
  $uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
  Write-Host ("System uptime: {0} days, {1} hours" -f $uptime.Days,$uptime.Hours) -ForegroundColor Cyan

  if ($uptime.TotalHours -ge $RestartThresholdHours) {
    Write-Host ("WARNING: System uptime exceeds {0} hours. A restart is recommended." -f $RestartThresholdHours) -ForegroundColor Red
  } else {
    Write-Host "System uptime is within acceptable range." -ForegroundColor Green
  }
}

function Update-WindowsDefender {
  Write-Host "Checking Windows Defender status and performing update if needed..." -ForegroundColor Yellow
  $status = Get-MpComputerStatus
  if ($status.AntispywareEnabled -and $status.AntivirusEnabled) {
    Write-Host "Windows Defender is enabled. Starting update..." -ForegroundColor Cyan
    Start-MpWDOScan
    Write-Host "Update completed." -ForegroundColor Green
  } else {
    Write-Host "Windows Defender is disabled or not fully enabled." -ForegroundColor Red
  }
}

function Test-NetworkLatency {
  param(
    [hashtable]$Servers = @{
      "Google DNS" = "8.8.8.8";
      "Cloudflare DNS" = "1.1.1.1";
      "OpenDNS" = "208.67.222.222";
      "Quad9 DNS" = "9.9.9.9";
      "Microsoft Azure" = "13.107.21.200";
      "Cloudflare Backup DNS" = "1.0.0.1";
      "Google (US)" = "www.google.com";
      "YouTube (US)" = "142.251.32.110";
      "GitHub" = "199.232.68.133";
      "StackOverflow" = "104.16.248.249";
      "Reddit (Fastly)" = "151.101.1.140";
      "AWS (Amazon)" = "52.95.110.1";
      "Twitter (US, Fastly)" = "151.101.65.69";
      "AWS Global DNS" = "205.251.242.103";
      "GitHub Pages (US)" = "185.199.108.153";
      "Telstra (Australia)" = "203.98.7.65";
      "TPG (Australia)" = "202.9.36.5";
      "Etisalat (UAE)" = "195.229.241.222";
      "Google (EU, Germany)" = "194.42.48.50";
      "Cloudflare EU" = "185.45.22.35";
    }
  )

  Write-Host "Testing network latency to specified servers..." -ForegroundColor Yellow
  $results = @()

  foreach ($serverName in $Servers.Keys) {
    $serverAddress = $Servers[$serverName]
    Write-Host "Pinging ${serverName} (${serverAddress})..." -ForegroundColor Cyan

    $latency = (Test-Connection -ComputerName $serverAddress -Count 5 -ErrorAction SilentlyContinue |
      Measure-Object -Property Latency -Average).Average

    if ($latency) {
      $roundedLatency = [math]::Round($latency,2)
      Write-Host "Latency to ${serverName}: $roundedLatency ms" -ForegroundColor Green
      $results += [pscustomobject]@{
        Server = $serverName
        Address = $serverAddress
        Latency = "$roundedLatency ms"
      }
    } else {
      Write-Host "Could not reach ${serverName} (${serverAddress})." -ForegroundColor Red
      $results += [pscustomobject]@{
        Server = $serverName
        Address = $serverAddress
        Latency = "Unreachable"
      }
    }
  }

  Write-Host "Latency Results" -ForegroundColor Yellow
  $results | Format-Table -AutoSize
}



# Retrieves a report of recent security-related log entries.
function Get-SecurityAuditLogs {
  param(
    [int]$Days = 7
  )

  Write-Host "Retrieving security audit logs from the past $Days days..." -ForegroundColor Yellow
  Get-EventLog -LogName Security -After (Get-Date).AddDays(- $Days) | Select-Object TimeGenerated,EntryType,Source,EventID,Message | Format-Table -AutoSize
  Write-Host "Security audit logs retrieved." -ForegroundColor Green
}

# Generates a detailed disk usage report for each folder in a specified directory, which is useful for analyzing disk space usage.
function Get-DiskUsageReport {
  param(
    [string]$Path = "."
  )

  Write-Host "Generating disk usage report for $Path..." -ForegroundColor Yellow
  if (Test-Path $Path) {
    Get-ChildItem -Path $Path -Directory | ForEach-Object {
      $size = (Get-ChildItem -Path $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
      [pscustomobject]@{
        FolderName = $_.Name
        SizeMB = [math]::Round($size / 1MB,2)
      }
    } | Sort-Object SizeMB -Descending | Format-Table -AutoSize
  } else {
    Write-Host "Directory not found: $Path" -ForegroundColor Red
  }
}

# change directory to github folder
function cdgithub {
  Write-Host "Changing to GitHub folder" -ForegroundColor Blue
  Set-Location "C:\Users\Nick\Dropbox\PC (2)\Documents\GitHub\UserStyles"
}

function Get-SystemInformationReport {
  param(
    [string]$ReportPath = "$env:USERPROFILE\Desktop\SystemReport.html"
  )

  # Gather system information
  $systemInfo = @{
    "Computer Name" = $env:COMPUTERNAME
    "User Name" = $env:USERNAME
    "OS Version" = (Get-CimInstance Win32_OperatingSystem).Caption
    "System Type" = (Get-CimInstance Win32_ComputerSystem).SystemType
    "CPU" = (Get-CimInstance Win32_Processor).Name
    "RAM (GB)" = "{0:N2}" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    "IP Address" = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet').IPAddress
    "MAC Address" = (Get-NetAdapter -Name 'Ethernet').MacAddress
    "Last Boot Time" = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
  }

  # Get list of installed software
  $installedSoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
  Select-Object DisplayName,DisplayVersion,Publisher,InstallDate |
  Where-Object { $_.DisplayName } |
  Sort-Object DisplayName

  # Get list of running services
  $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' } |
  Select-Object Name,DisplayName,Status

  # Generate HTML report
  $htmlReport = @"
<html>
<head>
    <title>System Information Report</title>
    <style>
        body { font-family: Arial, sans-serif; }
        h1 { color: #336699; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #dddddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>System Information Report</h1>
    <h2>General Information</h2>
    <table>
        <tbody>
"@

  foreach ($key in $systemInfo.Keys) {
    $htmlReport += "            <tr><th>$key</th><td>$($systemInfo[$key])</td></tr>`n"
  }

  $htmlReport += @"
        </tbody>
    </table>
    <h2>Installed Software</h2>
    <table>
        <thead>
            <tr>
                <th>Software Name</th>
                <th>Version</th>
                <th>Publisher</th>
                <th>Install Date</th>
            </tr>
        </thead>
        <tbody>
"@

  foreach ($app in $installedSoftware) {
    $installDate = if ($app.InstallDate) { [datetime]::ParseExact($app.InstallDate,'yyyyMMdd',$null) } else { 'N/A' }
    $htmlReport += "            <tr><td>$($app.DisplayName)</td><td>$($app.DisplayVersion)</td><td>$($app.Publisher)</td><td>$installDate</td></tr>`n"
  }

  $htmlReport += @"
        </tbody>
    </table>
    <h2>Running Services</h2>
    <table>
        <thead>
            <tr>
                <th>Service Name</th>
                <th>Display Name</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
"@

  foreach ($service in $runningServices) {
    $htmlReport += "            <tr><td>$($service.Name)</td><td>$($service.DisplayName)</td><td>$($service.Status)</td></tr>`n"
  }

  $htmlReport += @"
        </tbody>
    </table>
</body>
</html>
"@

  # Save the report to the specified path
  $htmlReport | Out-File -FilePath $ReportPath -Encoding UTF8
  Write-Host "System information report generated at $ReportPath" -ForegroundColor Green
}

# Function to Test Website Availability and Measure Response Time
function Test-WebsiteResponse {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Url
  )

  try {
    $request = [System.Net.WebRequest]::Create($Url)
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $response = $request.GetResponse()
    $stopwatch.Stop()

    Write-Host "Website is reachable. Response time: $($stopwatch.ElapsedMilliseconds) ms." -ForegroundColor Green

    $response.Close()
  } catch {
    Write-Host "Website is not reachable. Error: $_" -ForegroundColor Red
  }
}

# Invoke-Traceroute, performs a traceroute to a specified destination to diagnose network paths.Port 
function Invoke-Traceroute {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Destination,
    [int]$MaxHops = 30,
    [int]$Timeout = 5000
  )
  Port
  Write-Host "Tracing route to $Destination with a maximum of $MaxHops hops:`n" -ForegroundColor Cyan

  for ($ttl = 1; $ttl -le $MaxHops; $ttl++) {
    $ping = New-Object System.Net.NetworkInformation.Ping
    $options = New-Object System.Net.NetworkInformation.PingOptions ($ttl,$false)
    $buffer = ([System.Text.Encoding]::ASCII.GetBytes("Test"))
    $reply = $ping.Send($Destination,$Timeout,$buffer,$options)

    if ($reply.Status -eq "Success" -or $reply.Status -eq "TtlExpired") {
      $hostname = try {
        [System.Net.Dns]::GetHostEntry($reply.Address).HostName
      } catch {
        $reply.Address.IPAddressToString
      }
      Write-Host "$ttl`t$hostname`t$($reply.RoundtripTime) ms"
      if ($reply.Status -eq "Success") { break }
    } else {
      Write-Host "$ttl`t*`tRequest timed out."
    }
  }
}

# Test-Port, checks if a specific TCP port on a remote host is open.
function Test-Port {
  param(
    [Parameter(Mandatory = $true)]
    [string]$ComputerName,
    [Parameter(Mandatory = $true)]
    [int]$Port,
    [int]$Timeout = 5000
  )

  try {
    $address = [System.Net.Dns]::GetHostEntry($ComputerName).AddressList[0]
    $socket = New-Object System.Net.Sockets.TcpClient
    $asyncResult = $socket.BeginConnect($address,$Port,$null,$null)
    $wait = $asyncResult.AsyncWaitHandle.WaitOne($Timeout,$false)
    if ($wait -and $socket.Connected) {
      $socket.EndConnect($asyncResult)
      Write-Host "Connection to $ComputerName on port $Port succeeded." -ForegroundColor Green
      $socket.Close()
    } else {
      Write-Host "Connection to $ComputerName on port $Port timed out." -ForegroundColor Red
      $socket.Close()
    }
  } catch {
    Write-Host "Connection to $ComputerName on port $Port failed. Error: $_" -ForegroundColor Red
  }
}

# Test-MultiHostLatency, pings multiple hosts and reports their average response times.
function Test-MultiHostLatency {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Hosts,
    [int]$PingCount = 4
  )

  $results = @()

  foreach ($host in $Hosts) {
    Write-Host "Pinging $host..." -ForegroundColor Cyan
    $pingResults = Test-Connection -ComputerName $host -Count $PingCount -ErrorAction SilentlyContinue
    if ($pingResults) {
      $avgTime = ($pingResults | Measure-Object -Property ResponseTime -Average).Average
      Write-Host "Average latency to $host $avgTime ms" -ForegroundColor Green
      $results += [pscustomobject]@{
        Host = $host
        Latency = "{0:N2} ms" -f $avgTime
      }
    } else {
      Write-Host "Could not reach $host." -ForegroundColor Red
      $results += [pscustomobject]@{
        Host = $host
        Latency = "Unreachable"
      }
    }
  }

  Write-Host "`nLatency Results:" -ForegroundColor Yellow
  $results | Format-Table -AutoSize
}

# Get-SSLCertificateExpiry, checks the SSL certificate expiry date for HTTPS websites.
function Get-SSLCertificateExpiry {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Urls
  )

  foreach ($url in $Urls) {
    try {
      $request = [System.Net.HttpWebRequest]::Create($url)
      $request.Method = "GET"
      $request.AllowAutoRedirect = $false
      $request.Timeout = 5000

      $response = $request.GetResponse()
      $certificate = $request.ServicePoint.Certificate
      $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certificate

      $expiryDate = $cert2.NotAfter

      Write-Host "$url certificate expires on $expiryDate" -ForegroundColor Green
    } catch {
      Write-Host "Could not retrieve certificate information for $url. Error: $_" -ForegroundColor Red
    }
  }
}

# scans your local network by pinging IP addresses within your subnet range to identify active devices.
function Find-LocalNetworkDevices {
  param(
    [int]$Timeout = 200 # Timeout in milliseconds for each ping
  )

  # Get local IPv4 address and subnet prefix length
  $adapter = Get-NetIPAddress -AddressFamily IPv4 |
  Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.PrefixOrigin -ne 'WellKnown' }

  if (-not $adapter) {
    Write-Host "No active network adapters found." -ForegroundColor Red
    return
  }

  $ipAddress = $adapter.IPAddress
  $prefixLength = $adapter.PrefixLength

  # Calculate network address and subnet mask
  $ip = [System.Net.IPAddress]::Parse($ipAddress)
  $subnetMask = [System.Net.IPAddress]::Parse((([System.Net.IPNetwork]::Parse("$ipAddress/$prefixLength")).Netmask).ToString())

  # Get starting and ending IP addresses in the subnet
  $network = [System.Net.IPNetwork]::Parse("$ipAddress/$prefixLength")
  $startIp = [System.Net.IPAddress]::Parse(($network.Network + 1).ToString())
  $endIp = [System.Net.IPAddress]::Parse(($network.Broadcast - 1).ToString())

  # Convert IP addresses to integer for iteration
  $startIpBytes = $startIp.GetAddressBytes()
  $endIpBytes = $endIp.GetAddressBytes()

  # Reverse byte arrays manually
  [array]::Reverse($startIpBytes)
  [array]::Reverse($endIpBytes)

  # Convert reversed byte arrays to UInt32
  $startIpInt = [BitConverter]::ToUInt32($startIpBytes,0)
  $endIpInt = [BitConverter]::ToUInt32($endIpBytes,0)

  Write-Host "Scanning network for active devices..." -ForegroundColor Yellow
  $liveHosts = @()

  for ($ipInt = $startIpInt; $ipInt -le $endIpInt; $ipInt++) {
    $ipBytes = [BitConverter]::GetBytes($ipInt)
    [array]::Reverse($ipBytes) # Reverse byte order for each iteration
    $currentIp = [System.Net.IPAddress]::Parse(([System.Net.IPAddress]$ipBytes).ToString())

    # Ping the current IP address
    $pingReply = Test-Connection -ComputerName $currentIp -Quiet -Count 1 -TimeoutMilliseconds $Timeout

    if ($pingReply) {
      try {
        $hostname = ([System.Net.Dns]::GetHostEntry($currentIp)).HostName
      } catch {
        $hostname = "Unknown"
      }
      Write-Host "Active device found: $currentIp ($hostname)" -ForegroundColor Green
      $liveHosts += [pscustomobject]@{
        IPAddress = $currentIp.IPAddressToString
        HostName = $hostname
      }
    }
  }

  if ($liveHosts.Count -eq 0) {
    Write-Host "No active devices found on the network." -ForegroundColor Red
  } else {
    Write-Host "Active Devices:" -ForegroundColor Cyan
    $liveHosts | Format-Table -AutoSize
  }
}


# If your network uses a standard /24 subnet (255.255.255.0), you can use a simplified version:
function Find-LocalNetworkDevicesSimple {
  param(
    [int]$Timeout = 200 # Timeout in milliseconds for each ping
  )

  # Get the first three octets of the local IP address
  $localIp = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress
  $networkPrefix = ($localIp -split '\.')[0..2] -join '.'

  Write-Host "Scanning network $networkPrefix.0/24 for active devices..." -ForegroundColor Yellow
  $liveHosts = @()

  for ($i = 1; $i -le 254; $i++) {
    $ip = "$networkPrefix.$i"
    $pingReply = Test-Connection -ComputerName $ip -Quiet -Count 1 -TimeoutMilliseconds $Timeout

    if ($pingReply) {
      try {
        $hostname = ([System.Net.Dns]::GetHostEntry($ip)).HostName
      } catch {
        $hostname = "Unknown"
      }
      Write-Host "Active device found: $ip ($hostname)" -ForegroundColor Green
      $liveHosts += [pscustomobject]@{
        IPAddress = $ip
        HostName = $hostname
      }
    }
  }

  if ($liveHosts.Count -eq 0) {
    Write-Host "No active devices found on the network." -ForegroundColor Red
  } else {
    Write-Host "Active Devices:" -ForegroundColor Cyan
    $liveHosts | Format-Table -AutoSize
  }
}

# function reads the ARP (Address Resolution Protocol) cache on your computer to list local devices that have communicated recently. It doesn?t actively scan but provides a quick snapshot of devices previously contacted.
function Get-ARPTableDevices {
  $arpTable = arp -a | ForEach-Object {
    if ($_ -match "(\d{1,3}\.){3}\d{1,3}\s+([a-fA-F0-9-]{17})") {
      $ip,$mac = $_ -match "(\d{1,3}\.){3}\d{1,3}",$matches[0]
      [pscustomobject]@{
        IPAddress = $ip
        MacAddress = $mac
      }
    }
  }
  Write-Output $arpTable | Format-Table -AutoSize
}

# If you have Nmap installed, PowerShell can invoke it to perform a more thorough network scan.
function Discover-DevicesWithNmap {
  param(
    [string]$Subnet = "192.168.1.0/24" # Replace with your subnet if different
  )

  # Ensure nmap is installed
  if (!(Get-Command nmap -ErrorAction SilentlyContinue)) {
    Write-Host "Nmap is not installed. Please install Nmap to use this function." -ForegroundColor Red
    return
  }

  Write-Host "Scanning local network ($Subnet) with Nmap..." -ForegroundColor Yellow
  $nmapResult = & nmap -sn $Subnet | ForEach-Object {
    if ($_ -match "Nmap scan report for") {
      $host = $_ -replace "Nmap scan report for",""
    }
    elseif ($_ -match "MAC Address:") {
      $mac,$vendor = $_ -split ":",2
      [pscustomobject]@{
        Host = $host.Trim()
        MAC = $mac.Trim()
        Vendor = $vendor.Trim()
      }
    }
  }

  Write-Output $nmapResult | Format-Table -AutoSize
}

# Get-NetNeighbor retrieves information about neighbors on the local subnet if the devices support the Neighbor Discovery Protocol (NDP), such as other Windows devices.
function Find-LocalNetworkNeighbors {
  Get-NetNeighbor | Where-Object { $_.State -eq "Reachable" } | ForEach-Object {
    [pscustomobject]@{
      IPAddress = $_.IPAddress
      LinkLayerAddress = $_.LinkLayerAddress
      InterfaceAlias = $_.InterfaceAlias
    }
  } | Format-Table -AutoSize
}

# This function uses DNS Service Discovery (mDNS) to discover devices that broadcast their names (like some printers, smart devices, and Apple devices).
function Find-mDNSDevices {
  Write-Host "Discovering devices using mDNS (Multicast DNS)..."

  try {
    # Load the System.Net.DnsClient library if available (for mDNS resolution)
    $devices = Resolve-DnsName -Name "_services._dns-sd._udp.local" -Type PTR -ErrorAction SilentlyContinue
    foreach ($device in $devices) {
      Write-Host "Found device: $($device.NameHost)" -ForegroundColor Green
    }
  }
  catch {
    Write-Host "mDNS is not fully supported on this system." -ForegroundColor Red
  }
}

# PowerShell function that retrieves the ARP table and maps IP addresses to devices by resolving hostnames:
function Get-NetworkDeviceMap {
  # Retrieve ARP table entries
  $arpEntries = arp -a | ForEach-Object {
    $line = $_.Trim()
    if ($line -match '^\s*(\d{1,3}(?:\.\d{1,3}){3})\s+([-\w\.]+)\s+([-\w]+)') {
      $ipAddress = $matches[1]
      $macAddress = $matches[2]
      $type = $matches[3]

      # Resolve hostname
      $hostName = try {
        [System.Net.Dns]::GetHostEntry($ipAddress).HostName
      } catch {
        'Unknown'
      }

      # Output as PSCustomObject
      [pscustomobject]@{
        IPAddress = $ipAddress
        MacAddress = $macAddress
        Type = $type
        HostName = $hostName
      }
    }
  }

  # Display the results
  $arpEntries | Format-Table -AutoSize
}

# PowerShell function that retrieves all DNS records for a given domain and lists them in a table format:
function Get-AllDNSRecords {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Domain
  )

  $recordTypes = @('A','AAAA','CNAME','MX','NS','SOA','TXT','SRV','PTR','CAA')

  $dnsRecords = @()

  foreach ($type in $recordTypes) {
    try {
      $records = Resolve-DnsName -Name $Domain -Type $type -ErrorAction Stop
      foreach ($record in $records) {
        $data = switch ($record.Type) {
          'A' { $record.IPv4Address }
          'AAAA' { $record.IPv6Address }
          'CNAME' { $record.AliasName }
          'MX' { "$($record.Preference) $($record.Exchange)" }
          'NS' { $record.NameHost }
          'SOA' { "$($record.MName) $($record.RName) $($record.SerialNumber)" }
          'TXT' { $record.Text }
          'SRV' { "$($record.Priority) $($record.Weight) $($record.Port) $($record.Target)" }
          'PTR' { $record.PTRDomainName }
          'CAA' { "$($record.Flags) $($record.Tag) $($record.Value)" }
          default { $null }
        }

        $dnsRecords += [pscustomobject]@{
          Name = $record.Name
          Type = $record.Type
          TTL = $record.TTL
          Data = $data
        }
      }
    } catch {
      # Ignore errors for record types not present
    }
  }

  $dnsRecords | Sort-Object Get-Content | Format-Table -AutoSize
}

# PowerShell function to query various DNS records for a domain, including A, AAAA, MX, TXT, SPF, DKIM, DMARC, and other service records like _sip._tcp, etc. This function will use Resolve-DnsName to fetch these records and format them into a nice table.
function Get-DnsRecords {
  param(
    [string]$Domain = "example.com" # Change this to your target domain
  )

  Write-Host "Fetching DNS records for $Domain..." -ForegroundColor Yellow

  # Initialize an array to hold all results
  $dnsRecords = @()

  # A records (IPv4 addresses)
  $aRecords = Resolve-DnsName -Name $Domain -Type A -ErrorAction SilentlyContinue
  foreach ($record in $aRecords) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "A"
      Name = $Domain
      Value = $record.IPAddress
    }
  }

  # AAAA records (IPv6 addresses)
  $aaaaRecords = Resolve-DnsName -Name $Domain -Type AAAA -ErrorAction SilentlyContinue
  foreach ($record in $aaaaRecords) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "AAAA"
      Name = $Domain
      Value = $record.IPAddress
    }
  }

  # MX records (Mail exchange servers)
  $mxRecords = Resolve-DnsName -Name $Domain -Type MX -ErrorAction SilentlyContinue
  foreach ($record in $mxRecords) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "MX"
      Name = $Domain
      Value = "$($record.Exchange) with priority $($record.Preference)"
    }
  }

  # TXT records (including SPF, DKIM, DMARC, etc.)
  $txtRecords = Resolve-DnsName -Name $Domain -Type TXT -ErrorAction SilentlyContinue
  foreach ($record in $txtRecords) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "TXT"
      Name = $Domain
      Value = $record.Text
    }
  }

  # Service records (for example _sip._tcp for SIP servers)
  $serviceRecords = Resolve-DnsName -Name $Domain -Type SRV -ErrorAction SilentlyContinue
  foreach ($record in $serviceRecords) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "SRV"
      Name = $Domain
      Value = "$($record.Name) with priority $($record.Preference), weight $($record.Weight), port $($record.Port)"
    }
  }

  # DMARC record (_dmarc)
  $dmarcRecord = Resolve-DnsName -Name "_dmarc.$Domain" -Type TXT -ErrorAction SilentlyContinue
  foreach ($record in $dmarcRecord) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "DMARC"
      Name = "_dmarc.$Domain"
      Value = $record.Text
    }
  }

  # DKIM record (_domainkey)
  $dkimRecord = Resolve-DnsName -Name "default._domainkey.$Domain" -Type TXT -ErrorAction SilentlyContinue
  foreach ($record in $dkimRecord) {
    $dnsRecords += [pscustomobject]@{
      RecordType = "DKIM"
      Name = "default._domainkey.$Domain"
      Value = $record.Text
    }
  }

  # Format the results into a nice table
  if ($dnsRecords.Count -gt 0) {
    Write-Host "DNS Records for $Domain" -ForegroundColor Green
    $dnsRecords | Format-Table -AutoSize
  } else {
    Write-Host "No DNS records found for $Domain." -ForegroundColor Red
  }
}

function Get-Elevation {
  if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.PSVersion.Major -le 5) {
    [System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal (
      [System.Security.Principal.WindowsIdentity]::GetCurrent()
    )

    [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

    if ($currentPrincipal.IsInRole($administratorsRole)) {
      return $true
    }
    else {
      return $false
    }
  }

  if ($PSVersionTable.Platform -eq "Unix") {
    if ($(whoami) -eq "root") {
      return $true
    }
    else {
      return $false
    }
  }
}


# powershell compatibility Functions

function AddWinRMTrustLocalHost {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string]$NewRemoteHost = "localhost"
  )

  # Make sure WinRM in Enabled and Running on $env:ComputerName
  try {
    $null = Enable-PSRemoting -Force -ErrorAction Stop
  }
  catch {
    if ($PSVersionTable.PSEdition -eq "Core") {
      Import-WinModule NetConnection
    }

    $NICsWPublicProfile = @(Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 0 })
    if ($NICsWPublicProfile.Count -gt 0) {
      foreach ($Nic in $NICsWPublicProfile) {
        Set-NetConnectionProfile -InterfaceIndex $Nic.InterfaceIndex -NetworkCategory 'Private'
      }
    }

    try {
      $null = Enable-PSRemoting -Force
    }
    catch {
      Write-Error $_
      Write-Error "Problem with Enable-PSRemoting WinRM Quick Config! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  # If $env:ComputerName is not part of a Domain, we need to add this registry entry to make sure WinRM works as expected
  if (!$(Get-CimInstance Win32_Computersystem).PartOfDomain) {
    $null = reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
  }

  # Add the New Server's IP Addresses to $env:ComputerName's TrustedHosts
  $CurrentTrustedHosts = $(Get-Item WSMan:\localhost\Client\TrustedHosts).Value
  [System.Collections.ArrayList][array]$CurrentTrustedHostsAsArray = $CurrentTrustedHosts -split ','

  $HostsToAddToWSMANTrustedHosts = @($NewRemoteHost)
  foreach ($HostItem in $HostsToAddToWSMANTrustedHosts) {
    if ($CurrentTrustedHostsAsArray -notcontains $HostItem) {
      $null = $CurrentTrustedHostsAsArray.Add($HostItem)
    }
    else {
      Write-Warning "Current WinRM Trusted Hosts Config already includes $HostItem"
      return
    }
  }
  $UpdatedTrustedHostsString = $($CurrentTrustedHostsAsArray | Where-Object { ![string]::IsNullOrWhiteSpace($_) }) -join ','
  Set-Item WSMan:\localhost\Client\TrustedHosts $UpdatedTrustedHostsString -Force
}

function GetModuleDependencies {
  [CmdletBinding(DefaultParameterSetName = "LoadedFunction")]
  param(
    [Parameter(
      Mandatory = $False,
      ParameterSetName = "LoadedFunction"
    )]
    [string]$NameOfLoadedFunction,

    [Parameter(
      Mandatory = $False,
      ParameterSetName = "ScriptFile"
    )]
    [string]$PathToScriptFile,

    [Parameter(Mandatory = $False)]
    [string[]]$ExplicitlyNeededModules
  )

  if ($NameOfLoadedFunction) {
    $LoadedFunctions = Get-ChildItem Function:\
    if ($LoadedFunctions.Name -notcontains $NameOfLoadedFunction) {
      Write-Error "The function '$NameOfLoadedFunction' is not currently loaded! Halting!"
      $global:FunctionResult = "1"
      return
    }

    $FunctionOrScriptContent = Invoke-Expression $('${Function:' + $NameOfLoadedFunction + '}.Ast.Extent.Text')
  }
  if ($PathToScriptFile) {
    if (!$(Test-Path $PathToScriptFile)) {
      Write-Error "Unable to find path '$PathToScriptFile'! Halting!"
      $global:FunctionResult = "1"
      return
    }

    $FunctionOrScriptContent = Get-Content $PathToScriptFile
  }
  <#
    $ExplicitlyDefinedFunctionsInThisFunction = [Management.Automation.Language.Parser]::ParseInput($FunctionOrScriptContent, [ref]$null, [ref]$null).EndBlock.Statements.FindAll(
        [Func[Management.Automation.Language.Ast,bool]]{$args[0] -is [Management.Automation.Language.FunctionDefinitionAst]},
        $false
    ).Name
    #>

  # All Potential PSModulePaths
  $AllWindowsPSModulePaths = @(
    "C:\Program Files\WindowsPowerShell\Modules"
    "$HOME\Documents\WindowsPowerShell\Modules"
    "$HOME\Documents\PowerShell\Modules"
    "C:\Program Files\PowerShell\Modules"
    "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
    "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules"
  )

  $AllModuleManifestFileItems = foreach ($ModPath in $AllWindowsPSModulePaths) {
    if (Test-Path $ModPath) {
      Get-ChildItem -Path $ModPath -Recurse -File -Filter "*.psd1"
    }
  }

  $ModInfoFromManifests = foreach ($ManFileItem in $AllModuleManifestFileItems) {
    try {
      $ModManifestData = Import-PowerShellDataFile $ManFileItem.FullName -ErrorAction Stop
    }
    catch {
      continue
    }

    $Functions = $ModManifestData.FunctionsToExport | Where-Object {
      ![System.String]::IsNullOrWhiteSpace($_) -and $_ -ne '*'
    }
    $Cmdlets = $ModManifestData.CmdletsToExport | Where-Object {
      ![System.String]::IsNullOrWhiteSpace($_) -and $_ -ne '*'
    }

    @{
      ModuleName = $ManFileItem.BaseName
      ManifestFileItem = $ManFileItem
      ModuleManifestData = $ModManifestData
      ExportedCommands = $Functions + $Cmdlets
    }
  }
  $ModInfoFromGetCommand = Get-Command -CommandType Cmdlet,Function,Workflow

  $CurrentlyLoadedModuleNames = $(Get-Module).Name

  [System.Collections.ArrayList]$AutoFunctionsInfo = @()

  foreach ($ModInfoObj in $ModInfoFromManifests) {
    if ($AutoFunctionsInfo.ManifestFileItem -notcontains $ModInfoObj.ManifestFileItem) {
      $PSObj = [pscustomobject]@{
        ModuleName = $ModInfoObj.ModuleName
        ManifestFileItem = $ModInfoObj.ManifestFileItem
        ExportedCommands = $ModInfoObj.ExportedCommands
      }

      if ($NameOfLoadedFunction) {
        if ($PSObj.ModuleName -ne $NameOfLoadedFunction -and
          $CurrentlyLoadedModuleNames -notcontains $PSObj.ModuleName
        ) {
          $null = $AutoFunctionsInfo.Add($PSObj)
        }
      }
      if ($PathToScriptFile) {
        $ScriptFileItem = Get-Item $PathToScriptFile
        if ($PSObj.ModuleName -ne $ScriptFileItem.BaseName -and
          $CurrentlyLoadedModuleNames -notcontains $PSObj.ModuleName
        ) {
          $null = $AutoFunctionsInfo.Add($PSObj)
        }
      }
    }
  }
  foreach ($ModInfoObj in $ModInfoFromGetCommand) {
    $PSObj = [pscustomobject]@{
      ModuleName = $ModInfoObj.ModuleName
      ExportedCommands = $ModInfoObj.Name
    }

    if ($NameOfLoadedFunction) {
      if ($PSObj.ModuleName -ne $NameOfLoadedFunction -and
        $CurrentlyLoadedModuleNames -notcontains $PSObj.ModuleName
      ) {
        $null = $AutoFunctionsInfo.Add($PSObj)
      }
    }
    if ($PathToScriptFile) {
      $ScriptFileItem = Get-Item $PathToScriptFile
      if ($PSObj.ModuleName -ne $ScriptFileItem.BaseName -and
        $CurrentlyLoadedModuleNames -notcontains $PSObj.ModuleName
      ) {
        $null = $AutoFunctionsInfo.Add($PSObj)
      }
    }
  }

  $AutoFunctionsInfo = $AutoFunctionsInfo | Where-Object {
    ![string]::IsNullOrWhiteSpace($_) -and
    $_.ManifestFileItem -ne $null
  }

  $FunctionRegex = "([a-zA-Z]|[0-9])+-([a-zA-Z]|[0-9])+"
  $LinesWithFunctions = $($FunctionOrScriptContent -split "`n") -match $FunctionRegex | Where-Object { ![bool]$($_ -match "[\s]+#") }
  $FinalFunctionList = $($LinesWithFunctions | Select-String -Pattern $FunctionRegex -AllMatches).Matches.Value | Sort-Object | Get-Unique

  [System.Collections.ArrayList]$NeededWinPSModules = @()
  [System.Collections.ArrayList]$NeededPSCoreModules = @()
  foreach ($ModObj in $AutoFunctionsInfo) {
    foreach ($Func in $FinalFunctionList) {
      if ($ModObj.ExportedCommands -contains $Func -or $ExplicitlyNeededModules -contains $ModObj.ModuleName) {
        if ($ModObj.ManifestFileItem.FullName -match "\\WindowsPowerShell\\") {
          if ($NeededWinPSModules.ManifestFileItem.FullName -notcontains $ModObj.ManifestFileItem.FullName -and
            $ModObj.ModuleName -notmatch "\.WinModule") {
            $PSObj = [pscustomobject]@{
              ModuleName = $ModObj.ModuleName
              ManifestFileItem = $ModObj.ManifestFileItem
            }
            $null = $NeededWinPSModules.Add($PSObj)
          }
        }
        elseif ($ModObj.ManifestFileItem.FullName -match "\\PowerShell\\") {
          if ($NeededPSCoreModules.ManifestFileItem.FullName -notcontains $ModObj.ManifestFileItem.FullName -and
            $ModObj.ModuleName -notmatch "\.WinModule") {
            $PSObj = [pscustomobject]@{
              ModuleName = $ModObj.ModuleName
              ManifestFileItem = $ModObj.ManifestFileItem
            }
            $null = $NeededPSCoreModules.Add($PSObj)
          }
        }
        elseif ($PSVersionTable.PSEdition -eq "Core") {
          if ($NeededPSCoreModules.ModuleName -notcontains $ModObj.ModuleName -and
            $ModObj.ModuleName -notmatch "\.WinModule") {
            $PSObj = [pscustomobject]@{
              ModuleName = $ModObj.ModuleName
              ManifestFileItem = $null
            }
            $null = $NeededPSCoreModules.Add($PSObj)
          }
        }
        else {
          if ($NeededWinPSModules.ModuleName -notcontains $ModObj.ModuleName) {
            $PSObj = [pscustomobject]@{
              ModuleName = $ModObj.ModuleName
              ManifestFileItem = $null
            }
            $null = $NeededWinPSModules.Add($PSObj)
          }
        }
      }
    }
  }

  [System.Collections.ArrayList]$WinPSModuleDependencies = @()
  [System.Collections.ArrayList]$PSCoreModuleDependencies = @()
  $($NeededWinPSModules | Where-Object { ![string]::IsNullOrWhiteSpace($_.ModuleName) }) | ForEach-Object {
    $null = $WinPSModuleDependencies.Add($_)
  }
  $($NeededPSCoreModules | Where-Object { ![string]::IsNullOrWhiteSpace($_.ModuleName) }) | ForEach-Object {
    $null = $PSCoreModuleDependencies.Add($_)
  }

  [pscustomobject]@{
    WinPSModuleDependencies = $WinPSModuleDependencies
    PSCoreModuleDependencies = $PSCoreModuleDependencies
  }
}

function InvokeModuleDependencies {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [pscustomobject[]]$RequiredModules,

    [Parameter(Mandatory = $False)]
    [switch]$InstallModulesNotAvailableLocally
  )

  if ($InstallModulesNotAvailableLocally) {
    if ($PSVersionTable.PSEdition -ne "Core") {
      $null = Install-PackageProvider -Name Nuget -Force -Confirm:$False
      $null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }
    else {
      $null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }
  }

  if ($PSVersionTable.PSEdition -eq "Core") {
    $InvPSCompatSplatParams = @{
      ErrorAction = "SilentlyContinue"
      #WarningAction                       = "SilentlyContinue"
    }

    $MyInvParentScope = Get-Variable "MyInvocation" -Scope 1 -ValueOnly
    $PathToFile = $MyInvParentScope.MyCommand.Source
    $FunctionName = $MyInvParentScope.MyCommand.Name

    if ($PathToFile) {
      $InvPSCompatSplatParams.Add("InvocationMethod",$PathToFile)
    }
    elseif ($FunctionName) {
      $InvPSCompatSplatParams.Add("InvocationMethod",$FunctionName)
    }
    else {
      Write-Error "Unable to determine MyInvocation Source or Name! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if ($PSBoundParameters['InstallModulesNotAvailableLocally']) {
      $InvPSCompatSplatParams.Add("InstallModulesNotAvailableLocally",$True)
    }
    if ($PSBoundParameters['RequiredModules']) {
      $InvPSCompatSplatParams.Add("RequiredModules",$RequiredModules.Name)
    }

    $Output = InvokePSCompatibility @InvPSCompatSplatParams
  }
  else {
    [System.Collections.ArrayList]$SuccessfulModuleImports = @()
    [System.Collections.ArrayList]$FailedModuleImports = @()

    foreach ($ModuleObj in $RequiredModules) {
      $ModuleInfo = [pscustomobject]@{
        ModulePSCompatibility = "WinPS"
        ModuleName = $ModuleObj.Name
        Version = $ModuleObj.Version
      }

      if (![bool]$(Get-Module -ListAvailable $ModuleObj.Name) -and $InstallModulesNotAvailableLocally) {
        $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$($ModuleObj.Name)' and IsLatestVersion"
        $PSGalleryCheck = Invoke-RestMethod $searchUrl
        if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0 -or $ModuleObj.Version -eq "PreRelease") {
          $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$($ModuleObj.Name)'"
          $PSGalleryCheck = Invoke-RestMethod $searchUrl

          if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
            Write-Warning "Unable to find Module '$($ModuleObj.Name)' in the PSGallery! Skipping..."
            continue
          }

          $PreRelease = $True
        }

        try {
          if ($PreRelease) {
            try {
              Install-Module $ModuleObj.Name -AllowPrerelease -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
            }
            catch {
              ManualPSGalleryModuleInstall -ModuleName $ModuleObj.Name -DownloadDirectory "$HOME\Downloads" -Prerelease -ErrorAction Stop -WarningAction SilentlyContinue
            }
          }
          else {
            Install-Module $ModuleObj.Name -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
          }

          if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
            # Make sure the Module Manifest file name and the Module Folder name are exactly the same case
            $env:PSModulePath -split ':' | ForEach-Object {
              Get-ChildItem -Path $_ -Directory | Where-Object { $_ -match $ModuleObj.Name }
            } | ForEach-Object {
              $ManifestFileName = $(Get-ChildItem -Path $_ -Recurse -File | Where-Object { $_.Name -match "$($ModuleObj.Name)\.psd1" }).BaseName
              if (![bool]$($_.Name -cmatch $ManifestFileName)) {
                Rename-Item $_ $ManifestFileName
              }
            }
          }
        }
        catch {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }
      }

      if (![bool]$(Get-Module -ListAvailable $ModuleObj.Name)) {
        $ErrMsg = "The Module '$($ModuleObj.Name)' is not available on the localhost! Did you " +
        "use the -InstallModulesNotAvailableLocally switch? Halting!"
        Write-Error $ErrMsg
        continue
      }

      $ManifestFileItem = Get-Item $(Get-Module -ListAvailable $ModuleObj.Name).Path
      $ModuleInfo | Add-Member -Type NoteProperty -Name ManifestFileItem -Value $ManifestFileItem

      # Import the Module
      try {
        Import-Module $ModuleObj.Name -Scope Global -ErrorAction Stop -WarningAction SilentlyContinue
        $null = $SuccessfulModuleImports.Add($ModuleInfo)
      }
      catch {
        Write-Warning "Problem importing the $($ModuleObj.Name) Module!"
        $null = $FailedModuleImports.Add($ModuleInfo)
      }
    }

    $UnacceptableUnloadedModules = $FailedModuleImports

    $Output = [pscustomobject]@{
      SuccessfulModuleImports = $SuccessfulModuleImports
      FailedModuleImports = $FailedModuleImports
      UnacceptableUnloadedModules = $UnacceptableUnloadedModules
    }
  }

  $Output
}

function InvokePSCompatibility {
  [CmdletBinding()]
  param(
    # $InvocationMethod determines if the GetModuleDependencies function scans a file or loaded function
    [Parameter(Mandatory = $False)]
    [string]$InvocationMethod,

    [Parameter(Mandatory = $False)]
    [string[]]$RequiredModules,

    [Parameter(Mandatory = $False)]
    [switch]$InstallModulesNotAvailableLocally
  )

  #region >> Prep

  if ($PSVersionTable.PSEdition -ne "Core" -or
    $($PSVersionTable.PSEdition -ne "Core" -and $PSVersionTable.Platform -ne "Win32NT")) {
    Write-Error "This function is only meant to be used with PowerShell Core on Windows! Halting!"
    $global:FunctionResult = "1"
    return
  }

  AddWinRMTrustLocalHost

  if (!$InvocationMethod) {
    $MyInvParentScope = Get-Variable "MyInvocation" -Scope 1 -ValueOnly
    $PathToFile = $MyInvParentScope.MyCommand.Source
    $FunctionName = $MyInvParentScope.MyCommand.Name

    if ($PathToFile) {
      $InvocationMethod = $PathToFile
    }
    elseif ($FunctionName) {
      $InvocationMethod = $FunctionName
    }
    else {
      Write-Error "Unable to determine MyInvocation Source or Name! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  $AllWindowsPSModulePaths = @(
    "C:\Program Files\WindowsPowerShell\Modules"
    "$HOME\Documents\WindowsPowerShell\Modules"
    "$HOME\Documents\PowerShell\Modules"
    "C:\Program Files\PowerShell\Modules"
    "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
    "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules"
  )

  # Determine all current Locally Available Modules
  $AllLocallyAvailableModules = foreach ($ModPath in $AllWindowsPSModulePaths) {
    if (Test-Path $ModPath) {
      $ModuleBases = $(Get-ChildItem -Path $ModPath -Directory).FullName

      foreach ($ModuleBase in $ModuleBases) {
        [pscustomobject]@{
          ModuleName = $($ModuleBase | Split-Path -Leaf)
          ManifestFileItem = $(Get-ChildItem -Path $ModuleBase -Recurse -File -Filter "*.psd1")
        }
      }
    }
  }

  if (![bool]$(Get-Module -ListAvailable WindowsCompatibility)) {
    try {
      Install-Module WindowsCompatibility -ErrorAction Stop
    }
    catch {
      Write-Error $_
      Write-Error "Problem installing the Windows Compatibility Module! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }
  if (![bool]$(Get-Module WindowsCompatibility)) {
    try {
      Import-Module WindowsCompatibility -ErrorAction Stop
    }
    catch {
      Write-Error $_
      Write-Error "Problem importing the WindowsCompatibility Module! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  # Scan Script/Function/Module to get an initial list of Required Locally Available Modules
  try {
    # Below $RequiredLocallyAvailableModules is a PSCustomObject with properties WinPSModuleDependencies
    # and PSCoreModuleDependencies - both of which are [System.Collections.ArrayList]

    # If $InvocationMethod is a file, then GetModuleDependencies can use $PSCommandPath as the value
    # for -PathToScriptFile
    $GetModDepsSplatParams = @{}

    if (![string]::IsNullOrWhiteSpace($InvocationMethod)) {
      if ($PathToFile -or [bool]$($InvocationMethod -match "\.ps")) {
        if (Test-Path $InvocationMethod) {
          $GetModDepsSplatParams.Add("PathToScriptFile",$InvocationMethod)
        }
        else {
          Write-Error "'$InvocationMethod' was not found! Halting!"
          $global:FunctionResult = "1"
          return
        }
      }
      else {
        $GetModDepsSplatParams.Add("NameOfLoadedFunction",$InvocationMethod)
      }
    }
    if ($RequiredModules -ne $null) {
      $GetModDepsSplatParams.Add("ExplicitlyNeededModules",$RequiredModules)
    }

    if ($GetModDepsSplatParams.Keys.Count -gt 0) {
      $RequiredLocallyAvailableModulesScan = GetModuleDependencies @GetModDepsSplatParams
    }
  }
  catch {
    Write-Error $_
    Write-Error "Problem with enumerating Module Dependencies using GetModuleDependencies! Halting!"
    $global:FunctionResult = "1"
    return
  }

  #$RequiredLocallyAvailableModulesScan | Export-CliXml "$HOME\InitialRequiredLocallyAvailableModules.xml" -Force

  if (!$RequiredLocallyAvailableModulesScan) {
    Write-Host "InvokePSCompatibility reports that no additional modules need to be loaded." -ForegroundColor Green
    return
  }

  if ($RequiredModules) {
    # If, for some reason, the scan conducted by GetModuleDependencies did not determine
    # that $RequiredModules should be included, manually add $RequiredModules to the output
    # (i.e.$RequiredLocallyAvailableModulesScan.WinPSModuleDependencies and/or
    # $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies)
    [System.Collections.ArrayList]$ModulesNotFoundLocally = @()
    foreach ($ModuleName in $RequiredModules) {
      # Determine if $ModuleName is a PSCore or WinPS Module
      [System.Collections.ArrayList]$ModuleInfoArray = @()
      foreach ($ModPath in $AllWindowsPSModulePaths) {
        if (Test-Path "$ModPath\$ModuleName") {
          $ModuleBase = $(Get-ChildItem -Path $ModPath -Directory -Filter $ModuleName).FullName

          $ModObj = [pscustomobject]@{
            ModuleName = $ModuleName
            ManifestFileItem = $(Get-ChildItem -Path $ModuleBase -Recurse -File -Filter "*.psd1")
          }

          $null = $ModuleInfoArray.Add($ModObj)
        }
      }

      if ($ModuleInfoArray.Count -eq 0) {
        $null = $ModulesNotFoundLocally.Add($ModuleName)
        continue
      }

      foreach ($ModObj in $ModuleInfoArray) {
        if ($ModObj.ManifestItem.FullName -match "\\WindowsPowerShell\\") {
          if ($RequiredLocallyAvailableModulesScan.WinPSModuleDependencies.ManifestFileItem.FullName -notcontains
            $ModObj.ManifestFileItem.FullName
          ) {
            $null = $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies.Add($ModObj)
          }
        }
        if ($ModObj.ManifestItem.FullName -match "\\PowerShell\\") {
          if ($RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies.ManifestFileItem.FullName -notcontains
            $ModObj.ManifestFileItem.FullName
          ) {
            $null = $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies.Add($ModObj)
          }
        }
      }
    }

    # If any of the $RequiredModules are not available on the localhost, install them if that's okay
    [System.Collections.ArrayList]$ModulesSuccessfullyInstalled = @()
    [System.Collections.ArrayList]$ModulesFailedInstall = @()
    if ($ModulesNotFoundLocally.Count -gt 0 -and $InstallModulesNotAvailableLocally) {
      # Since there's currently no way to know if external Modules are actually compatible with PowerShell Core
      # until we try and load them, we just need to install them under both WinPS and PSCore. We will
      # uninstall/remove later once we figure out what actually works.
      foreach ($ModuleName in $ModulesNotFoundLocally) {
        try {
          if (![bool]$(Get-Module -ListAvailable $ModuleName) -and $InstallModulesNotAvailableLocally) {
            $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName' and IsLatestVersion"
            $PSGalleryCheck = Invoke-RestMethod $searchUrl
            if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
              $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName'"
              $PSGalleryCheck = Invoke-RestMethod $searchUrl

              if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
                Write-Warning "Unable to find Module '$ModuleName' in the PSGallery! Skipping..."
                continue
              }

              $PreRelease = $True
            }

            if ($PreRelease) {
              try {
                Install-Module $ModuleName -AllowPrerelease -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
              }
              catch {
                ManualPSGalleryModuleInstall -ModuleName $ModuleName -DownloadDirectory "$HOME\Downloads" -Prerelease -ErrorAction Stop -WarningAction SilentlyContinue
              }
            }
            else {
              Install-Module $ModuleName -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
            }

            if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
              # Make sure the Module Manifest file name and the Module Folder name are exactly the same case
              $env:PSModulePath -split ':' | ForEach-Object {
                Get-ChildItem -Path $_ -Directory | Where-Object { $_ -match $ModuleName }
              } | ForEach-Object {
                $ManifestFileName = $(Get-ChildItem -Path $_ -Recurse -File | Where-Object { $_.Name -match "$ModuleName\.psd1" }).BaseName
                if (![bool]$($_.Name -cmatch $ManifestFileName)) {
                  Rename-Item $_ $ManifestFileName
                }
              }
            }

            $null = $ModulesSuccessfullyInstalled.Add($ModuleName)
          }

          $ModObj = [pscustomobject]@{
            ModuleName = $ModuleName
            ManifestFileItem = $(Get-Item $(Get-Module -ListAvailable $ModuleName).Path)
          }

          $null = $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies.Add($ModObj)
        }
        catch {
          Write-Warning $($_ | Out-String)
          $null = $ModulesFailedInstall.Add($ModuleName)
        }

        try {
          # Make sure the PSSession Type Accelerator exists
          $TypeAccelerators = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get
          if ($TypeAccelerators.Name -notcontains "PSSession") {
            [powershell].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Add("PSSession","System.Management.Automation.Runspaces.PSSession")
          }

          $ManualPSGalleryModuleFuncAsString = ${Function:ManualPSGalleryModuleInstall}.Ast.Extent.Text

          $ManifestFileItem = Invoke-WinCommand -ComputerName localhost -ScriptBlock {
            if (![bool]$(Get-Module -ListAvailable $args[0]) -and $args[1]) {
              Invoke-Expression $args[2]

              $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$($args[0])' and IsLatestVersion"
              $PSGalleryCheck = Invoke-RestMethod $searchUrl
              if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
                $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$($args[0])'"
                $PSGalleryCheck = Invoke-RestMethod $searchUrl

                if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
                  Write-Warning "Unable to find Module '$($args[0])' in the PSGallery! Skipping..."
                  continue
                }

                $PreRelease = $True
              }

              if ($PreRelease) {
                try {
                  Install-Module $args[0] -AllowPrerelease -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
                }
                catch {
                  ManualPSGalleryModuleInstall -ModuleName $args[0] -DownloadDirectory "$HOME\Downloads" -Prerelease
                }
              }
              else {
                Install-Module $args[0] -AllowClobber -Force
              }

              if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
                # Make sure the Module Manifest file name and the Module Folder name are exactly the same case
                $env:PSModulePath -split ':' | ForEach-Object {
                  Get-ChildItem -Path $_ -Directory | Where-Object { $_ -match $args[0] }
                } | ForEach-Object {
                  $ManifestFileName = $(Get-ChildItem -Path $_ -Recurse -File | Where-Object { $_.Name -match "$($args[0])\.psd1" }).BaseName
                  if (![bool]$($_.Name -cmatch $ManifestFileName)) {
                    Rename-Item $_ $ManifestFileName
                  }
                }
              }
            }
            $(Get-Item $(Get-Module -ListAvailable $args[0]).Path)
          } -ArgumentList $ModuleName,$InstallModulesNotAvailableLocally,$ManualPSGalleryModuleFuncAsString -ErrorAction Stop -WarningAction SilentlyContinue

          if ($ManifestFileItem) {
            $null = $ModulesSuccessfullyInstalled.Add($ModuleName)

            $ModObj = [pscustomobject]@{
              ModuleName = $ModuleName
              ManifestFileItem = $ManifestFileItem
            }

            $null = $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies.Add($ModObj)
          }
        }
        catch {
          Write-Warning $($_ | Out-String)
          $null = $ModulesFailedInstall.Add($ModuleName)
        }
      }
    }

    if ($ModulesNotFoundLocally.Count -ne $ModulesSuccessfullyInstalled.Count -and !$InstallModulesNotAvailableLocally) {
      $ErrMsg = "The following Modules were not found locally, and they will NOT be installed " +
      "because the -InstallModulesNotAvailableLocally switch was not used:`n$($ModulesNotFoundLocally -join "`n")"
      Write-Error $ErrMsg
      Write-Warning "No Modules have been Imported or Installed!"
      $global:FunctionResult = "1"
      return
    }
    if ($ModulesFailedInstall.Count -gt 0) {
      if ($ModulesSuccessfullyInstalled.Count -gt 0) {
        Write-Ouptut "The following Modules were successfully installed:`n$($ModulesSuccessfullyInstalled -join "`n")"
      }
      Write-Error "The following Modules failed to install:`n$($ModulesFailedInstall -join "`n")"
      Write-Warning "No Modules have been imported!"
      $global:FunctionResult = "1"
      return
    }
  }

  #$RequiredLocallyAvailableModulesScan | Export-CliXml "$HOME\RequiredLocallyAvailableModules.xml" -Force

  # Now all required modules are available locally, so let's filter to make sure we only try
  # to import the latest versions in case things are side-by-side install
  # Do for PSCoreModules...
  $PSCoreModDeps = $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies.Clone()
  foreach ($ModObj in $PSCoreModDeps) {
    $MatchingModObjs = $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies | Where-Object {
      $_.ModuleName -eq $ModObj.ModuleName
    }

    $AllVersions = $MatchingModObjs.ManifestFileItem.FullName | ForEach-Object { $(Import-PowerShellDataFile $_).ModuleVersion } | ForEach-Object { [version]$_ }

    if ($AllVersions.Count -gt 1) {
      $VersionsSorted = $AllVersions | Sort-Object | Get-Unique
      $LatestVersion = $VersionsSorted[-1]

      $VersionsToRemove = $VersionsSorted[0..$($VersionsSorted.Count - 2)]

      foreach ($Version in $($VersionsToRemove | ForEach-Object { $_.ToString() })) {
        [array]$ModObjsToRemove = $MatchingModObjs | Where-Object {
          $(Import-PowerShellDataFile $_.ManifestFileItem.FullName).ModuleVersion -eq $Version -and $_.ModuleName -eq $ModObj.ModuleName
        }

        foreach ($obj in $ModObjsToRemove) {
          $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies.Remove($obj)
        }
      }
    }
  }
  # Do for WinPSModules
  $WinModDeps = $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies.Clone()
  foreach ($ModObj in $WinModDeps) {
    $MatchingModObjs = $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies | Where-Object {
      $_.ModuleName -eq $ModObj.ModuleName
    }

    $AllVersions = $MatchingModObjs.ManifestFileItem.FullName | ForEach-Object { $(Import-PowerShellDataFile $_).ModuleVersion } | ForEach-Object { [version]$_ }

    if ($AllVersions.Count -gt 1) {
      $VersionsSorted = $AllVersions | Sort-Object | Get-Unique
      $LatestVersion = $VersionsSorted[-1]

      $VersionsToRemove = $VersionsSorted[0..$($VersionsSorted.Count - 2)]

      foreach ($Version in $($VersionsToRemove | ForEach-Object { $_.ToString() })) {
        [array]$ModObjsToRemove = $MatchingModObjs | Where-Object {
          $(Import-PowerShellDataFile $_.ManifestFileItem.FullName).ModuleVersion -eq $Version -and $_.ModuleName -eq $ModObj.ModuleName
        }

        foreach ($obj in $ModObjsToRemove) {
          $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies.Remove($obj)
        }
      }
    }
  }

  #endregion >> Prep

  $RequiredLocallyAvailableModulesScan

  #region >> Main

  #$RequiredLocallyAvailableModulesScan | Export-CliXml "$HOME\ReqModules.xml" -Force

  # Start Importing Modules...
  [System.Collections.ArrayList]$SuccessfulModuleImports = @()
  [System.Collections.ArrayList]$FailedModuleImports = @()
  foreach ($ModObj in $RequiredLocallyAvailableModulesScan.PSCoreModuleDependencies) {
    Write-Verbose "Attempting import of $($ModObj.ModuleName)..."
    try {
      Import-Module $ModObj.ModuleName -Scope Global -NoClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue

      $ModuleInfo = [pscustomobject]@{
        ModulePSCompatibility = "PSCore"
        ModuleName = $ModObj.ModuleName
        ManifestFileItem = $ModObj.ManifestFileItem
      }
      if ([bool]$(Get-Module $ModObj.ModuleName) -and
        $SuccessfulModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName
      ) {
        $null = $SuccessfulModuleImports.Add($ModuleInfo)
      }
    }
    catch {
      Write-Verbose "Problem importing module '$($ModObj.ModuleName)'...trying via Manifest File..."

      try {
        Import-Module $ModObj.ManifestFileItem.FullName -Scope Global -NoClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue

        $ModuleInfo = [pscustomobject]@{
          ModulePSCompatibility = "PSCore"
          ModuleName = $ModObj.ModuleName
          ManifestFileItem = $ModObj.ManifestFileItem
        }
        if ([bool]$(Get-Module $ModObj.ModuleName) -and
          $SuccessfulModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName
        ) {
          $null = $SuccessfulModuleImports.Add($ModuleInfo)
        }
      }
      catch {
        $ModuleInfo = [pscustomobject]@{
          ModulePSCompatibility = "PSCore"
          ModuleName = $ModObj.ModuleName
          ManifestFileItem = $ModObj.ManifestFileItem
        }
        if ($FailedModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName) {
          $null = $FailedModuleImports.Add($ModuleInfo)
        }
      }
    }
  }
  foreach ($ModObj in $RequiredLocallyAvailableModulesScan.WinPSModuleDependencies) {
    if ($SuccessfulModuleImports.ModuleName -notcontains $ModObj.ModuleName) {
      Write-Verbose "Attempting import of $($ModObj.ModuleName)..."
      try {
        Remove-Variable -Name "CompatErr" -ErrorAction SilentlyContinue
        $tempfile = [IO.Path]::Combine([IO.Path]::GetTempPath(),[IO.Path]::GetRandomFileName())
        Import-WinModule $ModObj.ModuleName -NoClobber -Force -ErrorVariable CompatErr 2> $tempfile

        if ($CompatErr.Count -gt 0) {
          Write-Verbose "Import of $($ModObj.ModuleName) failed..."
          Remove-Module $ModObj.ModuleName -ErrorAction SilentlyContinue
          Remove-Item $tempfile -Force -ErrorAction SilentlyContinue
          throw "ModuleNotImportedCleanly"
        }

        # Make sure the PSSession Type Accelerator exists
        $TypeAccelerators = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get
        if ($TypeAccelerators.Name -notcontains "PSSession") {
          [powershell].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Add("PSSession","System.Management.Automation.Runspaces.PSSession")
        }

        Invoke-WinCommand -ComputerName localhost -ScriptBlock {
          Import-Module $args[0] -Scope Global -NoClobber -Force -WarningAction SilentlyContinue
        } -ArgumentList $ModObj.ModuleName -ErrorAction Stop

        $ModuleInfo = [pscustomobject]@{
          ModulePSCompatibility = "WinPS"
          ModuleName = $ModObj.ModuleName
          ManifestFileItem = $ModObj.ManifestFileItem
        }

        $ModuleLoadedImplictly = [bool]$(Get-Module $ModObj.ModuleName)
        $ModuleLoadedInPSSession = [bool]$(
          Invoke-WinCommand -ComputerName localhost -ScriptBlock {
            Get-Module $args[0]
          } -ArgumentList $ModObj.ModuleName -ErrorAction SilentlyContinue
        )

        if ($ModuleLoadedImplictly -or $ModuleLoadedInPSSession -and
          $SuccessfulModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName
        ) {
          $null = $SuccessfulModuleImports.Add($ModuleInfo)
        }
      }
      catch {
        Write-Verbose "Problem importing module '$($ModObj.ModuleName)'...trying via Manifest File..."

        try {
          if ($_.Exception.Message -eq "ModuleNotImportedCleanly") {
            Write-Verbose "Import of $($ModObj.ModuleName) failed..."
            throw "FailedImport"
          }

          Remove-Variable -Name "CompatErr" -ErrorAction SilentlyContinue
          $tempfile = [IO.Path]::Combine([IO.Path]::GetTempPath(),[IO.Path]::GetRandomFileName())
          Import-WinModule $ModObj.ManifestFileItem.FullName -NoClobber -Force -ErrorVariable CompatErr 2> $tempfile

          if ($CompatErr.Count -gt 0) {
            Remove-Module $ModObj.ModuleName -ErrorAction SilentlyContinue
            Remove-Item $tempfile -Force -ErrorAction SilentlyContinue
          }

          # Make sure the PSSession Type Accelerator exists
          $TypeAccelerators = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get
          if ($TypeAccelerators.Name -notcontains "PSSession") {
            [powershell].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Add("PSSession","System.Management.Automation.Runspaces.PSSession")
          }

          Invoke-WinCommand -ComputerName localhost -ScriptBlock {
            Import-Module $args[0] -Scope Global -NoClobber -Force -WarningAction SilentlyContinue
          } -ArgumentList $ModObj.ManifestFileItem.FullName -ErrorAction Stop

          $ModuleInfo = [pscustomobject]@{
            ModulePSCompatibility = "WinPS"
            ModuleName = $ModObj.ModuleName
            ManifestFileItem = $ModObj.ManifestFileItem
          }

          $ModuleLoadedImplictly = [bool]$(Get-Module $ModObj.ModuleName)
          $ModuleLoadedInPSSession = [bool]$(
            Invoke-WinCommand -ComputerName localhost -ScriptBlock {
              Get-Module $args[0]
            } -ArgumentList $ModObj.ModuleName -ErrorAction SilentlyContinue
          )

          if ($ModuleLoadedImplictly -or $ModuleLoadedInPSSession -and
            $SuccessfulModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName
          ) {
            $null = $SuccessfulModuleImports.Add($ModuleInfo)
          }
        }
        catch {
          $ModuleInfo = [pscustomobject]@{
            ModulePSCompatibility = "WinPS"
            ModuleName = $ModObj.ModuleName
            ManifestFileItem = $ModObj.ManifestFileItem
          }
          if ($FailedModuleImports.ManifestFileItem.FullName -notcontains $ModuleInfo.ManifestFileItem.FullName) {
            $null = $FailedModuleImports.Add($ModuleInfo)
          }
        }
      }
    }
  }

  #$SuccessfulModuleImports | Export-CliXml "$HOME\SuccessfulModImports.xml" -Force
  #$FailedModuleImports | Export-CliXml "$HOME\FailedModuleImports.xml" -Force

  # Now that Modules have been imported, we need to figure out which version of PowerShell we should use
  # for each Module. Modules might be able to be imported to PSCore, but NOT have all of their commands
  # available. So, let's filter out, remove, and uninstall all Modules with the least number of commands

  # Find all Modules that were successfully imported under both WinPS and PSCore
  $DualImportModules = $SuccessfulModuleImports | Group-Object -Property ModuleName | Where-Object {
    $_.Group.ModulePSCompatibility -contains "PSCore" -and $_.Group.ModulePSCompatibility -contains "WinPS"
  }
  # NOTE: The above $DualImportModules gives you something that looks like the following for each matching ModuleName
  <#
        Count Name                      Group
        ----- ----                      -----
            2 xActiveDirectory          {@{ModulePSCompatibility=PSCore; ModuleName=xActiveDirectory; ManifestFileItem=C:\Program Files\PowerShell\Modules\xActiveDi...
    #>
  # And each Group provides...
  <#
        ModulePSCompatibility ModuleName                   ManifestFileItem
        --------------------- ----------                   ----------------
        PSCore                xActiveDirectory             C:\Program Files\PowerShell\Modules\xActiveDirectory\2.19.0.0\xActiveDirectory.psd1
        WinPS                 xActiveDirectory             C:\Program Files\WindowsPowerShell\Modules\xActiveDirectory\2.19.0.0\xActiveDirectory.psd1
    #>

  foreach ($ModObjGroup in $DualImportModules) {
    $ModuleName = $ModObjGroup.Name

    # Check to see how many ExportedCommands are available in PSCore
    $PSCoreCmdCount = $($(Get-Module $ModuleName).ExportedCommands.Keys | Sort-Object | Get-Unique).Count

    # Check to see how many ExportedCommands are available in WinPS
    $WinPSCmdCount = Invoke-WinCommand -ComputerName localhost -ScriptBlock {
      $($(Get-Module $args[0]).ExportedCommands.Keys | Sort-Object | Get-Unique).Count
    } -ArgumentList $ModuleName

    if ($PSCoreCmdCount -ge $WinPSCmdCount) {
      Invoke-WinCommand -ComputerName localhost -ScriptBlock {
        Remove-Module $args[0] -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        Uninstall-Module $args[0] -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      } -ArgumentList $ModuleName

      $ObjectToRemove = $ModObjGroup.Group | Where-Object { $_.ModulePSCompatibility -eq "WinPS" }
      $null = $SuccessfulModuleImports.Remove($ObjectToRemove)
    }

    if ($PSCoreCmdCount -lt $WinPSCmdCount) {
      Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      Uninstall-Module $ModuleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

      $ObjectToRemove = $ModObjGroup.Group | Where-Object { $_.ModulePSCompatibility -eq "PSCore" }
      $null = $SuccessfulModuleImports.Remove($ObjectToRemove)
    }
  }

  if ($FailedModuleImports.Count -gt 0) {
    if ($PSVersionTable.PSEdition -ne "Core") {
      $AcceptableUnloadedModules = @("Microsoft.PowerShell.Core","WindowsCompatibility")
    }
    else {
      $AcceptableUnloadedModules = @()
    }

    [System.Collections.ArrayList]$UnacceptableUnloadedModules = @()
    foreach ($ModObj in $FailedModuleImports) {
      if ($AcceptableUnloadedModules -notcontains $ModObj.ModuleName -and
        $SuccessfulModuleImports.ModuleName -notcontains $ModObj.ModuleName
      ) {
        $null = $UnacceptableUnloadedModules.Add($ModObj)
      }
    }

    #$UnacceptableUnloadedModules | Export-CliXml "$HOME\UnacceptableUnloadedModules.xml" -Force

    if ($UnacceptableUnloadedModules.Count -gt 0) {
      $WrnMsgA = "The following Modules were not able to be loaded via implicit remoting:`n$($UnacceptableUnloadedModules.ModuleName -join "`n")"
      $WrnMsgB = "All code within '$InvocationMethod' that uses these Modules must be refactored similar to:`n" +
      "Invoke-WinCommand -ComputerName localhost -ScriptBlock {`n    <existing code>`n}"
      $WrnMsgC = "'$InvocationMethod' will probably *not* work in PowerShell Core!"
      Write-Warning $WrnMsgA
      Write-Warning $WrnMsgB
      Write-Warning $WrnMsgC
    }
  }

  # Uninstall the versions of Modules that don't work
  $AllLocallyAvailableModules = foreach ($ModPath in $AllWindowsPSModulePaths) {
    if (Test-Path $ModPath) {
      $ModuleBases = $(Get-ChildItem -Path $ModPath -Directory).FullName

      foreach ($ModuleBase in $ModuleBases) {
        [pscustomobject]@{
          ModuleName = $($ModuleBase | Split-Path -Leaf)
          ManifestFileItem = $(Get-ChildItem -Path $ModuleBase -Recurse -File -Filter "*.psd1")
        }
      }
    }
  }

  foreach ($ModObj in $SuccessfulModuleImports) {
    $ModulesToUninstall = $AllLocallyAvailableModules | Where-Object {
      $_.ModuleName -eq $ModObj.ModuleName -and
      $_.ManifestFileItem.FullName -ne $ModObj.ManifestFileItem.FullName
    }

    foreach ($ModObj2 in $ModulesToUninstall) {
      if ($ModObj2.ModuleManifestFileItem.FullName -match "\\PowerShell\\") {
        Remove-Module $ModObj2.ModuleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        Uninstall-Module $ModObj2.ModuleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      }
      if ($ModObj2.ModuleManifestFileItem.FullName -match "\\WindowsPowerShell\\") {
        Invoke-WinCommand -ComputerName localhost -ScriptBlock {
          Remove-Module $args[0] -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          Uninstall-Module $args[0] -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        } -ArgumentList $ModObj2.ModuleName
      }
    }
  }

  [pscustomobject]@{
    SuccessfulModuleImports = $SuccessfulModuleImports
    FailedModuleImports = $FailedModuleImports
    UnacceptableUnloadedModules = $UnacceptableUnloadedModules
  }
}

function ManualPSGalleryModuleInstall {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True)]
    [string]$ModuleName,

    [Parameter(Mandatory = $False)]
    [switch]$PreRelease,

    [Parameter(Mandatory = $False)]
    [string]$DownloadDirectory
  )

  if (!$DownloadDirectory) {
    $DownloadDirectory = $(Get-Location).Path
  }

  if (!$(Test-Path $DownloadDirectory)) {
    Write-Error "The path $DownloadDirectory was not found! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if (![bool]$($($env:PSModulePath -split ";") -match [regex]::Escape("$HOME\Documents\WindowsPowerShell\Modules"))) {
    $env:PSModulePath = "$HOME\Documents\WindowsPowerShell\Modules;$env:PSModulePath"
  }
  if (!$(Test-Path "$HOME\Documents\WindowsPowerShell\Modules")) {
    $null = New-Item -ItemType Directory "$HOME\Documents\WindowsPowerShell\Modules" -Force
  }

  if ($PreRelease) {
    $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName'"
  }
  else {
    $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName' and IsLatestVersion"
  }
  $ModuleInfo = Invoke-RestMethod $searchUrl
  if (!$ModuleInfo -or $ModuleInfo.Count -eq 0) {
    Write-Error "Unable to find Module Named $ModuleName! Halting!"
    $global:FunctionResult = "1"
    return
  }
  if ($PreRelease) {
    if ($ModuleInfo.Count -gt 1) {
      $ModuleInfo = $($ModuleInfo | Sort-Object -Property Updated | Where-Object { $_.properties.isPrerelease. '#text' -eq 'true' })[-1]
    }
  }

  $OutFilePath = Join-Path $DownloadDirectory $($ModuleInfo.title. '#text' + $ModuleInfo.properties.Version + '.zip')
  if (Test-Path $OutFilePath) { Remove-Item $OutFilePath -Force }

  try {
    #Invoke-WebRequest $ModuleInfo.Content.src -OutFile $OutFilePath
    # Download via System.Net.WebClient is a lot faster than Invoke-WebRequest...
    $WebClient = [System.Net.WebClient]::new()
    $WebClient.Downloadfile($ModuleInfo.Content.src,$OutFilePath)
  }
  catch {
    Write-Error $_
    $global:FunctionResult = "1"
    return
  }

  if (Test-Path "$DownloadDirectory\$ModuleName") { Remove-Item "$DownloadDirectory\$ModuleName" -Recurse -Force }
  Expand-Archive $OutFilePath -DestinationPath "$DownloadDirectory\$ModuleName"

  if ($DownloadDirectory -ne "$HOME\Documents\WindowsPowerShell\Modules") {
    if (Test-Path "$HOME\Documents\WindowsPowerShell\Modules\$ModuleName") {
      Remove-Item "$HOME\Documents\WindowsPowerShell\Modules\$ModuleName" -Recurse -Force
    }
    Copy-Item -Path "$DownloadDirectory\$ModuleName" -Recurse -Destination "$HOME\Documents\WindowsPowerShell\Modules"

    Remove-Item "$DownloadDirectory\$ModuleName" -Recurse -Force
  }

  Remove-Item $OutFilePath -Force
}

<#
    .SYNOPSIS
        This function creates a new SSH Public/Private Key Pair. Optionally, add it to the ssh-agent.
        Optionally add the public key to a Remote Host's ~/.ssh/authorized_keys file.

    .DESCRIPTION
        See .SYNOPSIS

    .NOTES

    .PARAMETER NewSSHKeyName
        This parameter is MANDATORY.

        This parameter takes a string that represents the file name that you would like to give to the new
        SSH User/Client Keys.

    .PARAMETER NewSSHKeyPurpose
        This parameter is OPTIONAL.

        This parameter takes a string that represents a very brief description of what the new SSH Keys
        will be used for. This description will be added to the Comment section when the new keys are
        created.

    .PARAMETER NewSSHKeyPwd
        This parameter is OPTIONAL.

        This parameter takes a SecureString that represents the password used to protect the new
        Private Key file that is created.

    .PARAMETER BlankSSHPrivateKeyPwd
        This parameter is OPTIONAL.

        This parameter is a switch. Use it to ensure that the newly created Private Key is NOT password
        protected.

    .PARAMETER AddToSSHAgent
        This parameter is OPTIONAL, but recommended.

        This parameter is a switch. If used, the new SSH Key Pair will be added to the ssh-agent service.

    .PARAMETER RemovePrivateKey
        This parameter is OPTIONAL. This parameter should only be used in conjunction with the
        -AddtoSSHAgent switch.

        This parameter is a switch. If used, the newly created Private Key will be added to the ssh-agent
        and deleted from the filesystem.

    .PARAMETER RemoteHost
        This parameter is OPTIONAL. This parameter should only be used in conjunction with the
        -AddToRemoteHostAuthKeys switch.

        This parameter takes a string that represents the IP Address of DNS-Resolvable name of a Remote Host.
        The newly created public key will be added to the Remote Host's ~/.ssh/authorized_keys file. The
        Remote Host can be either Windows or Linux (as long as you can ssh to it from the local host).

    .PARAMETER AddToRemoteHostAuthKeys
        This parameter is OPTIONAL.

        This parameter is a switch. If used, the newly created Public Key will be added to the Remote Host's
        ~/.ssh/authorized_keys file. (Specify the Remote Host using the -RemoteHost parameter)

    .PARAMETER RemoteHostUserName
        This parameter is OPTIONAL. This parameter should only be used in conjunction with the
        -AddToRemoteHostAuthKeys parameter.

        This parameter takes a string that represents the name of the user with ssh access to
        the Remote Host (specified by the -RemoteHost parameter).

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> $SplatParams = @{
            NewSSHKeyName           = "ToRHServ01"
            NewSSHKeyPurpose        = "ForSSHToRHServ01"
            AddToSSHAgent           = $True
        }
        PS C:\Users\zeroadmin> New-SSHKey @SplatParams
        
#>
function New-SSHKey {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True)]
    [string]$NewSSHKeyName,

    [Parameter(Mandatory = $False)]
    [securestring]$NewSSHKeyPwd,

    [Parameter(Mandatory = $False)]
    [ValidatePattern("^\w*$")] # No spaces allowed
    [string]$NewSSHKeyPurpose,

    [Parameter(Mandatory = $False)]
    [switch]$AddToSSHAgent,

    [Parameter(Mandatory = $False)]
    [switch]$RemovePrivateKey,

    #[Parameter(Mandatory=$False)]
    #[switch]$ShowNextSteps,

    [Parameter(Mandatory = $False)]
    [string]$RemoteHost,

    [Parameter(Mandatory = $False)]
    [switch]$AddToRemoteHostAuthKeys,

    [Parameter(Mandatory = $False)]
    [string]$RemoteHostUserName
  )

  #region >> Helper Functions

  function Get-Elevation {
    if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.PSVersion.Major -le 5) {
      [System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal (
        [System.Security.Principal.WindowsIdentity]::GetCurrent()
      )

      [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

      if ($currentPrincipal.IsInRole($administratorsRole)) {
        return $true
      }
      else {
        return $false
      }
    }

    if ($PSVersionTable.Platform -eq "Unix") {
      if ($(whoami) -eq "root") {
        return $true
      }
      else {
        return $false
      }
    }
  }

  function Install-LinuxPackage {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $True)]
      [string[]]$PossiblePackageNames,

      [Parameter(Mandatory = $True)]
      [string]$CommandName
    )

    if (!$(command -v $CommandName)) {
      foreach ($PackageName in $PossiblePackageNames) {
        if ($(command -v pacman)) {
          $null = sudo pacman -S $PackageName --noconfirm *> $null
        }
        elseif ($(command -v yum)) {
          $null = sudo yum -y install $PackageName *> $null
        }
        elseif ($(command -v dnf)) {
          $null = sudo dnf -y install $PackageName *> $null
        }
        elseif ($(command -v apt)) {
          $null = sudo apt-get -y install $PackageName *> $null
        }
        elseif ($(command -v zypper)) {
          $null = sudo zypper install $PackageName --non-interactive *> $null
        }

        if ($(command -v $CommandName)) {
          break
        }
      }

      if (!$(command -v $CommandName)) {
        Write-Error "Unable to find the command $CommandName! Install unsuccessful! Halting!"
        $global:FunctionResult = "1"
        return
      }
      else {
        Write-Host "$PackageName was successfully installed!" -ForegroundColor Green
      }
    }
    else {
      Write-Warning "The command $CommandName is already available!"
      return
    }
  }

  #endregion >> Helper Functions


  #region >> Prep

  if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
    if (Get-Elevation) {
      Write-Error "You cannot run the $($PSCmdlet.MyInvocation.MyCommand) function as root! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  if (!$PSVersionTable.Platform -or $PSVersionTable.Platform -eq "Win32NT") {
    try {
      if ($(Get-Module -ListAvailable).Name -notcontains 'WinSSH') { $null = Install-Module WinSSH -ErrorAction Stop }
      if ($(Get-Module).Name -notcontains 'WinSSH') { $null = Import-Module WinSSH -ErrorAction Stop }
      Import-Module "$($(Get-Module WinSSH).ModuleBase)\Await\Await.psd1" -ErrorAction Stop
    }
    catch {
      Write-Error $_
      $global:FunctionResult = "1"
      return
    }

    try {
      $null = Stop-AwaitSession
    }
    catch {
      Write-Verbose $_.Exception.Message
    }
  }

  if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
    # Determine if we have required Linux commands
    [System.Collections.ArrayList]$LinuxCommands = @(
      "echo"
      "expect"
    )
    [System.Collections.ArrayList]$CommandsNotPresent = @()
    foreach ($CommandName in $LinuxCommands) {
      $CommandCheckResult = command -v $CommandName
      if (!$CommandCheckResult) {
        $null = $CommandsNotPresent.Add($CommandName)
      }
    }

    if ($CommandsNotPresent.Count -gt 0) {
      [System.Collections.ArrayList]$FailedInstalls = @()
      if ($CommandsNotPresent -contains "echo") {
        try {
          $null = Install-LinuxPackage -PossiblePackageNames "coreutils" -CommandName "echo"
        }
        catch {
          $null = $FailedInstalls.Add("coreutils")
        }
      }
      if ($CommandsNotPresent -contains "expect") {
        try {
          $null = Install-LinuxPackage -PossiblePackageNames "expect" -CommandName "expect"
        }
        catch {
          $null = $FailedInstalls.Add("expect")
        }
      }

      if ($FailedInstalls.Count -gt 0) {
        Write-Error "The following Linux packages are required, but were not able to be installed:`n$($FailedInstalls -join "`n")`nHalting!"
        $global:FunctionResult = "1"
        return
      }
    }

    [System.Collections.ArrayList]$CommandsNotPresent = @()
    foreach ($CommandName in $LinuxCommands) {
      $CommandCheckResult = command -v $CommandName
      if (!$CommandCheckResult) {
        $null = $CommandsNotPresent.Add($CommandName)
      }
    }

    if ($CommandsNotPresent.Count -gt 0) {
      Write-Error "The following Linux commands are required, but not present on $env:ComputerName:`n$($CommandsNotPresent -join "`n")`nHalting!"
      $global:FunctionResult = "1"
      return
    }
  }

  if (!$(Get-Command ssh-keygen -ErrorAction SilentlyContinue)) {
    Write-Error "Unable to find ssh-keygen! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if ($AddToSSHAgent) {
    if (!$(Get-Command ssh-add -ErrorAction SilentlyContinue)) {
      Write-Error "Unable to find ssh-add! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if (!$PSVersionTable.Platform -or $PSVersionTable.Platform -eq "Win32NT") {
      if ($(Get-Service ssh-agent).Status -ne "Running") {
        $SSHDErrMsg = "The ssh-agent service is NOT curently running! No ssh key pair has been created. Please ensure that the " +
        "ssh-agent and sshd services are running and try again. Halting!'"
        Write-Error $SSHDErrMsg
        $global:FunctionResult = "1"
        return
      }
    }
  }

  if ($AddToRemoteHostAuthKeys -and !$RemoteHost) {
    $RemoteHost = Read-Host -Prompt "Please enter an IP, FQDN, or DNS-resolvable Host Name that represents the Remote Host you would like to share your new public key with."
  }
  if ($RemoteHost -and !$AddToRemoteHostAuthKeys) {
    $AddToRemoteHostAuthKeys = $True
  }

  if ($RemoteHost) {
    try {
      $RemoteHostNetworkInfo = ResolveHost -HostNameOrIP $RemoteHost -ErrorAction Stop
    }
    catch {
      Write-Error "Unable to resolve $RemoteHost! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  if ($RemoteHost -or $AddToRemoteHostAuthKeys -and !$RemoteHostUserName) {
    $RemoteHostUserName = Read-Host -Prompt "Please enter a UserName that has access to $RemoteHost"
  }

  $UserSSHDir = Join-Path $HOME ".ssh"
  if (!$(Test-Path $UserSSHDir)) {
    $null = New-Item -Type Directory -Path $UserSSHDir
  }

  $SSHKeyOutFile = Join-Path $UserSSHDir $NewSSHKeyName

  if ($NewSSHKeyPwd) {
    $NewSSHKeyPwdPT = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewSSHKeyPwd))
  }

  if ($NewSSHKeyPurpose) {
    #$SSHKeyGenArgumentsString = "-t rsa -b 2048 -f `"$SSHKeyOutFile`" -q -N `"$NewSSHKeyPwdPT`" -C `"$NewSSHKeyPurpose`""
    $NewSSHKeyPurpose = $NewSSHKeyPurpose -replace "[\s]",""
    $SSHKeyGenArgumentsString = "-t rsa -b 2048 -f `"$SSHKeyOutFile`" -q -C `"$NewSSHKeyPurpose`""
    $SSHKeyGenArgumentsStringForExpect = "-t rsa -b 2048 -f \`"$SSHKeyOutFile\`" -q -C \`"$NewSSHKeyPurpose\`""
  }
  else {
    #$SSHKeyGenArgumentsString = "-t rsa -b 2048 -f `"$SSHKeyOutFile`" -q -N `"$NewSSHKeyPwd`""
    $SSHKeyGenArgumentsString = "-t rsa -b 2048 -f `"$SSHKeyOutFile`" -q"
    $SSHKeyGenArgumentsStringForExpect = "-t rsa -b 2048 -f \`"$SSHKeyOutFile\`" -q"
  }

  #endregion >> Prep


  #region >> Main

  if (!$PSVersionTable.Platform -or $PSVersionTable.Platform -eq "Win32NT") {
    $sshkeygenParentDir = $(Get-Command ssh-keygen).Source | Split-Path -Parent

    #region >> Await Attempt 1 of 2

    # Create new public/private keypair
    $null = Start-AwaitSession
    Start-Sleep -Seconds 1
    $null = Send-AwaitCommand '$host.ui.RawUI.WindowTitle = "PSAwaitSession"'
    $PSAwaitProcess = $($(Get-Process | Where-Object { $_.Name -eq "powershell" }) | Sort-Object -Property StartTime -Descending)[0]
    Start-Sleep -Seconds 1
    $null = Send-AwaitCommand "`$env:Path = '$env:Path'; Push-Location '$sshkeygenParentDir'"
    Start-Sleep -Seconds 1
    $null = Send-AwaitCommand -Command $([scriptblock]::Create("ssh-keygen $SSHKeyGenArgumentsString; Test-Path $SSHKeyOutFile"))
    Start-Sleep -Seconds 2

    $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse

    [System.Collections.ArrayList]$CheckForExpectedResponses = @()
    $null = $CheckForExpectedResponses.Add($PassphraseOrOverwriteExistingKey)
    $Counter = 0
    while (![bool]$($($CheckForExpectedResponses -split "`n") -match [regex]::Escape("Enter passphrase (empty for no passphrase):")) -and
      ![bool]$($($CheckForExpectedResponses -split "`n") -match [regex]::Escape("Overwrite (y/n)?")) -and $Counter -le 30
    ) {
      $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse
      $null = $CheckForExpectedResponses.Add($PassphraseOrOverwriteExistingKey)
      if ($CheckResponsesOutput -match "must be greater than zero" -or @($CheckResponsesOutput)[-1] -notmatch "[a-zA-Z]") {
        break
      }
      Start-Sleep -Seconds 1
      $Counter++
    }
    if ($Counter -eq 31) {
      Write-Verbose "sshkeygen attempt timed out!"

      if ($PSAwaitProcess.Id) {
        try {
          $null = Stop-AwaitSession
        }
        catch {
          if ($PSAwaitProcess.Id -eq $PID) {
            Write-Error "The PSAwaitSession never spawned! Halting!"
            $global:FunctionResult = "1"
            return
          }
          else {
            if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
              Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
            }
            $Counter = 0
            while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
              Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
              Start-Sleep -Seconds 1
              $Counter++
            }
          }
        }
        $PSAwaitProcess = $null
      }
    }

    #endregion >> Await Attempt 1 of 2

    $CheckResponsesOutput = $CheckForExpectedResponses | ForEach-Object { $_ -split "`n" }

    #region >> Await Attempt 2 of 2

    # If $CheckResponsesOutput contains the string "must be greater than zero", then something broke with the Await Module.
    # Most of the time, just trying again resolves any issues
    if ($CheckResponsesOutput -match "must be greater than zero" -or @($CheckResponsesOutput)[-1] -notmatch "[a-zA-Z]" -or
      $CheckResponsesOutput -match "background process reported an error") {
      if ($PSAwaitProcess.Id) {
        try {
          $null = Stop-AwaitSession
        }
        catch {
          if ($PSAwaitProcess.Id -eq $PID) {
            Write-Error "The PSAwaitSession never spawned! Halting!"
            $global:FunctionResult = "1"
            return
          }
          else {
            if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
              Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
            }
            $Counter = 0
            while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
              Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
              Start-Sleep -Seconds 1
              $Counter++
            }
          }
        }
      }

      # Create new public/private keypair
      $null = Start-AwaitSession
      Start-Sleep -Seconds 1
      $null = Send-AwaitCommand '$host.ui.RawUI.WindowTitle = "PSAwaitSession"'
      $PSAwaitProcess = $($(Get-Process | Where-Object { $_.Name -eq "powershell" }) | Sort-Object -Property StartTime -Descending)[0]
      Start-Sleep -Seconds 1
      $null = Send-AwaitCommand "`$env:Path = '$env:Path'; Push-Location '$sshkeygenParentDir'"
      Start-Sleep -Seconds 1
      $null = Send-AwaitCommand -Command $([scriptblock]::Create("ssh-keygen $SSHKeyGenArgumentsString"))
      Start-Sleep -Seconds 2

      $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse

      [System.Collections.ArrayList]$CheckForExpectedResponses = @()
      $null = $CheckForExpectedResponses.Add($PassphraseOrOverwriteExistingKey)
      $Counter = 0
      while (![bool]$($($CheckForExpectedResponses -split "`n") -match [regex]::Escape("Enter passphrase (empty for no passphrase):")) -and
        ![bool]$($($CheckForExpectedResponses -split "`n") -match [regex]::Escape("Overwrite (y/n)?")) -and $Counter -le 30
      ) {
        $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse
        $null = $CheckForExpectedResponses.Add($PassphraseOrOverwriteExistingKey)
        Start-Sleep -Seconds 1
        $Counter++
      }
      if ($Counter -eq 31) {
        Write-Error "sshkeygen attempt timed out!"
        $global:FunctionResult = "1"

        #$CheckForExpectedResponses

        if ($PSAwaitProcess.Id) {
          try {
            $null = Stop-AwaitSession
          }
          catch {
            if ($PSAwaitProcess.Id -eq $PID) {
              Write-Error "The PSAwaitSession never spawned! Halting!"
              $global:FunctionResult = "1"
              return
            }
            else {
              if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
                Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
              }
              $Counter = 0
              while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
                Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
                Start-Sleep -Seconds 1
                $Counter++
              }
            }
          }
        }

        return
      }
    }

    #endregion >> Await Attempt 2 of 2

    $CheckResponsesOutput = $CheckForExpectedResponses | ForEach-Object { $_ -split "`n" }

    # At this point, if we don't have the expected output, we need to fail
    if ($CheckResponsesOutput -match "must be greater than zero" -or @($CheckResponsesOutput)[-1] -notmatch "[a-zA-Z]" -or
      $CheckResponsesOutput -match "background process reported an error") {
      if ($CheckResponsesOutput -match "must be greater than zero" -or @($CheckResponsesOutput)[-1] -notmatch "[a-zA-Z]") {
        Write-Error "Something went wrong with the PowerShell Await Module! Halting!"
      }
      if ($CheckResponsesOutput -match "background process reported an error") {
        Write-Error "Please check your credentials! Halting!"
      }
      $global:FunctionResult = "1"

      if ($PSAwaitProcess.Id) {
        try {
          $null = Stop-AwaitSession
        }
        catch {
          if ($PSAwaitProcess.Id -eq $PID) {
            Write-Error "The PSAwaitSession never spawned! Halting!"
            $global:FunctionResult = "1"
            return
          }
          else {
            if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
              Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
            }
            $Counter = 0
            while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
              Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
              Start-Sleep -Seconds 1
              $Counter++
            }
          }
        }
      }

      return
    }

    # Now we should either have a prompt to accept the host key, a prompt for a password, or it already worked...

    if ($CheckResponsesOutput -match [regex]::Escape("Overwrite (y/n)?")) {
      $null = Send-AwaitCommand "y"
      Start-Sleep -Seconds 3

      # This will either not prompt at all or prompt for a password
      $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse

      [System.Collections.ArrayList]$CheckExpectedSendYesOutput = @()
      $null = $CheckExpectedSendYesOutput.Add($PassphraseOrOverwriteExistingKey)
      $Counter = 0
      while (![bool]$($($CheckExpectedSendYesOutput -split "`n") -match [regex]::Escape("Enter passphrase (empty for no passphrase):")) -and $Counter -le 30) {
        $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse
        $null = $CheckExpectedSendYesOutput.Add($PassphraseOrOverwriteExistingKey)
        Start-Sleep -Seconds 1
        $Counter++
      }
      if ($Counter -eq 31) {
        Write-Error "Sending 'y' to overwrite the existing ssh key timed out!"
        $global:FunctionResult = "1"

        $CheckForExpectedResponses

        if ($PSAwaitProcess.Id) {
          try {
            $null = Stop-AwaitSession
          }
          catch {
            if ($PSAwaitProcess.Id -eq $PID) {
              Write-Error "The PSAwaitSession never spawned! Halting!"
              $global:FunctionResult = "1"
              return
            }
            else {
              if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
                Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
              }
              $Counter = 0
              while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
                Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
                Start-Sleep -Seconds 1
                $Counter++
              }
            }
          }
        }

        return
      }

      $CheckSendYesOutput = $CheckExpectedSendYesOutput | ForEach-Object { $_ -split "`n" }
    }

    if ($CheckSendYesOutput -match [regex]::Escape("Enter passphrase (empty for no passphrase):") -or
      $CheckResponsesOutput -match [regex]::Escape("Enter passphrase (empty for no passphrase):")
    ) {
      if ($NewSSHKeyPwd) {
        $null = Send-AwaitCommand $NewSSHKeyPwdPT
      }
      else {
        $null = Send-AwaitCommand ""
      }
      Start-Sleep -Seconds 3

      $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse

      [System.Collections.ArrayList]$CheckExpectedSendPwdOutput = @()
      $null = $CheckExpectedSendPwdOutput.Add($PassphraseOrOverwriteExistingKey)
      $Counter = 0
      while (![bool]$($CheckExpectedSendPwdOutput -match [regex]::Escape("Enter same passphrase again:")) -and $Counter -le 30) {
        $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse
        $null = $CheckExpectedSendPwdOutput.Add($PassphraseOrOverwriteExistingKey)
        Start-Sleep -Seconds 1
        $Counter++
      }
      if ($Counter -eq 31) {
        Write-Error "Sending the initial password for the private key timed out!"
        $global:FunctionResult = "1"

        $CheckExpectedSendPwdOutput

        if ($PSAwaitProcess.Id) {
          try {
            $null = Stop-AwaitSession
          }
          catch {
            if ($PSAwaitProcess.Id -eq $PID) {
              Write-Error "The PSAwaitSession never spawned! Halting!"
              $global:FunctionResult = "1"
              return
            }
            else {
              if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
                Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
              }
              $Counter = 0
              while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
                Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
                Start-Sleep -Seconds 1
                $Counter++
              }
            }
          }
        }

        return
      }

      $CheckSendPwdOutput = $CheckExpectedSendPwdOutput | ForEach-Object { $_ -split "`n" }

      if ($CheckSendPwdOutput -match [regex]::Escape("Enter same passphrase again:")) {
        if ($NewSSHKeyPwd) {
          $null = Send-AwaitCommand $NewSSHKeyPwdPT
        }
        else {
          $null = Send-AwaitCommand ""
        }
        Start-Sleep -Seconds 3

        $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse

        if (!$OutputPrep) {
          [System.Collections.ArrayList]$OutputPrep = @()
          if (![System.String]::IsNullOrWhiteSpace($SuccessOrAcceptHostKeyOrPwdPrompt)) {
            $null = $OutputPrep.Add($SuccessOrAcceptHostKeyOrPwdPrompt)
          }
        }
        $Counter = 0
        while (![bool]$($($OutputPrep -split "`n") -match "True") -and $Counter -le $CounterLimit) {
          $PassphraseOrOverwriteExistingKey = Receive-AwaitResponse
          $null = $OutputPrep.Add($PassphraseOrOverwriteExistingKey)
          Start-Sleep -Seconds 1
          $Counter++
        }
        if ($Counter -eq 31) {
          Write-Error "Sending the password again timed out!"
          $global:FunctionResult = "1"

          $OutputPrep

          if ($PSAwaitProcess.Id) {
            try {
              $null = Stop-AwaitSession
            }
            catch {
              if ($PSAwaitProcess.Id -eq $PID) {
                Write-Error "The PSAwaitSession never spawned! Halting!"
                $global:FunctionResult = "1"
                return
              }
              else {
                if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
                  Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
                }
                $Counter = 0
                while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
                  Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
                  Start-Sleep -Seconds 1
                  $Counter++
                }
              }
            }
          }

          return
        }
      }
    }

    $SSHKeyGenOutput = $OutputPrep
  }
  if ($PSVersionTable.Platform -eq "Unix" -or $PSVersionTable.OS -match "Darwin") {
    if ($AddToSSHAgent) {
      # Check to see if the ssh-agent is running
      #[scriptblock]::Create('ssh-add -L').InvokeReturnAsIs()
      $SSHAgentProcesses = Get-Process -Name ssh-agent -IncludeUserName -ErrorAction SilentlyContinue | Where-Object { $_.UserName -eq $env:USER }
      if ($SSHAgentProcesses.Count -gt 0) {
        $LatestSSHAgentProcess = $(@($SSHAgentProcesses) | Sort-Object StartTime)[-1]
        $env:SSH_AUTH_SOCK = $(Get-ChildItem /tmp -Recurse -File | Where-Object { $_.FullName -match "\.$($LatestSSHAgentProcess.Id-1)" }).FullName
        $env:SSH_AGENT_PID = $LatestSSHAgentProcess.Id
      }
      else {
        $SSHAgentInfo = ssh-agent
        $env:SSH_AUTH_SOCK = $($($($SSHAgentInfo -match "AUTH_SOCK") -replace 'SSH_AUTH_SOCK=','') -split ';')[0]
        $env:SSH_AGENT_PID = $($($($SSHAgentInfo -match "SSH_AGENT_PID") -replace 'SSH_AGENT_PID=','') -split ';')[0]
      }
    }

    [System.Collections.ArrayList]$ExpectScriptPrep = @(
      'expect - << EOF'
      'set timeout 20'
    )
    if ($NewSSHKeyPwdPT) {
      $null = $ExpectScriptPrep.Add("set password $NewSSHKeyPwdPT")
    }

    [System.Collections.ArrayList]$ExpectScriptPrep2 = @(
      'set prompt \"(>|:|#|\\\\\\$)\\\\s+\\$\"'
      "spawn ssh-keygen $SSHKeyGenArgumentsStringForExpect"
      'match_max 100000'
      'expect {'
      '    \"*Overwrite (y*\" {'
      '        send -- \"y\r\"'
      '        exp_continue'
      '    }'
      '    \"*(empty for no passphrase)*\" {'
    )
    if ($NewSSHKeyPwdPT) {
      $null = $ExpectScriptPrep2.Add('        send -- \"\$password\r\"')
    }
    else {
      $null = $ExpectScriptPrep2.Add('        send -- \"\r\"')
    }

    [System.Collections.ArrayList]$ExpectScriptPrep3 = @(
      '        expect \"*Enter same passphrase again*\"'
      '    }'
      '}'
    )
    if ($NewSSHKeyPwdPT) {
      $null = $ExpectScriptPrep3.Add('send -- \"\$password\r\"')
    }
    else {
      $null = $ExpectScriptPrep3.Add('send -- \"\r\"')
    }

    foreach ($Line in $ExpectScriptPrep2) {
      $null = $ExpectScriptPrep.Add($Line)
    }
    foreach ($Line in $ExpectScriptPrep3) {
      $null = $ExpectScriptPrep.Add($Line)
    }

    $null = $ExpectScriptPrep.Add('expect eof')
    $null = $ExpectScriptPrep.Add('EOF')

    $ExpectScript = $ExpectScriptPrep -join "`n"

    #Write-Host "`$ExpectScript is:`n$ExpectScript"
    #$ExpectScript | Export-CliXml "$HOME/ExpectScriptA.xml"

    # The below $ExpectOutput is an array of strings
    $ExpectOutput = bash -c "$ExpectScript"

    $SSHKeyGenOutput = $ExpectOutput
  }

  $PubPrivKeyPairFiles = Get-ChildItem -Path $UserSSHDir -File | Where-Object { $_.Name -match "$NewSSHKeyName" }
  $PubKey = $PubPrivKeyPairFiles | Where-Object { $_.Extension -eq ".pub" }
  $PrivKey = $PubPrivKeyPairFiles | Where-Object { $_.Extension -ne ".pub" }

  if (!$PubKey -or !$PrivKey) {
    if (!$PSVersionTable.Platform -or $PSVersionTable.Platform -eq "Win32NT") {
      $Counter = 0
      if ($PSAwaitProcess.Id) {
        try {
          $null = Stop-AwaitSession
        }
        catch {
          if ($PSAwaitProcess.Id -eq $PID) {
            Write-Error "The PSAwaitSession never spawned! Halting!"
            $global:FunctionResult = "1"
            return
          }
          else {
            if ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue)) {
              Stop-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue
            }
            $Counter = 0
            while ([bool]$(Get-Process -Id $PSAwaitProcess.Id -ErrorAction SilentlyContinue) -and $Counter -le 15) {
              Write-Verbose "Waiting for Await Module Process Id $($PSAwaitProcess.Id) to end..."
              Start-Sleep -Seconds 1
              $Counter++
            }
          }
        }
      }
    }

    Write-Error "The New SSH Key Pair was NOT created! Please review the output of ssh-keygen below. Halting!"
    $global:FunctionResult = "1"
    $SSHKeyGenOutput
    return
  }

  if ($AddToSSHAgent) {
    # Add the New Private Key to the ssh-agent
    $null = [scriptblock]::Create("ssh-add $($PrivKey.FullName)").InvokeReturnAsIs()
    if ($LASTEXITCODE -ne 0) {
      Write-Warning $Error[0].Exception.Message
      Write-Warning "There was a problem adding $($PrivKey.FullName) to the ssh-agent PID $env:SSH_AGENT_PID!"
    }

    [System.Collections.ArrayList]$PublicKeysAccordingToSSHAgent = @()
    $(ssh-add -L) | ForEach-Object {
      $null = $PublicKeysAccordingToSSHAgent.Add($_)
    }
    $ThisPublicKeyAccordingToSSHAgent = $PublicKeysAccordingToSSHAgent | Where-Object { $_ -match "$NewSSHKeyName$" }
    [System.Collections.ArrayList]$CharacterCountArray = @()
    $ThisPublicKeyAccordingToSSHAgent -split " " | ForEach-Object {
      $null = $CharacterCountArray.Add($_.Length)
    }
    $LongestStringLength = $($CharacterCountArray | Measure-Object -Maximum).Maximum
    $ArrayPositionBeforeComment = $CharacterCountArray.IndexOf([int]$LongestStringLength)
    $PublicKeySansCommentFromSSHAgent = $($ThisPublicKeyAccordingToSSHAgent -split " ")[0..$ArrayPositionBeforeComment] -join " "

    $ThisPublicKeyAccordingToFile = Get-Content $PubKey.FullName
    [System.Collections.ArrayList]$CharacterCountArray = @()
    $ThisPublicKeyAccordingToFile -split " " | ForEach-Object {
      $null = $CharacterCountArray.Add($_.Length)
    }
    $LongestStringLength = $($CharacterCountArray | Measure-Object -Maximum).Maximum
    $ArrayPositionBeforeComment = $CharacterCountArray.IndexOf([int]$LongestStringLength)
    $PublicKeySansCommentFromFile = $($ThisPublicKeyAccordingToFile -split " ")[0..$ArrayPositionBeforeComment] -join " "

    if ($PublicKeySansCommentFromSSHAgent -ne $PublicKeySansCommentFromFile) {
      Write-Warning "The public key according to the ssh-agent does NOT match the public key content in $($PubKey.FullName)! It appears the private key was never added to the ssh-agent!"
    }

    Write-Host "The Private Key $PublicKeyLocationFinal has been added to the ssh-agent service." -ForegroundColor Green

    if (!$RemovePrivateKey) {
      Write-Host "It is now safe to delete the private key (i.e. $($PrivKey.FullName)) since it has been added to the ssh-agent." -ForegroundColor Green
    }
  }

  if ($AddToRemoteHostAuthKeys) {
    if ($RemoteHostNetworkInfo.FQDN) {
      $RemoteHostLocation = $RemoteHostNetworkInfo.FQDN
    }
    elseif ($RemoteHostNetworkInfo.HostName) {
      $RemoteHostLocation = $RemoteHostNetworkInfo.HostName
    }
    elseif ($RemoteHostNetworkInfo.IPAddressList[0]) {
      $RemoteHostLocation = $RemoteHostNetworkInfo.IPAddressList[0]
    }

    try {
      Add-PublicKeyToRemoteHost -PublicKeyPath $PubKey.FullName -RemoteHost $RemoteHostLocation -RemoteHostUserName $RemoteHostUserName -ErrorAction Stop
    }
    catch {
      Write-Error "Unable to add the public key to the authorized_keys file on $RemoteHost! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if (!$AddToSSHAgent) {
      Write-Host "You can now ssh to $RemoteHost using public key authentication using the following command:" -ForegroundColor Green
      Write-Host "    ssh -i $PubKey.FullName $RemoteHostUserName@$RemoteHostLocation" -ForegroundColor Green
    }
    else {
      Write-Host "You can now ssh to $RemoteHost using public key authentication using the following command:" -ForegroundColor Green
      Write-Host "    ssh $RemoteHostUserName@$RemoteHostLocation" -ForegroundColor Green
    }
  }

  [pscustomobject]@{
    PublicKeyFilePath = $PubKey.FullName
    PrivateKeyFilePath = if (!$RemovePrivateKey) { $PrivKey.FullName } else { "PrivateKey was deleted after being added to the ssh-agent" }
    PublicKeyContent = Get-Content $(Join-Path $UserSSHDir "$NewSSHKeyName.pub")
  }

  ##### END Main Body #####

}

function New-UniqueString {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string[]]$ArrayOfStrings,

    [Parameter(Mandatory = $True)]
    [string]$PossibleNewUniqueString
  )

  if (!$ArrayOfStrings -or $ArrayOfStrings.Count -eq 0 -or ![bool]$($ArrayOfStrings -match "[\w]")) {
    $PossibleNewUniqueString
  }
  else {
    $OriginalString = $PossibleNewUniqueString
    $Iteration = 1
    while ($ArrayOfStrings -contains $PossibleNewUniqueString) {
      $AppendedValue = "_$Iteration"
      $PossibleNewUniqueString = $OriginalString + $AppendedValue
      $Iteration++
    }

    $PossibleNewUniqueString
  }
}

<#
.SYNOPSIS
    Input a Host Name or IP Address and use DNS to figure out:
    - IPAddressList (i.e. all associated IP Addresses that host might be using that DNS is aware of)
    - FQDN
    - HostName
    - Domain

.DESCRIPTION
    See .SYNOPSIS

.PARAMETER HostNameOrIP
    This parameter is MANDATORY

    This parameter takes a string that represents either an IP Address or a DNS-resolvable Host Name

.EXAMPLE
    Resolve-Host -HostNameOrIP 192.168.2.30

.EXAMPLE
    Resolve-Host -HostNameOrIP win12ws

.EXAMPLE
    Resolve-Host -HostNameOrIP win12ws.test2.lab
#>
function Resolve-Host {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True)]
    [string]$HostNameOrIP
  )

  ## BEGIN Native Helper Functions ##

  function Test-IsValidIPAddress ([string]$IPAddress) {
    [boolean]$Octets = (($IPAddress.Split(".") | Measure-Object).Count -eq 4)
    [boolean]$Valid = ($IPAddress -as [ipaddress]) -as [boolean]
    return ($Valid -and $Octets)
  }

  ## END Native Helper Functions ##


  ##### BEGIN Main Body #####

  $RemoteHostNetworkInfoArray = @()
  if (!$(Test-IsValidIPAddress -IPAddress $HostNameOrIP)) {
    try {
      $HostNamePrep = $HostNameOrIP
      [System.Collections.ArrayList]$RemoteHostArrayOfIPAddresses = @()
      $IPv4AddressFamily = "InterNetwork"
      $IPv6AddressFamily = "InterNetworkV6"

      $ResolutionInfo = [System.Net.Dns]::GetHostEntry($HostNamePrep)
      $ResolutionInfo.AddressList | Where-Object {
        $_.AddressFamily -eq $IPv4AddressFamily
      } | ForEach-Object {
        if ($RemoteHostArrayOfIPAddresses -notcontains $_.IPAddressToString) {
          $null = $RemoteHostArrayOfIPAddresses.Add($_.IPAddressToString)
        }
      }
    }
    catch {
      Write-Verbose "Unable to resolve $HostNameOrIP when treated as a Host Name (as opposed to IP Address)!"
    }
  }
  if (Test-IsValidIPAddress -IPAddress $HostNameOrIP) {
    try {
      $HostIPPrep = $HostNameOrIP
      [System.Collections.ArrayList]$RemoteHostArrayOfIPAddresses = @()
      $null = $RemoteHostArrayOfIPAddresses.Add($HostIPPrep)

      $ResolutionInfo = [System.Net.Dns]::GetHostEntry($HostIPPrep)

      [System.Collections.ArrayList]$RemoteHostFQDNs = @()
      $null = $RemoteHostFQDNs.Add($ResolutionInfo.HostName)
    }
    catch {
      Write-Verbose "Unable to resolve $HostNameOrIP when treated as an IP Address (as opposed to Host Name)!"
    }
  }

  if ($RemoteHostArrayOfIPAddresses.Count -eq 0) {
    Write-Error "Unable to determine IP Address of $HostNameOrIP! Halting!"
    $global:FunctionResult = "1"
    return
  }

  # At this point, we have $RemoteHostArrayOfIPAddresses...
  [System.Collections.ArrayList]$RemoteHostFQDNs = @()
  foreach ($HostIP in $RemoteHostArrayOfIPAddresses) {
    try {
      $FQDNPrep = [System.Net.Dns]::GetHostEntry($HostIP).HostName
    }
    catch {
      Write-Verbose "Unable to resolve $HostIP. No PTR Record? Please check your DNS config."
      continue
    }
    if ($RemoteHostFQDNs -notcontains $FQDNPrep) {
      $null = $RemoteHostFQDNs.Add($FQDNPrep)
    }
  }

  if ($RemoteHostFQDNs.Count -eq 0) {
    $null = $RemoteHostFQDNs.Add($ResolutionInfo.HostName)
  }

  [System.Collections.ArrayList]$HostNameList = @()
  [System.Collections.ArrayList]$DomainList = @()
  foreach ($fqdn in $RemoteHostFQDNs) {
    $PeriodCheck = $($fqdn | Select-String -Pattern "\.").Matches.Success
    if ($PeriodCheck) {
      $HostName = $($fqdn -split "\.")[0]
      $Domain = $($fqdn -split "\.")[1..$($($fqdn -split "\.").Count - 1)] -join '.'
    }
    else {
      $HostName = $fqdn
      $Domain = "Unknown"
    }

    $null = $HostNameList.Add($HostName)
    $null = $DomainList.Add($Domain)
  }

  if ($RemoteHostFQDNs[0] -eq $null -and $HostNameList[0] -eq $null -and $DomainList -eq "Unknown" -and $RemoteHostArrayOfIPAddresses) {
    [System.Collections.ArrayList]$SuccessfullyPingedIPs = @()
    # Test to see if we can reach the IP Addresses
    foreach ($ip in $RemoteHostArrayOfIPAddresses) {
      if ([bool]$(Test-Connection $ip -Count 1 -ErrorAction SilentlyContinue)) {
        $null = $SuccessfullyPingedIPs.Add($ip)
      }
    }

    if ($SuccessfullyPingedIPs.Count -eq 0) {
      Write-Error "Unable to resolve $HostNameOrIP! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  [pscustomobject]@{
    IPAddressList = [System.Collections.ArrayList]@($(if ($SuccessfullyPingedIPs) { $SuccessfullyPingedIPs } else { $RemoteHostArrayOfIPAddresses }))
    FQDN = if ($RemoteHostFQDNs) { $RemoteHostFQDNs[0] } else { $null }
    HostName = if ($HostNameList) { $HostNameList[0].ToLowerInvariant() } else { $null }
    Domain = if ($DomainList) { $DomainList[0] } else { $null }
  }

  ##### END Main Body #####

}

<#
.SYNOPSIS
    This function uses openssl.exe to extract all public certificates and private key from a .pfx file. Each public certificate
    and the private key is written to its own separate file in the specified. OutputDirectory. If openssl.exe is not available
    on the current system, it is downloaded to the Current User's Downloads folder and added to $env:Path.

    NOTE: Nothing is installed.

.DESCRIPTION
    See SYNOPSIS.

.NOTES
    Depends on openssl.exe.

    NOTE: Nothing needs to be installed in order to use openssl.exe.

.PARAMETER PFXFilePath
    Mandatory.

    This parameter takes a string that represents the full path to a .pfx file

.PARAMETER PFXFilePwd
    Optional.

    This parameter takes a string (i.e. plain text password) or a secure string.

    If the private key in the .pfx file is password protected, use this parameter.

.PARAMETER StripPrivateKeyPwd
    Optional.

    This parameter takes a boolean $true or $false.

    By default, this function writes the private key within the .pfx to a file in a protected format, i.e.
        -----BEGIN PRIVATE KEY-----
        -----END PRIVATE KEY-----

    If you set this parameter to $true, then this function will ALSO (in addition to writing out the above protected
    format to its own file) write the unprotected private key to its own file with format
        -----BEGIN RSA PRIVATE KEY----
        -----END RSA PRIVATE KEY----

    WARNING: This parameter is set to $true by default.

.PARAMETER OutputDirectory
    Optional.

    This parameter takes a string that represents a file path to a *directory* that will contain all file outputs.

    If this parameter is not used, all file outputs are written to the same directory as the .pfx file.

.PARAMETER DownloadAndAddOpenSSLToPath
    Optional.

    This parameter downloads openssl.exe from https://indy.fulgan.com/SSL/ to the current user's Downloads folder,
    and adds openssl.exe to $env:Path.

    WARNING: If openssl.exe is not already part of your $env:Path prior to running this function, this parameter
    becomes MANDATORY, or the function will fail.

.EXAMPLE
    # If your private key is password protected...
    $PSSigningCertFile = "C:\Certs\Testing2\ZeroCode.pfx"
    $PFXSigningPwdAsSecureString = Read-Host -Prompt "Please enter the private key's password" -AsSecureString
    $OutDir = "C:\Certs\Testing2"

    Extract-PFXCerts -PFXFilePath $PSSigningCertFile `
    -PFXFilePwd $PFXSigningPwdAsSecureString `
    -StripPrivateKeyPwd $true `
    -OutputDirectory $OutDir

.EXAMPLE
    # If your private key is NOT password protected...
    $PSSigningCertFile = "C:\Certs\Testing2\ZeroCode.pfx"
    $OutputDirectory = "C:\Certs\Testing2"

    Extract-PFXCerts -PFXFilePath $PSSigningCertFile `
    -StripPrivateKeyPwd $true `
    -OutputDirectory $OutDir
#>
function Extract-PFXCerts {
  [CmdletBinding(
    PositionalBinding = $true,
    ConfirmImpact = 'Medium'
  )]
  param(
    [Parameter(Mandatory = $False)]
    [string]$PFXFilePath = $(Read-Host -Prompt "Please enter the full path to the .pfx file."),

    [Parameter(Mandatory = $False)]
    $PFXFilePwd,# This is only needed if the .pfx contains a password-protected private key, which should be the case 99% of the time

    [Parameter(Mandatory = $False)]
    [bool]$StripPrivateKeyPwd = $true,

    [Parameter(Mandatory = $False)]
    [string]$OutputDirectory,# If this parameter is left blank, all output files will be in the same directory as the original .pfx

    [Parameter(Mandatory = $False)]
    [switch]$DownloadAndAddOpenSSLToPath
  )

  ##### BEGIN Native Helper Functions #####

  function Unzip-File {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $true,Position = 0)]
      [string]$PathToZip,

      [Parameter(Mandatory = $true,Position = 1)]
      [string]$TargetDir,

      [Parameter(Mandatory = $false,Position = 2)]
      [string[]]$SpecificItem
    )

    if ($PSVersionTable.PSEdition -eq "Core") {
      [System.Collections.ArrayList]$AssembliesToCheckFor = @("System.Console","System","System.IO",
        "System.IO.Compression","System.IO.Compression.Filesystem","System.IO.Compression.ZipFile"
      )

      [System.Collections.ArrayList]$NeededAssemblies = @()

      foreach ($assembly in $AssembliesToCheckFor) {
        try {
          [System.Collections.ArrayList]$Failures = @()
          try {
            $TestLoad = [System.Reflection.Assembly]::LoadWithPartialName($assembly)
            if (!$TestLoad) {
              throw
            }
          }
          catch {
            $null = $Failures.Add("Failed LoadWithPartialName")
          }

          try {
            $null = Invoke-Expression "[$assembly]"
          }
          catch {
            $null = $Failures.Add("Failed TabComplete Check")
          }

          if ($Failures.Count -gt 1) {
            $Failures
            throw
          }
        }
        catch {
          Write-Host "Downloading $assembly..."
          $NewAssemblyDir = "$HOME\Downloads\$assembly"
          $NewAssemblyDllPath = "$NewAssemblyDir\$assembly.dll"
          if (!$(Test-Path $NewAssemblyDir)) {
            New-Item -ItemType Directory -Path $NewAssemblyDir
          }
          if (Test-Path "$NewAssemblyDir\$assembly*.zip") {
            Remove-Item "$NewAssemblyDir\$assembly*.zip" -Force
          }
          $OutFileBaseNamePrep = Invoke-WebRequest "https://www.nuget.org/api/v2/package/$assembly" -DisableKeepAlive -UseBasicParsing
          $OutFileBaseName = $($OutFileBaseNamePrep.BaseResponse.ResponseUri.AbsoluteUri -split "/")[-1] -replace "nupkg","zip"
          Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/$assembly" -OutFile "$NewAssemblyDir\$OutFileBaseName"
          Expand-Archive -Path "$NewAssemblyDir\$OutFileBaseName" -DestinationPath $NewAssemblyDir

          $PossibleDLLs = Get-ChildItem -Recurse $NewAssemblyDir | Where-Object { $_.Name -eq "$assembly.dll" -and $_.Parent -notmatch "net[0-9]" -and $_.Parent -match "core|standard" }

          if ($PossibleDLLs.Count -gt 1) {
            Write-Warning "More than one item within $NewAssemblyDir\$OutFileBaseName matches $assembly.dll"
            Write-Host "Matches include the following:"
            for ($i = 0; $i -lt $PossibleDLLs.Count; $i++) {
              "$i) $($($PossibleDLLs[$i]).FullName)"
            }
            $Choice = Read-Host -Prompt "Please enter the number corresponding to the .dll you would like to load [0..$($($PossibleDLLs.Count)-1)]"
            if ($(0..$($($PossibleDLLs.Count) - 1)) -notcontains $Choice) {
              Write-Error "The number indicated does is not a valid choice! Halting!"
              $global:FunctionResult = "1"
              return
            }

            if ($PSVersionTable.Platform -eq "Win32NT") {
              # Install to GAC
              [System.Reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices")
              $publish = New-Object System.EnterpriseServices.Internal.Publish
              $publish.GacInstall($PossibleDLLs[$Choice].FullName)
            }

            # Copy it to the root of $NewAssemblyDir\$OutFileBaseName
            Copy-Item -Path "$($PossibleDLLs[$Choice].FullName)" -Destination "$NewAssemblyDir\$assembly.dll"

            # Remove everything else that was extracted with Expand-Archive
            Get-ChildItem -Recurse $NewAssemblyDir | Where-Object {
              $_.FullName -ne "$NewAssemblyDir\$assembly.dll" -and
              $_.FullName -ne "$NewAssemblyDir\$OutFileBaseName"
            } | Remove-Item -Recurse -Force

          }
          if ($PossibleDLLs.Count -lt 1) {
            Write-Error "No matching .dll files were found within $NewAssemblyDir\$OutFileBaseName ! Halting!"
            continue
          }
          if ($PossibleDLLs.Count -eq 1) {
            if ($PSVersionTable.Platform -eq "Win32NT") {
              # Install to GAC
              [System.Reflection.Assembly]::LoadWithPartialName("System.EnterpriseServices")
              $publish = New-Object System.EnterpriseServices.Internal.Publish
              $publish.GacInstall($PossibleDLLs.FullName)
            }

            # Copy it to the root of $NewAssemblyDir\$OutFileBaseName
            Copy-Item -Path "$($PossibleDLLs[$Choice].FullName)" -Destination "$NewAssemblyDir\$assembly.dll"

            # Remove everything else that was extracted with Expand-Archive
            Get-ChildItem -Recurse $NewAssemblyDir | Where-Object {
              $_.FullName -ne "$NewAssemblyDir\$assembly.dll" -and
              $_.FullName -ne "$NewAssemblyDir\$OutFileBaseName"
            } | Remove-Item -Recurse -Force
          }
        }
        $AssemblyFullInfo = [System.Reflection.Assembly]::LoadWithPartialName($assembly)
        if (!$AssemblyFullInfo) {
          $AssemblyFullInfo = [System.Reflection.Assembly]::LoadFile("$NewAssemblyDir\$assembly.dll")
        }
        if (!$AssemblyFullInfo) {
          Write-Error "The assembly $assembly could not be found or otherwise loaded! Halting!"
          $global:FunctionResult = "1"
          return
        }
        $null = $NeededAssemblies.Add([pscustomobject]@{
            AssemblyName = "$assembly"
            Available = if ($AssemblyFullInfo) { $true } else { $false }
            AssemblyInfo = $AssemblyFullInfo
            AssemblyLocation = $AssemblyFullInfo.Location
          })
      }

      if ($NeededAssemblies.Available -contains $false) {
        $AssembliesNotFound = $($NeededAssemblies | Where-Object { $_.Available -eq $false }).AssemblyName
        Write-Error "The following assemblies cannot be found:`n$AssembliesNotFound`nHalting!"
        $global:FunctionResult = "1"
        return
      }

      $Assem = $NeededAssemblies.AssemblyInfo.FullName

      $Source = @"
            using System;
            using System.IO;
            using System.IO.Compression;
    
            namespace MyCore.Utils
            {
                public static class Zip
                {
                    public static void ExtractAll(string sourcepath, string destpath)
                    {
                        string zipPath = @sourcepath;
                        string extractPath = @destpath;
    
                        using (ZipArchive archive = ZipFile.Open(zipPath, ZipArchiveMode.Update))
                        {
                            archive.ExtractToDirectory(extractPath);
                        }
                    }
    
                    public static void ExtractSpecific(string sourcepath, string destpath, string specificitem)
                    {
                        string zipPath = @sourcepath;
                        string extractPath = @destpath;
                        string itemout = @specificitem.Replace(@"\","/");
    
                        //Console.WriteLine(itemout);
    
                        using (ZipArchive archive = ZipFile.OpenRead(zipPath))
                        {
                            foreach (ZipArchiveEntry entry in archive.Entries)
                            {
                                //Console.WriteLine(entry.FullName);
                                //bool satisfied = new bool();
                                //satisfied = entry.FullName.IndexOf(@itemout, 0, StringComparison.CurrentCultureIgnoreCase) != -1;
                                //Console.WriteLine(satisfied);
    
                                if (entry.FullName.IndexOf(@itemout, 0, StringComparison.CurrentCultureIgnoreCase) != -1)
                                {
                                    string finaloutputpath = extractPath + "\\" + entry.Name;
                                    entry.ExtractToFile(finaloutputpath, true);
                                }
                            }
                        } 
                    }
                }
            }
"@

      Add-Type -ReferencedAssemblies $Assem -TypeDefinition $Source

      if (!$SpecificItem) {
        [MyCore.Utils.Zip]::ExtractAll($PathToZip,$TargetDir)
      }
      else {
        [MyCore.Utils.Zip]::ExtractSpecific($PathToZip,$TargetDir,$SpecificItem)
      }
    }


    if ($PSVersionTable.PSEdition -eq "Desktop" -and $($($PSVersionTable.Platform -and $PSVersionTable.Platform -eq "Win32NT") -or !$PSVersionTable.Platform)) {
      if ($SpecificItem) {
        foreach ($item in $SpecificItem) {
          if ($SpecificItem -match "\\") {
            $SpecificItem = $SpecificItem -replace "\\","\\"
          }
        }
      }

      ##### BEGIN Native Helper Functions #####
      function Get-ZipChildItems {
        [CmdletBinding()]
        param(
          [Parameter(Mandatory = $false,Position = 0)]
          [string]$ZipFile = $(Read-Host -Prompt "Please enter the full path to the zip file")
        )

        $shellapp = New-Object -com shell.application
        $zipFileComObj = $shellapp.Namespace($ZipFile)
        $i = $zipFileComObj.Items()
        Get-ZipChildItems_Recurse $i
      }

      function Get-ZipChildItems_Recurse {
        [CmdletBinding()]
        param(
          [Parameter(Mandatory = $true,Position = 0)]
          $items
        )

        foreach ($si in $items) {
          if ($si.getfolder -ne $null) {
            # Loop through subfolders 
            Get-ZipChildItems_Recurse $si.getfolder.Items()
          }
          # Spit out the object
          $si
        }
      }

      ##### END Native Helper Functions #####

      ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####
      if (!$(Test-Path $PathToZip)) {
        Write-Verbose "The path $PathToZip was not found! Halting!"
        Write-Error "The path $PathToZip was not found! Halting!"
        $global:FunctionResult = "1"
        return
      }
      if ($(Get-ChildItem $PathToZip).Extension -ne ".zip") {
        Write-Verbose "The file specified by the -PathToZip parameter does not have a .zip file extension! Halting!"
        Write-Error "The file specified by the -PathToZip parameter does not have a .zip file extension! Halting!"
        $global:FunctionResult = "1"
        return
      }

      $ZipFileNameWExt = $(Get-ChildItem $PathToZip).Name

      ##### END Variable/Parameter Transforms and PreRun Prep #####

      ##### BEGIN Main Body #####

      Write-Verbose "NOTE: PowerShell 5.0 uses Expand-Archive cmdlet to unzip files"

      if (!$SpecificItem) {
        if ($PSVersionTable.PSVersion.Major -ge 5) {
          Expand-Archive -Path $PathToZip -DestinationPath $TargetDir
        }
        if ($PSVersionTable.PSVersion.Major -lt 5) {
          # Load System.IO.Compression.Filesystem 
          [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null

          # Unzip file
          [System.IO.Compression.ZipFile]::ExtractToDirectory($PathToZip,$TargetDir)
        }
      }
      if ($SpecificItem) {
        $ZipSubItems = Get-ZipChildItems -ZipFile $PathToZip

        foreach ($searchitem in $SpecificItem) {
          [array]$potentialItems = foreach ($item in $ZipSubItems) {
            if ($item.Path -match $searchitem) {
              $item
            }
          }

          $shell = New-Object -com shell.application

          if ($potentialItems.Count -eq 1) {
            $shell.Namespace($TargetDir).CopyHere($potentialItems[0],0x14)
          }
          if ($potentialItems.Count -gt 1) {
            Write-Warning "More than one item within $ZipFileNameWExt matches $searchitem."
            Write-Host "Matches include the following:"
            for ($i = 0; $i -lt $potentialItems.Count; $i++) {
              "$i) $($($potentialItems[$i]).Path)"
            }
            $Choice = Read-Host -Prompt "Please enter the number corresponding to the item you would like to extract [0..$($($potentialItems.Count)-1)]"
            if ($(0..$($($potentialItems.Count) - 1)) -notcontains $Choice) {
              Write-Warning "The number indicated does is not a valid choice! Skipping $searchitem..."
              continue
            }
            for ($i = 0; $i -lt $potentialItems.Count; $i++) {
              $shell.Namespace($TargetDir).CopyHere($potentialItems[$Choice],0x14)
            }
          }
          if ($potentialItems.Count -lt 1) {
            Write-Warning "No items within $ZipFileNameWExt match $searchitem! Skipping..."
            continue
          }
        }
      }
      ##### END Main Body #####
    }
  }

  ##### END Native Helper Functions #####

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####
  # Check for Win32 or Win64 OpenSSL Binary
  if (!$(Get-Command openssl.exe -ErrorAction SilentlyContinue)) {
    if ($DownloadAndAddOpenSSLToPath) {
      Write-Host "Downloading openssl.exe from https://indy.fulgan.com/SSL/..."
      $LatestWin64OpenSSLVer = $($($(Invoke-WebRequest -Uri https://indy.fulgan.com/SSL/).Links | Where-Object { $_.href -like "*[a-z]-x64*" }).href | Sort-Object)[-1]
      Invoke-WebRequest -Uri "https://indy.fulgan.com/SSL/$LatestWin64OpenSSLVer" -OutFile "$env:USERPROFILE\Downloads\$LatestWin64OpenSSLVer"
      $SSLDownloadUnzipDir = $(Get-ChildItem "$env:USERPROFILE\Downloads\$LatestWin64OpenSSLVer").BaseName
      if (!$(Test-Path "$env:USERPROFILE\Downloads\$SSLDownloadUnzipDir")) {
        New-Item -Path "$env:USERPROFILE\Downloads\$SSLDownloadUnzipDir" -ItemType Directory
      }
      Unzip-File -PathToZip "$env:USERPROFILE\Downloads\$LatestWin64OpenSSLVer" -TargetDir "$env:USERPROFILE\Downloads\$SSLDownloadUnzipDir"
      # Add OpenSSL to $env:Path
      if ($env:Path[-1] -eq ";") {
        $env:Path = "$env:Path$env:USERPROFILE\Downloads\$SSLDownloadUnzipDir"
      }
      else {
        $env:Path = "$env:Path;$env:USERPROFILE\Downloads\$SSLDownloadUnzipDir"
      }
    }
    else {
      Write-Verbose "The Extract-PFXCerts function requires openssl.exe. Openssl.exe cannot be found on this machine. Use the -DownloadAndAddOpenSSLToPath parameter to download openssl.exe and add it to `$env:Path. NOTE: Openssl.exe does NOT require installation. Halting!"
      Write-Error "The Extract-PFXCerts function requires openssl.exe. Openssl.exe cannot be found on this machine. Use the -DownloadAndAddOpenSSLToPath parameter to download openssl.exe and add it to `$env:Path. NOTE: Openssl.exe does NOT require installation. Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  # OpenSSL can't handle PowerShell SecureStrings, so need to convert it back into Plain Text
  if ($PFXFilePwd) {
    if ($PFXFilePwd.GetType().FullName -eq "System.Security.SecureString") {
      $PwdForPFXOpenSSL = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PFXFilePwd))
    }
    if ($PFXFilePwd.GetType().FullName -eq "System.String") {
      $PwdForPFXOpenSSL = $PFXFilePwd
    }
  }

  $privpos = $PFXFilePath.LastIndexOf("\")
  $PFXFileDir = $PFXFilePath.Substring(0,$privpos)
  $PFXFileName = $PFXFilePath.Substring($privpos + 1)
  $PFXFileNameSansExt = $($PFXFileName.Split("."))[0]

  if (!$OutputDirectory) {
    $OutputDirectory = $PFXFileDir
  }

  $ProtectedPrivateKeyOut = "$PFXFileNameSansExt" + "_protected_private_key" + ".pem"
  $UnProtectedPrivateKeyOut = "$PFXFileNameSansExt" + "_unprotected_private_key" + ".pem"
  $AllPublicKeysInChainOut = "$PFXFileNameSansExt" + "_all_public_keys_in_chain" + ".pem"
  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Parameter Validation #####
  if (!$(Test-Path $PFXFilePath)) {
    Write-Verbose "The path $PFXFilePath was not found! Halting!"
    Write-Error "The path $PFXFilePath was not found! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if (!$(Test-Path $OutputDirectory)) {
    Write-Verbose "The path $OutputDirectory was not found! Halting!"
    Write-Error "The path $OutputDirectory was not found! Halting!"
    $global:FunctionResult = "1"
    return
  }

  ##### END Parameter Validation #####


  ##### BEGIN Main Body #####
  # The .pfx File could (and most likely does) contain a private key
  # Extract Private Key and Keep It Password Protected
  try {
    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $ProcessInfo.FileName = "openssl.exe"
    $ProcessInfo.RedirectStandardError = $true
    $ProcessInfo.RedirectStandardOutput = $true
    $ProcessInfo.UseShellExecute = $false
    $ProcessInfo.Arguments = "pkcs12 -in $PFXFilePath -nocerts -out $OutputDirectory\$ProtectedPrivateKeyOut -nodes -password pass:$PwdForPFXOpenSSL"
    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $ProcessInfo
    $Process.Start() | Out-Null
    $Process.WaitForExit()
    $stdout = $Process.StandardOutput.ReadToEnd()
    $stderr = $Process.StandardError.ReadToEnd()
    $AllOutput = $stdout + $stderr

    if ($AllOutput -match "error") {
      Write-Warning "openssl.exe reports that -PFXFilePwd is incorrect. However, it may be that at this stage in the process, it is not protected with a password. Trying without password..."
      throw
    }
  }
  catch {
    try {
      $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
      $ProcessInfo.FileName = "openssl.exe"
      $ProcessInfo.RedirectStandardError = $true
      $ProcessInfo.RedirectStandardOutput = $true
      $ProcessInfo.UseShellExecute = $false
      $ProcessInfo.Arguments = "pkcs12 -in $PFXFilePath -nocerts -out $OutputDirectory\$ProtectedPrivateKeyOut -nodes -password pass:"
      $Process = New-Object System.Diagnostics.Process
      $Process.StartInfo = $ProcessInfo
      $Process.Start() | Out-Null
      $Process.WaitForExit()
      $stdout = $Process.StandardOutput.ReadToEnd()
      $stderr = $Process.StandardError.ReadToEnd()
      $AllOutput = $stdout + $stderr

      if ($AllOutput -match "error") {
        Write-Warning "openssl.exe reports that -PFXFilePwd is incorrect."
        throw
      }
    }
    catch {
      $PFXFilePwdFailure = $true
    }
  }
  if ($PFXFilePwdFailure -eq $true) {
    Write-Verbose "The value for -PFXFilePwd is incorrect or was not supplied (and is needed). Halting!"
    Write-Error "The value for -PFXFilePwd is incorrect or was not supplied (and is needed). Halting!"
    $global:FunctionResult = "1"
    return
  }


  if ($StripPrivateKeyPwd) {
    # Strip Private Key of Password
    & openssl.exe rsa -In "$PFXFileDir\$ProtectedPrivateKeyOut" -out "$OutputDirectory\$UnProtectedPrivateKeyOut" 2>&1 | Out-Null
  }

  New-Variable -Name "$PFXFileNameSansExt`PrivateKeyInfo" -Value $(
    if ($StripPrivateKeyPwd) {
      [pscustomobject][ordered]@{
        ProtectedPrivateKeyFilePath = "$OutputDirectory\$ProtectedPrivateKeyOut"
        UnProtectedPrivateKeyFilePath = "$OutputDirectory\$UnProtectedPrivateKeyOut"
      }
    }
    else {
      [pscustomobject][ordered]@{
        ProtectedPrivateKeyFilePath = "$OutputDirectory\$ProtectedPrivateKeyOut"
        UnProtectedPrivateKeyFilePath = $null
      }
    }
  )


  # Setup $ArrayOfPubCertPSObjects for PSCustomObject Collection
  $ArrayOfPubCertPSObjects = @()
  # The .pfx File Also Contains ALL Public Certificates in Chain 
  # The below extracts ALL Public Certificates in Chain
  try {
    $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $ProcessInfo.FileName = "openssl.exe"
    $ProcessInfo.RedirectStandardError = $true
    $ProcessInfo.RedirectStandardOutput = $true
    $ProcessInfo.UseShellExecute = $false
    $ProcessInfo.Arguments = "pkcs12 -in $PFXFilePath -nokeys -out $OutputDirectory\$AllPublicKeysInChainOut -password pass:$PwdForPFXOpenSSL"
    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $ProcessInfo
    $Process.Start() | Out-Null
    $Process.WaitForExit()
    $stdout = $Process.StandardOutput.ReadToEnd()
    $stderr = $Process.StandardError.ReadToEnd()
    $AllOutput = $stdout + $stderr

    if ($AllOutput -match "error") {
      Write-Warning "openssl.exe reports that -PFXFilePwd is incorrect. However, it may be that at this stage in the process, it is not protected with a password. Trying without password..."
      throw
    }
  }
  catch {
    try {
      $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
      $ProcessInfo.FileName = "openssl.exe"
      $ProcessInfo.RedirectStandardError = $true
      $ProcessInfo.RedirectStandardOutput = $true
      $ProcessInfo.UseShellExecute = $false
      $ProcessInfo.Arguments = "pkcs12 -in $PFXFilePath -nokeys -out $OutputDirectory\$AllPublicKeysInChainOut -password pass:"
      $Process = New-Object System.Diagnostics.Process
      $Process.StartInfo = $ProcessInfo
      $Process.Start() | Out-Null
      $Process.WaitForExit()
      $stdout = $Process.StandardOutput.ReadToEnd()
      $stderr = $Process.StandardError.ReadToEnd()
      $AllOutput = $stdout + $stderr

      if ($AllOutput -match "error") {
        Write-Warning "openssl.exe reports that -PFXFilePwd is incorrect."
        throw
      }
    }
    catch {
      $PFXFilePwdFailure = $true
    }
  }
  if ($PFXFilePwdFailure -eq $true) {
    Write-Verbose "The value for -PFXFilePwd is incorrect or was not supplied (and is needed). Halting!"
    Write-Error "The value for -PFXFilePwd is incorrect or was not supplied (and is needed). Halting!"
    $global:FunctionResult = "1"
    return
  }
  New-Variable -Name "CertObj$PFXFileNameSansExt" -Scope Script -Value $(
    [pscustomobject][ordered]@{
      CertName = "$PFXFileNameSansExt`AllPublicKCertsInChain"
      AllCertInfo = Get-Content "$OutputDirectory\$AllPublicKeysInChainOut"
      FileLocation = "$OutputDirectory\$AllPublicKeysInChainOut"
    }
  ) -Force

  $ArrayOfPubCertPSObjects +=,$(Get-Variable -Name "CertObj$PFXFileNameSansExt" -ValueOnly)


  # Parse the Public Certificate Chain File and and Write Each Public Certificate to a Separate File
  # These files should have the EXACT SAME CONTENT as the .cer counterparts
  $PublicKeySansChainPrep1 = $(Get-Content "$OutputDirectory\$AllPublicKeysInChainOut") -join "`n"
  $PublicKeySansChainPrep2 = $($PublicKeySansChainPrep1 -replace "-----END CERTIFICATE-----","-----END CERTIFICATE-----;;;").Split(";;;")
  $PublicKeySansChainPrep3 = foreach ($obj1 in $PublicKeySansChainPrep2) {
    if ($obj1 -like "*[\w]*") {
      $obj1.Trim()
    }
  }
  # Setup PSObject for Certs with CertName and CertValue
  foreach ($obj1 in $PublicKeySansChainPrep3) {
    $CertNamePrep = $($obj1).Split("`n") | ForEach-Object { if ($_ | Select-String "subject") { $_ } }
    $CertName = $($CertNamePrep | Select-String "CN=([\w]|[\W]){1,1000}$").Matches.Value -replace "CN=",""
    $IndexNumberForBeginCert = $obj1.Split("`n") | ForEach-Object {
      if ($_ -match "-----BEGIN CERTIFICATE-----") {
        [array]::IndexOf($($obj1.Split("`n")),$_)
      }
    }
    $IndexNumberForEndCert = $obj1.Split("`n") | ForEach-Object {
      if ($_ -match "-----End CERTIFICATE-----") {
        [array]::IndexOf($($obj1.Split("`n")),$_)
      }
    }
    $CertValue = $($($obj1.Split("`n"))[$IndexNumberForBeginCert..$IndexNumberForEndCert] | Out-String).Trim()
    $AttribFriendlyNamePrep = $obj1.Split("`n") | Select-String "friendlyName"
    if ($AttribFriendlyNamePrep) {
      $AttribFriendlyName = $($AttribFriendlyNamePrep.Line).Split(":")[-1].Trim()
    }
    $tmpFile = [IO.Path]::GetTempFileName()
    $CertValue.Trim() | Out-File $tmpFile -Encoding Ascii

    $CertDumpContent = certutil -dump $tmpfile

    $SubjectTypePrep = $CertDumpContent | Select-String -Pattern "Subject Type="
    if ($SubjectTypePrep) {
      $SubjectType = $SubjectTypePrep.Line.Split("=")[-1]
    }
    $RootCertFlag = $CertDumpContent | Select-String -Pattern "Subject matches issuer"

    if ($SubjectType -eq "CA" -and $RootCertFlag) {
      $RootCACert = $True
    }
    else {
      $RootCACert = $False
    }
    if ($SubjectType -eq "CA" -and !$RootCertFlag) {
      $IntermediateCACert = $True
    }
    else {
      $IntermediateCACert = $False
    }
    if ($RootCACert -eq $False -and $IntermediateCACert -eq $False) {
      $EndPointCert = $True
    }
    else {
      $EndPointCert = $False
    }

    New-Variable -Name "CertObj$CertName" -Scope Script -Value $(
      [pscustomobject][ordered]@{
        CertName = $CertName
        FriendlyName = $AttribFriendlyName
        CertValue = $CertValue.Trim()
        AllCertInfo = $obj1.Trim()
        RootCACert = $RootCACert
        IntermediateCACert = $IntermediateCACert
        EndPointCert = $EndPointCert
        FileLocation = "$OutputDirectory\$($CertName)_Public_Cert.pem"
      }
    ) -Force

    $ArrayOfPubCertPSObjects +=,$(Get-Variable -Name "CertObj$CertName" -ValueOnly)

    Remove-Item -Path $tmpFile -Force
    Remove-Variable -Name "tmpFile" -Force
  }

  # Write each CertValue to Separate Files (i.e. writing all public keys in chain to separate files)
  foreach ($obj1 in $ArrayOfPubCertPSObjects) {
    if ($(Test-Path $obj1.FileLocation) -and !$Force) {
      Write-Verbose "The extracted Public cert $($obj1.CertName) was NOT written to $OutputDirectory because it already exists there!"
    }
    if (!$(Test-Path $obj1.FileLocation) -or $Force) {
      $obj1.CertValue | Out-File "$($obj1.FileLocation)" -Encoding Ascii
      Write-Verbose "Public certs have been extracted and written to $OutputDirectory"
    }
  }

  New-Variable -Name "PubAndPrivInfoOutput" -Scope Script -Value $(
    [pscustomobject][ordered]@{
      PublicKeysInfo = $ArrayOfPubCertPSObjects
      PrivateKeyInfo = $(Get-Variable -Name "$PFXFileNameSansExt`PrivateKeyInfo" -ValueOnly)
    }
  ) -Force

  $(Get-Variable -Name "PubAndPrivInfoOutput" -ValueOnly)

  $global:FunctionResult = "0"
  ##### END Main Body #####

}

function Load-ModulesFrom {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string]$ModuleDirectory = $(Read-Host -Prompt "Please enter the full path to the directory that contains PowerShell Modules you would like to load"),

    [Parameter(Mandatory = $False)]
    [string[]]$ModulesToLoad
  )

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####
  # Get current $PSModulePath
  $OriginalPSModulePath = $env:PSModulePath
  $OriginalPSModulePathArr = $OriginalPSModulePath -split ";"

  # Validating a string that is supposed to be a Local or UNC Path
  if (!$($([uri]$ModuleDirectory).IsAbsoluteURI -and $($([uri]$ModuleDirectory).IsLoopBack -or $([uri]$ModuleDirectory).IsUnc))) {
    Write-Error "$ModuleDirectory is not a valid directory path! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if (!$(Test-Path $ModuleDirectory)) {
    Write-Error "The path $ModuleDirectory was not found! Halting!"
    $global:FunctionResult = "1"
    return
  }

  $ModuleDirSubDirs = Get-ChildItem -Path $ModuleDirectory -Directory
  if ($ModuleDirSubDirs.Count -lt 1) {
    Write-Error "No Modules were found under $ModuleDirectory! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if ($ModulesToLoad) {
    [System.Collections.ArrayList]$FinalModulesToLoad = @()
    foreach ($ModName in $ModulesToLoad) {
      if ($ModuleDirSubDirs.Name -notcontains $ModName) {
        Write-Warning "Unable to find $ModName under $ModuleDirectory! Skipping..."
      }
      else {
        foreach ($subdir in $ModuleDirSubDirs) {
          if ($subdir.Name -eq $ModName) {
            $null = $FinalModulesToLoad.Add($subdir)
          }
        }
      }
    }
  }
  else {
    $FinalModulesToLoad = $ModuleDirSubDirs
  }

  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Main Body #####

  $env:PSModulePath = $null

  $env:PSModulePath = $ModuleDirectory

  foreach ($ModItem in $FinalModulesToLoad) {
    Write-Host "Attempting to load module $($ModItem.Name) from directory $($ModItem.FullName)..."
    Import-Module -Name $(Get-ChildItem $ModItem.FullName -Filter "$(ModItem.Name).psd1").FullName
  }

  if ($OriginalPSModulePathArr -contains $ModuleDirectory) {
    $UpdatedPSModulePath = $OriginalPSModulePath
  }
  else {
    $UpdatedPSModulePath = $OriginalPSModulePath + $ModuleDirectory
  }

  $env:PSModulePath = $UpdatedPSModulePath

  <#
    [System.Collections.ArrayList]$PotentialPSD1FilesToLoad = @()
    [System.Collections.ArrayList]$FinalPSD1FilesToLoad = @()
    foreach ($ModItem in $FinalModulesToLoad) {
        # Make sure the Module is not already loaded
        if ($(Get-Module).Name -contains $ModItem.Name) {
            Write-Warning "$($ModItem.Name) is already loaded from $($(Get-Module -Name $($ModItem.Name)).ModuleBase)! Skipping..."
            continue
        }
        else {
            # Select .psd1 files at the specified depths as long as there is only ONE .psd1 file
            # in the specified directory at the current depth
            $StartLevel = 0 # 0 = include base folder, 1 = sub-folders only, 2 = start at 2nd level
            $Depth = 2      # How many levels deep to scan
            $BaseDir = $ModItem.FullName     # starting path
            for ($i=$StartLevel; $i -le $Depth; $i++) {
                $Levels = "\*" * $i
                $ProvPath = $(Resolve-Path $BaseDir$Levels).ProviderPath
                $GetPSD1Files = if ($ProvPath -ne $null) {$ProvPath | Get-Item | Where-Object {$_.Extension -eq ".psd1"}}
                New-Variable -Name "ModulePSD1Search$i" -Value $(
                    [pscustomobject][ordered]@{
                        ModuleDirectoryInfoItem   = $ModItem
                        psd1SearchResults         = $GetPSD1Files
                        Depth                     = $i
                    }
                ) -Force

                $null = $PotentialPSD1FilesToLoad.Add($(Get-Variable -Name "ModulePSD1Search$i" -ValueOnly))
                
            }
        }
    }

    $PotentialPSD1FilesGrouped = $PotentialPSD1FilesToLoad | Group-Object -Property ModuleDirectoryInfoItem

    # We only want to load the .psd1 file at the shallowest depth...
    foreach ($PSD1Group in $PotentialPSD1FilesGrouped) {
        for ($i=0; $i -lt $PSD1Group.Group.Count; $i++) {
            if ($PSD1Group.Group[$i].psd1SearchResults.Count -eq 1) {
                $null = $FinalPSD1FilesToLoad.Add($($PSD1Group.Group[$i].psd1SearchResults.FullName))
                break
            }
        }
    }

    foreach ($PSD1File in $FinalPSD1FilesToLoad) {
        Import-Module $PSD1File
    }
    #>

  ##### END Main Body #####

}

function Get-WebSiteText {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True)]
    [string]$SiteUrl
  )

  # Make sure $SiteUrl is a valid Url
  try {
    $SiteUrlAsUriObj = [uri]$SiteUrl
  }
  catch {
    Write-Error $_
    $global:FunctionResult = "1"
    return
  }

  if (![bool]$($SiteUrlAsUriObj.Scheme -match "http")) {
    Write-Error "'$SiteUrl' does not appear to be a URL! Halting!"
    $global:FunctionResult = "1"
    return
  }

  $pldmggFunctionsUrl = "https://raw.githubusercontent.com/pldmgg/misc-powershell/master/MyFunctions"

  if (![bool]$(Get-Command Install-Program -ErrorAction SilentlyContinue)) {
    $InstallProgramFunctionUrl = "$pldmggFunctionsUrl/Install-Program.ps1"
    try {
      Invoke-Expression $([System.Net.WebClient]::new().DownloadString($InstallProgramFunctionUrl))
    }
    catch {
      Write-Error $_
      Write-Error "Unable to load the Install-Program function! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  try {
    $InstallProgramSplatParams = @{
      ProgramName = "Nuget.CommandLine"
      CommandName = "nuget"
      UseChocolateyCmdLine = $True
      ErrorAction = "SilentlyContinue"
      ErrorVariable = "IPErr"
    }

    $InstallNuGetCmdLineResult = Install-Program @InstallProgramSplatParams
    if (!$InstallNuGetCmdLineResult) { throw "The Install-Program function failed!" }
  }
  catch {
    Write-Error $_
    Write-Host "Errors for the Install-Program function are as follows:"
    Write-Error $($IPErr | Out-String)
    $global:FunctionResult = "1"
    return
  }

  if (!$(Get-Command nuget -ErrorAction SilentlyContinue)) {
    Write-Error "Unable to find 'nuget.exe' after Nuget.CommandLine install! Halting!"
    $global:FunctionResult = "1"
    return
  }

  $null = nuget install htmlagilitypack

  if (!$(Test-Path "$HOME\.nuget\packages\htmlagilitypack")) {
    Write-Error "The Nuget CommandLine did not install HTML Agility Pack to '$HOME\.nuget\packages\htmlagilitypack'! Halting!"
    $global:FunctionResult = "1"
    return
  }

  $CurrentlyLoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()

  if (![bool]$($CurrentlyLoadedAssemblies.FullName -match "HtmlAgilityPack")) {
    $PathToHtmlAgilityPackDLL = $(Resolve-Path "$HOME\.nuget\packages\htmlagilitypack\*\lib\net40\HtmlAgilityPack.dll").Path
    [Reflection.Assembly]::LoadFile($PathToHtmlAgilityPackDLL)
  }
  else {
    Write-Warning "HtmlAgilityPack is already loaded!"
  }

  $Web = [HtmlAgilityPack.HtmlWeb]::new()
  $HtmlDoc = [HtmlAgilityPack.HtmlDocument]$Web.Load($SiteUrl)
  $TextNodes = $HtmlDoc.DocumentNode.SelectNodes("//*[not(self::script or self::style)]/text()")

  $FinalTextBlob = foreach ($node in $TextNodes) {
    if ($node.InnerText -match "[\w]") {
      $node.InnerText
    }
  }

  $FinalTextBlob
}

function New-Shortcut {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    $AppLocation = $(Read-Host -Prompt "Please enter the full path to the file you would like to create a shortcut to"),

    [Parameter(Mandatory = $False)]
    $ShortcutDestDir = [System.Environment]::CurrentDirectory,

    [Parameter(Mandatory = $False)]
    $ShortcutFileName = $(Read-Host -Prompt "Please enter the file name you would like the new shortcut to have"),

    [Parameter(Mandatory = $False)]
    $ShortcutIconFilePath,# path to a .ico file for the shortcut icon

    [Parameter(Mandatory = $False)]
    [string]$ShortcutArguments

  )

  ##### BEGIN Native Helper Functions #####

  function Check-Elevation {
    if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.PSVersion.Major -le 5) {
      [System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal (
        [System.Security.Principal.WindowsIdentity]::GetCurrent()
      )

      [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

      if ($currentPrincipal.IsInRole($administratorsRole)) {
        return $true
      }
      else {
        return $false
      }
    }

    if ($PSVersionTable.Platform -eq "Unix") {
      if ($(whoami) -eq "root") {
        return $true
      }
      else {
        return $false
      }
    }
  }


  ##### END Native Helper Functions #####

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

  if (!$(Check-Elevation)) {
    Write-Error "The New-Shortcut cmdlet must be run from an elevated shell (i.e. Run As Administrator)! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if (!$(Test-Path $ShortcutDestDir)) {
    Write-Error "The path $ShortcutDestDir was not found! Halting!"
    $global:FunctionResult = "1"
    return
  }

  $InvalidFileNameChars = [System.IO.Path]::GetInvalidFileNameChars()
  $InvalidFileNameChars = $InvalidFileNameChars | ForEach-Object { if ($_ -eq '\') { '\\' } else { $_ } }

  [System.Collections.ArrayList]$FoundIllegalCharacters = @()
  $InvalidFileNameChars | ForEach-Object {
    if ($ShortcutFileName -match $_) {

      Write-Error "The filename for the shortcut (i.e. $ShortcutFileName) contains an illegal character '$_' ! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }
  if ($ShortcutFileName -match $InvalidFileNameChars) {

  }
  if ($ShortcutFileName -match "\.lnk$") {
    $ShortcutFileName = $($ShortcutFileName -split "\.lnk")[0]
  }

  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Main Body #####

  $WshShell = New-Object -ComObject WScript.Shell
  # This is where the shortcut will be created
  $Shortcut = $WshShell.CreateShortcut("$ShortcutDestDir\$ShortcutFileName.lnk")
  # This is the program the shortcut will open
  $Shortcut.TargetPath = "$AppLocation"
  # This is the icon location that the shortcut will use
  $Shortcut.IconLocation = "$ShortcutIconFilePath,0"
  # This is any extra parameters that the shortcut may have. For example, opening to google.com when internet explorer opens
  $Shortcut.Arguments = "$ShortcutArguments"
  # This command will save all the modifications to the newly created shortcut.
  $Shortcut.Save()

  ##### END Main Body #####

}

function Install-ChocolateyCmdLine {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [switch]$NoUpdatePackageManagement
  )

  ##### BEGIN Native Helper Functions #####

  function GetElevation {
    if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.PSVersion.Major -le 5) {
      [System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal (
        [System.Security.Principal.WindowsIdentity]::GetCurrent()
      )

      [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

      if ($currentPrincipal.IsInRole($administratorsRole)) {
        return $true
      }
      else {
        return $false
      }
    }

    if ($PSVersionTable.Platform -eq "Unix") {
      if ($(whoami) -eq "root") {
        return $true
      }
      else {
        return $false
      }
    }
  }

  ##### END Native Helper Functions #####

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####
  # Invoke-WebRequest fix...
  [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

  if (!$(GetElevation)) {
    Write-Error "The $($MyInvocation.MyCommand.Name) function must be ran from an elevated PowerShell Session (i.e. 'Run as Administrator')! Halting!"
    $global:FunctionResult = "1"
    return
  }

  Write-Host "Please wait..."
  $global:FunctionResult = "0"
  $MyFunctionsUrl = "https://raw.githubusercontent.com/pldmgg/misc-powershell/master/MyFunctions"

  if (!$NoUpdatePackageManagement) {
    if (![bool]$(Get-Command Update-PackageManagement -ErrorAction SilentlyContinue)) {
      $UpdatePMFunctionUrl = "$MyFunctionsUrl/PowerShellCore_Compatible/Update-PackageManagement.ps1"
      try {
        Invoke-Expression $([System.Net.WebClient]::new().DownloadString($UpdatePMFunctionUrl))
      }
      catch {
        Write-Error $_
        Write-Error "Unable to load the Update-PackageManagement function! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }

    try {
      $global:FunctionResult = "0"
      $UPMResult = Update-PackageManagement -AddChocolateyPackageProvider -ErrorAction SilentlyContinue -ErrorVariable UPMErr
      if ($global:FunctionResult -eq "1" -or $UPMResult -eq $null) { throw "The Update-PackageManagement function failed!" }
    }
    catch {
      Write-Error $_
      Write-Host "Errors from the Update-PackageManagement function are as follows:"
      Write-Error $($UPMErr | Out-String)
      $global:FunctionResult = "1"
      return
    }
  }

  if (![bool]$(Get-Command Refresh-ChocolateyEnv -ErrorAction SilentlyContinue)) {
    $RefreshCEFunctionUrl = "$MyFunctionsUrl/PowerShellCore_Compatible/Refresh-ChocolateyEnv.ps1"
    try {
      Invoke-Expression $([System.Net.WebClient]::new().DownloadString($RefreshCEFunctionUrl))
    }
    catch {
      Write-Error $_
      Write-Error "Unable to load the Refresh-ChocolateyEnv function! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Main Body #####

  if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
    # The below Install-Package Chocolatey screws up $env:Path, so restore it afterwards
    $OriginalEnvPath = $env:Path

    # Installing Package Providers is spotty sometimes...Using while loop 3 times before failing
    $Counter = 0
    while ($(Get-PackageProvider).Name -notcontains "Chocolatey" -and $Counter -lt 3) {
      Install-PackageProvider -Name Chocolatey -Force -Confirm:$false -WarningAction SilentlyContinue
      $Counter++
      Start-Sleep -Seconds 5
    }
    if ($(Get-PackageProvider).Name -notcontains "Chocolatey") {
      Write-Error "Unable to install the Chocolatey Package Provider / Repo for PackageManagement/PowerShellGet! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if (![bool]$(Get-Package -Name Chocolatey -ProviderName Chocolatey -ErrorAction SilentlyContinue)) {
      # NOTE: The PackageManagement install of choco is unreliable, so just in case, fallback to the Chocolatey cmdline for install
      $null = Install-Package Chocolatey -Provider Chocolatey -Force -Confirm:$false -ErrorVariable ChocoInstallError -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

      if ($ChocoInstallError.Count -gt 0) {
        Write-Warning "There was a problem installing the Chocolatey CmdLine via PackageManagement/PowerShellGet!"
        $InstallViaOfficialScript = $True
        Uninstall-Package Chocolatey -Force -ErrorAction SilentlyContinue
      }

      if ($ChocoInstallError.Count -eq 0) {
        $PMPGetInstall = $True
      }
    }

    # Try and find choco.exe
    try {
      Write-Host "Refreshing `$env:Path..."
      $global:FunctionResult = "0"
      $null = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue -ErrorVariable RCEErr

      if ($RCEErr.Count -gt 0 -and
        $global:FunctionResult -eq "1" -and
        ![bool]$($RCEErr -match "Neither the Chocolatey PackageProvider nor the Chocolatey CmdLine appears to be installed!")) {
        throw "The Refresh-ChocolateyEnv function failed! Halting!"
      }
    }
    catch {
      Write-Error $_
      Write-Host "Errors from the Refresh-ChocolateyEnv function are as follows:"
      Write-Error $($RCEErr | Out-String)
      $global:FunctionResult = "1"
      return
    }

    if ($PMPGetInstall) {
      # It's possible that PowerShellGet didn't run the chocolateyInstall.ps1 script to actually install the
      # Chocolatey CmdLine. So do it manually.
      if (Test-Path "C:\Chocolatey") {
        $ChocolateyPath = "C:\Chocolatey"
      }
      elseif (Test-Path "C:\ProgramData\chocolatey") {
        $ChocolateyPath = "C:\ProgramData\chocolatey"
      }
      else {
        Write-Warning "Unable to find Chocolatey directory! Halting!"
        Write-Host "Installing via official script at https://chocolatey.org/install.ps1"
        $InstallViaOfficialScript = $True
      }

      if ($ChocolateyPath) {
        $ChocolateyInstallScript = $(Get-ChildItem -Path $ChocolateyPath -Recurse -File -Filter "*chocolateyinstall.ps1").FullName | Where-Object {
          $_ -match ".*?chocolatey\.[0-9].*?chocolateyinstall.ps1$"
        }

        if (!$ChocolateyInstallScript) {
          Write-Warning "Unable to find chocolateyinstall.ps1!"
          $InstallViaOfficialScript = $True
        }
      }

      if ($ChocolateyInstallScript) {
        try {
          Write-Host "Trying PowerShellGet Chocolatey CmdLine install script from $ChocolateyInstallScript ..." -ForegroundColor Yellow
          & $ChocolateyInstallScript
        }
        catch {
          Write-Error $_
          Write-Error "The Chocolatey Install Script $ChocolateyInstallScript has failed!"

          if ([bool]$(Get-Package $ProgramName)) {
            Uninstall-Package Chocolatey -Force -ErrorAction SilentlyContinue
          }
        }
      }
    }

    # If we still can't find choco.exe, then use the Chocolatey install script from chocolatey.org
    if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue) -or $InstallViaOfficialScript) {
      $ChocolateyInstallScriptUrl = "https://chocolatey.org/install.ps1"
      try {
        Invoke-Expression $([System.Net.WebClient]::new().DownloadString($ChocolateyInstallScriptUrl))
      }
      catch {
        Write-Error $_
        Write-Error "Unable to install Chocolatey via the official chocolatey.org script! Halting!"
        $global:FunctionResult = "1"
        return
      }

      $PMPGetInstall = $False
    }

    # If we STILL can't find choco.exe, then Refresh-ChocolateyEnv a third time...
    #if (![bool]$($env:Path -split ";" -match "chocolatey\\bin")) {
    if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
      # ...and then find it again and add it to $env:Path via Refresh-ChocolateyEnv function
      if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
        try {
          Write-Host "Refreshing `$env:Path..."
          $global:FunctionResult = "0"
          $null = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue -ErrorVariable RCEErr

          if ($RCEErr.Count -gt 0 -and
            $global:FunctionResult -eq "1" -and
            ![bool]$($RCEErr -match "Neither the Chocolatey PackageProvider nor the Chocolatey CmdLine appears to be installed!")) {
            throw "The Refresh-ChocolateyEnv function failed! Halting!"
          }
        }
        catch {
          Write-Error $_
          Write-Host "Errors from the Refresh-ChocolateyEnv function are as follows:"
          Write-Error $($RCEErr | Out-String)
          $global:FunctionResult = "1"
          return
        }
      }
    }

    # If we STILL can't find choco.exe, then give up...
    if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
      Write-Error "Unable to find choco.exe after install! Check your `$env:Path! Halting!"
      $global:FunctionResult = "1"
      return
    }
    else {
      Write-Host "Finished installing Chocolatey CmdLine." -ForegroundColor Green

      try {
        cup chocolatey-core.extension -y
      }
      catch {
        Write-Error "Installation of chocolatey-core.extension via the Chocolatey CmdLine failed! Halting!"
        $global:FunctionResult = "1"
        return
      }

      try {
        Write-Host "Refreshing `$env:Path..."
        $global:FunctionResult = "0"
        $null = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue -ErrorVariable RCEErr
        if ($RCEErr.Count -gt 0 -and $global:FunctionResult -eq "1") {
          throw "The Refresh-ChocolateyEnv function failed! Halting!"
        }
      }
      catch {
        Write-Error $_
        Write-Host "Errors from the Refresh-ChocolateyEnv function are as follows:"
        Write-Error $($RCEErr | Out-String)
        $global:FunctionResult = "1"
        return
      }

      $ChocoModulesThatRefreshEnvShouldHaveLoaded = @(
        "chocolatey-core"
        "chocolateyInstaller"
        "chocolateyProfile"
        "chocolateysetup"
      )

      foreach ($ModName in $ChocoModulesThatRefreshEnvShouldHaveLoaded) {
        if ($(Get-Module).Name -contains $ModName) {
          Write-Host "The $ModName Module has been loaded from $($(Get-Module -Name $ModName).Path)" -ForegroundColor Green
        }
      }
    }
  }
  else {
    Write-Warning "The Chocolatey CmdLine is already installed!"
  }

  ##### END Main Body #####
}

<#
    .SYNOPSIS
        Install a Program using PackageManagement/PowerShellGet OR the Chocolatey Cmdline.

    .DESCRIPTION
        This function was written to make program installation on Windows as easy and generic
        as possible by leveraging existing solutions such as PackageManagement/PowerShellGet
        and the Chocolatey CmdLine.

        The function defaults to using PackageManagement/PowerShellGet. If that fails for
        whatever reason, then the Chocolatey CmdLine is used. You can also use appropriate
        parameters to specifically use EITHER PackageManagement/PowerShellGet OR the
        Chocolatey CmdLine

    .PARAMETER ProgramName
        This parameter is MANDATORY.

        This paramter takes a string that represents the name of the program that you'd like to install.

    .PARAMETER UsePowerShellGet
        This parameter is OPTIONAL.

        This parameter is a switch that makes the function attempt program installation using ONLY
        PackageManagement/PowerShellGet Modules. Install using those modules fails for whatever
        reason, the function halts and returns the relevant error message(s).

        Installation via the Chocolatey CmdLine will NOT be attempted.

    .PARAMETER UseChocolateyCmdLine
        This parameter is OPTIONAL.

        This parameter is a switch that makes the function attemt program installation using ONLY
        the Chocolatey CmdLine. If installation via the Chocolatey CmdLine fails for whatever reason,
        the function halts and returns the relevant error message(s)

    .PARAMETER ExpectedInstallLocation
        This parameter is OPTIONAL.

        This parameter takes a string that represents the full path to a directory that contains the
        main executable for the installed program. This directory does NOT have to be the immediate
        parent directory of the .exe.

        If you are absolutely certain you know where on the filesystem the program will be installed,
        then use this parameter to speed things up.

    .PARAMETER CommandName
        This parameter is OPTIONAL.

        This parameter takes a string that represents the name of the main executable for the installed
        program. For example, if you are installing 7zip, the value of this parameter should be (under
        most circumstances) '7z'.

    .PARAMETER NoUpdatePackageManagement
        This parameter is OPTIONAL.

        This parameter is a switch that suppresses this function's default behavior, which is to try
        and update PackageManagement/PowerShellGet Modules before attempting to use them to install
        the desired program. Updating these modules can take up to a minute, so use this switch
        if you want to skip the attempt to update.

    .EXAMPLE
        Install-Program -ProgramName kubernetes-cli -CommandName kubectl.exe

    .EXAMPLE
        Install-Program -ProgramName awscli -CommandName aws.exe -UsePowerShellGet

    .EXAMPLE
        Install-Program -ProgramName VisualStudioCode -CommandName Code.exe -UseChocolateyCmdLine

    .EXAMPLE
        # If the Program Name and Main Executable are the same, then this is all you need...
        Install-Program -ProgramName vagrant

#>
function Install-Program {
  [CmdletBinding(DefaultParameterSetName = 'ChocoCmdLine')]
  param(
    [Parameter(Mandatory = $True)]
    [string]$ProgramName,

    [Parameter(Mandatory = $False)]
    [string]$CommandName,

    [Parameter(
      Mandatory = $False,
      ParameterSetName = 'PackageManagement'
    )]
    [switch]$UsePowerShellGet,

    [Parameter(
      Mandatory = $False,
      ParameterSetName = 'PackageManagement'
    )]
    [switch]$ForceChocoInstallScript,

    [Parameter(Mandatory = $False)]
    [switch]$UseChocolateyCmdLine,

    [Parameter(Mandatory = $False)]
    [string]$ExpectedInstallLocation,

    [Parameter(Mandatory = $False)]
    [switch]$NoUpdatePackageManagement = $True,

    [Parameter(Mandatory = $False)]
    [switch]$ScanCDriveForMainExeIfNecessary,

    [Parameter(Mandatory = $False)]
    [switch]$ResolveCommandPath = $True,

    [Parameter(Mandatory = $False)]
    [switch]$PreRelease
  )

  ##### BEGIN Native Helper Functions #####

  # The below function adds Paths from System PATH that aren't present in $env:Path (this probably shouldn't
  # be an issue, because $env:Path pulls from System PATH...but sometimes profile.ps1 scripts do weird things
  # and also $env:Path wouldn't necessarily be updated within the same PS session where a program is installed...)
  function Synchronize-SystemPathEnvPath {
    $SystemPath = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path

    $SystemPathArray = $SystemPath -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }
    $EnvPathArray = $env:Path -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }

    # => means that $EnvPathArray HAS the paths but $SystemPathArray DOES NOT
    # <= means that $SystemPathArray HAS the paths but $EnvPathArray DOES NOT
    $PathComparison = Compare-Object $SystemPathArray $EnvPathArray
    [System.Collections.ArrayList][array]$SystemPathsThatWeWantToAddToEnvPath = $($PathComparison | Where-Object { $_.SideIndicator -eq "<=" }).InputObject

    if ($SystemPathsThatWeWantToAddToEnvPath.Count -gt 0) {
      foreach ($NewPath in $SystemPathsThatWeWantToAddToEnvPath) {
        if ($env:Path[-1] -eq ";") {
          $env:Path = "$env:Path$NewPath"
        }
        else {
          $env:Path = "$env:Path;$NewPath"
        }
      }
    }
  }

  # Outputs [System.Collections.ArrayList]$ExePath
  function Adjudicate-ExePath {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $True)]
      [string]$ProgramName,

      [Parameter(Mandatory = $True)]
      [string]$OriginalSystemPath,

      [Parameter(Mandatory = $True)]
      [string]$OriginalEnvPath,

      [Parameter(Mandatory = $True)]
      [string]$FinalCommandName,

      [Parameter(Mandatory = $False)]
      [string]$ExpectedInstallLocation
    )

    # ...search for it in the $ExpectedInstallLocation if that parameter is provided by the user...
    if ($ExpectedInstallLocation) {
      [System.Collections.ArrayList][array]$ExePath = $(Get-ChildItem -Path $ExpectedInstallLocation -File -Recurse -Filter "*$FinalCommandName.exe").FullName
    }
    # If we don't have $ExpectedInstallLocation provided...
    if (!$ExpectedInstallLocation) {
      # ...then we can compare $OriginalSystemPath to the current System PATH to potentially
      # figure out which directories *might* contain the main executable.
      $OriginalSystemPathArray = $OriginalSystemPath -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }
      $OriginalEnvPathArray = $OriginalEnvPath -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }

      $CurrentSystemPath = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
      $CurrentSystemPathArray = $CurrentSystemPath -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }
      $CurrentEnvPath = $env:Path
      $CurrentEnvPathArray = $CurrentEnvPath -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }


      $OriginalVsCurrentSystemPathComparison = Compare-Object $OriginalSystemPathArray $CurrentSystemPathArray
      $OriginalVsCurrentEnvPathComparison = Compare-Object $OriginalEnvPathArray $CurrentEnvPathArray

      [System.Collections.ArrayList]$DirectoriesToSearch = @()
      if ($OriginalVsCurrentSystemPathComparison -ne $null) {
        # => means that $CurrentSystemPathArray has some new directories
        [System.Collections.ArrayList][array]$NewSystemPathDirs = $($OriginalVsCurrentSystemPathComparison | Where-Object { $_.SideIndicator -eq "=>" }).InputObject

        if ($NewSystemPathDirs.Count -gt 0) {
          foreach ($dir in $NewSystemPathDirs) {
            $null = $DirectoriesToSearch.Add($dir)
          }
        }
      }
      if ($OriginalVsCurrentEnvPathComparison -ne $null) {
        # => means that $CurrentEnvPathArray has some new directories
        [System.Collections.ArrayList][array]$NewEnvPathDirs = $($OriginalVsCurrentEnvPathComparison | Where-Object { $_.SideIndicator -eq "=>" }).InputObject

        if ($NewEnvPathDirs.Count -gt 0) {
          foreach ($dir in $NewEnvPathDirs) {
            $null = $DirectoriesToSearch.Add($dir)
          }
        }
      }

      if ($DirectoriesToSearch.Count -gt 0) {
        $DirectoriesToSearchFinal = $($DirectoriesToSearch | Sort-Object | Get-Unique) | ForEach-Object { if (Test-Path $_) { $_ } }
        $DirectoriesToSearchFinal = $DirectoriesToSearchFinal | Where-Object { $_ -match "$ProgramName" }

        [System.Collections.ArrayList]$ExePath = @()
        foreach ($dir in $DirectoriesToSearchFinal) {
          [array]$ExeFiles = $(Get-ChildItem -Path $dir -File -Filter "*$FinalCommandName.exe").FullName
          if ($ExeFiles.Count -gt 0) {
            $null = $ExePath.Add($ExeFiles)
          }
        }

        # If there IS a difference in original vs current System PATH / $Env:Path, but we 
        # still DO NOT find the main executable in those diff directories (i.e. $ExePath is still not set),
        # it's possible that the name of the main executable that we're looking for is actually
        # incorrect...in which case just tell the user that we can't find the expected main
        # executable name and provide a list of other .exe files that we found in the diff dirs.
        if (!$ExePath -or $ExePath.Count -eq 0) {
          [System.Collections.ArrayList]$ExePath = @()
          foreach ($dir in $DirectoriesToSearchFinal) {
            [array]$ExeFiles = $(Get-ChildItem -Path $dir -File -Filter "*.exe").FullName
            foreach ($File in $ExeFiles) {
              $null = $ExePath.Add($File)
            }
          }
        }
      }
    }

    $ExePath | Sort-Object | Get-Unique
  }

  function GetElevation {
    if ($PSVersionTable.PSEdition -eq "Desktop" -or $PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.PSVersion.Major -le 5) {
      [System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal (
        [System.Security.Principal.WindowsIdentity]::GetCurrent()
      )

      [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

      if ($currentPrincipal.IsInRole($administratorsRole)) {
        return $true
      }
      else {
        return $false
      }
    }

    if ($PSVersionTable.Platform -eq "Unix") {
      if ($(whoami) -eq "root") {
        return $true
      }
      else {
        return $false
      }
    }
  }

  ##### END Native Helper Functions #####

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

  # Invoke-WebRequest fix...
  [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

  if (!$(GetElevation)) {
    Write-Error "The $($MyInvocation.MyCommand.Name) function must be ran from an elevated PowerShell Session (i.e. 'Run as Administrator')! Halting!"
    $global:FunctionResult = "1"
    return
  }

  if ($UseChocolateyCmdLine) {
    $NoUpdatePackageManagement = $True
  }

  Write-Host "Please wait..."
  $global:FunctionResult = "0"
  $MyFunctionsUrl = "https://raw.githubusercontent.com/pldmgg/misc-powershell/master/MyFunctions"

  $null = Install-PackageProvider -Name nuget -Force -Confirm:$False
  $null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  $null = Install-PackageProvider -Name Chocolatey -Force -Confirm:$False
  $null = Set-PackageSource -Name chocolatey -Trusted -Force

  if (!$NoUpdatePackageManagement) {
    if (![bool]$(Get-Command Update-PackageManagement -ErrorAction SilentlyContinue)) {
      $UpdatePMFunctionUrl = "$MyFunctionsUrl/PowerShellCore_Compatible/Update-PackageManagement.ps1"
      try {
        Invoke-Expression $([System.Net.WebClient]::new().DownloadString($UpdatePMFunctionUrl))
      }
      catch {
        Write-Error $_
        Write-Error "Unable to load the Update-PackageManagement function! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }

    try {
      $global:FunctionResult = "0"
      $null = Update-PackageManagement -AddChocolateyPackageProvider -ErrorAction SilentlyContinue -ErrorVariable UPMErr
      if ($UPMErr -and $global:FunctionResult -eq "1") { throw "The Update-PackageManagement function failed! Halting!" }
    }
    catch {
      Write-Error $_
      Write-Host "Errors from the Update-PackageManagement function are as follows:"
      Write-Error $($UPMErr | Out-String)
      $global:FunctionResult = "1"
      return
    }
  }

  if ($UseChocolateyCmdLine -or $(!$UsePowerShellGet -and !$UseChocolateyCmdLine)) {
    if (![bool]$(Get-Command Install-ChocolateyCmdLine -ErrorAction SilentlyContinue)) {
      $InstallCCFunctionUrl = "$MyFunctionsUrl/Install-ChocolateyCmdLine.ps1"
      try {
        Invoke-Expression $([System.Net.WebClient]::new().DownloadString($InstallCCFunctionUrl))
      }
      catch {
        Write-Error $_
        Write-Error "Unable to load the Install-ChocolateyCmdLine function! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }
  }

  if (![bool]$(Get-Command Refresh-ChocolateyEnv -ErrorAction SilentlyContinue)) {
    $RefreshCEFunctionUrl = "$MyFunctionsUrl/PowerShellCore_Compatible/Refresh-ChocolateyEnv.ps1"
    try {
      Invoke-Expression $([System.Net.WebClient]::new().DownloadString($RefreshCEFunctionUrl))
    }
    catch {
      Write-Error $_
      Write-Error "Unable to load the Refresh-ChocolateyEnv function! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  # If PackageManagement/PowerShellGet is installed, determine if $ProgramName is installed
  if ([bool]$(Get-Command Get-Package -ErrorAction SilentlyContinue)) {
    $PackageManagementInstalledPrograms = Get-Package

    # If teh Current Installed Version is not equal to the Latest Version available, then it's outdated
    if ($PackageManagementInstalledPrograms.Name -contains $ProgramName) {
      $PackageManagementCurrentInstalledPackage = $PackageManagementInstalledPrograms | Where-Object { $_.Name -eq $ProgramName }
      $PackageManagementLatestVersion = $(Find-Package -Name $ProgramName -Source chocolatey -AllVersions | Sort-Object -Property Version)[-1]
    }
  }

  # If the Chocolatey CmdLine is installed, get a list of programs installed via Chocolatey
  if ([bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
    $ChocolateyInstalledProgramsPrep = clist --local-only
    $ChocolateyInstalledProgramsPrep = $ChocolateyInstalledProgramsPrep[1..$($ChocolateyInstalledProgramsPrep.Count - 2)]

    [System.Collections.ArrayList]$ChocolateyInstalledProgramsPSObjects = @()

    foreach ($program in $ChocolateyInstalledProgramsPrep) {
      $programParsed = $program -split " "
      $PSCustomObject = [pscustomobject]@{
        ProgramName = $programParsed[0]
        Version = $programParsed[1]
      }

      $null = $ChocolateyInstalledProgramsPSObjects.Add($PSCustomObject)
    }

    # Also get a list of outdated packages in case this Install-Program function is used to update a package
    $ChocolateyOutdatedProgramsPrep = choco outdated
    $UpperLineMatch = $ChocolateyOutdatedProgramsPrep -match "Output is package name"
    $LowerLineMatch = $ChocolateyOutdatedProgramsPrep -match "Chocolatey has determined"
    $UpperIndex = $ChocolateyOutdatedProgramsPrep.IndexOf($UpperLineMatch) + 2
    $LowerIndex = $ChocolateyOutdatedProgramsPrep.IndexOf($LowerLineMatch) - 2
    $ChocolateyOutdatedPrograms = $ChocolateyOutdatedProgramsPrep[$UpperIndex..$LowerIndex]

    [System.Collections.ArrayList]$ChocolateyOutdatedProgramsPSObjects = @()
    foreach ($line in $ChocolateyOutdatedPrograms) {
      $ParsedLine = $line -split "\|"
      $Program = $ParsedLine[0]
      $CurrentInstalledVersion = $ParsedLine[1]
      $LatestAvailableVersion = $ParsedLine[2]

      $PSObject = [pscustomobject]@{
        ProgramName = $Program
        CurrentInstalledVersion = $CurrentInstalledVersion
        LatestAvailableVersion = $LatestAvailableVersion
      }

      $null = $ChocolateyOutdatedProgramsPSObjects.Add($PSObject)
    }
  }

  if ($CommandName -match "\.exe") {
    $CommandName = $CommandName -replace "\.exe",""
  }
  $FinalCommandName = if ($CommandName) { $CommandName } else { $ProgramName }

  # Save the original System PATH and $env:Path before we do anything, just in case
  $OriginalSystemPath = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
  $OriginalEnvPath = $env:Path
  Synchronize-SystemPathEnvPath
  $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue

  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Main Body #####

  # Install $ProgramName if it's not already or if it's outdated...
  if ($($PackageManagementInstalledPrograms.Name -notcontains $ProgramName -and
      $ChocolateyInstalledProgramsPSObjects.ProgramName -notcontains $ProgramName) -or
    $PackageManagementCurrentInstalledPackage.Version -ne $PackageManagementLatestVersion.Version -or
    $ChocolateyOutdatedProgramsPSObjects.ProgramName -contains $ProgramName
  ) {
    if ($UsePowerShellGet -or $(!$UsePowerShellGet -and !$UseChocolateyCmdLine) -or
      $PackageManagementInstalledPrograms.Name -contains $ProgramName -and $ChocolateyInstalledProgramsPSObjects.ProgramName -notcontains $ProgramName
    ) {
      $InstallPackageSplatParams = @{
        Name = $ProgramName
        Force = $True
        ErrorAction = "SilentlyContinue"
        ErrorVariable = "InstallError"
        WarningAction = "SilentlyContinue"
      }
      if ($PreRelease) {
        $LatestVersion = $(Find-Package $ProgramName -AllVersions)[-1].Version
        $InstallPackageSplatParams.Add("MinimumVersion",$LatestVersion)
      }
      # NOTE: The PackageManagement install of $ProgramName is unreliable, so just in case, fallback to the Chocolatey cmdline for install
      $null = Install-Package @InstallPackageSplatParams
      if ($InstallError.Count -gt 0) {
        $null = Uninstall-Package $ProgramName -Force -ErrorAction SilentlyContinue
        Write-Warning "There was a problem installing $ProgramName via PackageManagement/PowerShellGet!"

        if ($UsePowerShellGet) {
          Write-Error "One or more errors occurred during the installation of $ProgramName via the the PackageManagement/PowerShellGet Modules failed! Installation has been rolled back! Halting!"
          Write-Host "Errors for the Install-Package cmdlet are as follows:"
          Write-Error $($InstallError | Out-String)
          $global:FunctionResult = "1"
          return
        }
        else {
          Write-Host "Trying install via Chocolatey CmdLine..."
          $PMInstall = $False
        }
      }
      else {
        $PMInstall = $True

        # Since Installation via PackageManagement/PowerShellGet was succesful, let's update $env:Path with the
        # latest from System PATH before we go nuts trying to find the main executable manually
        Synchronize-SystemPathEnvPath
        $env:Path = $($(Refresh-ChocolateyEnv -ErrorAction SilentlyContinue) -split ";" | ForEach-Object {
            if (-not [System.String]::IsNullOrWhiteSpace($_) -and $(Test-Path $_)) { $_ }
          }) -join ";"
      }
    }

    if (!$PMInstall -or $UseChocolateyCmdLine -or
      $ChocolateyInstalledProgramsPSObjects.ProgramName -contains $ProgramName
    ) {
      try {
        Write-Host "Refreshing `$env:Path..."
        $global:FunctionResult = "0"
        $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue -ErrorVariable RCEErr

        # The first time we attempt to Refresh-ChocolateyEnv, Chocolatey CmdLine and/or the
        # Chocolatey Package Provider legitimately might not be installed,
        # so if the Refresh-ChocolateyEnv function throws that error, we can ignore it
        if ($RCEErr.Count -gt 0 -and
          $global:FunctionResult -eq "1" -and
          ![bool]$($RCEErr -match "Neither the Chocolatey PackageProvider nor the Chocolatey CmdLine appears to be installed!")) {
          throw "The Refresh-ChocolateyEnv function failed! Halting!"
        }
      }
      catch {
        Write-Error $_
        Write-Host "Errors from the Refresh-ChocolateyEnv function are as follows:"
        Write-Error $($RCEErr | Out-String)
        $global:FunctionResult = "1"
        return
      }

      # Make sure Chocolatey CmdLine is installed...if not, install it
      if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
        try {
          $global:FunctionResult = "0"
          $null = Install-ChocolateyCmdLine -NoUpdatePackageManagement -ErrorAction SilentlyContinue -ErrorVariable ICCErr
          if ($ICCErr -and $global:FunctionResult -eq "1") { throw "The Install-ChocolateyCmdLine function failed! Halting!" }
        }
        catch {
          Write-Error $_
          Write-Host "Errors from the Install-ChocolateyCmdline function are as follows:"
          Write-Error $($ICCErr | Out-String)
          $global:FunctionResult = "1"
          return
        }
      }

      try {
        # TODO: Figure out how to handle errors from choco.exe. Some we can ignore, others
        # we shouldn't. But I'm not sure what all of the possibilities are so I can't
        # control for them...
        if ($PreRelease) {
          $null = cup $ProgramName --pre -y
        }
        else {
          $null = cup $ProgramName -y
        }
        $ChocoInstall = $true

        # Since Installation via the Chocolatey CmdLine was succesful, let's update $env:Path with the
        # latest from System PATH before we go nuts trying to find the main executable manually
        Synchronize-SystemPathEnvPath
        $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue
      }
      catch {
        Write-Error "There was a problem installing $ProgramName using the Chocolatey cmdline! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }

    if ($ResolveCommandPath -or $PSBoundParameters['CommandName']) {
      ## BEGIN Try to Find Main Executable Post Install ##

      # Now the parent directory of $ProgramName's main executable should be part of the SYSTEM Path
      # (and therefore part of $env:Path). If not, try to find it in Chocolatey directories...
      if ($(Get-Command $FinalCommandName -ErrorAction SilentlyContinue).CommandType -eq "Alias") {
        while (Test-Path Alias:\$FinalCommandName) {
          Remove-Item Alias:\$FinalCommandName
        }
      }

      if (![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue)) {
        try {
          Write-Host "Refreshing `$env:Path..."
          $global:FunctionResult = "0"
          $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue -ErrorVariable RCEErr
          if ($RCEErr.Count -gt 0 -and $global:FunctionResult -eq "1") { throw "The Refresh-ChocolateyEnv function failed! Halting!" }
        }
        catch {
          Write-Error $_
          Write-Host "Errors from the Refresh-ChocolateyEnv function are as follows:"
          Write-Error $($RCEErr | Out-String)
          $global:FunctionResult = "1"
          return
        }
      }

      # If we still can't find the main executable...
      if (![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue) -and $(!$ExePath -or $ExePath.Count -eq 0)) {
        $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue

        if ($ExpectedInstallLocation) {
          [System.Collections.ArrayList][array]$ExePath = Adjudicate-ExePath -ProgramName $ProgramName -OriginalSystemPath $OriginalSystemPath -OriginalEnvPath $OriginalEnvPath -FinalCommandName $FinalCommandName -ExpectedInstallLocation $ExpectedInstallLocation
        }
        else {
          [System.Collections.ArrayList][array]$ExePath = Adjudicate-ExePath -ProgramName $ProgramName -OriginalSystemPath $OriginalSystemPath -OriginalEnvPath $OriginalEnvPath -FinalCommandName $FinalCommandName
        }
      }

      # Determine if there's an exact match for the $FinalCommandName
      if (![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue)) {
        if ($ExePath.Count -ge 1) {
          if ([bool]$($ExePath -match "\\$FinalCommandName.exe$")) {
            $FoundExactCommandMatch = $True
          }
        }
      }

      # If we STILL can't find the main executable...
      if ($(![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue) -and $(!$ExePath -or $ExePath.Count -eq 0)) -or
        $(!$FoundExactCommandMatch -and $PSBoundParameters['CommandName']) -or
        $($ResolveCommandPath -and !$FoundExactCommandMatch) -or $ForceChocoInstallScript) {
        # If, at this point we don't have $ExePath, if we did a $ChocoInstall, then we have to give up...
        # ...but if we did a $PMInstall, then it's possible that PackageManagement/PowerShellGet just
        # didn't run the chocolateyInstall.ps1 script that sometimes comes bundled with Packages from the
        # Chocolatey Package Provider/Repo. So try running that...
        if ($ChocoInstall) {
          if (![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue)) {
            Write-Warning "Unable to find main executable for $ProgramName!"
            $MainExeSearchFail = $True
          }
        }
        if ($PMInstall -or $ForceChocoInstallScript) {
          [System.Collections.ArrayList]$PossibleChocolateyInstallScripts = @()

          if (Test-Path "C:\Chocolatey") {
            $ChocoScriptsA = Get-ChildItem -Path "C:\Chocolatey" -Recurse -File -Filter "*chocolateyinstall.ps1" | Where-Object { $($(Get-Date) - $_.CreationTime).TotalMinutes -lt 5 }
            foreach ($Script in $ChocoScriptsA) {
              $null = $PossibleChocolateyInstallScripts.Add($Script)
            }
          }
          if (Test-Path "C:\ProgramData\chocolatey") {
            $ChocoScriptsB = Get-ChildItem -Path "C:\ProgramData\chocolatey" -Recurse -File -Filter "*chocolateyinstall.ps1" | Where-Object { $($(Get-Date) - $_.CreationTime).TotalMinutes -lt 5 }
            foreach ($Script in $ChocoScriptsB) {
              $null = $PossibleChocolateyInstallScripts.Add($Script)
            }
          }

          [System.Collections.ArrayList][array]$ChocolateyInstallScriptSearch = $PossibleChocolateyInstallScripts.FullName | Where-Object { $_ -match ".*?$ProgramName.*?chocolateyinstall.ps1$" }
          if ($ChocolateyInstallScriptSearch.Count -eq 0) {
            Write-Warning "Unable to find main the Chocolatey Install Script for $ProgramName PowerShellGet install!"
            $MainExeSearchFail = $True
          }
          if ($ChocolateyInstallScriptSearch.Count -eq 1) {
            $ChocolateyInstallScript = $ChocolateyInstallScriptSearch[0]
          }
          if ($ChocolateyInstallScriptSearch.Count -gt 1) {
            $ChocolateyInstallScript = $($ChocolateyInstallScriptSearch | Sort-Object LastWriteTime)[-1]
          }

          if ($ChocolateyInstallScript) {
            try {
              Write-Host "Trying the Chocolatey Install script from $ChocolateyInstallScript..." -ForegroundColor Yellow
              & $ChocolateyInstallScript

              # Now that the $ChocolateyInstallScript ran, search for the main executable again
              Synchronize-SystemPathEnvPath
              $env:Path = Refresh-ChocolateyEnv -ErrorAction SilentlyContinue

              if ($ExpectedInstallLocation) {
                [System.Collections.ArrayList][array]$ExePath = Adjudicate-ExePath -ProgramName $ProgramName -OriginalSystemPath $OriginalSystemPath -OriginalEnvPath $OriginalEnvPath -FinalCommandName $FinalCommandName -ExpectedInstallLocation $ExpectedInstallLocation
              }
              else {
                [System.Collections.ArrayList][array]$ExePath = Adjudicate-ExePath -ProgramName $ProgramName -OriginalSystemPath $OriginalSystemPath -OriginalEnvPath $OriginalEnvPath -FinalCommandName $FinalCommandName
              }

              # If we STILL don't have $ExePath, then we have to give up...
              if (!$ExePath -or $ExePath.Count -eq 0) {
                Write-Warning "Unable to find main executable for $ProgramName!"
                $MainExeSearchFail = $True
              }
            }
            catch {
              Write-Error $_
              Write-Error "The Chocolatey Install Script $ChocolateyInstallScript has failed!"

              # If PackageManagement/PowerShellGet is ERRONEOUSLY reporting that the program was installed
              # use the Uninstall-Package cmdlet to wipe it out. This scenario happens when PackageManagement/
              # PackageManagement/PowerShellGet gets a Package from the Chocolatey Package Provider/Repo but
              # fails to run the chocolateyInstall.ps1 script for some reason.
              if ([bool]$(Get-Package $ProgramName -ErrorAction SilentlyContinue)) {
                $null = Uninstall-Package $ProgramName -Force -ErrorAction SilentlyContinue
              }

              # Now we need to try the Chocolatey CmdLine. Easiest way to do this at this point is to just
              # invoke the function again with the same parameters, but specify -UseChocolateyCmdLine
              $BoundParametersDictionary = $PSCmdlet.MyInvocation.BoundParameters
              $InstallProgramSplatParams = @{}
              foreach ($kvpair in $BoundParametersDictionary.GetEnumerator()) {
                $key = $kvpair.Key
                $value = $BoundParametersDictionary[$key]
                if ($key -notmatch "UsePowerShellGet|ForceChocoInstallScript" -and $InstallProgramSplatParams.Keys -notcontains $key) {
                  $InstallProgramSplatParams.Add($key,$value)
                }
              }
              if ($InstallProgramSplatParams.Keys -notcontains "UseChocolateyCmdLine") {
                $InstallProgramSplatParams.Add("UseChocolateyCmdLine",$True)
              }
              if ($InstallProgramSplatParams.Keys -notcontains "NoUpdatePackageManagement") {
                $InstallProgramSplatParams.Add("NoUpdatePackageManagement",$True)
              }
              Install-Program @InstallProgramSplatParams

              return
            }
          }
        }
      }

      ## END Try to Find Main Executable Post Install ##
    }
  }
  else {
    if ($ChocolateyInstalledProgramsPSObjects.ProgramName -contains $ProgramName) {
      Write-Warning "$ProgramName is already installed via the Chocolatey CmdLine!"
      $AlreadyInstalled = $True
    }
    elseif ([bool]$(Get-Package $ProgramName -ErrorAction SilentlyContinue)) {
      Write-Warning "$ProgramName is already installed via PackageManagement/PowerShellGet!"
      $AlreadyInstalled = $True
    }
  }

  # If we weren't able to find the main executable (or any potential main executables) for
  # $ProgramName, offer the option to scan the whole C:\ drive (with some obvious exceptions)
  if ($MainExeSearchFail -and $($ResolveCommandPath -or $PSBoundParameters['CommandName']) -and
    ![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue)) {
    if (!$ScanCDriveForMainExeIfNecessary -and $ResolveCommandPath -and !$PSBoundParameters['CommandName']) {
      $ScanCDriveChoice = Read-Host -Prompt "Would you like to scan C:\ for $FinalCommandName.exe? NOTE: This search excludes system directories but still could take some time. [Yes\No]"
      while ($ScanCDriveChoice -notmatch "Yes|yes|Y|y|No|no|N|n") {
        Write-Host "$ScanDriveChoice is not a valid input. Please enter 'Yes' or 'No'"
        $ScanCDriveChoice = Read-Host -Prompt "Would you like to scan C:\ for $FinalCommandName.exe? NOTE: This search excludes system directories but still could take some time. [Yes\No]"
      }
    }

    if ($ScanCDriveChoice -match "Yes|yes|Y|y" -or $ScanCDriveForMainExeIfNecessary) {
      $DirectoriesToSearchRecursively = $(Get-ChildItem -Path "C:\" -Directory | Where-Object { $_.Name -notmatch "Windows|PerfLogs|Microsoft" }).FullName
      [System.Collections.ArrayList]$ExePath = @()
      foreach ($dir in $DirectoriesToSearchRecursively) {
        $FoundFiles = $(Get-ChildItem -Path $dir -Recurse -File).FullName
        foreach ($FilePath in $FoundFiles) {
          if ($FilePath -match "(.*?)$FinalCommandName([^\\]+)") {
            $null = $ExePath.Add($FilePath)
          }
        }
      }
    }
  }

  if ($ResolveCommandPath -or $PSBoundParameters['CommandName']) {
    # Finalize $env:Path
    if ([bool]$($ExePath -match "\\$FinalCommandName.exe$")) {
      $PathToAdd = $($ExePath -match "\\$FinalCommandName.exe$") | Split-Path -Parent
      if ($($env:Path -split ";") -notcontains $PathToAdd) {
        if ($env:Path[-1] -eq ";") {
          $env:Path = "$env:Path" + $PathToAdd + ";"
        }
        else {
          $env:Path = "$env:Path" + ";" + $PathToAdd
        }
      }
    }
    $FinalEnvPathArray = $env:Path -split ";" | ForEach-Object { if (-not [System.String]::IsNullOrWhiteSpace($_)) { $_ } }
    $FinalEnvPathString = $($FinalEnvPathArray | ForEach-Object { if (Test-Path $_) { $_ } }) -join ";"
    $env:Path = $FinalEnvPathString

    if (![bool]$(Get-Command $FinalCommandName -ErrorAction SilentlyContinue)) {
      # Try to determine Main Executable
      if (!$ExePath -or $ExePath.Count -eq 0) {
        $FinalExeLocation = "NotFound"
      }
      elseif ($ExePath.Count -eq 1) {
        $UpdatedFinalCommandName = $ExePath | Split-Path -Leaf

        try {
          $FinalExeLocation = $(Get-Command $UpdatedFinalCommandName -ErrorAction SilentlyContinue).Source
        }
        catch {
          $FinalExeLocation = $ExePath
        }
      }
      elseif ($ExePath.Count -gt 1) {
        if (![bool]$($ExePath -match "\\$FinalCommandName.exe$")) {
          Write-Warning "No exact match for main executable $FinalCommandName.exe was found. However, other executables associated with $ProgramName were found."
        }
        $FinalExeLocation = $ExePath
      }
    }
    else {
      $FinalExeLocation = $(Get-Command $FinalCommandName).Source
    }
  }

  if ($ChocoInstall) {
    $InstallManager = "choco.exe"
    $InstallCheck = $(clist --local-only $ProgramName)[1]
  }
  if ($PMInstall -or [bool]$(Get-Package $ProgramName -ProviderName Chocolatey -ErrorAction SilentlyContinue)) {
    $InstallManager = "PowerShellGet"
    $InstallCheck = Get-Package $ProgramName -ErrorAction SilentlyContinue
  }

  if ($AlreadyInstalled) {
    $InstallAction = "AlreadyInstalled"
  }
  elseif ($PackageManagementCurrentInstalledPackage.Version -ne $PackageManagementLatestVersion.Version -or
    $ChocolateyOutdatedProgramsPSObjects.ProgramName -contains $ProgramName
  ) {
    $InstallAction = "Updated"
  }
  else {
    $InstallAction = "FreshInstall"
  }

  $env:Path = Refresh-ChocolateyEnv

  [pscustomobject]@{
    InstallManager = $InstallManager
    InstallAction = $InstallAction
    InstallCheck = $InstallCheck
    MainExecutable = $FinalExeLocation
    OriginalSystemPath = $OriginalSystemPath
    CurrentSystemPath = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
    OriginalEnvPath = $OriginalEnvPath
    CurrentEnvPath = $env:Path
  }

  ##### END Main Body #####
}

function Install-RSAT {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string]$DownloadDirectory = "$HOME\Downloads",

    [Parameter(Mandatory = $False)]
    [switch]$AllowRestart,

    [Parameter(Mandatory = $False)]
    [switch]$Force
  )

  Write-Host "Please wait..."

  if (!$(Get-Module -ListAvailable -Name ActiveDirectory) -or $Force) {
    $OSInfo = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $OSCimInfo = Get-CimInstance Win32_OperatingSystem
    $OSArchitecture = $OSCimInfo.OSArchitecture

    if ([version]$OSCimInfo.Version -lt [version]"6.3") {
      Write-Error "This function only handles RSAT Installation for Windows 8.1 and higher! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if ($OSInfo.ProductName -notlike "*Server*") {
      $KBCheck = [bool]$(Get-WmiObject -Query 'select * from win32_quickfixengineering' | Where-Object {
          $_.HotFixID -eq 'KB958830' -or $_.HotFixID -eq 'KB2693643'
        })

      if (!$KBCheck -or $Force) {
        if ($([version]$OSCimInfo.Version).Major -lt 10 -and [version]$OSCimInfo.Version -ge [version]"6.3") {
          if ($OSArchitecture -eq "64-bit") {
            $OutFileName = "Windows8.1-KB2693643-x64.msu"
          }
          if ($OSArchitecture -eq "32-bit") {
            $OutFileName = "Windows8.1-KB2693643-x86.msu"
          }

          $DownloadUrl = "https://download.microsoft.com/download/1/8/E/18EA4843-C596-4542-9236-DE46F780806E/$OutFileName"
        }
        if ($([version]$OSCimInfo.Version).Major -ge 10) {
          if ([int]$OSInfo.ReleaseId -ge 1803) {
            if ($OSArchitecture -eq "64-bit") {
              $OutFileName = "WindowsTH-RSAT_WS_1803-x64.msu"
            }
            if ($OSArchitecture -eq "32-bit") {
              $OutFileName = "WindowsTH-RSAT_WS_1803-x86.msu"
            }
          }
          if ([int]$OSInfo.ReleaseId -ge 1709 -and [int]$OSInfo.ReleaseId -lt 1803) {
            if ($OSArchitecture -eq "64-bit") {
              $OutFileName = "WindowsTH-RSAT_WS_1709-x64.msu"
            }
            if ($OSArchitecture -eq "32-bit") {
              $OutFileName = "WindowsTH-RSAT_WS_1709-x86.msu"
            }
          }
          if ([int]$OSInfo.ReleaseId -lt 1709) {
            if ($OSArchitecture -eq "64-bit") {
              $OutFileName = "WindowsTH-RSAT_WS2016-x64.msu"
            }
            if ($OSArchitecture -eq "32-bit") {
              $OutFileName = "WindowsTH-RSAT_WS2016-x86.msu"
            }
          }

          $DownloadUrl = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/$OutFileName"
        }

        try {
          # Make sure the Url exists...
          $HTTP_Request = [System.Net.WebRequest]::Create($DownloadUrl)
          $HTTP_Response = $HTTP_Request.GetResponse()
        }
        catch {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }

        try {
          # Download via System.Net.WebClient is a lot faster than Invoke-WebRequest...
          $WebClient = [System.Net.WebClient]::new()
          $WebClient.Downloadfile($DownloadUrl,"$DownloadDirectory\$OutFileName")
        }
        catch {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }

        Write-Host "Beginning installation..."
        if ($AllowRestart) {
          $Arguments = "`"$DownloadDirectory\$OutFileName`" /quiet /log:`"$DownloadDirectory\wusaRSATInstall.log`""
        }
        else {
          $Arguments = "`"$DownloadDirectory\$OutFileName`" /quiet /norestart /log:`"$DownloadDirectory\wusaRSATInstall.log`""
        }
        #Start-Process -FilePath $(Get-Command wusa.exe).Source -ArgumentList "`"$DownloadDirectory\$OutFileName`" /quiet /log:`"$DownloadDirectory\wusaRSATInstall.log`"" -NoNewWindow -Wait

        $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
        #$ProcessInfo.WorkingDirectory = $BinaryPath | Split-Path -Parent
        $ProcessInfo.FileName = $(Get-Command wusa.exe).Source
        $ProcessInfo.RedirectStandardError = $true
        $ProcessInfo.RedirectStandardOutput = $true
        #$ProcessInfo.StandardOutputEncoding = [System.Text.Encoding]::Unicode
        #$ProcessInfo.StandardErrorEncoding = [System.Text.Encoding]::Unicode
        $ProcessInfo.UseShellExecute = $false
        $ProcessInfo.Arguments = $Arguments
        $Process = New-Object System.Diagnostics.Process
        $Process.StartInfo = $ProcessInfo
        $Process.Start() | Out-Null
        # Below $FinishedInAlottedTime returns boolean true/false
        # Wait 20 seconds for wusa to finish...
        $FinishedInAlottedTime = $Process.WaitForExit(20000)
        if (!$FinishedInAlottedTime) {
          $Process.Kill()
        }
        $stdout = $Process.StandardOutput.ReadToEnd()
        $stderr = $Process.StandardError.ReadToEnd()
        $AllOutput = $stdout + $stderr

        # Check the log to make sure there weren't any errors
        # NOTE: Get-WinEvent cmdlet does NOT work consistently on all Windows Operating Systems...
        Write-Host "Reviewing wusa.exe logs..."
        $EventLogReader = [System.Diagnostics.Eventing.Reader.EventLogReader]::new("$DownloadDirectory\wusaRSATInstall.log",[System.Diagnostics.Eventing.Reader.PathType]::FilePath)
        [System.Collections.ArrayList]$EventsFromLog = @()

        $Event = $EventLogReader.ReadEvent()
        $null = $EventsFromLog.Add($Event)
        while ($Event -ne $null) {
          $Event = $EventLogReader.ReadEvent()
          $null = $EventsFromLog.Add($Event)
        }

        if ($EventsFromLog.LevelDisplayName -contains "Error") {
          $ErrorRecord = $EventsFromLog | Where-Object { $_.LevelDisplayName -eq "Error" }
          $ProblemDetails = $ErrorRecord.properties.Value | Where-Object { $_ -match "[\w]" }
          $ProblemDetailsString = $ProblemDetails[0..$($ProblemDetails.Count - 2)] -join ": "

          $ErrMsg = "wusa.exe failed to install '$DownloadDirectory\$OutFileName' due to '$ProblemDetailsString'. " +
          "This could be because of a pending restart. Please restart $env:ComputerName and try the Install-RSAT function again."
          Write-Error $ErrMsg
          $global:FunctionResult = "1"
          return
        }

        if ($AllowRestart) {
          Restart-Computer -Confirm:$false -Force
        }
        else {
          $Output = "RestartNeeded"
        }
      }
    }
    if ($OSInfo.ProductName -like "*Server*") {
      #Import-Module ServerManager
      if (!$(Get-WindowsFeature RSAT-AD-Tools).Installed) {
        Write-Host "Beginning installation..."
        if ($AllowRestart) {
          Install-WindowsFeature -Name RSAT -IncludeAllSubFeature -IncludeManagementTools -Restart
        }
        else {
          Install-WindowsFeature -Name RSAT -IncludeAllSubFeature -IncludeManagementTools
          $Output = "RestartNeeded"
        }
      }
    }
  }
  else {
    Write-Warning "RSAT is already installed! No action taken."
  }

  if ($Output -eq "RestartNeeded") {
    Write-Warning "You must restart your computer in order to finish RSAT installation."
  }

  $Output
}

function Install-Vim {
  [CmdletBinding(DefaultParameterSetName = 'ChocoCmdLine')]
  param(
    [Parameter(Mandatory = $False)]
    [switch]$NoUpdatePackageManagement,

    [Parameter(
      Mandatory = $False,
      ParameterSetName = 'PackageManagement'
    )]
    [switch]$UsePackageManagement,

    [Parameter(Mandatory = $False)]
    [switch]$UseChocolateyCmdLine
  )

  ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

  Write-Host "Please wait..."
  $global:FunctionResult = "0"
  $MyFunctionsUrl = "https://raw.githubusercontent.com/pldmgg/misc-powershell/master/MyFunctions"

  $InstallProgramFunctionUrl = "$MyFunctionsUrl/Install-Program.ps1"
  try {
    Invoke-Expression $([System.Net.WebClient]::new().DownloadString($InstallProgramFunctionUrl))
  }
  catch {
    Write-Error $_
    Write-Error "Unable to load the Install-Program function! Halting!"
    $global:FunctionResult = "1"
    return
  }

  ##### END Variable/Parameter Transforms and PreRun Prep #####


  ##### BEGIN Main Body #####

  $ExpectedInstallLocation = "C:\Program Files (x86)\vim"
  $InstallProgramSplatParams = @{
    ProgramName = "vim"
    ExpectedInstallLocation = $ExpectedInstallLocation
  }

  $BoundParametersDictionary = $PSCmdlet.MyInvocation.BoundParameters
  foreach ($kvpair in $BoundParametersDictionary.GetEnumerator()) {
    $key = $kvpair.Key
    $value = $BoundParametersDictionary[$key]
    $InstallProgramSplatParams.Add($key,$value)
  }
  Install-Program @InstallProgramSplatParams

  # Alternate Download/Install method...
  <#
    $LatestVimForWin32 = $($(Invoke-WebRequest -Uri "http://www.vim.org/download.php").Links | Where-Object {$_.href -like "*w32*.zip"}).href
    $LatestVimForWin32ZipFileName = $LatestVimForWin32 | Split-Path -Leaf
    Invoke-WebRequest -Uri "$LatestVimForWin32" -OutFile "$HOME\Downloads\$LatestVimForWin32ZipFileName"
    Unzip-File -PathToZip "$HOME\Downloads\$LatestVimForWin32ZipFileName" -TargetDir "$HOME\Downloads"
    $FullPathToVimExe = $(Get-ChildItem "$HOME\Downloads\vim" -Recurse | Where-Object {$_.Name -like "*vim*.exe"}).FullName
    Copy-Item -Path "$FullPathToVimExe" -Destination "C:\Windows\System32\vim.exe"
    #>

  # Set vim default configuration settings...
  $HomeDoubleSlashes = $HOME -replace "\\","\\"
  $HomeVimrc = @'
let $HOME = '{0}'
let $MYVIMRC = '$HOME\\_vimrc'
set viminfo+=n$HOME\\_viminfo
set backspace=2
set backspace=indent,eol,start
set shortmess=at
set cmdheight=2
silent!
'@ -f $HomeDoubleSlashes

  $ProgramFiles86Vimrc = @'
let $HOME = '{0}'
let $MYVIMRC = '$HOME\\_vimrc'        
'@ -f $HomeDoubleSlashes

  if (Test-Path "$ExpectedInstallLocation\_vimrc") {
    Move-Item "$ExpectedInstallLocation\_vimrc" "$ExpectedInstallLocation\_vimrc_original" -Force
  }
  if (Test-Path "$HOME\_vimrc") {
    Move-Item "$HOME\_vimrc" "$HOME\_vimrc_original" -Force
  }

  Set-Content -Path "$ExpectedInstallLocation\_vimrc" -Value $ProgramFiles86Vimrc
  Set-Content -Path "$HOME\_vimrc" -Value $HomeVimrc

  ##### END Main Body #####
}

function Get-UserAdminRights {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [ValidatePattern("[\w]+\\[\w]+")]
    [string]$UserAcct = [Security.Principal.WindowsIdentity]::GetCurrent().Name
  )

  #region >> Helper Functions

  function Parse-NLTest {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $True)]
      [string]$Domain
    )

    while ($Domain -notmatch "\.") {
      Write-Warning "The provided value for the -Domain parameter is not in the correct format. Please use the entire domain name (including periods)."
      $Domain = Read-Host -Prompt "Please enter the full domain name (including periods)"
    }

    if (![bool]$(Get-Command nltest -ErrorAction SilentlyContinue)) {
      Write-Error "Unable to find nltest.exe! Halting!"
      $global:FunctionResult = "1"
      return
    }

    $DomainPrefix = $($Domain -split '\.')[0]
    $PrimaryDomainControllerPrep = Invoke-Expression "nltest /dclist:$DomainPrefix 2>null"
    if (![bool]$($PrimaryDomainControllerPrep | Select-String -Pattern 'PDC')) {
      Write-Error "Can't find the Primary Domain Controller for domain $DomainPrefix"
      return
    }
    $PrimaryDomainControllerPrep = $($($PrimaryDomainControllerPrep -match 'PDC').Trim() -split ' ')[0]
    if ($PrimaryDomainControllerPrep -match '\\\\') {
      $PrimaryDomainController = $($PrimaryDomainControllerPrep -replace '\\\\','').ToLower() + ".$Domain"
    }
    else {
      $PrimaryDomainController = $PrimaryDomainControllerPrep.ToLower() + ".$Domain"
    }

    $PrimaryDomainController
  }

  function Get-DomainController {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $False)]
      [string]$Domain
    )

    ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

    $ComputerSystemCim = Get-CimInstance Win32_ComputerSystem
    $PartOfDomain = $ComputerSystemCim.PartOfDomain

    ##### END Variable/Parameter Transforms and PreRun Prep #####


    ##### BEGIN Main Body #####

    if (!$PartOfDomain -and !$Domain) {
      Write-Error "$env:Computer is NOT part of a Domain and the -Domain parameter was not used in order to specify a domain! Halting!"
      $global:FunctionResult = "1"
      return
    }

    $ThisMachinesDomain = $ComputerSystemCim.Domain

    if ($Domain) {
      try {
        $Forest = [system.directoryservices.activedirectory.Forest]::GetCurrentForest()
      }
      catch {
        Write-Verbose "Cannot connect to current forest."
      }

      if ($ThisMachinesDomain -eq $Domain -and $Forest.Domains -contains $Domain) {
        [System.Collections.ArrayList]$FoundDomainControllers = $Forest.Domains | Where-Object { $_.Name -eq $Domain } | ForEach-Object { $_.DomainControllers } | ForEach-Object { $_.Name }
        $PrimaryDomainController = $Forest.Domains.PdcRoleOwner.Name
      }
      if ($ThisMachinesDomain -eq $Domain -and $Forest.Domains -notcontains $Domain) {
        try {
          $GetCurrentDomain = [system.directoryservices.activedirectory.domain]::GetCurrentDomain()
          [System.Collections.ArrayList]$FoundDomainControllers = $GetCurrentDomain | ForEach-Object { $_.DomainControllers } | ForEach-Object { $_.Name }
          $PrimaryDomainController = $GetCurrentDomain.PdcRoleOwner.Name
        }
        catch {
          try {
            Write-Warning "Only able to report the Primary Domain Controller for $Domain! Other Domain Controllers most likely exist!"
            Write-Warning "For a more complete list, try running this function on a machine that is part of the domain $Domain!"
            $PrimaryDomainController = Parse-NLTest -Domain $Domain
            [System.Collections.ArrayList]$FoundDomainControllers = @($PrimaryDomainController)
          }
          catch {
            Write-Error $_
            $global:FunctionResult = "1"
            return
          }
        }
      }
      if ($ThisMachinesDomain -ne $Domain -and $Forest.Domains -contains $Domain) {
        [System.Collections.ArrayList]$FoundDomainControllers = $Forest.Domains | ForEach-Object { $_.DomainControllers } | ForEach-Object { $_.Name }
        $PrimaryDomainController = $Forest.Domains.PdcRoleOwner.Name
      }
      if ($ThisMachinesDomain -ne $Domain -and $Forest.Domains -notcontains $Domain) {
        try {
          Write-Warning "Only able to report the Primary Domain Controller for $Domain! Other Domain Controllers most likely exist!"
          Write-Warning "For a more complete list, try running this function on a machine that is part of the domain $Domain!"
          $PrimaryDomainController = Parse-NLTest -Domain $Domain
          [System.Collections.ArrayList]$FoundDomainControllers = @($PrimaryDomainController)
        }
        catch {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }
      }
    }
    else {
      try {
        $Forest = [system.directoryservices.activedirectory.Forest]::GetCurrentForest()
        [System.Collections.ArrayList]$FoundDomainControllers = $Forest.Domains | ForEach-Object { $_.DomainControllers } | ForEach-Object { $_.Name }
        $PrimaryDomainController = $Forest.Domains.PdcRoleOwner.Name
      }
      catch {
        Write-Verbose "Cannot connect to current forest."

        try {
          $GetCurrentDomain = [system.directoryservices.activedirectory.domain]::GetCurrentDomain()
          [System.Collections.ArrayList]$FoundDomainControllers = $GetCurrentDomain | ForEach-Object { $_.DomainControllers } | ForEach-Object { $_.Name }
          $PrimaryDomainController = $GetCurrentDomain.PdcRoleOwner.Name
        }
        catch {
          $Domain = $ThisMachinesDomain

          try {
            $CurrentUser = "$(whoami)"
            Write-Warning "Only able to report the Primary Domain Controller for the domain that $env:ComputerName is joined to (i.e. $Domain)! Other Domain Controllers most likely exist!"
            Write-Host "For a more complete list, try one of the following:" -ForegroundColor Yellow
            if ($($CurrentUser -split '\\') -eq $env:ComputerName) {
              Write-Host "- Try logging into $env:ComputerName with a domain account (as opposed to the current local account $CurrentUser" -ForegroundColor Yellow
            }
            Write-Host "- Try using the -Domain parameter" -ForegroundColor Yellow
            Write-Host "- Run this function on a computer that is joined to the Domain you are interested in" -ForegroundColor Yellow
            $PrimaryDomainController = Parse-NLTest -Domain $Domain
            [System.Collections.ArrayList]$FoundDomainControllers = @($PrimaryDomainController)
          }
          catch {
            Write-Error $_
            $global:FunctionResult = "1"
            return
          }
        }
      }
    }

    [pscustomobject]@{
      FoundDomainControllers = $FoundDomainControllers
      PrimaryDomainController = $PrimaryDomainController
    }

    ##### END Main Body #####
  }

  function Test-LDAP {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $True)]
      [string]$ADServerHostNameOrIP
    )

    # Make sure you CAN resolve $ADServerHostNameOrIP AND that we can get FQDN
    try {
      $ADServerNetworkInfo = [System.Net.Dns]::GetHostEntry($ADServerHostNameOrIP)
      if ($ADServerNetworkInfo.HostName -notmatch "\.") {
        $IP = $ADServerNetworkInfo.AddressList[0].IPAddressToString
        $ADServerNetworkInfo = [System.Net.Dns]::GetHostEntry($IP)
        if ($ADServerNetworkInfo.HostName -notmatch "\.") {
          throw "Can't resolve $ADServerHostNameOrIP FQDN! Halting!"
        }
      }
    }
    catch {
      Write-Error $_
      $global:FunctionResult = "1"
      return
    }

    $ADServerFQDN = $ADServerNetworkInfo.HostName

    $LDAPPrep = "LDAP://" + $ADServerFQDN

    # Try Global Catalog First - It's faster and you can execute from a different domain and
    # potentially still get results
    try {
      $LDAP = $LDAPPrep + ":3269"
      # This does NOT throw an error because it doen't actually try to reach out to make the connection yet
      $Connection = [adsi]($LDAP)
      # This WILL throw an error
      $Connection.Close()
      $GlobalCatalogConfiguredForSSL = $True
    }
    catch {
      if ($_.Exception.ToString() -match "The server is not operational") {
        Write-Warning "Either can't find LDAP Server or SSL on Global Catalog (3269) is not operational!"
      }
      elseif ($_.Exception.ToString() -match "The user name or password is incorrect") {
        Write-Warning "The current user $(whoami) does not have access!"
      }
      else {
        Write-Error $_
      }
    }

    try {
      $LDAP = $LDAPPrep + ":3268"
      $Connection = [adsi]($LDAP)
      $Connection.Close()
      $GlobalCatalogConfigured = $True
    }
    catch {
      if ($_.Exception.ToString() -match "The server is not operational") {
        Write-Warning "Either can't find LDAP Server or Global Catalog (3268) is not operational!"
      }
      elseif ($_.Exception.ToString() -match "The user name or password is incorrect") {
        Write-Warning "The current user $(whoami) does not have access!"
      }
      else {
        Write-Error $_
      }
    }

    # Try the normal ports
    try {
      $LDAP = $LDAPPrep + ":636"
      # This does NOT throw an error because it doen't actually try to reach out to make the connection yet
      $Connection = [adsi]($LDAP)
      # This WILL throw an error
      $Connection.Close()
      $ConfiguredForSSL = $True
    }
    catch {
      if ($_.Exception.ToString() -match "The server is not operational") {
        Write-Warning "Can't find LDAP Server or SSL (636) is NOT configured! Check the value provided to the -ADServerHostNameOrIP parameter!"
      }
      elseif ($_.Exception.ToString() -match "The user name or password is incorrect") {
        Write-Warning "The current user $(whoami) does not have access! Halting!"
      }
      else {
        Write-Error $_
      }
    }

    try {
      $LDAP = $LDAPPrep + ":389"
      $Connection = [adsi]($LDAP)
      $Connection.Close()
      $Configured = $True
    }
    catch {
      if ($_.Exception.ToString() -match "The server is not operational") {
        Write-Warning "Can't find LDAP Server (389)! Check the value provided to the -ADServerHostNameOrIP parameter!"
      }
      elseif ($_.Exception.ToString() -match "The user name or password is incorrect") {
        Write-Warning "The current user $(whoami) does not have access!"
      }
      else {
        Write-Error $_
      }
    }

    if (!$GlobalCatalogConfiguredForSSL -and !$GlobalCatalogConfigured -and !$ConfiguredForSSL -and !$Configured) {
      Write-Error "Unable to connect to $LDAPPrep! Halting!"
      $global:FunctionResult = "1"
      return
    }

    [System.Collections.ArrayList]$PortsThatWork = @()
    if ($GlobalCatalogConfigured) { $null = $PortsThatWork.Add("3268") }
    if ($GlobalCatalogConfiguredForSSL) { $null = $PortsThatWork.Add("3269") }
    if ($Configured) { $null = $PortsThatWork.Add("389") }
    if ($ConfiguredForSSL) { $null = $PortsThatWork.Add("636") }

    [pscustomobject]@{
      DirectoryEntryInfo = $Connection
      LDAPBaseUri = $LDAPPrep
      GlobalCatalogConfigured3268 = if ($GlobalCatalogConfigured) { $True } else { $False }
      GlobalCatalogConfiguredForSSL3269 = if ($GlobalCatalogConfiguredForSSL) { $True } else { $False }
      Configured389 = if ($Configured) { $True } else { $False }
      ConfiguredForSSL636 = if ($ConfiguredForSSL) { $True } else { $False }
      PortsThatWork = $PortsThatWork
    }
  }

  function Get-UserObjectsInLDAP {
    [CmdletBinding()]
    param()

    # Below $LDAPInfo Output is PSCustomObject with properties: DirectoryEntryInfo, LDAPBaseUri,
    # GlobalCatalogConfigured3268, GlobalCatalogConfiguredForSSL3269, Configured389, ConfiguredForSSL636,
    # PortsThatWork
    try {
      $DomainControllerInfo = Get-DomainController -ErrorAction Stop
      $LDAPInfo = Test-LDAP -ADServerHostNameOrIP $DomainControllerInfo.PrimaryDomainController -ErrorAction Stop
      if (!$DomainControllerInfo) { throw "Problem with Get-DomainController function! Halting!" }
      if (!$LDAPInfo) { throw "Problem with Test-LDAP function! Halting!" }
    }
    catch {
      Write-Error $_
      $global:FunctionResult = "1"
      return
    }

    if (!$LDAPInfo.PortsThatWork) {
      Write-Error "Unable to access LDAP on $($DomainControllerInfo.PrimaryDomainController)! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if ($LDAPInfo.PortsThatWork -contains "389") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":389"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "3268") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":3268"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "636") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":636"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "3269") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":3269"
    }

    $Connection = [adsi]($LDAPUri)
    #$UsersLDAPContainer = $Connection.Children | Where-Object {$_.distinguishedName -match "Users"}
    #$UserObjectsInLDAP = $UsersLDAPContainer.Children | Where-Object {$_.objectClass -contains "user" -and $_.objectClass -notcontains "group"}
    $Searcher = New-Object System.DirectoryServices.DirectorySearcher
    $Searcher.SearchRoot = $Connection
    $Searcher.Filter = "(&(objectCategory=User))"
    $UserObjectsInLDAP = $Searcher.FindAll() | ForEach-Object { $_.GetDirectoryEntry() }

    $UserObjectsInLDAP
  }

  function Get-GroupObjectsInLDAP {
    [CmdletBinding()]
    param()

    # Below $LDAPInfo Output is PSCustomObject with properties: DirectoryEntryInfo, LDAPBaseUri,
    # GlobalCatalogConfigured3268, GlobalCatalogConfiguredForSSL3269, Configured389, ConfiguredForSSL636,
    # PortsThatWork
    try {
      $DomainControllerInfo = Get-DomainController -ErrorAction Stop
      $LDAPInfo = Test-LDAP -ADServerHostNameOrIP $DomainControllerInfo.PrimaryDomainController -ErrorAction Stop
      if (!$DomainControllerInfo) { throw "Problem with Get-DomainController function! Halting!" }
      if (!$LDAPInfo) { throw "Problem with Test-LDAP function! Halting!" }
    }
    catch {
      Write-Error $_
      $global:FunctionResult = "1"
      return
    }

    if (!$LDAPInfo.PortsThatWork) {
      Write-Error "Unable to access LDAP on $($DomainControllerInfo.PrimaryDomainController)! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if ($LDAPInfo.PortsThatWork -contains "389") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":389"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "3268") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":3268"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "636") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":636"
    }
    elseif ($LDAPInfo.PortsThatWork -contains "3269") {
      $LDAPUri = $LDAPInfo.LDAPBaseUri + ":3269"
    }

    $Connection = [adsi]($LDAPUri)
    #$UsersLDAPContainer = $Connection.Children | Where-Object {$_.distinguishedName -match "Users"}
    #$UserObjectsInLDAP = $UsersLDAPContainer.Children | Where-Object {$_.objectClass -contains "user" -and $_.objectClass -notcontains "group"}
    $Searcher = New-Object System.DirectoryServices.DirectorySearcher
    $Searcher.SearchRoot = $Connection
    $Searcher.Filter = "(&(objectCategory=Group))"
    $GroupObjectsInLDAP = $Searcher.FindAll() | ForEach-Object { $_.GetDirectoryEntry() }

    $GroupObjectsInLDAP
  }

  #endregion >> Helper Functions

  #region >> Main Body

  $UserShortName = $($UserAcct -split "\\")[-1]
  try {
    $LocalUserObject = Get-LocalUser -Name $UserShortName -ErrorAction Stop
    $UserIsLocalAccount = $True
  }
  catch {
    $UserIsDomainAccount = $True
  }

  $LocalAdministratorsGroupMembers = $(Get-LocalGroupMember -Group Administrators).Name
  if ($LocalAdministratorsGroupMembers -notcontains $UserAcct) {
    $GroupObjectsInLocalAdministratorsGroup = Get-LocalGroupMember -Group Administrators | Where-Object { $_.ObjectClass -eq "Group" }

    [System.Collections.ArrayList]$UserAcctMembershipCheck = @()
    foreach ($GroupObject in $GroupObjectsInLocalAdministratorsGroup) {
      if ($GroupObject.PrincipalSource -eq "Local") {
        if ($(Get-LocalGroupMember -Group $GroupObject.Name).Name -contains $UserAcct) {
          $null = $UserAcctMembershipCheck.Add($True)
        }
      }
      if ($GroupObject.PrincipalSource -eq "ActiveDirectory" -and $UserIsDomainAccount) {
        $GroupShortName = $($GroupObject.Name -split "\\")[-1]
        [array]$RelevantLDAPGroupObject = Get-GroupObjectsInLDAP | Where-Object { $_.CN -match $GroupShortName }

        if ($RelevantLDAPGroupObject.Count -eq 1) {
          if ($RelevantLDAPGroupObject.member -match "CN=$UserShortName,") {
            $null = $UserAcctMembershipCheck.Add($True)
          }
        }
        else {
          Write-Warning "Unable to find exact match for the Group '$GroupShortName' in LDAP!"
        }
      }
    }
  }


  if ($LocalAdministratorsGroupMembers -contains $UserAcct -or $UserAcctMembershipCheck -contains $True) {
    $True
  }
  else {
    $False
  }

  #endregion >> Main Body
}

<#
    .SYNOPSIS
        Get Windows Special Folders. (Not as easy as it sounds)

        This function leverages work from:

        Ray Koopa - https://www.codeproject.com/articles/878605/getting-all-special-folders-in-net
        Lee Dailey - https://www.reddit.com/r/PowerShell/comments/7rnt31/looking_for_a_critique_on_function/

    .DESCRIPTION
        Give the function the name (or part of a name) of a Special Folder and this function will tell you
        where the actual path is on the given Windows OS.

    .PARAMETER SpecialFolderName
        This parameter is MANDATORY.
        
        This parameter takes a string that represents the name of the Special Folder you are searching for.

    .EXAMPLE
        Get-SpecialFolder -SpecialFolderName MyDocuments    

    .EXAMPLE
        Get-SpecialFolder Documents

    .OUTPUTS
        One or more Syroot.Windows.IO.KnownFolder objects that look like:

            Type         : Documents
            Identity     : System.Security.Principal.WindowsIdentity
            DefaultPath  : C:\Users\zeroadmin\Documents
            Path         : C:\Users\zeroadmin\Documents
            ExpandedPath : C:\Users\zeroadmin\Documents
#>

function Get-SpecialFolder {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $True)]
    [string]$SpecialFolderName
  )

  $CurrentlyLoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
  if (![bool]$($CurrentlyLoadedAssemblies.FullName -match "Syroot")) {
    $PathHelper = "$HOME\Downloads\Syroot.Windows.IO.KnownFolders.1.0.2"
    Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Syroot.Windows.IO.KnownFolders/1.0.2" -OutFile "$PathHelper.zip"
    Expand-Archive -Path "$PathHelper.zip" -DestinationPath $PathHelper -Force
    $Syroot = Add-Type -Path "$PathHelper\lib\net40\Syroot.Windows.IO.KnownFolders.dll" -Passthru
  }
  else {
    $Syroot = $($CurrentlyLoadedAssemblies -match "Syroot").ExportedTypes
  }
  $SyrootKnownFolders = $Syroot | Where-Object { $_.Name -eq "KnownFolders" }
  $AllSpecialFolders = $($SyrootKnownFolders.GetMembers() | Where-Object { $_.MemberType -eq "Property" }).Name
  [System.Collections.ArrayList]$AllSpecialFolderObjects = foreach ($FolderName in $AllSpecialFolders) {
    [Syroot.Windows.IO.KnownFolders]::$FolderName
  }

  $Full_SFN_List = [enum]::GetNames('System.Environment+SpecialFolder')
  # The ACTUAL paths ARE accounted for in $RealSpecialFolderObjects.Path, but SOME of the Special Names used in $Full_SFN_List
  # are not mapped to the 'Type' property of $RealSpecialFolderObjects
  $SpecialNamesNotAccountedFor = $(Compare-Object $AllSpecialFolders $Full_SFN_List | Where-Object { $_.SideIndicator -eq "=>" }).InputObject

  if ([bool]$($AllSpecialFolderObjects.Type -match $SpecialFolderName)) {
    $AllSpecialFolderObjects | Where-Object { $_.Type -match $SpecialFolderName }
  }
  elseif ([bool]$($SpecialNamesNotAccountedFor -match $SpecialFolderName)) {
    $AllPossibleMatches = $SpecialNamesNotAccountedFor -match $SpecialFolderName

    foreach ($PossibleMatch in $AllPossibleMatches) {
      $AllSpecialFolderObjects | Where-Object { $_.ExpandedPath -eq [environment]::GetFolderPath($PossibleMatch) }
    }
  }
  else {
    Write-Error "Unable to find a Special Folder with the name $SpecialFolderName! Halting!"
    $global:FunctionResult = "1"
    return
  }
}

function Get-GuestVMAndHypervisorInfo {
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param(
    [Parameter(
      Mandatory = $True,
      ParameterSetName = 'Default'
    )]
    [string]$TargetHostNameOrIP,

    [Parameter(
      Mandatory = $True,
      ParameterSetName = 'RanFromHypervisor'
    )]
    [string]$TargetVMName,

    [Parameter(Mandatory = $False)]
    [string]$HypervisorFQDNOrIP,

    [Parameter(Mandatory = $False)]
    [System.Management.Automation.PSCredential]$TargetHostNameCreds,

    [Parameter(Mandatory = $False)]
    [System.Management.Automation.PSCredential]$HypervisorCreds
  )

  ##### BEGIN Helper Functions #####

  function Test-IsValidIPAddress ([string]$IPAddress) {
    [boolean]$Octets = (($IPAddress.Split(".") | Measure-Object).Count -eq 4)
    [boolean]$Valid = ($IPAddress -as [ipaddress]) -as [boolean]
    return ($Valid -and $Octets)
  }

  function Resolve-Host {
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $True)]
      [string]$HostNameOrIP
    )

    ## BEGIN Native Helper Functions ##

    function Test-IsValidIPAddress ([string]$IPAddress) {
      [boolean]$Octets = (($IPAddress.Split(".") | Measure-Object).Count -eq 4)
      [boolean]$Valid = ($IPAddress -as [ipaddress]) -as [boolean]
      return ($Valid -and $Octets)
    }

    ## END Native Helper Functions ##


    ##### BEGIN Main Body #####

    $RemoteHostNetworkInfoArray = @()
    if (!$(Test-IsValidIPAddress -IPAddress $HostNameOrIP)) {
      try {
        $HostNamePrep = $HostNameOrIP
        [System.Collections.ArrayList]$RemoteHostArrayOfIPAddresses = @()
        $IPv4AddressFamily = "InterNetwork"
        $IPv6AddressFamily = "InterNetworkV6"

        $ResolutionInfo = [System.Net.Dns]::GetHostEntry($HostNamePrep)
        $ResolutionInfo.AddressList | Where-Object {
          $_.AddressFamily -eq $IPv4AddressFamily
        } | ForEach-Object {
          if ($RemoteHostArrayOfIPAddresses -notcontains $_.IPAddressToString) {
            $null = $RemoteHostArrayOfIPAddresses.Add($_.IPAddressToString)
          }
        }
      }
      catch {
        Write-Verbose "Unable to resolve $HostNameOrIP when treated as a Host Name (as opposed to IP Address)!"
      }
    }
    if (Test-IsValidIPAddress -IPAddress $HostNameOrIP) {
      try {
        $HostIPPrep = $HostNameOrIP
        [System.Collections.ArrayList]$RemoteHostArrayOfIPAddresses = @()
        $null = $RemoteHostArrayOfIPAddresses.Add($HostIPPrep)

        $ResolutionInfo = [System.Net.Dns]::GetHostEntry($HostIPPrep)

        [System.Collections.ArrayList]$RemoteHostFQDNs = @()
        $null = $RemoteHostFQDNs.Add($ResolutionInfo.HostName)
      }
      catch {
        Write-Verbose "Unable to resolve $HostNameOrIP when treated as an IP Address (as opposed to Host Name)!"
      }
    }

    if ($RemoteHostArrayOfIPAddresses.Count -eq 0) {
      Write-Error "Unable to determine IP Address of $HostNameOrIP! Halting!"
      $global:FunctionResult = "1"
      return
    }

    # At this point, we have $RemoteHostArrayOfIPAddresses...
    [System.Collections.ArrayList]$RemoteHostFQDNs = @()
    foreach ($HostIP in $RemoteHostArrayOfIPAddresses) {
      try {
        $FQDNPrep = [System.Net.Dns]::GetHostEntry($HostIP).HostName
      }
      catch {
        Write-Verbose "Unable to resolve $HostIP. No PTR Record? Please check your DNS config."
        continue
      }
      if ($RemoteHostFQDNs -notcontains $FQDNPrep) {
        $null = $RemoteHostFQDNs.Add($FQDNPrep)
      }
    }

    if ($RemoteHostFQDNs.Count -eq 0) {
      $null = $RemoteHostFQDNs.Add($ResolutionInfo.HostName)
    }

    [System.Collections.ArrayList]$HostNameList = @()
    [System.Collections.ArrayList]$DomainList = @()
    foreach ($fqdn in $RemoteHostFQDNs) {
      $PeriodCheck = $($fqdn | Select-String -Pattern "\.").Matches.Success
      if ($PeriodCheck) {
        $HostName = $($fqdn -split "\.")[0]
        $Domain = $($fqdn -split "\.")[1..$($($fqdn -split "\.").Count - 1)] -join '.'
      }
      else {
        $HostName = $fqdn
        $Domain = "Unknown"
      }

      $null = $HostNameList.Add($HostName)
      $null = $DomainList.Add($Domain)
    }

    if ($RemoteHostFQDNs[0] -eq $null -and $HostNameList[0] -eq $null -and $DomainList -eq "Unknown" -and $RemoteHostArrayOfIPAddresses) {
      [System.Collections.ArrayList]$SuccessfullyPingedIPs = @()
      # Test to see if we can reach the IP Addresses
      foreach ($ip in $RemoteHostArrayOfIPAddresses) {
        if ([bool]$(Test-Connection $ip -Count 1 -ErrorAction SilentlyContinue)) {
          $null = $SuccessfullyPingedIPs.Add($ip)
        }
      }

      if ($SuccessfullyPingedIPs.Count -eq 0) {
        Write-Error "Unable to resolve $HostNameOrIP! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }

    [pscustomobject]@{
      IPAddressList = [System.Collections.ArrayList]@($(if ($SuccessfullyPingedIPs) { $SuccessfullyPingedIPs } else { $RemoteHostArrayOfIPAddresses }))
      FQDN = if ($RemoteHostFQDNs) { $RemoteHostFQDNs[0] } else { $null }
      HostName = if ($HostNameList) { $HostNameList[0].ToLowerInvariant() } else { $null }
      Domain = if ($DomainList) { $DomainList[0] } else { $null }
    }

    ##### END Main Body #####

  }

  ##### END Helper Functions #####

  ## BEGIN $TargetVMName adjudication ##

  if ($TargetVMName) {
    if (!$HypervisorFQDNOrIP) {
      # Assume that $env:ComputerName is the hypervisor
      $HypervisorFQDNOrIP = $env:ComputerName
      if ($(Get-Module -ListAvailable).Name -notcontains "Hyper-V") {
        Write-Warning "The localhost $env:ComputerName does not appear to be a hypervisor!"
        $HypervisorFQDNOrIP = Read-Host -Prompt "Please enter the FQDN or IP of the hypervisor that manages $TargetVMName"
      }
    }
  }

  if ($HypervisorFQDNOrIP) {
    try {
      $HypervisorNetworkInfo = Resolve-Host -HostNameOrIP $HypervisorFQDNOrIP -ErrorAction Stop
    }
    catch {
      Write-Error "Unable to resolve $HypervisorFQDNOrIP! Halting!"
      $global:FunctionResult = "1"
      return
    }
  }

  if ($TargetVMName) {
    # Make sure the $TargetVMName exists on the hypervisor and get some info about it from the Hypervisor's perspective
    if ($HypervisorNetworkInfo.HostName -ne $env:ComputerName) {
      $InvokeCommandSB = {
        try {
          $TargetVMInfoFromHyperV = Get-VM -Name $using:TargetVMName -ErrorAction Stop
        }
        catch {
          Write-Error "Unable to find $using:TargetVMName on $($using:HypervisorNetworkInfo.HostName)!"
          return
        }

        # Need to Get $HostNameNetworkInfo via Network Adapter IP
        $GuestVMIPAddresses = $TargetVMInfoFromHyperV.NetworkAdapters.IPAddresses

        [pscustomobject]@{
          HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
          HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
          TargetVMInfoFromHyperV = $TargetVMInfoFromHyperV
          GuestVMIPAddresses = $GuestVMIPAddresses
        }
      }

      try {
        $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -ScriptBlock $InvokeCommandSB -ErrorAction Stop

        $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
        $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
        $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
        $GuestVMIPAddresses = $InvokeCommandOutput.GuestVMIPAddresses
      }
      catch {
        if ($_ -match "Cannot find the computer") {
          try {
            if (!$HypervisorCreds) {
              Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
              $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
              $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

              $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
            }
            $Creds = $HypervisorCreds

            $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
            $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
            $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
            $GuestVMIPAddresses = $InvokeCommandOutput.GuestVMIPAddresses
          }
          catch {
            if ($_ -match "no logon servers") {
              try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                $GuestVMIPAddresses = $InvokeCommandOutput.GuestVMIPAddresses
              }
              catch {
                Write-Error $_
                $global:FunctionResult = "1"
                return
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        elseif ($_ -match "no logon servers") {
          try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
            $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
            $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
            $GuestVMIPAddresses = $InvokeCommandOutput.GuestVMIPAddresses
          }
          catch {
            if ($_ -match "Cannot find the computer") {
              try {
                if (!$HypervisorCreds) {
                  Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
                  $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                  $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                  $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                }
                $Creds = $HypervisorCreds

                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                $GuestVMIPAddresses = $InvokeCommandOutput.GuestVMIPAddresses
              }
              catch {
                Write-Error $_
                $global:FunctionResult = "1"
                return
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        else {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }
      }
    }
    else {
      # Guest VM Info from Hypervisor Perspective
      try {
        $TargetVMInfoFromHyperV = Get-VM -Name $TargetVMName -ErrorAction Stop
      }
      catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
      }

      # Guest VM OS Info
      $HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
      $HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
      $GuestVMIPAddresses = $TargetVMInfoFromHyperV.NetworkAdapters.IPAddresses
    }

    # Now, we need to get $HostNameOSInfo and $HostNameComputerInfo
    [System.Collections.ArrayList]$ResolvedIPs = @()
    foreach ($IPAddr in $GuestVMIPAddresses) {
      try {
        $HostNameNetworkInfoPrep = Resolve-Host -HostNameOrIP $IPAddr -ErrorAction Stop

        $null = $ResolvedIPs.Add($HostNameNetworkInfoPrep)
      }
      catch {
        Write-Verbose "Unable to resolve $IPAddr"
      }
    }
    foreach ($ResolvedIP in $ResolvedIPs) {
      $NTDomainInfo = Get-CimInstance Win32_NTDomain
      if ($ResolvedIP.Domain -eq $NTDomainInfo.DnsForestName) {
        $HostNameNetworkInfo = $ResolvedIP
      }
    }
    if (!$HostNameNetworkInfo) {
      $HostNameNetworkInfo = $ResolvedIPs[0]
    }

    $InvokeCommandSB = {
      [pscustomobject]@{
        HostNameComputerInfo = Get-CimInstance Win32_ComputerSystem
        HostNameOSInfo = Get-CimInstance Win32_OperatingSystem
        HostNameProcessorInfo = Get-CimInstance Win32_Processor
        HostNameBIOSInfo = Get-CimInstance Win32_BIOS
      }
    }

    try {
      $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.FQDN -ScriptBlock $InvokeCommandSB -ErrorAction Stop

      #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
      $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
      $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
      $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
      $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
    }
    catch {
      if ($_ -match "Cannot find the computer") {
        try {
          if (!$TargetHostNameCreds) {
            Write-Warning "Connecting to remote server $($HostNameNetworkInfo.FQDN) failed using credentials of the current user."
            $UserName = Read-Host -Prompt "Please enter a user name with access to $($HostNameNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
            $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

            $TargetHostNameCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
          }
          $Creds = $TargetHostNameCreds

          $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

          #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -WarningAction SilentlyContinue -ErrorAction Stop
          $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
          $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
          $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
          $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
        }
        catch {
          if ($_ -match "no logon servers") {
            try {
              $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

              #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
              $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
              $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
              $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
              $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
            }
            catch {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
          else {
            Write-Error $_
            $global:FunctionResult = "1"
            return
          }
        }
      }
      elseif ($_ -match "no logon servers") {
        try {
          $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -ScriptBlock $InvokeCommandSB -ErrorAction Stop

          #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
          $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
          $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
          $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
          $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
        }
        catch {
          if ($_ -match "Cannot find the computer") {
            try {
              if (!$TargetHostNameCreds) {
                Write-Warning "Connecting to remote server $($HostNameNetworkInfo.FQDN) failed using credentials of the current user."
                $UserName = Read-Host -Prompt "Please enter a user name with access to $($HostNameNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                $TargetHostNameCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
              }
              $Creds = $TargetHostNameCreds

              $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

              #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -WarningAction SilentlyContinue -ErrorAction Stop
              $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
              $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
              $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
              $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
            }
            catch {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
          else {
            Write-Error $_
            $global:FunctionResult = "1"
            return
          }
        }
      }
      else {
        Write-Error $_
        $global:FunctionResult = "1"
        return
      }
    }

    # Now we have $HypervisorNetworkInfo, $HypervisorComputerInfo, $HypervisorOSInfo, $TargetVMInfoFromHyperV, 
    # $HostNameNetworkInfo, $HostNameComputerInfo, $HostNameOSInfo, and $HostNameBIOSInfo
  }

  ## END $TargetVMName adjudication ##

  ## BEGIN $TargetHostNameOrIP adjudication ##

  if ($TargetHostNameOrIP) {
    try {
      $HostNameNetworkInfo = Resolve-Host -HostNameOrIP $TargetHostNameOrIP -ErrorAction Stop
    }
    catch {
      Write-Error "Unable to resolve $TargetHostNameOrIP! Halting!"
      $global:FunctionResult = "1"
      return
    }

    # BEGIN Get Guest VM Info # 

    if ($HostNameNetworkInfo.HostName -ne $env:ComputerName) {
      $InvokeCommandSB = {
        try {
          $HostNameGuestVMInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters" -ErrorAction Stop
        }
        catch {
          $HostNameGuestVMInfo = "IntegrationServices_Not_Installed"
        }

        [pscustomobject]@{
          HostNameComputerInfo = Get-CimInstance Win32_ComputerSystem
          HostNameOSInfo = Get-CimInstance Win32_OperatingSystem
          HostNameProcessorInfo = Get-CimInstance Win32_Processor
          HostNameBIOSInfo = Get-CimInstance Win32_BIOS
          HostNameGuestVMInfo = $HostNameGuestVMInfo
        }
      }

      try {
        $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.FQDN -ScriptBlock $InvokeCommandSB -ErrorAction Stop

        #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
        $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
        $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
        $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
        $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
        $HostNameGuestVMInfo = $InvokeCommandOutput.HostNameGuestVMInfo
      }
      catch {
        if ($_ -match "Cannot find the computer") {
          try {
            if (!$TargetHostNameCreds) {
              Write-Warning "Connecting to remote server $($HostNameNetworkInfo.FQDN) failed using credentials of the current user."
              $UserName = Read-Host -Prompt "Please enter a user name with access to $($HostNameNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
              $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

              $TargetHostNameCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
            }
            $Creds = $TargetHostNameCreds

            $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -WarningAction SilentlyContinue -ErrorAction Stop
            $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
            $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
            $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
            $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
            $HostNameGuestVMInfo = $InvokeCommandOutput.HostNameGuestVMInfo
          }
          catch {
            if ($_ -match "no logon servers") {
              try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
                $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
                $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
                $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
                $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
                $HostNameGuestVMInfo = $InvokeCommandOutput.HostNameGuestVMInfo
              }
              catch {
                Write-Error $_
                $global:FunctionResult = "1"
                return
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        elseif ($_ -match "no logon servers") {
          try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -WarningAction SilentlyContinue -ErrorAction Stop
            $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
            $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
            $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
            $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
            $HostNameGuestVMInfo = $InvokeCommandOutput.HostNameGuestVMInfo
          }
          catch {
            if ($_ -match "Cannot find the computer") {
              try {
                if (!$TargetHostNameCreds) {
                  Write-Warning "Connecting to remote server $($HostNameNetworkInfo.FQDN) failed using credentials of the current user."
                  $UserName = Read-Host -Prompt "Please enter a user name with access to $($HostNameNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                  $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                  $TargetHostNameCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                }
                $Creds = $TargetHostNameCreds

                $InvokeCommandOutput = Invoke-Command -ComputerName $HostNameNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                #$HostNameVirtualStatusInfo = Get-ComputerVirtualStatus -ComputerName $HostNameNetworkInfo.FQDN -Credential $Creds -WarningAction SilentlyContinue -ErrorAction Stop
                $HostNameComputerInfo = $InvokeCommandOutput.HostNameComputerInfo
                $HostNameOSInfo = $InvokeCommandOutput.HostNameOSInfo
                $HostNameProcessorInfo = $InvokeCommandOutput.HostNameProcessorInfo
                $HostNameBIOSInfo = $InvokeCommandOutput.HostNameBIOSInfo
                $HostNameGuestVMInfo = $InvokeCommandOutput.HostNameGuestVMInfo
              }
              catch {
                Write-Error $_
                $global:FunctionResult = "1"
                return
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        else {
          Write-Error $_
          $global:FunctionResult = "1"
          return
        }
      }
    }
    else {
      try {
        $HostNameGuestVMInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters" -ErrorAction Stop
      }
      catch {
        $HostNameGuestVMInfo = "IntegrationServices_Not_Installed"
      }

      $HostNameComputerInfo = Get-CimInstance Win32_ComputerSystem
      $HostNameOSInfo = Get-CimInstance Win32_OperatingSystem
      $HostNameProcessorInfo = Get-CimInstance Win32_Processor
      $HostNameBIOSInfo = Get-CimInstance Win32_BIOS
      $HostNameGuestVMInfo = $HostNameGuestVMInfo
    }

    if ($HostNameBIOSInfo.SMBIOSBIOSVersion -match "Hyper-V|VirtualBox|VMWare" -or
      $HostNameBIOSInfo.Manufacturer -match "Hyper-V|VirtualBox|VMWare" -or
      $HostNameBIOSInfo.Name -match "Hyper-V|VirtualBox|VMWare" -or
      $HostNameBIOSInfo.SerialNumber -match "Hyper-V|VirtualBox|VMWare" -or
      $HostNameBIOSInfo.Version -match "Hyper-V|VirtualBox|VMWare") {
      Add-Member -InputObject $HostNameBIOSInfo NoteProperty -Name "IsVirtual" -Value $True
    }
    else {
      Add-Member -InputObject $HostNameBIOSInfo NoteProperty -Name "IsVirtual" -Value $False
    }

    if (!$HostNameBIOSInfo.IsVirtual) {
      Write-Error "This function is meant to determine if a Guest VM is capable of Nested Virtualization, but $TargetHostNameOrIP is a physical machine! Halting!"
      $global:FunctionResult = "1"
      return
    }

    if (!$($HostNameBIOSInfo.SMBIOSBIOSVersion -match "Hyper-V" -or $HostNameBIOSInfo.Name -match "Hyper-V")) {
      Write-Warning "The hypervisor for $($HostNameNetworkInfo.FQDN) is NOT Microsoft's Hyper-V. Unable to get additional information about the hypervisor!"
      $HypervisorIsHyperV = $False
    }
    else {
      $HypervisorIsHyperV = $True
    }


    # END Get Guest VM Info #

    # BEGIN Get Hypervisor Info #

    if ($HypervisorIsHyperV) {
      # Now we need to try and get some info about the hypervisor
      if ($HostNameGuestVMInfo -eq "IntegrationServices_Not_Installed") {
        # Still need the FQDN/Location of the hypervisor
        if (!$HypervisorFQDNOrIP) {
          $HypervisorFQDNOrIP = $env:ComputerName
          if ($(Get-Module -ListAvailable).Name -notcontains "Hyper-V") {
            Write-Warning "The localhost $env:ComputerName does not appear to be a hypervisor!"
            $HypervisorFQDNOrIP = Read-Host -Prompt "Please enter the FQDN or IP of the hypervisor that manages $TargetVMName"
          }
        }

        try {
          $HypervisorNetworkInfo = Resolve-Host -HostNameOrIP $HypervisorFQDNOrIP -ErrorAction Stop
        }
        catch {
          Write-Error "Unable to resolve $HypervisorFQDNOrIP! Halting!"
          $global:FunctionResult = "1"
          return
        }

        # Still need the name of the Guest VM according the the hypervisor
        if ($HypervisorNetworkInfo.HostName -ne $env:ComputerName) {
          $InvokeCommandSB = {
            # We an determine the $TargetVMName by finding the Guest VM Network Adapter with an IP that matches
            # $HostNameNetworkInfo.IPAddressList
            $TargetVMName = $(Get-VM | Where-Object { $_.NetworkAdapters.IPAddresses -contains $using:HostNameNetworkInfo.IPAddressList[0] }).Name

            try {
              $TargetVMInfoFromHyperV = Get-VM -Name $TargetVMName -ErrorAction Stop
            }
            catch {
              $TargetVMInfoFromHyperV = "Unable_to_find_VM"
            }

            [pscustomobject]@{
              HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
              HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
              TargetVMInfoFromHyperV = $TargetVMInfoFromHyperV
            }
          }

          try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
            $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
            $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
          }
          catch {
            if ($_ -match "Cannot find the computer") {
              try {
                if (!$HypervisorCreds) {
                  Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
                  $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                  $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                  $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                }
                $Creds = $HypervisorCreds

                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
              }
              catch {
                if ($_ -match "no logon servers") {
                  try {
                    $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                    $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                    $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                    $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                  }
                  catch {
                    Write-Error $_
                    $global:FunctionResult = "1"
                    return
                  }
                }
                else {
                  Write-Error $_
                  $global:FunctionResult = "1"
                  return
                }
              }
            }
            elseif ($_ -match "no logon servers") {
              try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
              }
              catch {
                if ($_ -match "Cannot find the computer") {
                  try {
                    if (!$HypervisorCreds) {
                      Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
                      $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                      $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                      $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                    }
                    $Creds = $HypervisorCreds

                    $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo ..HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                    $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                    $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                    $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                  }
                  catch {
                    Write-Error $_
                    $global:FunctionResult = "1"
                    return
                  }
                }
                else {
                  Write-Error $_
                  $global:FunctionResult = "1"
                  return
                }
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        else {
          # We an determine the $TargetVMName by finding the Guest VM Network Adapter with an IP that matches
          # $HostNameNetworkInfo.IPAddressList
          $TargetVMName = $(Get-VM | Where-Object { $_.NetworkAdapters.IPAddresses -contains $HostNameNetworkInfo.IPAddressList[0] }).Name

          try {
            $TargetVMInfoFromHyperV = Get-VM -Name $TargetVMName -ErrorAction Stop
          }
          catch {
            $TargetVMInfoFromHyperV = "Unable_to_find_VM"
          }

          $HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
          $HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
        }
      }
      else {
        # Already have the FQDN of the hypervisor...
        try {
          $HypervisorNetworkInfo = Resolve-Host -HostNameOrIP $HostNameGuestVMInfo.PhysicalHostNameFullyQualified -ErrorAction Stop
        }
        catch {
          Write-Error "Unable to resolve $($HostNameGuestVMInfo.PhysicalHostNameFullyQualified))! Halting!"
          $global:FunctionResult = "1"
          return
        }

        if ($HypervisorNetworkInfo.HostName -ne $env:ComputerName) {
          $InvokeCommandSB = {
            try {
              $TargetVMInfoFromHyperV = Get-VM -Name $using:HostNameGuestVMInfo.VirtualMachineName -ErrorAction Stop
            }
            catch {
              $TargetVMInfoFromHyperV = "Unable_to_find_VM"
            }

            [pscustomobject]@{
              HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
              HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
              TargetVMInfoFromHyperV = $TargetVMInfoFromHyperV
            }
          }

          try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -ScriptBlock $InvokeCommandSB -ErrorAction Stop

            $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
            $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
            $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
          }
          catch {
            if ($_ -match "Cannot find the computer") {
              try {
                if (!$HypervisorCreds) {
                  Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
                  $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                  $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                  $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                }
                $Creds = $HypervisorCreds

                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.FQDN -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
              }
              catch {
                if ($_ -match "no logon servers") {
                  try {
                    $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                    $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                    $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                    $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                  }
                  catch {
                    Write-Error $_
                    $global:FunctionResult = "1"
                    return
                  }
                }
                else {
                  Write-Error $_
                  $global:FunctionResult = "1"
                  return
                }
              }
            }
            elseif ($_ -match "no logon servers") {
              try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
              }
              catch {
                if ($_ -match "Cannot find the computer") {
                  try {
                    if (!$HypervisorCreds) {
                      Write-Warning "Connecting to remote server $($HypervisorNetworkInfo.FQDN) failed using credentials of the current user."
                      $UserName = Read-Host -Prompt "Please enter a user name with access to $($HypervisorNetworkInfo.FQDN) using format <DomainPrefix>\<User>"
                      $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString

                      $HypervisorCreds = [System.Management.Automation.PSCredential]::new($UserName,$Password)
                    }
                    $Creds = $HypervisorCreds

                    $InvokeCommandOutput = Invoke-Command -ComputerName $HypervisorNetworkInfo.HostName -Credential $Creds -ScriptBlock $InvokeCommandSB -ErrorAction Stop

                    $HypervisorComputerInfo = $InvokeCommandOutput.HypervisorComputerInfo
                    $HypervisorOSInfo = $InvokeCommandOutput.HypervisorOSInfo
                    $TargetVMInfoFromHyperV = $InvokeCommandOutput.TargetVMInfoFromHyperV
                  }
                  catch {
                    Write-Error $_
                    $global:FunctionResult = "1"
                    return
                  }
                }
                else {
                  Write-Error $_
                  $global:FunctionResult = "1"
                  return
                }
              }
            }
            else {
              Write-Error $_
              $global:FunctionResult = "1"
              return
            }
          }
        }
        else {
          try {
            $TargetVMInfoFromHyperV = Get-VM -Name $HostNameGuestVMInfo.VirtualMachineName -ErrorAction Stop
          }
          catch {
            $TargetVMInfoFromHyperV = "Unable_to_find_VM"
          }

          $HypervisorComputerInfo = Get-CimInstance Win32_ComputerSystem
          $HypervisorOSInfo = Get-CimInstance Win32_OperatingSystem
        }
      }

      if ($TargetVMInfoFromHyperV -eq "Unable_to_find_VM") {
        Write-Error "Unable to find VM $TargetVMName on the specified hypervisor $($HypervisorNetworkInfo.FQDN)! Halting!"
        $global:FunctionResult = "1"
        return
      }
    }
    else {
      $HypervisorNetworkInfo = $null
      $HypervisorComputerInfo = $null
      $HypervisorOSInfo = $null
    }

    # Now we have $HypervisorNetworkInfo, $HypervisorComputerInfo, $HypervisorOSInfo, $TargetVMInfoFromHyperV, 
    # $HostNameGuestVMInfo, $HostNameNetworkInfo, $HostNameComputerInfo, and $HostNameOSInfo, $HostNameBIOSInfo,
    # and $HostNameProcessorInfo


    # End Get Hypervisor Info #

  }

  ## END $TargetHostNameOrIP adjudication ##

  [pscustomobject]@{
    HypervisorNetworkInfo = $HypervisorNetworkInfo
    HypervisorComputerInfo = $HypervisorComputerInfo
    HypervisorOSInfo = $HypervisorOSInfo
    TargetVMInfoFromHyperV = $TargetVMInfoFromHyperV
    HostNameNetworkInfo = $HostNameNetworkInfo
    HostNameComputerInfo = $HostNameComputerInfo
    HostNameOSInfo = $HostNameOSInfo
    HostNameProcessorInfo = $HostNameProcessorInfo
    HostNameBIOSInfo = $HostNameBIOSInfo
  }
}
