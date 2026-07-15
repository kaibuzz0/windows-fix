#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Repair Suite - PowerScript Toolkit
    Advanced PowerShell-based repair and optimization

.DESCRIPTION
    Comprehensive Windows maintenance and repair automation
    with detailed logging and reporting capabilities.

.NOTES
    Version: 2.0
    Author: Monday's Players Edition
#>

param(
    [Parameter()]
    [ValidateSet("Full", "Quick", "Deep", "Gaming", "Network", "Security", "Maintenance")]
    [string]$Mode = "Quick",

    [switch]$CreateRestorePoint,
    [switch]$NoReboot,
    [switch]$GenerateReport,
    [string]$LogPath = "$env:TEMP\WindowsRepair_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
)

# Initialize
$ErrorActionPreference = "Continue"
$StartTime = Get-Date
$Results = @{
    StartTime = $StartTime
    Mode = $Mode
    Operations = @()
    Errors = @()
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry -ForegroundColor $(switch($Level){ "ERROR"{"Red"}; "WARN"{"Yellow"}; "SUCCESS"{"Green"}; default{"White"}})
    Add-Content -Path $LogPath -Value $logEntry
}

function Test-Admin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-RestorePoint {
    try {
        Write-Log "Creating system restore point..."
        Enable-ComputerRestore -Drive "$env:SystemDrive\"
        Checkpoint-Computer -Description "Windows Repair Suite - $Mode Repair" -RestorePointType "MODIFY_SETTINGS"
        Write-Log "Restore point created successfully" "SUCCESS"
        $Results.Operations += "Restore point created"
    }
    catch {
        Write-Log "Failed to create restore point: $($_.Exception.Message)" "ERROR"
        $Results.Errors += "Restore point creation failed"
    }
}

function Invoke-SystemFileCheck {
    Write-Log "Starting System File Checker..."
    $process = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -PassThru -NoNewWindow
    $Results.Operations += "SFC scan completed (Exit: $($process.ExitCode))"
    Write-Log "SFC scan completed" "SUCCESS"
}

function Invoke-DISMRepair {
    param([string]$Operation = "ScanHealth")
    Write-Log "Running DISM /$Operation..."
    $process = Start-Process -FilePath "DISM.exe" -ArgumentList "/Online /Cleanup-Image /$Operation" -Wait -PassThru -NoNewWindow
    $Results.Operations += "DISM $Operation completed (Exit: $($process.ExitCode))"
    Write-Log "DISM $Operation completed" "SUCCESS"
}

function Invoke-NetworkReset {
    Write-Log "Resetting network configuration..."
    
    $commands = @(
        @{ Name = "Winsock Reset"; Cmd = "netsh winsock reset" },
        @{ Name = "IP Reset"; Cmd = "netsh int ip reset" },
        @{ Name = "Proxy Reset"; Cmd = "netsh winhttp reset proxy" },
        @{ Name = "Flush DNS"; Cmd = "ipconfig /flushdns" },
        @{ Name = "Release IP"; Cmd = "ipconfig /release" },
        @{ Name = "Renew IP"; Cmd = "ipconfig /renew" }
    )
    
    foreach ($cmd in $commands) {
        try {
            Invoke-Expression $cmd.Cmd | Out-Null
            Write-Log "$($cmd.Name) completed" "SUCCESS"
        }
        catch {
            Write-Log "$($cmd.Name) failed: $($_.Exception.Message)" "ERROR"
            $Results.Errors += "$($cmd.Name) failed"
        }
    }
    
    $Results.Operations += "Network reset completed"
}

function Invoke-WindowsUpdateReset {
    Write-Log "Resetting Windows Update components..."
    
    $services = @("bits", "wuauserv", "appidsvc", "cryptsvc")
    
    # Stop services
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Write-Log "Stopped service: $service"
    }
    
    # Rename SoftwareDistribution
    $paths = @(
        "$env:SystemRoot\SoftwareDistribution",
        "$env:SystemRoot\system32\catroot2"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            Rename-Item -Path $path -NewName "$path.old" -Force -ErrorAction SilentlyContinue
            Write-Log "Renamed: $path"
        }
    }
    
    # Start services
    foreach ($service in $services) {
        Start-Service -Name $service -ErrorAction SilentlyContinue
        Write-Log "Started service: $service"
    }
    
    $Results.Operations += "Windows Update reset completed"
    Write-Log "Windows Update reset completed" "SUCCESS"
}

function Clear-SystemTemp {
    Write-Log "Clearing temporary files..."
    
    $paths = @(
        $env:TEMP,
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch",
        "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
    )
    
    $totalFreed = 0
    foreach ($path in $paths) {
        if (Test-Path $path) {
            $sizeBefore = (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
            $sizeAfter = (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $freed = ($sizeBefore - $sizeAfter) / 1MB
            $totalFreed += $freed
            Write-Log "Cleaned $path - Freed: $([math]::Round($freed, 2)) MB"
        }
    }
    
    $Results.Operations += "Cleared temp files (Freed: $([math]::Round($totalFreed, 2)) MB)"
    Write-Log "Total space freed: $([math]::Round($totalFreed, 2)) MB" "SUCCESS"
}

function Invoke-DefenderScan {
    param([string]$ScanType = "QuickScan")
    Write-Log "Starting Windows Defender $ScanType..."
    
    try {
        $defenderPath = "$env:ProgramFiles\Windows Defender\MpCmdRun.exe"
        $typeCode = if ($ScanType -eq "FullScan") { 2 } else { 1 }
        
        $process = Start-Process -FilePath $defenderPath -ArgumentList "-Scan -ScanType $typeCode" -Wait -PassThru -NoNewWindow
        $Results.Operations += "Defender $ScanType completed"
        Write-Log "Defender scan completed" "SUCCESS"
    }
    catch {
        Write-Log "Defender scan failed: $($_.Exception.Message)" "ERROR"
        $Results.Errors += "Defender scan failed"
    }
}

function Optimize-Services {
    param([string]$Profile = "Balanced")
    
    Write-Log "Optimizing services for profile: $Profile"
    
    $serviceConfigs = switch ($Profile) {
        "Gaming" {
            @{
                "SysMain" = "Automatic"
                "WSearch" = "Disabled"
                "WMPNetworkSvc" = "Disabled"
                "WalletService" = "Disabled"
                "diagnosticshub.standardcollector.service" = "Disabled"
                "WerSvc" = "Disabled"
            }
        }
        "Productivity" {
            @{
                "SysMain" = "Automatic"
                "WSearch" = "Automatic"
                "BITS" = "Manual"
                "wuauserv" = "Automatic"
            }
        }
        default {
            @{
                "diagtrack" = "Disabled"
                "dmwappushservice" = "Disabled"
                "MapsBroker" = "Manual"
            }
        }
    }
    
    foreach ($service in $serviceConfigs.GetEnumerator()) {
        try {
            Set-Service -Name $service.Key -StartupType $service.Value -ErrorAction SilentlyContinue
            Write-Log "Configured $($service.Key) to $($service.Value)"
        }
        catch {
            Write-Log "Failed to configure $($service.Key): $($_.Exception.Message)" "WARN"
        }
    }
    
    $Results.Operations += "Services optimized for $Profile profile"
}

function Get-SystemHealth {
    Write-Log "Gathering system health information..."
    
    $health = @{
        OS = (Get-CimInstance Win32_OperatingSystem).Caption
        Version = (Get-CimInstance Win32_OperatingSystem).Version
        Architecture = if ([Environment]::Is64BitOperatingSystem) { "64-bit" } else { "32-bit" }
        TotalRAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
        FreeRAM = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
        DiskSpace = @()
        Uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    }
    
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $health.DiskSpace += @{
            Drive = $_.DeviceID
            Size = [math]::Round($_.Size / 1GB, 2)
            Free = [math]::Round($_.FreeSpace / 1GB, 2)
            PercentFree = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)
        }
    }
    
    $Results.SystemHealth = $health
    Write-Log "System health information collected" "SUCCESS"
    
    return $health
}

function New-HealthReport {
    $EndTime = Get-Date
    $Duration = $EndTime - $StartTime
    
    $report = @"
==============================================
    WINDOWS REPAIR SUITE - HEALTH REPORT
==============================================
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Mode: $Mode
Duration: $($Duration.ToString('hh\:mm\:ss'))

SYSTEM INFORMATION
----------------------------------------------
OS: $($Results.SystemHealth.OS)
Version: $($Results.SystemHealth.Version)
Architecture: $($Results.SystemHealth.Architecture)
Total RAM: $($Results.SystemHealth.TotalRAM) GB
Free RAM: $($Results.SystemHealth.FreeRAM) GB
Uptime: $($Results.SystemHealth.Uptime.ToString('dd\:hh\:mm'))

DISK STATUS
----------------------------------------------
$(foreach ($disk in $Results.SystemHealth.DiskSpace) { "Drive $($disk.Drive) - $($disk.Free) GB free of $($disk.Size) GB ($($disk.PercentFree)%)`n" })

OPERATIONS PERFORMED
----------------------------------------------
$($Results.Operations | ForEach-Object { "[+] $_`n" })

ERRORS ENCOUNTERED
----------------------------------------------
$(if ($Results.Errors.Count -eq 0) { "None" } else { $Results.Errors | ForEach-Object { "[!] $_`n" } })

RECOMMENDATIONS
----------------------------------------------
$(if ($Results.SystemHealth.DiskSpace | Where-Object { $_.PercentFree -lt 15 }) { "[!] Low disk space detected. Consider cleaning up files.`n" })
$(if ($Results.SystemHealth.FreeRAM / $Results.SystemHealth.TotalRAM -lt 0.2) { "[!] Low memory available. Consider closing unused applications.`n" })
$([if ($Mode -eq "Full") { "[*] A system reboot is recommended to complete repairs.`n" }])

Log file: $LogPath
==============================================
"@
    
    $reportPath = "$env:USERPROFILE\Documents\WindowsRepair_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    $report | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Log "Report saved to: $reportPath" "SUCCESS"
    
    return $reportPath
}

# ===== MAIN EXECUTION =====

Write-Log "Windows Repair Suite v2.0 - Starting $Mode repair"
Write-Log "Log file: $LogPath"

if (-not (Test-Admin)) {
    Write-Log "Administrator privileges required!" "ERROR"
    exit 1
}

# Create restore point if requested
if ($CreateRestorePoint) {
    New-RestorePoint
}

# Get baseline health
Get-SystemHealth | Out-Null

# Execute based on mode
switch ($Mode) {
    "Quick" {
        Invoke-SystemFileCheck
        Clear-SystemTemp
        Invoke-NetworkReset
    }
    "Deep" {
        Invoke-SystemFileCheck
        Invoke-DISMRepair -Operation "ScanHealth"
        Invoke-DISMRepair -Operation "RestoreHealth"
        Clear-SystemTemp
        Invoke-WindowsUpdateReset
        Invoke-NetworkReset
        Invoke-DefenderScan -ScanType "QuickScan"
    }
    "Full" {
        New-RestorePoint
        Invoke-SystemFileCheck
        Invoke-DISMRepair -Operation "ScanHealth"
        Invoke-DISMRepair -Operation "CheckHealth"
        Invoke-DISMRepair -Operation "RestoreHealth"
        Clear-SystemTemp
        Invoke-WindowsUpdateReset
        Invoke-NetworkReset
        Invoke-DefenderScan -ScanType "FullScan"
        Optimize-Services -Profile "Balanced"
    }
    "Gaming" {
        Optimize-Services -Profile "Gaming"
        Clear-SystemTemp
        Invoke-DefenderScan -ScanType "QuickScan"
    }
    "Network" {
        Invoke-NetworkReset
    }
    "Security" {
        Invoke-DefenderScan -ScanType "FullScan"
        Invoke-WindowsUpdateReset
    }
    "Maintenance" {
        Clear-SystemTemp
        Invoke-DISMRepair -Operation "StartComponentCleanup"
    }
}

# Generate report if requested
if ($GenerateReport) {
    $reportFile = New-HealthReport
    Write-Log "Report generated: $reportFile"
}

Write-Log "Windows Repair Suite completed" "SUCCESS"

# Prompt for reboot (if not NoReboot)
if (-not $NoReboot -and $Mode -in @("Full", "Deep")) {
    $reboot = Read-Host "A reboot is recommended. Reboot now? (Y/N)"
    if ($reboot -eq "Y" -or $reboot -eq "y") {
        Restart-Computer -Force -Timeout 30
    }
}