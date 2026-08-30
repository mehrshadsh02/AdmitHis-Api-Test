@echo off
chcp 65001 > nul
echo ========================================================
echo   HIS Test Environment Setup (One-Time Run)
echo ========================================================

:: 1. بررسی وجود پایتون در سیستم
python --version > nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not installed or not in PATH!
    echo Please install Python 3.10+ and add it to PATH.
    pause
    exit /b 1
)

:: 2. ساخت venv در صورت عدم وجود
if not exist "venv\Scripts\python.exe" (
    echo [*] Creating virtual environment (venv)...
    python -m venv venv
) else (
    echo [*] Virtual environment already exists.
)

:: 3. آپگرید pip و نصب پکیج‌ها از requirements.txt
if exist requirements.txt (
    echo [*] Installing/Updating dependencies from requirements.txt...
    call venv\Scripts\python.exe -m pip install --upgrade pip
    call venv\Scripts\pip.exe install -r requirements.txt
    echo.
    echo ========================================================
    echo   [SUCCESS] Environment is ready!
    echo   Now you can run 'run_tests.bat' to execute tests.
    echo ========================================================
) else (
    echo [ERROR] requirements.txt not found in the current directory!
)

pause
