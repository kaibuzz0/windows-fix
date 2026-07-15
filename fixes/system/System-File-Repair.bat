@echo off
title System File Repair
color 0C
cls

echo ===============================================
echo   SYSTEM FILE REPAIR TOOL
echo   SFC and DISM Repair Wizard
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
echo  SYSTEM FILE REPAIR MENU
echo  ========================================
echo.
echo   [1] Quick Scan (SFC only)
echo   [2] Standard Repair (SFC + DISM Scan)
echo   [3] Deep Repair (SFC + Full DISM)
echo   [4] Component Store Cleanup
echo   [5] Check DISM Health
echo   [6] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto Quick
if "%choice%"=="2" goto Standard
if "%choice%"=="3" goto Deep
if "%choice%"=="4" goto Cleanup
if "%choice%"=="5" goto CheckHealth
if "%choice%"=="6" exit /b 0

goto Menu

:Quick
echo Running System File Checker...
sfc /scannow
echo.
pause
goto Menu

:Standard
echo Running System File Checker...
sfc /scannow
echo.
echo Running DISM ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth
echo.
pause
goto Menu

:Deep
echo ===============================================
echo   DEEP SYSTEM REPAIR
echo   This may take 30-60 minutes
echo ===============================================
echo.
pause

echo [1/5] Running SFC...
sfc /scannow

echo [2/5] Running DISM ScanHealth...
DISM /Online /Cleanup-Image /ScanHealth

echo [3/5] Running DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth

echo [4/5] Running SFC again...
sfc /scannow

echo [5/5] Cleaning Component Store...
DISM /Online /Cleanup-Image /StartComponentCleanup

echo.
echo ===============================================
echo   DEEP REPAIR COMPLETE
echo ===============================================
pause
goto Menu

:Cleanup
echo Cleaning Component Store...
DISM /Online /Cleanup-Image /StartComponentCleanup
DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
echo.
pause
goto Menu

:CheckHealth
echo Checking Windows Health...
DISM /Online /Cleanup-Image /CheckHealth
echo.
pause
goto Menu