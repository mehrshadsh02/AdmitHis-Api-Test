pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
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
                echo 'Pulling latest code from Git repository...'
                checkout scm
            }
        }

        stage('Setup Environment') {
            steps {
                echo 'Creating venv and installing dependencies...'
                bat '''
                @echo off
                chcp 65001 > nul
                setlocal enabledelayedexpansion

                echo ========================================================
                echo   HIS Test Environment Setup
                echo ========================================================

                REM 1. Set explicit Python path
                set "PY_BIN=C:\\Users\\Administrator\\AppData\\Local\\Programs\\Python\\Python314\\python.exe"

                if not exist "!PY_BIN!" (
                    echo [ERROR] Python executable was not found at: !PY_BIN!
                    exit /b 1
                )

                echo [*] Using Python: !PY_BIN!
                "!PY_BIN!" --version

                REM 2. Create venv
                if not exist "venv\\Scripts\\python.exe" (
                    echo [*] Creating fresh virtual environment (venv)...
                    "!PY_BIN!" -m venv venv
                    if !ERRORLEVEL! NEQ 0 (
                        echo [ERROR] Failed to create virtual environment!
                        exit /b 1
                    )
                ) else (
                    echo [*] Virtual environment already exists.
                )

                REM 3. Install requirements
                if exist "requirements.txt" (
                    echo [*] Upgrading pip and installing requirements...
                    call "venv\\Scripts\\python.exe" -m pip install --upgrade pip
                    call "venv\\Scripts\\python.exe" -m pip install -r requirements.txt
                    if !ERRORLEVEL! NEQ 0 (
                        echo [ERROR] Failed to install requirements!
                        exit /b 1
                    )
                    echo ========================================================
                    echo   [SUCCESS] Environment is ready!
                    echo ========================================================
                ) else (
                    echo [ERROR] requirements.txt not found!
                    exit /b 1
                )

                endlocal
                '''
            }
        }

        stage('Execute Automation Tests') {
            steps {
                echo 'Running Robot Framework tests...'
                bat '''
                @echo off
                chcp 65001 > nul
                setlocal enabledelayedexpansion

                echo ========================================================
                echo   [RUNNER] Running HIS Automation Tests (Robot Framework)
                echo ========================================================

                REM 1. Check venv and robot.exe
                if not exist "venv\\Scripts\\robot.exe" (
                    echo [ERROR] Virtual environment venv or robot.exe was not found!
                    exit /b 1
                )

                REM 2. Ensure results folder exists
                if not exist "results\\allure-results" (
                    mkdir "results\\allure-results"
                )

                REM 3. Execute tests with Allure Listener
                echo [*] Executing AdmitHis-Api.robot with Allure Listener...
                call "venv\\Scripts\\robot.exe" --listener "allure_robotframework:results\\allure-results" -d results -L INFO --consolecolors on AdmitHis-Api.robot

                set TEST_EXIT_CODE=!ERRORLEVEL!

                echo.
                echo ========================================================
                if !TEST_EXIT_CODE! EQU 0 (
                    echo   [RESULT: PASS] All tests finished successfully!
                ) else (
                    echo   [RESULT: FAIL] Some tests failed with exit code !TEST_EXIT_CODE!.
                )
                echo ========================================================

                exit /b !TEST_EXIT_CODE!
                '''
            }
        }
    }

    post {
        always {
            echo '========================================================'
            echo '  Publishing Reports & Artifacts'
            echo '========================================================'

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

            script {
                try {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'results/allure-results']]
                    ])
                } catch (Exception e) {
                    echo "Allure publication step info: ${e.message}"
                }
            }

            archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
        }
        success {
            echo '🎉 All tests executed and passed successfully!'
        }
        failure {
            echo '⚠️ Pipeline completed with test failures or errors.'
        }
    }
}
