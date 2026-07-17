@echo off
title Windows Performance Optimizer - Maximum Speed
color 0A
setlocal EnableDelayedExpansion

:: ============================================================================
:: WINDOWS PERFORMANCE OPTIMIZER
:: Maximizes Windows speed by optimizing services, visual effects, and settings
:: For Windows 10/11 - Run as Administrator!
:: ============================================================================

echo.
echo  ========================================
echo   WINDOWS PERFORMANCE OPTIMIZER
echo   Maximum Speed & Responsiveness
echo  ========================================
echo.
echo  [!] Optimizes for performance over appearance
echo  [!] Recommended for gaming and workstations
echo.
pause

:MainMenu
cls
echo  ========================================
echo   PERFORMANCE OPTIMIZER
echo  ========================================
echo.
echo   [1] GAMING MODE - Ultimate gaming performance
echo   [2] WORKSTATION MODE - Productivity focused
echo   [3] BALANCED MODE - Good performance, keep some features
echo   [4] CUSTOM OPTIMIZATION - Choose what to optimize
echo   [5] SERVICE OPTIMIZER - Disable unnecessary services
echo   [6] VISUAL EFFECTS - Adjust for speed
echo   [7] POWER SETTINGS - Maximize performance
echo   [8] MEMORY OPTIMIZATION - RAM tweaks
echo   [9] NETWORK OPTIMIZATION - Low latency
echo.
echo   [0] EXIT
echo.
echo  ========================================
set /p choice="Enter choice (0-9): "

if "%choice%"=="1" goto GamingMode
if "%choice%"=="2" goto WorkstationMode
if "%choice%"=="3" goto BalancedMode
if "%choice%"=="4" goto CustomOptimization
if "%choice%"=="5" goto ServiceOptimizer
if "%choice%"=="6" goto VisualEffects
if "%choice%"=="7" goto PowerSettings
if "%choice%"=="8" goto MemoryOptimization
if "%choice%"=="9" goto NetworkOptimization
if "%choice%"=="0" exit

goto MainMenu

:: ============================================================================
:: GAMING MODE - Ultimate performance for gaming
:: ============================================================================
:GamingMode
cls
echo  [*] Applying GAMING MODE optimizations...
echo  [*] Maximum performance, minimal background tasks
echo.

:: Visual Effects
echo  [-] Setting visual effects to performance...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul

:: Disable Game DVR / Xbox Game Bar completely
echo  [-] Disabling Game DVR and Game Bar...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul

:: Enable Game Mode
echo  [-] Enabling Game Mode...
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul

:: Disable fullscreen optimizations
echo  [-] Disabling fullscreen optimizations...
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul

:: Set power plan to high performance
echo  [-] Setting power plan to High Performance...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>nul || powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>nul

:: Disable HPET (High Precision Event Timer) - requires reboot
echo  [-] HPET tweak available (requires reboot to take effect)
echo      Run this in Device Manager: Disable High Precision Event Timer

:: Network tweaks for gaming
echo  [-] Optimizing network for low latency...
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global rss=enabled >nul

:: Disable Nagle's Algorithm
echo  [-] Disabling Nagle's Algorithm for lower latency...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul

:: Disable Windows Search indexing during gaming
echo  [-] Adjusting Windows Search...
sc config WSearch start= disabled >nul

:: Disable Superfetch/SysMain (can cause stuttering in games for some)
echo  [-] Disabling SysMain (Superfetch)...
sc config SysMain start= disabled >nul

:: Priority tweaks
echo  [-] Setting Win32PrioritySeparation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul

:: Disable Windows Defender real-time protection during gaming (manual toggle available)
echo  [-] Adding option to disable Windows Defender (requires manual toggle)...
echo      Use Group Policy or Settings > Update & Security > Windows Security

:: Mouse acceleration off
echo  [-] Disabling mouse acceleration...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul

echo.
echo  [+] GAMING MODE Applied!
echo  [+] System optimized for maximum gaming performance
echo  [!] Restart recommended
echo.
pause
goto MainMenu

:: ============================================================================
:: WORKSTATION MODE - Productivity focused
:: ============================================================================
:WorkstationMode
cls
echo  [*] Applying WORKSTATION MODE optimizations...
echo  [*] Fast application launching, good multitasking
echo.

:: Visual Effects - Balanced
echo  [-] Setting visual effects to balanced...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul

:: Power plan - Balanced
echo  [-] Setting power plan to Balanced...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>nul

:: Disable unnecessary animations
echo  [-] Disabling unnecessary animations...
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul

:: Keep Superfetch for app launching
echo  [-] Keeping Superfetch for fast app launching...
sc config SysMain start= auto >nul

:: Enable Windows Search
echo  [-] Enabling Windows Search for fast file finding...
sc config WSearch start= auto >nul

echo.
echo  [+] WORKSTATION MODE Applied!
echo  [+] Good balance of performance and features
echo.
pause
goto MainMenu

:: ============================================================================
:: BALANCED MODE - Good performance, keep features
:: ============================================================================
:BalancedMode
cls
echo  [*] Applying BALANCED MODE optimizations...
echo.

:: Set visual effects to "Let Windows choose"
echo  [-] Setting visual effects to automatic...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f >nul

:: Balanced power plan
echo  [-] Setting balanced power plan...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>nul

:: Basic service tweaks
echo  [-] Applying basic service optimizations...
sc config Fax start= disabled >nul
sc config MapsBroker start= disabled >nul
sc config WMPNetworkSvc start= disabled >nul

echo.
echo  [+] BALANCED MODE Applied!
echo  [+] Performance improved while keeping features
echo.
pause
goto MainMenu

:: ============================================================================
:: SERVICE OPTIMIZER - Disable unnecessary services
:: ============================================================================
:ServiceOptimizer
cls
echo  [*] SERVICE OPTIMIZER
echo  [*] Disabling unnecessary Windows services
echo.
echo  [!] This will disable services that most users don't need
echo  [!] Review the list before confirming
echo.
set /p confirm="Continue? (yes/no): "
if /I not "%confirm%"=="yes" goto MainMenu

echo.
echo  [*] Disabling unnecessary services...

:: Print services (if you don't use printers)
echo  [-] Disabling print services...
sc config Spooler start= disabled >nul

:: Fax
echo  [-] Disabling Fax service...
sc config Fax start= disabled >nul

:: Windows Search (optional - disable if you don't search files often)
echo  [-] Disabling Windows Search (optional)...
sc config WSearch start= disabled >nul

:: Superfetch/SysMain
echo  [-] Disabling SysMain...
sc config SysMain start= disabled >nul

:: Maps
echo  [-] Disabling Maps services...
sc config MapsBroker start= disabled >nul

:: Windows Media Player network sharing
echo  [-] Disabling WMP Network Sharing...
sc config WMPNetworkSvc start= disabled >nul

:: Bluetooth (if not using Bluetooth)
echo  [-] Disabling Bluetooth services (optional)...
sc config bthserv start= disabled >nul

:: Remote Registry
echo  [-] Disabling Remote Registry...
sc config RemoteRegistry start= disabled >nul

:: Secondary Logon
echo  [-] Disabling Secondary Logon...
sc config seclogon start= disabled >nul

:: Tablet PC Input (if not using tablet)
echo  [-] Disabling Tablet Input...
sc config TabletInputService start= disabled >nul

:: Windows Error Reporting
echo  [-] Disabling Windows Error Reporting...
sc config WerSvc start= disabled >nul

:: Diagnostic Policy Service
echo  [-] Disabling Diagnostics...
sc config DPS start= disabled >nul
sc config WdiServiceHost start= disabled >nul
sc config WdiSystemHost start= disabled >nul

:: Retail Demo (definitely don't need this)
echo  [-] Disabling Retail Demo...
sc config RetailDemo start= disabled >nul

:: Wallet (Windows payments)
echo  [-] Disabling Wallet...
sc config WalletService start= disabled >nul

echo.
echo  [+] Services Optimized!
echo  [+] Unnecessary services disabled
echo  [!] Restart to take full effect
echo.
pause
goto MainMenu

:: ============================================================================
:: VISUAL EFFECTS - Adjust for speed
:: ============================================================================
:VisualEffects
cls
echo  [*] VISUAL EFFECTS OPTIMIZER
echo.
echo   [1] MAXIMUM PERFORMANCE - Disable all effects
echo   [2] BALANCED - Keep some effects
echo   [3] CUSTOM - Choose individually
echo   [4] RESTORE DEFAULTS
echo.
set /p vechoice="Choice (1-4): "

if "%vechoice%"=="1" (
    echo  [-] Setting maximum performance...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
    reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul
    reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul
    echo  [+] Maximum performance applied
)

if "%vechoice%"=="2" (
    echo  [-] Setting balanced visual effects...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul
    echo  [+] Balanced settings applied
)

if "%vechoice%"=="4" (
    echo  [-] Restoring defaults...
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f >nul
    echo  [+] Defaults restored
)

echo.
pause
goto MainMenu

:: ============================================================================
:: POWER SETTINGS - Maximize performance
:: ============================================================================
:PowerSettings
cls
echo  [*] POWER SETTINGS OPTIMIZER
echo.
echo   [1] HIGH PERFORMANCE - Maximum power, fans may run louder
echo   [2] BALANCED - Good performance with power saving
echo   [3] ULTIMATE PERFORMANCE - Hidden Windows plan (desktop only)
echo   [4] AMD RYZEN BALANCED - For AMD Ryzen CPUs
echo.
set /p pschoice="Choice (1-4): "

if "%pschoice%"=="1" (
    echo  [-] Activating High Performance plan...
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>nul
    echo  [+] High Performance activated
)

if "%pschoice%"=="2" (
    echo  [-] Activating Balanced plan...
    powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>nul
    echo  [+] Balanced activated
)

if "%pschoice%"=="3" (
    echo  [-] Activating Ultimate Performance plan...
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
    echo  [+] Ultimate Performance activated
    echo  [!] Only available on some Windows versions
)

if "%pschoice%"=="4" (
    echo  [-] AMD Ryzen Balanced plan...
    echo  [!] Install AMD chipset drivers first
    powercfg /setactive 9897998c-92de-4669-8f31-c9ab9d1c4b8b 2>nul || echo Plan not found
)

echo.
pause
goto MainMenu

:: ============================================================================
:: MEMORY OPTIMIZATION - RAM tweaks
:: ============================================================================
:MemoryOptimization
cls
echo  [*] MEMORY OPTIMIZATION
echo.

:: Disable memory compression (Windows 10/11)
echo  [-] Disabling memory compression...
powershell -Command "Disable-MMAgent -mc" 2>nul

:: Clear standby list
echo  [-] Adding clear standby list to context menu...
reg add "HKCR\Directory\Background\shell\Clear Memory Standby List" /ve /t REG_SZ /d "Clear Memory Standby List" /f >nul
reg add "HKCR\Directory\Background\shell\Clear Memory Standby List\command" /ve /t REG_SZ /d "powershell -Command \"\$Process = Get-Process rammap64 -ErrorAction SilentlyContinue; if (!\$Process) { Start-Process rammap64 -ArgumentList '-Ew' }\"" /f >nul

:: Large system cache (for workstations with lots of RAM)
echo  [-] Optimizing system cache...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul

echo.
echo  [+] Memory optimizations applied
echo.
pause
goto MainMenu

:: ============================================================================
:: NETWORK OPTIMIZATION - Low latency
:: ============================================================================
:NetworkOptimization
cls
echo  [*] NETWORK OPTIMIZATION
echo.

:: Disable autotuning
echo  [-] Optimizing TCP settings...
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global netdma=enabled >nul

:: Disable network throttling
echo  [-] Disabling network throttling...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul

:: System responsiveness for games
echo  [-] Setting system responsiveness...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 10 /f >nul

:: Gaming scheduling
echo  [-] Enabling gaming scheduling...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 2710 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul

echo.
echo  [+] Network optimized for low latency
echo.
pause
goto MainMenu

:: ============================================================================
:: CUSTOM OPTIMIZATION (placeholder)
:: ============================================================================
:CustomOptimization
echo.
echo  [Use individual menu options for custom optimization]
echo.
pause
goto MainMenu
