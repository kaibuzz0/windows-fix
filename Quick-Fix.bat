@echo off
title One-Click Quick Fix
color 0A
cls

echo ===============================================
echo   ONE-CLICK QUICK FIX
echo   Fast repair for common issues
echo ===============================================
echo.
echo This will:
echo  1. Create a restore point
echo  2. Clear temporary files
echo  3. Flush DNS
echo  4. Run quick SFC check
echo  5. Reset Windows Store
echo.
pause

:: Check admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Run as Administrator required!
    pause
    exit /b 1
)

echo.
echo [1/5] Creating restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="OneClick Quick Fix", RestorePointType=12 2>nul

echo [2/5] Clearing temporary files...
rd /s /q %TEMP%\* 2>nul
rd /s /q %SystemRoot%\Temp\* 2>nul

echo [3/5] Flushing DNS...
ipconfig /flushdns

echo [4/5] Running SFC verification...
sfc /verifyonly

echo [5/5] Resetting Windows Store...
wsreset.exe >> nul 2>&1

echo.
echo ===============================================
echo   QUICK FIX COMPLETE
echo ===============================================
echo.
echo Recommend restarting to complete cleanup.
echo.
pause