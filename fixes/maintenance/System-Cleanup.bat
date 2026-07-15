@echo off
title System Cleanup Tool
color 0A
cls

echo ===============================================
echo   SYSTEM CLEANUP TOOL
echo   Clean temporary files and free disk space
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
echo  SYSTEM CLEANUP MENU
echo  ========================================
echo.
echo   [1] Quick Cleanup (Temp files only)
echo   [2] Full Cleanup (All caches)
echo   [3] Disk Cleanup (cleanmgr)
echo   [4] Clear Browser Caches
echo   [5] Clear Event Logs
echo   [6] Empty Recycle Bin
echo   [7] Delete Old Restore Points
echo   [8] Analyze Disk (Defrag check)
echo   [9] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto Quick
if "%choice%"=="2" goto Full
if "%choice%"=="3" goto DiskCleanup
if "%choice%"=="4" goto BrowserCache
if "%choice%"=="5" goto EventLogs
if "%choice%"=="6" goto RecycleBin
if "%choice%"=="7" goto OldRestore
if "%choice%"=="8" goto DefragCheck
if "%choice%"=="9" exit /b 0

goto Menu

:Quick
echo Quick cleanup: Temp files only...
rd /s /q %TEMP%\* 2>nul
rd /s /q %SystemRoot%\Temp\* 2>nul
echo Temp files cleared.
pause
goto Menu

:Full
echo ===============================================
echo   FULL SYSTEM CLEANUP
echo ===============================================
echo.

echo Cleaning Windows Temp...
rd /s /q %TEMP%\* 2>nul
rd /s /q %SystemRoot%\Temp\* 2>nul
rd /s /q %SystemRoot%\Prefetch\* 2>nul

echo Cleaning Internet Cache...
rd /s /q "%LOCALAPPDATA%\Microsoft\Windows\INetCache" 2>nul

echo Cleaning Windows Update Cache...
rd /s /q "%SystemRoot%\SoftwareDistribution\Download" 2>nul

echo Cleaning Thumbnail Cache...
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul

echo Cleaning Error Reports...
rd /s /q "%ProgramData%\Microsoft\Windows\WER" 2>nul

echo Clearing Recycle Bin...
rd /s /q %systemdrive%\$Recycle.Bin 2>nul

echo.
echo Full cleanup complete!
pause
goto Menu

:DiskCleanup
echo Starting Disk Cleanup...
cleanmgr /sageset:1
cls
echo Running selected cleanup tasks...
cleanmgr /sagerun:1
echo.
pause
goto Menu

:BrowserCache
echo Clearing browser caches...
echo.
echo Chrome cache...
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
echo Firefox cache...
for /d %%x in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do rd /s /q "%%x\cache2" 2>nul
echo Edge cache...
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>nul
echo.
echo Browser caches cleared.
pause
goto Menu

:EventLogs
echo Clearing Event Logs...
for /f "tokens=*" %%a in ('wevtutil el') do wevtutil cl "%%a" 2>nul
echo Event logs cleared.
pause
goto Menu

:RecycleBin
echo Emptying Recycle Bin...
rd /s /q %systemdrive%\$Recycle.Bin 2>nul
echo Recycle Bin emptied.
pause
goto Menu

:OldRestore
echo Deleting old restore points (keeping latest)...
vssadmin delete shadows /for=%systemdrive% /oldest /quiet
echo Old restore points deleted.
pause
goto Menu

:DefragCheck
echo Analyzing disk fragmentation...
defrag %systemdrive% /A
echo.
pause
goto Menu