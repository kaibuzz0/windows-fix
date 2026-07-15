@echo off
title System Diagnostics
color 0B
cls

echo ===============================================
echo   SYSTEM DIAGNOSTICS TOOL
echo   Check system health and information
echo ===============================================
echo.

:Menu
cls
echo  DIAGNOSTICS MENU
echo  ========================================
echo.
echo   [1] System Information
echo   [2] Disk Health Check
echo   [3] Memory Status
echo   [4] Battery Report (Laptops)
echo   [5] Network Diagnostics
echo   [6] Generate Full Report
echo   [7] Event Viewer
echo   [8] Performance Monitor
echo   [9] Resource Monitor
echo  [10] DirectX Diagnostic
echo  [11] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto SysInfo
if "%choice%"=="2" goto DiskHealth
if "%choice%"=="3" goto MemoryStatus
if "%choice%"=="4" goto BatteryReport
if "%choice%"=="5" goto NetDiag
if "%choice%"=="6" goto FullReport
if "%choice%"=="7" goto EventView
if "%choice%"=="8" goto PerfMon
if "%choice%"=="9" goto ResMon
if "%choice%"=="10" goto DXDiag
if "%choice%"=="11" exit /b 0

goto Menu

:SysInfo
echo Gathering system information...
systeminfo | more
echo.
pause
goto Menu

:DiskHealth
echo Checking disk health...
wmic diskdrive get status,model,size
wmic logicaldisk get size,freespace,caption,description
echo.
pause
goto Menu

:MemoryStatus
echo Memory Status:
wmic memorychip get capacity,devicelocator,speed
echo.
wmic computersystem get totalphysicalmemory
echo.
pause
goto Menu

:BatteryReport
echo Generating battery report...
powercfg /batteryreport
start battery-report.html
echo Battery report opened.
pause
goto Menu

:NetDiag
echo Network Diagnostics:
echo.
echo IP Configuration:
ipconfig /all | more
echo.
echo DNS Test:
nslookup google.com
echo.
pause
goto Menu

:FullReport
echo ===============================================
echo   GENERATING FULL SYSTEM REPORT
echo ===============================================
echo.
set reportdir=%USERPROFILE%\Documents\SystemReports
if not exist "%reportdir%" mkdir "%reportdir%"
set reportfile=%reportdir%\Report_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%.txt
echo Report will be saved to:
echo %reportfile%
echo.
echo Gathering information...

echo =============================================== > "%reportfile%"
echo   SYSTEM REPORT >> "%reportfile%"
echo   Generated: %date% %time% >> "%reportfile%"
echo =============================================== >> "%reportfile%"
echo. >> "%reportfile%"

echo SYSTEM INFORMATION: >> "%reportfile%"
echo -------------------------------- >> "%reportfile%"
systeminfo >> "%reportfile%" 2>&1
echo. >> "%reportfile%"

echo DISK INFORMATION: >> "%reportfile%"
echo -------------------------------- >> "%reportfile%"
wmic diskdrive get status,model,size >> "%reportfile%"
wmic logicaldisk get size,freespace,caption >> "%reportfile%"
echo. >> "%reportfile%"

echo NETWORK INFORMATION: >> "%reportfile%"
echo -------------------------------- >> "%reportfile%"
ipconfig /all >> "%reportfile%"
echo. >> "%reportfile%"

echo FIREWALL STATUS: >> "%reportfile%"
echo -------------------------------- >> "%reportfile%"
netsh advfirewall show currentprofile >> "%reportfile%"
echo. >> "%reportfile%"

echo WINDOWS VERSION: >> "%reportfile%"
echo -------------------------------- >> "%reportfile%"
winver >> "%reportfile%" 2>&1
echo. >> "%reportfile%"

echo.
echo Report generated!
echo Opening report...
start "" "%reportfile%"
pause
goto Menu

:EventView
echo Opening Event Viewer...
eventvwr
echo.
pause
goto Menu

:PerfMon
echo Opening Performance Monitor...
perfmon
echo.
pause
goto Menu

:ResMon
echo Opening Resource Monitor...
resmon
echo.
pause
goto Menu

:DXDiag
echo Running DirectX Diagnostic Tool...
dxdiag
echo.
pause
goto Menu