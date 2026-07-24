@echo off
title Performance Tweaks - RESTORE DEFAULTS
color 0C
cls

echo ===============================================
echo   PERFORMANCE TWEAKS - RESTORE DEFAULTS
echo   Restore default Windows performance settings
echo ===============================================
echo.
pause

:: Create restore point
echo Creating restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="Before Performance Restore", RestorePointType=12

:: Restore visual effects
echo Restoring visual effects...
reg delete "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /f 2>nul
reg delete "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /f 2>nul
reg delete "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /f 2>nul
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "0" /f

:: Restore services timeout
echo Restoring services defaults...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "5000" /f

:: Re-enable startup delay (Windows default has delay)
echo Restoring startup delay...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /f 2>nul

:: Restore error reporting
echo Restoring error reporting defaults...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /f 2>nul

:: Restore Superfetch/SysMain
echo Restoring SysMain (Superfetch) service...
sc config SysMain start= auto
net start SysMain 2>nul

echo.
echo ===============================================
echo   PERFORMANCE TWEAKS RESTORED
echo ===============================================
echo.
pause
