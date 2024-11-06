
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

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

function Test-Port {
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
    Write-Host ("Total size of directory {0}: {1} MB" -f $Path, [math]::Round($size / 1MB, 2)) -ForegroundColor Cyan
  } else {
    Write-Host "Directory not found: $Path" -ForegroundColor Red
  }
}

# Function to retrieve the list of services
function Get-Services {
  Write-Host "Retrieving list of services..." -ForegroundColor Yellow
  Get-Service | Format-Table DisplayName, Status
  Write-Host "Services list retrieved." -ForegroundColor Green
}

# Function to get system information
function Get-SystemInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $disk = Get-CimInstance Win32_LogicalDisk

    [PSCustomObject]@{
        OS             = $os.Caption
        OS_Version     = $os.Version
        CPU            = $cpu.Name
        CPU_Cores      = $cpu.NumberOfCores
        Total_Memory   = [math]::Round($memory.Sum / 1GB, 2)
        Disk_Space     = $disk | ForEach-Object { [PSCustomObject]@{ $_.DeviceID = [math]::Round($_.Size / 1GB, 2) } }
    } | Format-Table -AutoSize
}

# Function to retrieve environment variables
function Get-EnvironmentVariables {
  Write-Host "Retrieving environment variables..." -ForegroundColor Yellow
  Get-ChildItem Env: | Format-Table Name, Value
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
  Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Format-Table -AutoSize
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
    Get-FileHash -Path $FilePath | Format-Table Algorithm, Hash
  } else {
    Write-Host "File not found: $FilePath" -ForegroundColor Red
  }
}

function editprofile {
  Write-Host "Opening Notepad++ with your profile" -ForegroundColor Yellow
  C:\"Program Files"\Notepad++\notepad++.exe "C:\Users\Nick\Dropbox\PC (2)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
}

function notepad++ {
  Write-Host "Opening Notepad++" -ForegroundColor Yellow
  C:\"Program Files"\Notepad++\notepad++.exe
}

# Function to quickly open Visual Studio Code in the current directory
function Open-Code {
    code .
}

# Function to get the size of a directory
function Get-DirSize {
    param (
        [string]$path = "."
    )
    $size = (Get-ChildItem -Recurse -ErrorAction SilentlyContinue $path | Measure-Object -Property Length -Sum).Sum
    [math]::Round($size / 1MB, 2)
}

# Function to list the top 10 processes by memory usage
function Get-TopProcesses {
    Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 10 | Format-Table -Property Id, ProcessName, @{Label="Memory (MB)"; Expression={[math]::Round($_.WorkingSet / 1MB, 2)}}
}

# Checks and displays available and used disk space for a specified drive.
function Check-DiskSpace {
  param(
    [string]$DriveLetter = "C"
  )

  Write-Host "Checking disk space on drive $DriveLetter..." -ForegroundColor Yellow
  $disk = Get-PSDrive -Name $DriveLetter
  if ($disk) {
    Write-Host ("Drive {0}: Used: {1} GB, Free: {2} GB" -f $DriveLetter, [math]::Round($disk.Used / 1GB, 2), [math]::Round($disk.Free / 1GB, 2)) -ForegroundColor Cyan
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

# Deletes files in the system’s temporary folder to free up space.
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
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $ImagePath, 0x0001)
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
  (New-Object -ComObject Shell.Application).NameSpace(10).Items() | ForEach-Object { $_.InvokeVerb("delete") }
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
    param (
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
    param (
        [string]$directory,
        [string]$searchString
    )
    if (Test-Path $directory) {
        Get-ChildItem -Path $directory -Recurse -File |
        Select-String -Pattern $searchString |
        ForEach-Object {
            [PSCustomObject]@{
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
    param (
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
    param (
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
    param (
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
    param (
        [string]$directory,
        [int]$daysOld
    )
    $archivePath = Join-Path $directory "Archive_$(Get-Date -Format 'yyyyMMdd')"
    New-Item -ItemType Directory -Path $archivePath -Force

    Get-ChildItem -Path $directory -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) } | ForEach-Object {
        Move-Item -Path $_.FullName -Destination $archivePath
    }

    Write-Host "Files older than $daysOld days have been archived to $archivePath"
}

# Function to monitor CPU and memory usage
function Monitor-SystemUsage {
    [CmdletBinding()]
    param (
        [int]$interval = 5,
        [int]$duration = 60
    )

    $endTime = (Get-Date).AddSeconds($duration)
    while ((Get-Date) -lt $endTime) {
        $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
        $memory = Get-Counter '\Memory\Available MBytes'

        [PSCustomObject]@{
            TimeStamp = Get-Date
            CPU_Usage = [math]::Round($cpu.CounterSamples.CookedValue, 2)
            AvailableMemory_MB = [math]::Round($memory.CounterSamples.CookedValue, 2)
        } | Format-Table -AutoSize

        Start-Sleep -Seconds $interval
    }
}

# Function to send an email with system information
function Send-SystemInfoEmail {
    param (
        [string]$to,
        [string]$from,
        [string]$smtpServer
    )

    $systemInfo = Get-SystemInfo
    $body = $systemInfo | Out-String

    $message = @{
        To      = $to
        From    = $from
        Subject = "System Information Report"
        Body    = $body
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
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourcePath, $zipPath)
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
  Write-Host ("System uptime: {0} days, {1} hours" -f $uptime.Days, $uptime.Hours) -ForegroundColor Cyan
  
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
            "Google DNS"            = "8.8.8.8";
            "Cloudflare DNS"        = "1.1.1.1";
            "OpenDNS"               = "208.67.222.222";
            "Quad9 DNS"             = "9.9.9.9";
            "Microsoft Azure"       = "13.107.21.200";
            "Cloudflare Backup DNS" = "1.0.0.1";
            "Google (US)"           = "www.google.com";
            "YouTube (US)"          = "142.251.32.110";
            "GitHub"                = "199.232.68.133";
            "StackOverflow"         = "104.16.248.249";
            "Reddit (Fastly)"       = "151.101.1.140";
            "AWS (Amazon)"          = "52.95.110.1";
            "Twitter (US, Fastly)"  = "151.101.65.69";
            "AWS Global DNS"        = "205.251.242.103";
            "GitHub Pages (US)"     = "185.199.108.153";
            "Telstra (Australia)"   = "203.98.7.65";
            "TPG (Australia)"       = "202.9.36.5";
            "Etisalat (UAE)"        = "195.229.241.222";
            "Google (EU, Germany)"  = "194.42.48.50";
            "Cloudflare EU"         = "185.45.22.35";
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
            $roundedLatency = [math]::Round($latency, 2)
            Write-Host "Latency to ${serverName}: $roundedLatency ms" -ForegroundColor Green
            $results += [pscustomobject]@{
                Server  = $serverName
                Address = $serverAddress
                Latency = "$roundedLatency ms"
            }
        } else {
            Write-Host "Could not reach ${serverName} (${serverAddress})." -ForegroundColor Red
            $results += [pscustomobject]@{
                Server  = $serverName
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
  Get-EventLog -LogName Security -After (Get-Date).AddDays(-$Days) | Select-Object TimeGenerated, EntryType, Source, EventID, Message | Format-Table -AutoSize
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
        SizeMB     = [math]::Round($size / 1MB, 2)
      }
    } | Sort-Object SizeMB -Descending | Format-Table -AutoSize
  } else {
    Write-Host "Directory not found: $Path" -ForegroundColor Red
  }
}
