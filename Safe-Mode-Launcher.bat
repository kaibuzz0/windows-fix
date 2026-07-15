@echo off
title Safe Mode Launcher
color 0E
cls

echo ===============================================
echo   SAFE MODE LAUNCHER
echo   Boot options for troubleshooting
echo ===============================================
echo.
echo  BOOT OPTIONS:
echo  ========================================
echo.
echo   [1] Enable Safe Mode (Minimal)
echo   [2] Enable Safe Mode with Networking
echo   [3] Enable Safe Mode with Command Prompt
echo   [4] Disable Safe Mode (Normal Boot)
echo   [5] Boot to Recovery Environment
echo   [6] Open Advanced Startup Options
echo   [7] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto SafeModeMinimal
if "%choice%"=="2" goto SafeModeNetwork
if "%choice%"=="3" goto SafeModeCmd
if "%choice%"=="4" goto NormalBoot
if "%choice%"=="5" goto Recovery
if "%choice%"=="6" goto AdvancedStartup
if "%choice%"=="7" exit /b 0

exit /b 0

:SafeModeMinimal
bcdedit /set {current} safeboot minimal
echo Safe Mode enabled.
echo Restart now? (Y/N)
set /p restart=
if /i "%restart%"=="Y" shutdown /r /t 5
goto :eof

:SafeModeNetwork
bcdedit /set {current} safeboot network
echo Safe Mode with Networking enabled.
echo Restart now? (Y/N)
set /p restart=
if /i "%restart%"=="Y" shutdown /r /t 5
goto :eof

:SafeModeCmd
bcdedit /set {current} safeboot minimal
bcdedit /set {current} safebootalternateshell yes
echo Safe Mode with Command Prompt enabled.
echo Restart now? (Y/N)
set /p restart=
if /i "%restart%"=="Y" shutdown /r /t 5
goto :eof

:NormalBoot
bcdedit /deletevalue {current} safeboot
bcdedit /deletevalue {current} safebootalternateshell
echo Normal boot restored.
echo Restart now? (Y/N)
set /p restart=
if /i "%restart%"=="Y" shutdown /r /t 5
goto :eof

:Recovery
shutdown /r /o /f /t 0
goto :eof

:AdvancedStartup
start ms-settings:recovery
goto :eof