@echo off
setlocal EnableDelayedExpansion
title Unlock MCBE Levil - Made by HirotoKuga
color 0b

rem Tao ky tu Carriage Return (CR) de lam hieu ung ghi de thanh Loading
for /f %%A in ('copy /Z "%~f0" nul') do set "CR=%%A"

rem Kiem tra quyen Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo [!] LOI: Script can quyen Administrator!
    echo Vui long chuot phai vao file .bat va chon "Run as administrator".
    echo ========================================================
    echo.
    pause
    exit /b
)

:SCAN_GAME
rem Tim thu muc game Minecraft Bedrock trong WindowsApps
set "MC_DIR="
for /d %%D in ("%ProgramFiles%\WindowsApps\Microsoft.MinecraftUWP_*") do (
    if exist "%%D\Minecraft.Windows.exe" (
        set "MC_DIR=%%D"
    )
)

:MENU
cls
echo ========================================================
echo             UNLOCK MCBE LEVIL - TIEP CAN UWP
echo                   Made by HirotoKuga
echo ========================================================
echo.
if defined MC_DIR (
    echo [Trang thai] Da tim thay game tai:
    echo "!MC_DIR!"
) else (
    echo [Canh bao] Chua tim thay Minecraft UWP.
)
echo.
echo  [1] UNLOCK (Tu cap quyen + Inject winmm.dll)
echo  [2] GO UNLOCK / KHOA LAI (Xoa winmm.dll - Ve goc)
echo  [3] Mo khoa toan quyen thu muc WindowsApps (Hien tien trinh thuc)
echo  [4] Dong tien trinh Minecraft (Kill Task)
echo  [5] Thoat
echo.
echo ========================================================
set /p opt="Nhap lua chon [1-5]: "

if "%opt%"=="1" goto UNLOCK
if "%opt%"=="2" goto RESTORE
if "%opt%"=="3" goto UNLOCK_WINDOWS_APPS
if "%opt%"=="4" goto KILL_TASK
if "%opt%"=="5" exit /b
goto MENU

:KILL_TASK
cls
call :LOADING_BAR "Dang tat tien trinh Minecraft"
taskkill /f /im Minecraft.Windows.exe >nul 2>&1
echo Da dong game.
timeout /t 2 >nul
goto MENU

:UNLOCK_WINDOWS_APPS
cls
echo ========================================================
echo        CAP QUYEN THU MUC WINDOWSAPPS - HirotoKuga
echo ========================================================
echo.
echo [Thong tin] Do WindowsApps chua hang chuc ngan file he thong bi an,
echo CMD khong the dem truoc tong so file de tinh phan tram (%%) duoc.
echo De tranh bi treo, tool se chay hien thi THOI GIAN THUC (Real-time).
echo Ban se thay truc tiep tung file dang duoc mo khoa tren man hinh.
echo.
pause
echo.
call :LOADING_BAR "Dang chuan bi he thong..."

echo.
echo ========================================================
echo [1/2] DANG LAY QUYEN SO HUU (TAKE OWNERSHIP)...
echo ========================================================
takeown /f "%ProgramFiles%\WindowsApps" /r /d y

echo.
echo ========================================================
echo [2/2] DANG CAP QUYEN FULL CONTROL (ICACLS)...
echo ========================================================
icacls "%ProgramFiles%\WindowsApps" /grant administrators:F /t

echo.
echo ========================================================
echo [THANH CONG] Da cap toan quyen thu muc WindowsApps!
pause
goto SCAN_GAME

:UNLOCK
cls
echo ========================================================
echo               DANG TIEN HANH UNLOCK
echo ========================================================
echo.

if not exist "%~dp0winmm.dll" (
    echo [Loi] Khong tim thay file "winmm.dll" cung thu muc voi tool!
    echo Hay de file winmm.dll vao: %~dp0
    pause
    goto MENU
)

if not defined MC_DIR (
    echo [Loi] Khong tim thay thu muc game Minecraft UWP de inject!
    pause
    goto MENU
)

rem Tat game truoc khi thao tac
taskkill /f /im Minecraft.Windows.exe >nul 2>&1

call :LOADING_BAR "[1/3] Dang xac thuc cap quyen thu muc game"
takeown /f "!MC_DIR!" /a >nul 2>&1
icacls "!MC_DIR!" /grant administrators:F >nul 2>&1

call :LOADING_BAR "[2/3] Dang tien hanh Inject file winmm.dll"
copy /y "%~dp0winmm.dll" "!MC_DIR!\winmm.dll" >nul 2>&1

if %errorlevel% equ 0 (
    call :LOADING_BAR "[3/3] Dang dong bo quyen thuc thi ung dung"
    icacls "!MC_DIR!\winmm.dll" /grant "ALL APPLICATION PACKAGES":RX >nul 2>&1
    echo.
    echo ========================================================
    echo [THANH CONG] Da unlock Minecraft Bedrock hoan tat!
    echo ========================================================
) else (
    echo.
    echo [THAT BAI] Khong the ghi file vao thu muc game.
)
pause
goto MENU

:RESTORE
cls
echo ========================================================
echo          DANG GO UNLOCK (KHOA LAI BAN GOC)
echo ========================================================
echo.

if not defined MC_DIR (
    echo [Loi] Khong xac dinh duoc thu muc game.
    pause
    goto MENU
)

call :LOADING_BAR "[1/3] Dang tat game de giai phong bo nho"
taskkill /f /im Minecraft.Windows.exe >nul 2>&1
timeout /t 2 >nul

if exist "!MC_DIR!\winmm.dll" (
    call :LOADING_BAR "[2/3] Dang chiem quyen dieu khien file winmm.dll"
    takeown /f "!MC_DIR!\winmm.dll" /a >nul 2>&1
    icacls "!MC_DIR!\winmm.dll" /grant administrators:F >nul 2>&1
    attrib -r -s -h "!MC_DIR!\winmm.dll" >nul 2>&1

    call :LOADING_BAR "[3/3] Dang xoa file unlock"
    del /f /q "!MC_DIR!\winmm.dll" >nul 2>&1
    
    if not exist "!MC_DIR!\winmm.dll" (
        echo.
        echo [THANH CONG] Da xoa winmm.dll. Game da tro ve ban goc!
    ) else (
        echo.
        echo [THAT BAI] Khong the xoa file winmm.dll.
        echo Tinh trang: File van dang bi he thong giu - In use.
        echo Giai phap: Hay KHOI DONG LAI MAY TINH, mo lai tool nay va chon [2].
    )
) else (
    echo [Thong tin] Khong thay file winmm.dll trong game. Game da o trang thai goc.
)
pause
goto MENU

rem ========================================================
rem HAM HO TRO: HIEU UNG LOADING % (ANIMATION) - HirotoKuga
rem ========================================================
:LOADING_BAR
set "text=%~1"
echo !text!
set "bar="
set "spaces=                    "
for /l %%A in (1,1,20) do (
    set "bar=!bar!#"
    set "display_bar=!bar!!spaces!"
    set "display_bar=!display_bar:~0,20!"
    set /a "pct=%%A * 5"
    
    rem In de tren cung 1 dong tao hieu ung phan tram chay
    <nul set /p ="[!display_bar!] !pct!%%!CR!"
    
    rem Vong lap micro-delay giup Animation chay muot ma
    for /l %%B in (1,1,3000) do rem
)
echo.
exit /b