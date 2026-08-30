@echo off
chcp 65001 > nul
cls
echo ========================================================
echo   [RUNNER] Running HIS Automation Tests (Robot Framework)
echo ========================================================
echo.

:: 1. بررسی اینکه آیا محیط venv قبلاً ستاپ شده یا خیر
if not exist "venv\Scripts\robot.exe" (
    echo [ERROR] Virtual environment 'venv' or 'robot.exe' was not found!
    echo [ACTION] Please run 'setup_env.bat' first to prepare the environment.
    echo.
    pause
    exit /b 1
)

:: 2. اطمینان از ساخت پوشه نتایج
if not exist "results\allure-results" (
    mkdir "results\allure-results" > nul 2>&1
)

:: 3. اجرای تست‌ها به همراه Listener اختصاصی Allure
echo [*] Executing AdmitHis-Api.robot with Allure Listener...
echo.
call venv\Scripts\robot.exe --listener "allure_robotframework:results\allure-results" -d results -L INFO --consolecolors on AdmitHis-Api.robot

:: 4. ذخیره کد وضعیت خروجی تست (Exit Code)
set TEST_EXIT_CODE=%ERRORLEVEL%

echo.
echo ========================================================
if %TEST_EXIT_CODE% EQU 0 (
    echo   [RESULT: PASS] All tests finished successfully!
) else (
    echo   [RESULT: FAIL] Some tests failed (Exit Code: %TEST_EXIT_CODE%).
)
echo ========================================================
echo [*] Robot Report: results\report.html
echo [*] Allure Data:  results\allure-results
echo.

:: 5. باز کردن خودکار داشبورد Allure در مرورگر
if exist "results\allure-results\*.json" (
    echo [*] Launching Allure Report Server in browser...
    start "Allure Server" cmd /c npx allure serve results/allure-results
) else (
    echo [!] Warning: No Allure JSON files found. Opening standard HTML report instead...
    if exist "results\report.html" (
        start "" "results\report.html"
    )
)

echo.
echo [INFO] Test execution finished. Allure server is running in background.
echo Press any key to close this terminal...
pause > nul
