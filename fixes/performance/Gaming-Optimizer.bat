@echo off
title Gaming Performance Optimizer
color 0D
cls

echo ===============================================
echo   GAMING PERFORMANCE OPTIMIZER
echo   Optimize Windows for Gaming
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
echo  GAMING OPTIMIZATION MENU
echo  ========================================
echo.
echo   [1] Apply All Gaming Tweaks
echo   [2] Disable Game DVR/Bar
echo   [3] Optimize Services for Gaming
echo   [4] Disable Fullscreen Optimizations
echo   [5] Disable Nagle's Algorithm (Latency)
echo   [6] Restore Default Settings
echo   [7] Return to Main Menu
echo.
set /p choice="Select option: "

if "%choice%"=="1" goto AllTweaks
if "%choice%"=="2" goto DisableDVR
if "%choice%"=="3" goto OptimizeServices
if "%choice%"=="4" goto DisableFSO
if "%choice%"=="5" goto DisableNagle
if "%choice%"=="6" goto RestoreDefaults
if "%choice%"=="7" exit /b 0

goto Menu

:AllTweaks
echo Applying all gaming optimizations...
call :DisableDVR
call :OptimizeServices
call :DisableFSO
call :DisableNagle
echo.
echo All gaming optimizations applied!
echo Restart recommended for full effect.
pause
goto Menu

:DisableDVR
echo Disabling Game DVR and Game Bar...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d 0 /f
echo Game DVR disabled.
pause
goto Menu

:OptimizeServices
echo Optimizing services for gaming...
sc config SysMain start= auto
sc config WSearch start= disabled
sc config WMPNetworkSvc start= disabled
sc config WalletService start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config WerSvc start= disabled
sc config PcaSvc start= disabled
sc config DcpSvc start= disabled
sc config WbioSrvc start= disabled
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
echo Services optimized.
pause
goto Menu

:DisableFSO
echo Disabling fullscreen optimizations...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f
echo Fullscreen optimizations disabled.
pause
goto Menu

:DisableNagle
echo Disabling Nagle's Algorithm for lower latency...
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"') do (
    reg add "%%i" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
)
echo Nagle's Algorithm disabled on all interfaces.
echo Note: May slightly increase CPU usage.
pause
goto Menu

:RestoreDefaults
echo Restoring default settings...
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /f >nul 2>&1
sc config WSearch start= delayed-auto
sc config WerSvc start= demand
sc config PcaSvc start= demand
echo Default settings restored.
pause
goto Menu