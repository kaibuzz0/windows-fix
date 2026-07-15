@echo off
title Network Repair Toolkit
color 0B
cls

echo ===============================================
echo   NETWORK REPAIR TOOLKIT
echo   Reset & Repair Network Connection
echo ===============================================
echo.

:: Check admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Run as Administrator required!
    pause
    exit /b 1
)

echo [1/10] Stopping network services...
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
net stop Dhcp
net stop Dnscache
net stop NlaSvc

echo [2/10] Flushing DNS...
ipconfig /flushdns

echo [3/10] Releasing IP...
ipconfig /release

echo [4/10] Renewing IP...
ipconfig /renew

echo [5/10] Resetting Winsock...
netsh winsock reset

echo [6/10] Resetting TCP/IP stack...
netsh int ip reset

echo [7/10] Resetting Windows HTTP proxy...
netsh winhttp reset proxy

echo [8/10] Resetting firewall...
netsh advfirewall reset

echo [9/10] Clearing network cache...
rd /s /q "%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Microsoft\Windows\DeliveryOptimization\State" 2>nul
rd /s /q "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\State" 2>nul

echo [10/10] Restarting services...
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc
net start Dhcp
net start Dnscache
net start NlaSvc

echo.
echo ===============================================
echo   NETWORK REPAIR COMPLETE
echo ===============================================
echo.
echo A system restart is REQUIRED.
pause

set /p reboot="Restart now? (Y/N): "
if /i "%reboot%"=="Y" shutdown /r /t 30 /c "Network repair complete"
exit /b 0