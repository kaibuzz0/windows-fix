@echo off
title Windows Update Repair
color 0E
cls

echo ===============================================
echo   WINDOWS UPDATE REPAIR TOOL
echo   Fixes update errors and stuck updates
echo ===============================================
echo.

:: Check admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Run as Administrator required!
    pause
    exit /b 1
)

echo Step 1: Stopping Windows Update services...
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
net stop msiserver

echo.
echo Step 2: Renaming update folders...
ren %SystemRoot%\SoftwareDistribution SoftwareDistribution.old 2>nul
ren %SystemRoot%\System32\catroot2 catroot2.old 2>nul

echo.
echo Step 3: Resetting BITS and Windows Update service...
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)

echo.
echo Step 4: Re-registering Windows Update DLLs...
cd /d %SystemRoot%\system32
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll

echo.
echo Step 5: Resetting Winsock and proxy...
netsh winsock reset
netsh winhttp reset proxy

echo.
echo Step 6: Restarting services...
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc
net start msiserver

echo.
echo ===============================================
echo   WINDOWS UPDATE REPAIR COMPLETE
echo ===============================================
echo.
echo Try Windows Update now.
echo.
pause