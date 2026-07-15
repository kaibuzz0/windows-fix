@echo off
title Windows Repair Suite - Complete System Maintenance Toolkit
color 0A
setlocal EnableDelayedExpansion

:: ============================================================================
:: WINDOWS REPAIR SUITE v2.0
:: Comprehensive Windows maintenance, repair, and optimization toolkit
:: Created for Monday's Players - Organized by category
:: ============================================================================

call :CheckAdmin
call :ShowBanner

:MainMenu
cls
call :ShowBanner
echo.
echo  MAIN MENU - Select Category:
echo  ========================================
echo.
echo   [1] SYSTEM REPAIRS       - SFC, DISM, Component Store
echo   [2] PERFORMANCE TWEAKS   - Speed, memory, startup optimization  
echo   [3] NETWORK FIXES        - Reset TCP/IP, DNS, Winsock
echo   [4] SECURITY TOOLS       - Defender, firewall, malware scans
echo   [5] MAINTENANCE TOOLS    - Cleanup, defrag, disk check
echo   [6] REGISTRY TOOLS       - Backup, restore, tweaks
echo   [7] DIAGNOSTICS          - System info, health checks
echo   [8] SERVICE MANAGEMENT   - Default services, optimizations
echo   [9] ALL-IN-ONE REPAIR    - Run complete maintenance cycle
echo.
echo   [0] EXIT
echo.
echo  ========================================
set /p choice="Enter choice (0-9): "

if "%choice%"=="1" goto SystemRepairs
if "%choice%"=="2" goto PerformanceMenu
if "%choice%"=="3" goto NetworkMenu
if "%choice%"=="4" goto SecurityMenu
if "%choice%"=="5" goto MaintenanceMenu
if "%choice%"=="6" goto RegistryMenu
if "%choice%"=="7" goto DiagnosticsMenu
if "%choice%"=="8" goto ServiceMenu
if "%choice%"=="9" goto AllInOneRepair
if "%choice%"=="0" goto End

goto MainMenu

:: ============================================================================
:: SYSTEM REPAIRS
:: ============================================================================
:SystemRepairs
cls
call :ShowBanner
echo  SYSTEM REPAIRS
echo  ========================================
echo.
echo   [1] Run SFC /scannow (System File Checker)
echo   [2] Run DISM ScanHealth
echo   [3] Run DISM RestoreHealth
echo   [4] Run DISM CheckHealth
echo   [5] Fix Windows Update Components
echo   [6] Reset Windows Store Cache
echo   [7] Repair System Image (Complete)
echo   [8] Check Disk (chkdsk on next boot)
echo   [9] Return to Main Menu
echo.
set /p syschoice="Enter choice: "

if "%syschoice%"=="1" (
    echo Running SFC /scannow...
    sfc /scannow
    pause
)
if "%syschoice%"=="2" (
    echo Running DISM ScanHealth...
    DISM /Online /Cleanup-Image /ScanHealth
    pause
)
if "%syschoice%"=="3" (
    echo Running DISM RestoreHealth...
    DISM /Online /Cleanup-Image /RestoreHealth
    pause
)
if "%syschoice%"=="4" (
    echo Running DISM CheckHealth...
    DISM /Online /Cleanup-Image /CheckHealth
    pause
)
if "%syschoice%"=="5" call :ResetWindowsUpdate
if "%syschoice%"=="6" (
    echo Resetting Windows Store...
    wsreset.exe
    pause
)
if "%syschoice%"=="7" call :CompleteSystemRepair
if "%syschoice%"=="8" (
    echo Scheduling chkdsk on next reboot...
    chkdsk /f /r
    echo Reboot required. Schedule now? (Y/N)
    set /p rebootnow=
    if /i "!rebootnow!"=="Y" shutdown /r /t 60 /c "Chkdsk scheduled"
    pause
)
if "%syschoice%"=="9" goto MainMenu

goto SystemRepairs

:: ============================================================================
:: PERFORMANCE MENU
:: ============================================================================
:PerformanceMenu
cls
call :ShowBanner
echo  PERFORMANCE OPTIMIZATION
echo  ========================================
echo.
echo   [1] Apply Performance Registry Tweaks
echo   [2] Disable Unnecessary Startup Programs
echo   [3] Optimize Visual Effects
echo   [4] Enable Fast Startup
echo   [5] Optimize Power Plan (High Performance)
echo   [6] Disable Services (Safe optimization)
echo   [7] Clear Temp Files
echo   [8] Memory Optimization
echo   [9] Superfetch/SysMain Configuration
echo  [10] Return to Main Menu
echo.
set /p perfchoice="Enter choice: "

if "%perfchoice%"=="1" call :ApplyPerfTweaks
if "%perfchoice%"=="2" (
    echo Opening Startup folder and Task Manager...
    start shell:startup
    start taskmgr
    pause
)
if "%perfchoice%"=="3" (
    echo Opening Performance Options...
    SystemPropertiesPerformance
    pause
)
if "%perfchoice%"=="4" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
    echo Fast startup enabled.
    pause
)
if "%perfchoice%"=="5" (
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo High Performance power plan activated.
    pause
)
if "%perfchoice%"=="6" call :OptimizeServices
if "%perfchoice%"=="7" call :ClearTempFiles
if "%perfchoice%"=="8" (
    echo Running memory diagnostic...
    mdsched.exe
    pause
)
if "%perfchoice%"=="9" (
    echo Configuring SysMain (Superfetch)...
    sc config SysMain start=auto
    net start SysMain
    echo SysMain enabled and started.
    pause
)
if "%perfchoice%"=="10" goto MainMenu

goto PerformanceMenu

:: ============================================================================
:: NETWORK MENU
:: ============================================================================
:NetworkMenu
cls
call :ShowBanner
echo  NETWORK REPAIRS
echo  ========================================
echo.
echo   [1] Complete Network Reset (All)
echo   [2] Reset TCP/IP Stack
echo   [3] Flush DNS Cache
echo   [4] Reset Winsock
echo   [5] Release and Renew IP
echo   [6] Reset Network Settings (Windows 10/11)
echo   [7] Network Adapter Troubleshooter
echo   [8] Show Network Configuration
echo   [9] Ping Test (Google DNS)
echo  [10] Return to Main Menu
echo.
set /p netchoice="Enter choice: "

if "%netchoice%"=="1" call :CompleteNetworkReset
if "%netchoice%"=="2" (
    echo Resetting TCP/IP...
    netsh int ip reset
    pause
)
if "%netchoice%"=="3" (
    echo Flushing DNS...
    ipconfig /flushdns
    echo DNS cache cleared.
    pause
)
if "%netchoice%"=="4" (
    echo Resetting Winsock...
    netsh winsock reset
    echo Winsock reset. Reboot required.
    pause
)
if "%netchoice%"=="5" (
    echo Releasing and renewing IP...
    ipconfig /release
    ipconfig /renew
    pause
)
if "%netchoice%"=="6" (
    echo Opening Network Reset...
    start ms-settings:network-status
    pause
)
if "%netchoice%"=="7" (
    echo Opening Network Adapter settings...
    ncpa.cpl
    pause
)
if "%netchoice%"=="8" (
    ipconfig /all
    pause
)
if "%netchoice%"=="9" (
    ping 8.8.8.8 -t
    pause
)
if "%netchoice%"=="10" goto MainMenu

goto NetworkMenu

:: ============================================================================
:: SECURITY MENU
:: ============================================================================
:SecurityMenu
cls
call :ShowBanner
echo  SECURITY TOOLS
echo  ========================================
echo.
echo   [1] Run Windows Defender Quick Scan
echo   [2] Run Windows Defender Full Scan
echo   [3] Update Defender Definitions
echo   [4] Check Firewall Status
echo   [5] Reset Firewall to Defaults
echo   [6] Check for Windows Updates
echo   [7] Enable Real-time Protection
echo   [8] Windows Security Center
echo   [9] Malicious Software Removal Tool
echo  [10] Return to Main Menu
echo.
set /p secchoice="Enter choice: "

if "%secchoice%"=="1" (
    echo Starting Quick Scan...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    pause
)
if "%secchoice%"=="2" (
    echo Starting Full Scan...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    pause
)
if "%secchoice%"=="3" (
    echo Updating definitions...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    pause
)
if "%secchoice%"=="4" (
    netsh advfirewall show currentprofile
    pause
)
if "%secchoice%"=="5" (
    echo Resetting firewall...
    netsh advfirewall reset
    pause
)
if "%secchoice%"=="6" (
    start ms-settings:windowsupdate
    pause
)
if "%secchoice%"=="7" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f
    echo Real-time protection enabled.
    pause
)
if "%secchoice%"=="8" (
    start windowsdefender:
    pause
)
if "%secchoice%"=="9" (
    echo Running MSRT...
    mrt.exe
    pause
)
if "%secchoice%"=="10" goto MainMenu

goto SecurityMenu

:: ============================================================================
:: MAINTENANCE MENU
:: ============================================================================
:MaintenanceMenu
cls
call :ShowBanner
echo  MAINTENANCE TOOLS
echo  ========================================
echo.
echo   [1] Disk Cleanup (cleanmgr)
echo   [2] Analyze Disk (defrag)
echo   [3] Clear All Temp Folders
echo   [4] Clear Event Logs
echo   [5] Empty Recycle Bin
echo   [6] Clean Browser Cache
echo   [7] System Restore Point
echo   [8] Component Cleanup (WinSxS)
echo   [9] Schedule Maintenance
echo  [10] Return to Main Menu
echo.
set /p maintchoice="Enter choice: "

if "%maintchoice%"=="1" (
    start cleanmgr /sagerun:1
    pause
)
if "%maintchoice%"=="2" (
    echo Analyzing disk...
    defrag /C /A
    pause
)
if "%maintchoice%"=="3" call :ClearTempFiles
if "%maintchoice%"=="4" (
    echo Clearing Event Logs...
    for /f "tokens=*" %%a in ('wevtutil el') do wevtutil cl "%%a" 2>nul
    echo Event logs cleared.
    pause
)
if "%maintchoice%"=="5" (
    rd /s /q %systemdrive%\$Recycle.Bin 2>nul
    echo Recycle bin emptied.
    pause
)
if "%maintchoice%"=="6" (
    echo Clearing browser caches...
    rd /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache" 2>nul
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
    rd /s /q "%APPDATA%\Mozilla\Firefox\Profiles\*\cache2" 2>nul
    echo Browser caches cleared.
    pause
)
if "%maintchoice%"=="7" (
    echo Creating restore point...
    wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="Windows Repair Suite", Description="Before running repair suite", RestorePointType=12
    pause
)
if "%maintchoice%"=="8" (
    echo Cleaning WinSxS folder...
    DISM /Online /Cleanup-Image /StartComponentCleanup
    DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
    pause
)
if "%maintchoice%"=="9" (
    echo Scheduling automatic maintenance...
    schtasks /create /tn "WindowsRepairMaintenance" /tr "%~dp0Windows-Repair-Suite.bat /auto" /sc weekly /d SUN /st 02:00 /ru SYSTEM
    pause
)
if "%maintchoice%"=="10" goto MainMenu

goto MaintenanceMenu

:: ============================================================================
:: REGISTRY MENU
:: ============================================================================
:RegistryMenu
cls
call :ShowBanner
echo  REGISTRY TOOLS
echo  ========================================
echo.
echo   [1] Backup Registry
echo   [2] Apply Fast Indexing Tweaks
echo   [3] Apply Performance Tweaks
echo   [4] Apply Context Menu Tweaks (Copy To/Move To)
echo   [5] Restore Default Services
echo   [6] Apply Gaming Optimizations
echo   [7] Apply Privacy Tweaks
echo   [8] Clean Registry (CCleaner style)
echo   [9] Import Custom Registry File
echo  [10] Return to Main Menu
echo.
set /p regchoice="Enter choice: "

if "%regchoice%"=="1" (
    echo Backing up registry...
    set backupdir=%USERPROFILE%\Documents\RegistryBackups
    if not exist "!backupdir!" mkdir "!backupdir!"
    reg export HKLM\SOFTWARE "!backupdir!\HKLM_SOFTWARE_%date:~-4,4%%date:~-10,2%%date:~-7,2%.reg"
    reg export HKCU\SOFTWARE "!backupdir!\HKCU_SOFTWARE_%date:~-4,4%%date:~-10,2%%date:~-7,2%.reg"
    echo Registry backed up to !backupdir!
    pause
)
if "%regchoice%"=="2" (
    regedit /s "%~dp0registry\Indexing-Fast.reg"
    net stop WSearch 2>nul
    net start WSearch 2>nul
    echo Fast indexing applied.
    pause
)
if "%regchoice%"=="3" (
    regedit /s "%~dp0registry\Performance-Tweaks.reg"
    echo Performance tweaks applied.
    pause
)
if "%regchoice%"=="4" (
    regedit /s "%~dp0registry\Context-Menu-Tweaks.reg"
    echo Context menu tweaks applied.
    pause
)
if "%regchoice%"=="5" (
    regedit /s "%~dp0registry\Default-Services.reg"
    echo Default services restored. Reboot required.
    pause
)
if "%regchoice%"=="6" (
    regedit /s "%~dp0registry\Gaming-Optimizations.reg"
    echo Gaming optimizations applied.
    pause
)
if "%regchoice%"=="7" (
    regedit /s "%~dp0registry\Privacy-Tweaks.reg"
    echo Privacy tweaks applied.
    pause
)
if "%regchoice%"=="8" (
    echo Opening Registry Cleaner...
    echo Use third-party tool or PowerShell script.
    pause
)
if "%regchoice%"=="9" (
    set /p regfile="Enter path to .reg file: "
    if exist "!regfile!" (
        regedit /s "!regfile!"
        echo Registry file imported.
    ) else (
        echo File not found.
    )
    pause
)
if "%regchoice%"=="10" goto MainMenu

goto RegistryMenu

:: ============================================================================
:: DIAGNOSTICS MENU
:: ============================================================================
:DiagnosticsMenu
cls
call :ShowBanner
echo  DIAGNOSTICS
echo  ========================================
echo.
echo   [1] System Information
echo   [2] Check Disk Health
echo   [3] Memory Diagnostics
echo   [4] Battery Report (laptops)
echo   [5] Generate Health Report
echo   [6] View Event Logs
echo   [7] Performance Monitor
echo   [8] Resource Monitor
echo   [9] DirectX Diagnostic Tool
echo  [10] Return to Main Menu
echo.
set /p diagchoice="Enter choice: "

if "%diagchoice%"=="1" (
    systeminfo | more
    pause
)
if "%diagchoice%"=="2" (
    wmic diskdrive get status,model,size
    pause
)
if "%diagchoice%"=="3" (
    mdsched.exe
    pause
)
if "%diagchoice%"=="4" (
    powercfg /batteryreport
    start battery-report.html
    pause
)
if "%diagchoice%"=="5" (
    echo Generating health report...
    mkdir "%USERPROFILE%\Documents\SystemReports" 2>nul
    systeminfo > "%USERPROFILE%\Documents\SystemReports\systeminfo_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
    ipconfig /all >> "%USERPROFILE%\Documents\SystemReports\systeminfo_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
    netsh advfirewall show currentprofile >> "%USERPROFILE%\Documents\SystemReports\systeminfo_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt"
    echo Report saved to Documents\SystemReports\
    pause
)
if "%diagchoice%"=="6" (
    start eventvwr
    pause
)
if "%diagchoice%"=="7" (
    start perfmon
    pause
)
if "%diagchoice%"=="8" (
    start resmon
    pause
)
if "%diagchoice%"=="9" (
    dxdiag
    pause
)
if "%diagchoice%"=="10" goto MainMenu

goto DiagnosticsMenu

:: ============================================================================
:: SERVICE MENU
:: ============================================================================
:ServiceMenu
cls
call :ShowBanner
echo  SERVICE MANAGEMENT
echo  ========================================
echo.
echo   [1] View Running Services
echo   [2] Restore Default Windows 10 Services
echo   [3] Restore Default Windows 11 Services
echo   [4] Disable Unnecessary Services (Safe)
echo   [5] Optimize for Gaming
echo   [6] Optimize for Productivity
echo   [7] Enable Windows Update
echo   [8] Disable Windows Update
echo   [9] Open Services Manager
echo  [10] Return to Main Menu
echo.
set /p svcchoice="Enter choice: "

if "%svcchoice%"=="1" (
    sc query type=service state=running | more
    pause
)
if "%svcchoice%"=="2" (
    regedit /s "%~dp0registry\Default-Services-Win10.reg"
    echo Windows 10 default services restored.
    pause
)
if "%svcchoice%"=="3" (
    regedit /s "%~dp0registry\Default-Services-Win11.reg"
    echo Windows 11 default services restored.
    pause
)
if "%svcchoice%"=="4" (
    call :DisableUnnecessaryServices
    pause
)
if "%svcchoice%"=="5" (
    call :GamingServiceOptimizations
    pause
)
if "%svcchoice%"=="6" (
    call :ProductivityServiceOptimizations
    pause
)
if "%svcchoice%"=="7" (
    sc config wuauserv start=delayed-auto
    net start wuauserv
    echo Windows Update enabled.
    pause
)
if "%svcchoice%"=="8" (
    net stop wuauserv
    sc config wuauserv start=disabled
    echo Windows Update disabled.
    pause
)
if "%svcchoice%"=="9" (
    services.msc
    pause
)
if "%svcchoice%"=="10" goto MainMenu

goto ServiceMenu

:: ============================================================================
:: ALL-IN-ONE REPAIR
:: ============================================================================
:AllInOneRepair
cls
call :ShowBanner
echo  ALL-IN-ONE COMPLETE REPAIR
echo  ========================================
echo.
echo  This will run a comprehensive repair cycle.
echo  Estimated time: 30-60 minutes
echo.
pause

echo [%time%] Creating restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="AllInOne Repair", RestorePointType=12 2>nul

echo [%time%] Step 1/10 - Stopping services...
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc

echo [%time%] Step 2/10 - Clearing temp files...
call :ClearTempFilesSilent

echo [%time%] Step 3/10 - SFC Scan...
sfc /scannow

echo [%time%] Step 4/10 - DISM ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth

echo [%time%] Step 5/10 - DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth

echo [%time%] Step 6/10 - Network reset...
netsh winsock reset
netsh int ip reset
ipconfig /flushdns

echo [%time%] Step 7/10 - Component cleanup...
DISM /Online /Cleanup-Image /StartComponentCleanup

echo [%time%] Step 8/10 - Re-registering DLLs...
call :ReRegisterDLLs

echo [%time%] Step 9/10 - Restarting services...
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

echo [%time%] Step 10/10 - Final cleanup...
call :ClearTempFilesSilent

echo.
echo ========================================
echo  REPAIR CYCLE COMPLETE!
echo ========================================
echo.
echo  A reboot is REQUIRED for changes to take effect.
echo.
set /p rebootnow="Reboot now? (Y/N): "
if /i "%rebootnow%"=="Y" shutdown /r /t 30 /c "Windows Repair Complete"
goto MainMenu

:: ============================================================================
:: HELPER FUNCTIONS
:: ============================================================================

:ShowBanner
echo.
echo  ===============================================
echo   WINDOWS REPAIR SUITE v2.0
echo   Complete System Maintenance Toolkit
echo   Monday's Players Edition
echo  ===============================================
echo.
goto :eof

:CheckAdmin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Administrator privileges required!
    echo Right-click and Run as Administrator.
    pause
    exit /b 1
)
goto :eof

:ResetWindowsUpdate
echo Stopping Windows Update services...
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc

echo Deleting update files...
rd /s /q %systemroot%\SoftwareDistribution 2>nul
rd /s /q %systemroot%\system32\catroot2 2>nul

echo Restarting services...
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

echo Windows Update components reset.
goto :eof

:CompleteSystemRepair
echo Running complete system repair...
sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /StartComponentCleanup
echo System repair complete.
goto :eof

:CompleteNetworkReset
echo Performing complete network reset...
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
netsh advfirewall reset
echo Network reset complete. Reboot required.
goto :eof

:ClearTempFiles
echo Clearing temporary files...
rd /s /q %TEMP% 2>nul
rd /s /q %systemroot%\Temp 2>nul
rd /s /q %systemroot%\Prefetch 2>nul
cleanmgr /sagerun:1
echo Temporary files cleared.
goto :eof

:ClearTempFilesSilent
rd /s /q %TEMP% 2>nul
rd /s /q %systemroot%\Temp 2>nul
rd /s /q %systemroot%\Prefetch 2>nul
goto :eof

:ApplyPerfTweaks
echo Applying performance tweaks...
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 8 /f
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f
echo Performance tweaks applied.
goto :eof

:OptimizeServices
echo Optimizing services (safe settings)...
sc config diagtrack start=disabled
sc config dmwappushservice start=disabled
sc config MapsBroker start=disabled
sc config lfsvc start=disabled
sc config SharedAccess start=disabled
sc config WbioSrvc start=disabled
sc config WMPNetworkSvc start=disabled
echo Services optimized.
goto :eof

:DisableUnnecessaryServices
echo Disabling unnecessary services...
sc config Fax start=disabled
sc config XblAuthManager start=disabled
sc config XblGameSave start=disabled
sc config XboxNetApiSvc start=disabled
sc config XboxGipSvc start=disabled
sc config CDPUserSvc start=disabled
sc config OneSyncSvc start=disabled
sc config PcaSvc start=disabled
echo Unnecessary services disabled.
goto :eof

:GamingServiceOptimizations
echo Optimizing services for gaming...
sc config SysMain start=auto
sc config WSearch start=disabled
sc config WMPNetworkSvc start=disabled
sc config WalletService start=disabled
sc config diagnosticshub.standardcollector.service start=disabled
sc config WerSvc start=disabled
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
echo Gaming optimizations applied.
goto :eof

:ProductivityServiceOptimizations
echo Optimizing services for productivity...
sc config SysMain start=auto
sc config WSearch start=delayed-auto
sc config BITS start=delayed-auto
sc config wuauserv start=delayed-auto
echo Productivity optimizations applied.
goto :eof

:ReRegisterDLLs
echo Re-registering system DLLs...
regsvr32 /s actxprxy.dll
regsvr32 /s browseui.dll
regsvr32 /s jscript.dll
regsvr32 /s mshtml.dll
regsvr32 /s shdocvw.dll
regsvr32 /s shell32.dll
regsvr32 /s urlmon.dll
regsvr32 /s vbscript.dll
regsvr32 /s wininet.dll
regsvr32 /s atl.dll
echo DLLs re-registered.
goto :eof

:End
echo.
echo Thank you for using Windows Repair Suite!
echo.
pause
exit /b 0