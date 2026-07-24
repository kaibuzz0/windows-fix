@echo off
title Windows Fix Suite - Download Required Tools
color 0A
cls

echo ===============================================
echo   TOOLS DOWNLOADER
echo   Download Required 3rd Party Tools
echo ===============================================
echo.
echo This will download optional tools to enhance functionality.
echo All downloads are from official sources.
echo.
pause

set "ToolsDir=%~dp0tools"
if not exist "%ToolsDir%" mkdir "%ToolsDir%"

:Menu
cls
echo ===============================================
echo   SELECT TOOLS TO DOWNLOAD
echo ===============================================
echo.
echo   [1] Download ALL Recommended Tools
echo   [2] Classic Shell (Start Menu replacement)
echo   [3] Wise Care 365 (System cleaner)
echo   [4] AVG Antivirus Free
echo   [5] Wondershare Recoverit (Data recovery)
echo   [6] HP Support Framework (For HP PCs only)
echo.
echo   [9] Cleanup downloaded files
echo   [0] Return to Main Menu
echo.
echo ===============================================
echo NOTE: Downloads require internet connection.
echo ===============================================
set /p choice="Enter choice: "

if "%choice%"=="1" goto DownloadAll
if "%choice%"=="2" goto DownloadClassicShell
if "%choice%"=="3" goto DownloadWiseCare
if "%choice%"=="4" goto DownloadAVG
if "%choice%"=="5" goto DownloadRecoverit
if "%choice%"=="6" goto DownloadHPFramework
if "%choice%"=="9" goto Cleanup
if "%choice%"=="0" exit /b 0

goto Menu

:DownloadAll
call :DownloadClassicShell
call :DownloadWiseCare
call :DownloadAVG
echo.
echo All downloads complete!
echo Check %ToolsDir% for installers.
pause
goto Menu

:DownloadClassicShell
echo.
echo Downloading Classic Shell...
echo Source: https://github.com/coddec/Classic-Shell/
powershell -Command "& {$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/coddec/Classic-Shell/releases/download/v4.4.170/ClassicShellSetup_4_4_170.exe' -OutFile '%ToolsDir%\ClassicShellSetup.exe' -UseBasicParsing}"
if exist "%ToolsDir%\ClassicShellSetup.exe" (
    echo [OK] Classic Shell downloaded
) else (
    echo [FAIL] Download failed. Visit: https://github.com/coddec/Classic-Shell/
)
pause
goto Menu

:DownloadWiseCare
echo.
echo Downloading Wise Care 365 Free...
echo Source: https://www.wisecleaner.com/wise-care-365.html
powershell -Command "& {$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://downloads.wisecleaner.com/soft/WiseCare365Free.exe' -OutFile '%ToolsDir%\WiseCare365.exe' -UseBasicParsing}"
if exist "%ToolsDir%\WiseCare365.exe" (
    echo [OK] Wise Care 365 downloaded
) else (
    echo [FAIL] Download failed. Visit: https://www.wisecleaner.com/
)
pause
goto Menu

:DownloadAVG
echo.
echo Downloading AVG Antivirus Free...
echo Source: https://www.avg.com/en-us/free-antivirus-download
echo Please download manually from: https://www.avg.com/en-us/free-antivirus-download
echo (AVG requires registration for download)
start https://www.avg.com/en-us/free-antivirus-download
pause
goto Menu

:DownloadRecoverit
echo.
echo Downloading Wondershare Recoverit...
echo Source: https://recoverit.wondershare.com/
echo Please download manually from: https://recoverit.wondershare.com/free-download.html
start https://recoverit.wondershare.com/free-download.html
pause
goto Menu

:DownloadHPFramework
echo.
echo HP Support Solutions Framework
echo This is only needed for HP computers.
echo Download from: https://support.hp.com/us-en/drivers
echo.
echo OR run HP Support Assistant which will auto-install it.
start https://support.hp.com/us-en/drivers
pause
goto Menu

:Cleanup
echo.
echo Cleaning up downloaded files...
del /q "%ToolsDir%\*.exe" 2>nul
del /q "%ToolsDir%\*.zip" 2>nul
del /q "%ToolsDir%\*.7z" 2>nul
echo Done!
pause
goto Menu
