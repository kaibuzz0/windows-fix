@echo off
title Security Quick Scan
color 0C
cls

echo ===============================================
echo   SECURITY QUICK SCAN TOOL
echo   Defender and Security Checks
echo ===============================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Run as Administrator required!
    pause
    exit /b 1
)

:Menu
cls
echo  SECURITY TOOLS MENU
echo  ========================================
echo.
echo   [1] Quick Malware Scan
echo   [2] Full System Scan
echo   [3] Update Virus Definitions
echo   [4] Check Firewall Status
echo   [5] Reset Firewall to Defaults
echo   [6] Check Windows Security Center
echo   [7] Run Malicious Software Removal
echo   [8] View Defender Settings
echo   [9] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto QuickScan
if "%choice%"=="2" goto FullScan
if "%choice%"=="3" goto UpdateDefs
if "%choice%"=="4" goto CheckFirewall
if "%choice%"=="5" goto ResetFirewall
if "%choice%"=="6" goto SecurityCenter
if "%choice%"=="7" goto MSRT
if "%choice%"=="8" goto DefenderSettings
if "%choice%"=="9" exit /b 0

goto Menu

:QuickScan
echo Starting Quick Scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo.
pause
goto Menu

:FullScan
echo ===============================================
echo   FULL SYSTEM SCAN
echo   This will take 1-4 hours depending on system
echo ===============================================
echo.
echo Press any key to start, or close to cancel...
pause >nul
echo.
echo Starting Full Scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo.
pause
goto Menu

:UpdateDefs
echo Updating virus definitions...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
echo.
pause
goto Menu

:CheckFirewall
echo Checking Windows Firewall status...
netsh advfirewall show currentprofile
echo.
pause
goto Menu

:ResetFirewall
echo Resetting Windows Firewall to defaults...
netsh advfirewall reset
echo Firewall reset complete.
echo.
pause
goto Menu

:SecurityCenter
echo Opening Windows Security Center...
start windowsdefender:
echo.
pause
goto Menu

:MSRT
echo Running Malicious Software Removal Tool...
mrt.exe
echo.
pause
goto Menu

:DefenderSettings
echo Opening Windows Defender Security Center...
start windowsdefender:
echo.
pause
goto Menu