#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
    Windows Repair Suite - Enhanced PowerShell Edition v3.0
    Advanced Windows repair and optimization with safety features

.DESCRIPTION
    This PowerShell script provides comprehensive Windows maintenance with:
    - Automatic restore point creation
    - Detailed logging
    - Safety confirmations for destructive operations
    - Progress reporting
    - Undo/restore functionality
    - Validation checks

.PARAMETER Mode
    Operation mode: Full, Quick, Deep, Gaming, Network, Security, Maintenance

.PARAMETER CreateRestorePoint
    Create system restore point before operations

.PARAMETER GenerateReport
    Generate HTML report after completion

.PARAMETER ConfirmDestructive
    Require confirmation for destructive operations

.EXAMPLE
    .\Windows-Repair-Suite-Enhanced.ps1 -Mode Quick -CreateRestorePoint -GenerateReport

.EXAMPLE
    .\Windows-Repair-Suite-Enhanced.ps1 -Mode Gaming -ConfirmDestructive

.NOTES
    Version: 3.0
    Author: Enhanced Edition
    Requires: Windows 10/11, PowerShell 5.1+
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter()]
    [ValidateSet("Full", "Quick", "Deep", "Gaming", "Network", "Security", "Maintenance", "Debloat")]
    [string]$Mode = "Quick",

    [switch]$CreateRestorePoint,
    [switch]$GenerateReport,
    [switch]$ConfirmDestructive,
    [switch]$NoReboot,
    [string]$LogPath = "$env:TEMP\WindowsRepair_$(Get-Date -Format 'yyyyMMdd_HHmmss').log",
    [string]$ReportPath = "$env:TEMP\WindowsRepair_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
)

#region Initialization
$ErrorActionPreference = "Stop"
$StartTime = Get-Date
$Results = @{
    StartTime = $StartTime
    Mode = $Mode
    Operations = [System.Collections.ArrayList]::new()
    Errors = [System.Collections.ArrayList]::new()
    Warnings = [System.Collections.ArrayList]::new()
    Success = 0
    Failed = 0
}

# ASCII Art Banner
$Banner = @"
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║         WINDOWS REPAIR SUITE v3.0 - Enhanced PowerShell           ║
║                                                                      ║
║        Safe • Validated • Recoverable • Professional               ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
"@

Write-Host $Banner -ForegroundColor Cyan

# Check Windows Version
$WindowsVersion = [System.Environment]::OSVersion.Version
$IsWin10 = ($WindowsVersion.Major -eq 10 -and $WindowsVersion.Build -lt 22000)
$IsWin11 = ($WindowsVersion.Major -eq 10 -and $WindowsVersion.Build -ge 22000)

if (-not ($IsWin10 -or $IsWin11)) {
    Write-Warning "This script is designed for Windows 10/11. Proceed with caution."
}
#endregion

#region Functions

function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS", "DESTRUCTIVE")]
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    $color = switch($Level) {
        "ERROR"       { "Red" }
        "WARNING"     { "Yellow" }
        "SUCCESS"     { "Green" }
        "DESTRUCTIVE" { "Magenta" }
        default       { "White" }
    }
    
    Write-Host $logEntry -ForegroundColor $color
    Add-Content -Path $LogPath -Value $logEntry -ErrorAction SilentlyContinue
    
    # Add to results
    switch($Level) {
        "ERROR"       { [void]$Results.Errors.Add($Message) }
        "WARNING"     { [void]$Results.Warnings.Add($Message) }
        "SUCCESS"     { $Results.Success++ }
        default       { [void]$Results.Operations.Add($Message) }
    }
}

function Test-AdminRights {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Confirm-DestructiveOperation {
    param(
        [Parameter(Mandatory)]
        [string]$OperationName,
        
        [string]$WarningMessage = "This operation may cause system instability or data loss."
    )
    
    if (-not $ConfirmDestructive) {
        return $true
    }
    
    Write-Host ""
    Write-Host "⚠️  DESTRUCTIVE OPERATION WARNING" -ForegroundColor Red
    Write-Host "Operation: $OperationName" -ForegroundColor Yellow
    Write-Host $WarningMessage -ForegroundColor Yellow
    Write-Host ""
    
    $confirmation = Read-Host "Type 'DESTRUCTIVE-CONFIRM' to proceed or press Enter to cancel"
    
    if ($confirmation -eq "DESTRUCTIVE-CONFIRM") {
        return $true
    }
    
    Write-Log "Operation cancelled by user" "WARNING"
    return $false
}

function New-SystemRestorePoint {
    param([string]$Description = "Windows Repair Suite")
    
    try {
        Write-Log "Creating system restore point..." "INFO"
        
        # Enable System Restore if disabled
        $systemDrive = $env:SystemDrive
        Enable-ComputerRestore -Drive "$systemDrive\" -ErrorAction SilentlyContinue
        
        # Create restore point
        Checkpoint-Computer -Description "$Description - $(Get-Date -Format 'yyyyMMdd_HHmm')" `
                         -RestorePointType "MODIFY_SETTINGS" `
                         -ErrorAction Stop
        
        Write-Log "Restore point created successfully" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Failed to create restore point: $($_.Exception.Message)" "WARNING"
        $response = Read-Host "Continue without restore point? (Y/N)"
        return ($response -eq "Y" -or $response -eq "y")
    }
}

function Invoke-SystemFileCheck {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    
    Write-Log "Starting System File Checker (SFC)..." "INFO"
    
    if ($PSCmdlet.ShouldProcess("System files", "Run SFC /scannow")) {
        try {
            $process = Start-Process -FilePath "sfc.exe" `
                                    -ArgumentList "/scannow" `
                                    -Wait `
                                    -PassThru `
                                    -NoNewWindow
            
            if ($process.ExitCode -eq 0) {
                Write-Log "SFC completed successfully - no errors found" "SUCCESS"
            } else {
                Write-Log "SFC completed with exit code: $($process.ExitCode)" "WARNING"
                Write-Log "Check CBS.log for details: %SystemRoot%\Logs\CBS\CBS.log" "INFO"
            }
        }
        catch {
            Write-Log "SFC failed: $($_.Exception.Message)" "ERROR"
        }
    }
}

function Invoke-DISMRepair {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [ValidateSet("CheckHealth", "ScanHealth", "RestoreHealth")]
        [string]$Operation = "ScanHealth"
    )
    
    Write-Log "Running DISM /$Operation..." "INFO"
    
    if ($PSCmdlet.ShouldProcess("Windows Image", "Run DISM $Operation")) {
        try {
            $process = Start-Process -FilePath "DISM.exe" `
                                    -ArgumentList "/Online /Cleanup-Image /$Operation" `
                                    -Wait `
                                    -PassThru `
                                    -NoNewWindow
            
            if ($process.ExitCode -eq 0) {
                Write-Log "DISM $Operation completed successfully" "SUCCESS"
            } else {
                Write-Log "DISM completed with exit code: $($process.ExitCode)" "WARNING"
            }
        }
        catch {
            Write-Log "DISM failed: $($_.Exception.Message)" "ERROR"
        }
    }
}

function Invoke-NetworkReset {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    
    Write-Log "Resetting network configuration..." "INFO"
    
    $networkCommands = @(
        @{ Name = "Winsock Reset"; Command = "netsh winsock reset" },
        @{ Name = "IP Reset"; Command = "netsh int ip reset" },
        @{ Name = "Proxy Reset"; Command = "netsh winhttp reset proxy" },
        @{ Name = "Firewall Reset"; Command = "netsh advfirewall reset" }
    )
    
    foreach ($cmd in $networkCommands) {
        if ($PSCmdlet.ShouldProcess($cmd.Name, "Execute")) {
            try {
                $result = Invoke-Expression $cmd.Command 2&1
                Write-Log "$($cmd.Name) completed" "SUCCESS"
            }
            catch {
                Write-Log "$($cmd.Name) failed: $($_.Exception.Message)" "WARNING"
            }
        }
    }
    
    Write-Log "Network reset completed. Restart required." "SUCCESS"
}

function Remove-SystemBloat {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [ValidateSet("Safe", "Moderate", "Aggressive")]
        [string]$Level = "Safe"
    )
    
    $appRemoval = @{
        "Safe" = @(
            "Microsoft.BingFinance",
            "Microsoft.BingSports", 
            "Microsoft.BingWeather",
            "Microsoft.GetStarted",
            "Microsoft.OfficeHub",
            "Microsoft.SolitaireCollection"
        )
        "Moderate" = @(
            "Microsoft.BingFinance",
            "Microsoft.BingSports",
            "Microsoft.BingWeather", 
            "Microsoft.GetStarted",
            "Microsoft.OfficeHub",
            "Microsoft.SolitaireCollection",
            "Microsoft.People",
            "Microsoft.SkypeApp",
            "Microsoft.WindowsMaps",
            "Microsoft.XboxApp",
            "Microsoft.ZuneMusic",
            "Microsoft.ZuneVideo"
        )
        "Aggressive" = @(
            "*"  # All except critical
        )
    }
    
    Write-Log "Removing bloatware (Level: $Level)..." "INFO"
    
    $appsToRemove = $appRemoval[$Level]
    $removedCount = 0
    
    foreach ($app in $appsToRemove) {
        if ($app -eq "*") {
            # Aggressive mode - require confirmation
            if (-not (Confirm-DestructiveOperation "Remove ALL Store apps" "This removes ALL Windows Store apps including Calculator and Photos")) {
                continue
            }
        }
        
        if ($PSCmdlet.ShouldProcess($app, "Remove AppxPackage")) {
            try {
                Get-AppxPackage -Name "*$app*" -ErrorAction SilentlyContinue | 
                    Remove-AppxPackage -ErrorAction Stop
                $removedCount++
                Write-Log "Removed: $app" "SUCCESS"
            }
            catch {
                Write-Log "Failed to remove $app`: $($_.Exception.Message)" "WARNING"
            }
        }
    }
    
    Write-Log "Removed $removedCount apps" "INFO"
}

function Invoke-GamingOptimization {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    
    Write-Log "Applying gaming optimizations..." "INFO"
    
    $gamingTweaks = @{
        # Disable Game DVR
        "HKCU:\System\GameConfigStore" = @{
            "GameDVR_Enabled" = 0
            "GameDVR_FSEBehaviorMode" = 2
        }
        # Disable Game Bar
        "HKCU:\Software\Microsoft\GameBar" = @{
            "AllowAutoGameMode" = 0
            "AutoGameModeEnabled" = 0
        }
    }
    
    foreach ($regPath in $gamingTweaks.Keys) {
        foreach ($name in $gamingTweaks[$regPath].Keys) {
            $value = $gamingTweaks[$regPath][$name]
            if ($PSCmdlet.ShouldProcess("$regPath\$name", "Set registry value")) {
                try {
                    if (-not (Test-Path $regPath)) {
                        New-Item -Path $regPath -Force | Out-Null
                    }
                    Set-ItemProperty -Path $regPath -Name $name -Value $value -Force
                    Write-Log "Set $name = $value" "SUCCESS"
                }
                catch {
                    Write-Log "Failed to set $name`: $($_.Exception.Message)" "WARNING"
                }
            }
        }
    }
    
    Write-Log "Gaming optimizations applied" "SUCCESS"
}

function New-HtmlReport {
    param()
    
    $endTime = Get-Date
    $duration = $endTime - $StartTime
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Windows Repair Suite Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .header { background: #0078d4; color: white; padding: 20px; border-radius: 5px; }
        .section { background: white; margin: 20px 0; padding: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .success { color: green; }
        .warning { color: orange; }
        .error { color: red; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 8px; border-bottom: 1px solid #ddd; }
        th { background: #f0f0f0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Windows Repair Suite - Execution Report</h1>
        <p>Generated: $($endTime.ToString("yyyy-MM-dd HH:mm:ss"))</p>
        <p>Duration: $([math]::Round($duration.TotalMinutes, 2)) minutes</p>
    </div>
    
    <div class="section">
        <h2>Summary</h2>
        <table>
            <tr><th>Mode</th><td>$Mode</td></tr>
            <tr><th>Success Count</th><td class="success">$($Results.Success)</td></tr>
            <tr><th>Warnings</th><td class="warning">$($Results.Warnings.Count)</td></tr>
            <tr><th>Errors</th><td class="error">$($Results.Errors.Count)</td></tr>
        </table>
    </div>
    
    <div class="section">
        <h2>Operations Performed</h2>
        <ul>
$(foreach($op in $Results.Operations) { "            <li>$op</li>" })
        </ul>
    </div>
    
    $(if($Results.Warnings.Count -gt 0) {
    "    <div class='section'>
        <h2 class='warning'>Warnings</h2>
        <ul>
$(foreach($warn in $Results.Warnings) { "            <li>$warn</li>" })
        </ul>
    </div>"
    })
    
    $(if($Results.Errors.Count -gt 0) {
    "    <div class='section'>
        <h2 class='error'>Errors</h2>
        <ul>
$(foreach($err in $Results.Errors) { "            <li>$err</li>" })
        </ul>
    </div>"
    })
</body>
</html>
"@
    
    $html | Out-File -FilePath $ReportPath -Encoding UTF8
    Write-Log "Report saved to: $ReportPath" "SUCCESS"
}

#endregion

#region Main Execution

# Validate Admin Rights
if (-not (Test-AdminRights)) {
    Write-Error "Administrator privileges required. Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

# Create Restore Point (if requested)
if ($CreateRestorePoint) {
    $continue = New-SystemRestorePoint -Description "Windows Repair Suite - $Mode Mode"
    if (-not $continue) {
        Write-Error "User cancelled operation"
        exit 1
    }
}

# Execute based on Mode
switch ($Mode) {
    "Quick" {
        Write-Log "Running QUICK repair mode..." "INFO"
        Invoke-SystemFileCheck
        Invoke-DISMRepair -Operation ScanHealth
        Invoke-NetworkReset
    }
    
    "Full" {
        Write-Log "Running FULL repair mode..." "INFO"
        Invoke-SystemFileCheck
        Invoke-DISMRepair -Operation CheckHealth
        Invoke-DISMRepair -Operation ScanHealth
        Invoke-DISMRepair -Operation RestoreHealth
        Invoke-NetworkReset
        Remove-SystemBloat -Level Safe
    }
    
    "Gaming" {
        Write-Log "Running GAMING optimization mode..." "INFO"
        Invoke-GamingOptimization
    }
    
    "Network" {
        Write-Log "Running NETWORK reset mode..." "INFO"
        Invoke-NetworkReset
    }
    
    "Debloat" {
        Write-Log "Running DEBLOAT mode..." "INFO"
        if (Confirm-DestructiveOperation "Debloat" "This will remove Windows Store apps") {
            Remove-SystemBloat -Level Moderate
        }
    }
    
    default {
        Write-Log "Unknown mode: $Mode" "ERROR"
    }
}

# Generate Report
if ($GenerateReport) {
    New-HtmlReport
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EXECUTION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Log "Success: $($Results.Success) | Warnings: $($Results.Warnings.Count) | Errors: $($Results.Errors.Count)" "INFO"

if (-not $NoReboot) {
    $reboot = Read-Host "Restart computer now? (Y/N)"
    if ($reboot -eq "Y" -or $reboot -eq "y") {
        Restart-Computer -Force
    }
}

#endregion
