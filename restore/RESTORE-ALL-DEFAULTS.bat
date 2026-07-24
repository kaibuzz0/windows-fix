@echo off
title Windows Fix Suite - RESTORE DEFAULTS
color 0C
cls

echo ===============================================
echo   WINDOWS FIX SUITE - RESTORE DEFAULTS
echo   Revert all tweaks to Windows defaults
echo ===============================================
echo.
echo [!] WARNING: This will undo optimization tweaks!
echo [!] Windows will return to default settings.
echo.
pause

:Menu
cls
echo  RESTORE DEFAULTS MENU
echo  ========================================
echo.
echo   [1] Restore Gaming Optimizations
echo   [2] Restore Privacy Settings
echo   [3] Restore Performance Tweaks
echo   [4] Restore Registry Tweaks (reg files)
echo   [5] Restore ALL (Nuclear Restore)
echo.
echo   [0] Exit
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto GamingRestore
if "%choice%"=="2" goto PrivacyRestore
if "%choice%"=="3" goto PerformanceRestore
if "%choice%"=="4" goto RegistryRestore
if "%choice%"=="5" goto NuclearRestore
if "%choice%"=="0" exit /b 0

goto Menu

:GamingRestore
call "%~dp0Gaming-Restore-Defaults.bat"
goto Menu

:PrivacyRestore
call "%~dp0Privacy-Restore-Defaults.bat"
goto Menu

:PerformanceRestore
call "%~dp0Performance-Restore-Defaults.bat"
goto Menu

:RegistryRestore
cls
echo Restoring registry from backup...
echo.
if exist "%~dp0..\registry\Default-Services-Win10.reg" (
    echo Importing default services registry...
    reg import "%~dp0..\registry\Default-Services-Win10.reg"
    echo [OK] Registry restored
) else (
    echo [WARNING] Default services registry not found!
    echo Please run Windows-Repair-Suite.bat and select Service Management
)
pause
goto Menu

:NuclearRestore
cls
echo  ☢️  NUCLEAR RESTORE - ALL DEFAULTS  ☢️
echo.
echo This will restore ALL tweaks to defaults:
echo   - Gaming settings
echo   - Privacy settings  
echo   - Performance tweaks
echo   - Registry modifications
echo.
echo Type NUCLEAR-RESTORE to proceed:
set /p confirm="Confirmation: "
if /i not "%confirm%"=="NUCLEAR-RESTORE" goto Menu

call "%~dp0Gaming-Restore-Defaults.bat"
call "%~dp0Privacy-Restore-Defaults.bat"
call "%~dp0Performance-Restore-Defaults.bat"
echo.
echo ☢️  NUCLEAR RESTORE COMPLETE ☢️
echo System has been restored to default Windows settings.
pause
goto Menu
