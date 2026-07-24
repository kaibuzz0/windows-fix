@echo off
title Privacy Tweaks - RESTORE DEFAULTS
color 0C
cls

echo ===============================================
echo   PRIVACY TWEAKS - RESTORE DEFAULTS
echo   Re-enable Windows telemetry and data collection
echo ===============================================
echo.
pause

:: Create restore point
echo Creating restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Class CreateRestorePoint Name="Before Privacy Restore", RestorePointType=12

:: Re-enable Telemetry
echo Re-enabling telemetry...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 1 /f

:: Re-enable Advertising ID
echo Re-enabling Advertising ID...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 1 /f

:: Re-enable Location
echo Re-enabling Location services...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /f 2>nul

:: Re-enable Error Reporting
echo Re-enabling Error Reporting...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /f 2>nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /f 2>nul

:: Re-enable Cortana
echo Re-enabling Cortana...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /f 2>nul

echo.
echo ===============================================
echo   PRIVACY SETTINGS RESTORED
echo ===============================================
echo.
echo Windows telemetry has been re-enabled.
pause
