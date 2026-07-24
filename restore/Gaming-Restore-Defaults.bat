@echo off
title Gaming Optimizations - RESTORE DEFAULTS
color 0C
cls

echo ===============================================
echo   GAMING OPTIMIZATIONS - RESTORE DEFAULTS
echo   Revert all gaming tweaks to Windows defaults
echo ===============================================
echo.
echo [!] This will restore default Windows settings
echo [!] Create restore point first? (Recommended)
echo.
pause

:: Create restore point
echo Creating restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="Before Gaming Restore", RestorePointType=12

:: Restore Game DVR
echo Restoring Game DVR...
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /f 2>nul
reg delete "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /f 2>nul
reg delete "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /f 2>nul

:: Restore fullscreen optimizations
echo Restoring fullscreen optimizations...
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /f 2>nul

:: Restore network throttling
echo Restoring network defaults...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f

:: Restore Nagle's algorithm
echo Restoring Nagle's algorithm (default)...
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg delete "%%i" /v "TcpAckFrequency" /f 2>nul
    reg delete "%%i" /v "TCPNoDelay" /f 2>nul
)

:: Restart services
echo Restarting services...
net start BFE 2>nul
net start mpssvc 2>nul

:: Restart explorer
echo Restarting Explorer...
taskkill /f /im explorer.exe > nul 2>&1
start explorer.exe

echo.
echo ===============================================
echo   GAMING TWEAKS RESTORED TO DEFAULTS
echo ===============================================
echo.
echo Please restart your computer for full effect.
pause
