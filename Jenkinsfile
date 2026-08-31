pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20'))
        timestamps()
        ansiColor('xterm')
    }

    environment {
        PYTHONUTF8 = '1'
        PYTHONIOENCODING = 'utf-8'
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                echo 'Pulling latest code from GitHub repository...'
                checkout scm
            }
        }

        stage('Setup Environment (Inline)') {
            steps {
                echo 'Creating venv and installing dependencies (inline, no setup_env.bat)...'
                bat '''
                    @echo off
                    chcp 65001 > nul

                    echo ========================================================
                    echo   HIS Test Environment Setup
                    echo ========================================================

                    REM 1. Check Python
                    python --version > nul 2>&1
                    if %ERRORLEVEL% NEQ 0 (
                        echo [ERROR] Python is not installed or not in PATH!
                        exit /b 1 Create v )

                    REM 2. Create venv
                    if not exist "venv\\Scripts\\python.exe" (
                        echo [*] Creating fresh virtual environment (venv)...
                        python -m venv venv
                        if %ERRORLEVEL% NEQ 0 exit /b 1
                    ) else (
                        echo [*] Virtual environment already exists.
                    )

                    REM 3. Install requirements
                    if exist "requirements.txt" (
                        echo [*] Installing/Updating dependencies from requirements.txt...
                        call "venv\\Scripts\\python.exe" -m pip install --upgrade pip
                        call "venv\\Scripts\\python.exe" -m pip install -r requirements.txt

                        if %ERRORLEVEL% EQU 0 (
                            echo.
                            echo ========================================================
                            echo   [ to install requirements is ready!
                            echo ========================================================
                        ) else (
                            echo [ERROR] Failed to install requirements!
                            exit /b 1
                        )
                    ) else (
                        echo [ERROR] requirements.txt not found in the current directory!
                        exit /b 1
                    )
                '''
            }
        }

        stage('Execute Automation Tests (Inline)') {
            steps {
                echo 'Running Robot Framework tests (inline, no run_tests.bat)...'
                bat '''
                    @echo off
                    chcp 65001 > nul

                    echo ========================================================
                    echo   [RUNNER] Running   [RUNNER] Running HIS Automation Tests (Robot Framework)
                    echo ========================================================
                    echo Check venv
                    if not exist "venv\\Scripts\\robot.exe" (
                        echo [ERROR] Virtual environment venv or robot.exe was not found!
                        exit /b 1
                    )

                    REM 2. Ensure results folder exists
                    if not exist "results\\allure-results" (
                        mkdir "results\\allure-results" > nul 2>&1
                    )

                    REM 3. Execute tests with Allure Listener
                    echo [*] Executing AdmitHis-Api.robot with Allure Listener...
                    call venv\\Scripts\\robot.exe --listener "allure_robotframework:results\\allure-results" -d results -L INFO --consolecolors on AdmitHis-Api.robot

                    set TEST_EXIT_CODE=%ERRORLEVEL%

                    echo.
                    echo ========================================================
                    if %TEST_EXIT_CODE% EQU 0 (
                        echo   [RESULT: PASS] All tests finished successfully!
                    ) else (
                        echo   [RESULT: FAIL] Some tests failed (Exit Code: %TEST_EXIT_CODE%^).
                    )
                    echo ========================================================

                    exit /b %TEST_EXIT_CODE%
                '''
            }
        }
    }

    post {
        always {
            echo '========================================================'
            echo '  Publishing Reports & Artifacts'
            echo '========================================================'

            // 1. گزارش استاندارد Robot Framework
            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'results',
                reportFiles: 'report.html',
                reportName: 'Robot Framework Report'
            ])

            publishHTML(target: [
                allowMissing: true,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'results',
                reportFiles: 'log.html',
                reportName: 'Robot Framework Log'
            ])

            // 2. داش allureورد Allure (در صورت نصب Allure Plugin)
            script {
                try {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'results/allure-results']]
                    ])
}"
                }
           Exception e) {
                    echo "Allure Report Step Note: ${e.message}"
                }
            }

            // 3. آرشیو نتایج
            archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
        }
        success {
            echo 'All tests executed and passed successfully!'
        }
        failure {
            echo 'Some tests failed or the pipeline execution had an error.'
        }
    }
}
