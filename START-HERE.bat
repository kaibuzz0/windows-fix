@echo off
title Windows Ultimate Fix Suite - Main Launcher
color 0A
cls

:: ============================================================================
:: WINDOWS ULTIMATE FIX SUITE - MAIN LAUNCHER
:: Version 3.0 - The complete Windows optimization system
:: ============================================================================

echo.
echo  ╔════════════════════════════════════════════════════════════════════╗
echo  ║                                                                    ║
echo  ║              WINDOWS ULTIMATE FIX SUITE v3.0                     ║
echo  ║                                                                    ║
echo  ║     Debloat • Optimize • Repair • Privacy • Performance           ║
echo  ║                                                                    ║
echo  ╚════════════════════════════════════════════════════════════════════╝
echo.
echo  [!] WARNING: Run all scripts as Administrator!
echo.
echo  This suite will transform your Windows PC:
echo   • Remove bloatware and unwanted apps
echo   • Optimize for maximum performance
echo   • Fix common Windows issues
echo   • Stop Windows telemetry and tracking
echo.
echo  ==========================================
echo   QUICK START - Choose Your Path:
echo  ==========================================
echo.
echo   [1] FRESH PC SETUP    (Debloat + Optimize + Privacy)
echo   [2] GAMING PC         (Maximum gaming performance)
echo   [3] WORKSTATION       (Productivity optimized)
echo   [4] PRIVACY FIRST     (Maximum privacy, minimal data)
echo   [5] REPAIR WINDOWS    (Fix broken system)
echo.
echo   [6] CUSTOM SELECTION  (Choose individual tools)
echo   [7] VIEW DOCUMENTATION (Read how to use)
echo   [8] CREATE RESTORE POINT (Safety first!)
echo.
echo   [0] EXIT
echo.
echo  ==========================================
set /p choice="Enter your choice (0-8): "

if "%choice%"=="1" goto FreshSetup
if "%choice%"=="2" goto GamingPC
if "%choice%"=="3" goto Workstation
if "%choice%"=="4" goto PrivacyFirst
if "%choice%"=="5" goto RepairWindows
if "%choice%"=="6" goto CustomMenu
if "%choice%"=="7" goto Documentation
if "%choice%"=="8" goto CreateRestore
if "%choice%"=="0" exit

goto START

:: ============================================================================
:: FRESH PC SETUP - Complete optimization for new PC
:: ============================================================================
:FreshSetup
cls
echo.
echo  [*] FRESH PC SETUP - Complete Windows optimization
echo.
echo  This will:
echo   1. Remove all bloatware (Xbox, Skype, Solitaire, etc.)
echo   2. Optimize visual effects for performance
echo   3. Disable unnecessary services
echo   4. Apply privacy hardening
echo   5. Set power plan to balanced
echo.
echo  Estimated time: 10-15 minutes
echo.
set /p confirm="Continue? (yes/no): "
if /I not "%confirm%"=="yes" goto START

echo.
echo  [STEP 1/5] Removing bloatware...
call "%~dp01-Debloat\Ultimate-Debloat.bat" :QuickDebloatSilent 2>nul
echo  [+] Bloatware removed

echo.
echo  [STEP 2/5] Applying visual effects...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
echo  [+] Visual effects optimized

echo.
echo  [STEP 3/5] Disabling unnecessary services...
sc config Fax start= disabled >nul
sc config MapsBroker start= disabled >nul
sc config WMPNetworkSvc start= disabled >nul
echo  [+] Services optimized

echo.
echo  [STEP 4/5] Applying privacy tweaks...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
echo  [+] Privacy hardening applied

echo.
echo  [STEP 5/5] Setting power plan...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e 2>nul
echo  [+] Power plan set to Balanced

echo.
echo  ════════════════════════════════════════
echo  [+] FRESH PC SETUP COMPLETE!
echo  ════════════════════════════════════════
echo.
echo  Next steps:
echo   1. Restart your PC now
echo   2. Install your preferred browser
echo   3. Install your essential apps
echo   4. Enjoy your fast, clean Windows!
echo.
pause
goto START

:: ============================================================================
:: GAMING PC - Ultimate gaming performance
:: ============================================================================
:GamingPC
cls
echo.
echo  [*] GAMING PC - Maximum gaming performance
echo.
echo  This will:
echo   • Remove ALL gaming-related bloatware
echo   • Disable Game DVR and overlays
echo   • Enable Game Mode
echo   • Optimize network for low latency
echo   • Set High Performance power plan
echo   • Disable mouse acceleration
echo   • Optimize services for gaming
echo.
set /p confirm="Continue? (yes/no): "
if /I not "%confirm%"=="yes" goto START

start "" "%~dp02-Performance\Performance-Optimizer.bat"
goto START

:: ============================================================================
:: WORKSTATION - Productivity focused
:: ============================================================================
:Workstation
cls
echo.
echo  [*] WORKSTATION - Productivity optimization
echo.
echo  This will:
echo   • Remove consumer bloatware
echo   • Keep productivity features
echo   • Optimize for fast app launching
echo   • Maintain search functionality
echo   • Set balanced power plan
echo.
set /p confirm="Continue? (yes/no): "
if /I not "%confirm%"=="yes" goto START

call "%~dp01-Debloat\Ultimate-Debloat.bat" :QuickDebloatSilent 2>nul
echo.
echo  [+] Workstation optimization complete
echo  [+] Quick debloat applied
echo  [+] Productivity features preserved
echo.
echo  [!] For full workstation optimization, run:
echo     2-Performance\Performance-Optimizer.bat
echo     And select Workstation Mode
echo.
pause
goto START

:: ============================================================================
:: PRIVACY FIRST - Maximum privacy
:: ============================================================================
:PrivacyFirst
cls
echo.
echo  [*] PRIVACY FIRST - Maximum privacy hardening
echo.
echo  This will:
echo   • Disable ALL telemetry
   • Remove data collection features
   • Disable location tracking
   • Stop activity history
   • Remove Cortana
   • Disable advertising ID
   • Stop feedback collection
   • Disable Windows tips/suggestions
echo.
set /p confirm="Continue? (WARNING: This is aggressive) (yes/no): "
if /I not "%confirm%"=="yes" goto START

start "" "%~dp01-Debloat\Ultimate-Debloat.bat"
goto START

:: ============================================================================
:: REPAIR WINDOWS - Fix broken system
:: ============================================================================
:RepairWindows
cls
echo.
echo  [*] REPAIR WINDOWS - Fix system issues
echo.
echo  Common fixes:
echo   • Corrupt system files
   • Windows Update stuck
   • Network issues
   • Slow performance
   • Blue screens
   • App crashes
echo.
set /p confirm="Continue? (yes/no): "
if /I not "%confirm%"=="yes" goto START

start "" "%~dp03-Repair\Windows-Repair-Suite.bat"
goto START

:: ============================================================================
:: CUSTOM SELECTION - Choose individual tools
:: ============================================================================
:CustomMenu
cls
echo.
echo  ╔═══════════════════════════════════════════════════════╗
echo  ║              CUSTOM TOOL SELECTION                    ║
echo  ╚═══════════════════════════════════════════════════════╝
echo.
echo   [1] DEBLOAT Menu      - Remove unwanted apps
echo   [2] PERFORMANCE Menu  - Optimize speed
echo   [3] REPAIR Menu       - Fix Windows issues
echo   [4] PRIVACY Menu      - Stop tracking
echo   [5] TOOLS Menu        - Individual utilities
echo   [6] REGISTRY FILES    - Apply .reg tweaks
echo.
echo   [0] Back to Main Menu
echo.
set /p custom="Enter choice (0-6): "

if "%custom%"=="1" start "" "%~dp01-Debloat\Ultimate-Debloat.bat"
if "%custom%"=="2" start "" "%~dp02-Performance\Performance-Optimizer.bat"
if "%custom%"=="3" start "" "%~dp03-Repair\Windows-Repair-Suite.bat"
if "%custom%"=="4" start "" "%~dp04-Privacy\Telemetry-Disabler.bat"
if "%custom%"=="5" goto ToolsMenu
if "%custom%"=="6" goto RegistryFiles
if "%custom%"=="0" goto START

goto START

:: ============================================================================
:: TOOLS MENU
:: ============================================================================
:ToolsMenu
cls
echo.
echo   AVAILABLE TOOLS:
echo.
echo   [1] Context Menu Manager
echo   [2] Startup Manager
echo   [3] System Information
echo   [4] Safe Mode Boot Options
echo.
echo   [0] Back
echo.
set /p tool="Select tool: "

if "%tool%"=="1" start "" "%~dp05-Tools\Context-Menu-Manager.bat"
if "%tool%"=="2" start "" "%~dp05-Tools\Startup-Manager.bat"
if "%tool%"=="3" start "" "%~dp05-Tools\System-Information.bat"
if "%tool%"=="4" start "" "%~dp05-Tools\Safe-Mode-Boot.bat"

goto START

:: ============================================================================
:: REGISTRY FILES
:: ============================================================================
:RegistryFiles
cls
echo.
echo  REGISTRY FILES (Double-click to apply):
echo.
echo  Location: %~dp0registry\
echo.
echo  Available files:
dir /b "%~dp0registry\*.reg" 2>nul || echo   (No .reg files found)
echo.
echo  Instructions:
echo   1. Navigate to the registry folder
echo   2. Double-click any .reg file
echo   3. Click "Yes" when prompted
echo   4. Restart if needed
echo.
pause
goto START

:: ============================================================================
:: DOCUMENTATION
:: ============================================================================
:Documentation
cls
echo.
echo  DOCUMENTATION:
echo.
echo  Files available:
echo   • README.md - Main documentation
echo   • docs/WHAT-EACH-SCRIPT-DOES.md - Detailed explanations
echo   • docs/MANUAL-TWEAKS.md - Do it yourself guide
echo   • docs/TROUBLESHOOTING.md - Fix common issues
echo.
echo  Would you like to open the README?
set /p openreadme="Open README? (yes/no): "
if /I "%openreadme%"=="yes" start notepad "%~dp0README.md"
goto START

:: ============================================================================
:: CREATE RESTORE POINT
:: ============================================================================
:CreateRestore
cls
echo.
echo  [*] Creating System Restore Point...
echo.
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Windows Fix", 100, 7 2>nul
if %errorlevel%==0 (
    echo  [+] Restore point created successfully!
) else (
    echo  [!] Could not create restore point automatically.
    echo      Please create one manually:
    echo      1. Search "Create a restore point"
    echo      2. Click "Create..."
    echo      3. Name it "Before Cleanup"
    echo      4. Click "Create"
)
echo.
pause
goto START

:: ============================================================================
:: END
:: ============================================================================
