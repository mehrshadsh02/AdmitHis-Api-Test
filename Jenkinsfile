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
        PY_BIN = 'C:\\Users\\Administrator\\AppData\\Local\\Programs\\Python\\Python314\\python.exe'
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
                echo 'Setting up Python virtual environment and packages...'
                bat '''@echo off
chcp 65001 > nul

echo [*] Python interpreter: %PY_BIN%

if not exist "venv\\Scripts\\python.exe" (
    echo [*] Creating virtual environment...
    "%PY_BIN%" -m venv venv
)

echo [*] Installing dependencies from requirements.txt...
call "venv\\Scripts\\python.exe" -m pip install --upgrade pip
call "venv\\Scripts\\python.exe" -m pip install -r requirements.txt

echo [SUCCESS] Environment is ready.
'''
            }
        }

        stage('Execute Automation Tests') {
            steps {
                echo 'Running Robot Framework tests...'
                bat '''@echo off
chcp 65001 > nul

echo ========================================================
echo   Running HIS Automation Tests
echo ========================================================

if exist "results" (
    rmdir /s /q "results"
)
mkdir "results\\allure-results"

echo [*] Executing test suite...
call "venv\\Scripts\\robot.exe" --listener "allure_robotframework:results\\allure-results" -d results -L INFO --consolecolors on AdmitHis-Api.robot

exit /b %ERRORLEVEL%
'''
            }
        }
    }

    post {
        always {
            echo '========================================================'
            echo '  Publishing Test Reports & Artifacts'
            echo '========================================================'

            // گزارش‌های پیش‌فرض Robot Framework (HTML)
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

            // تولید داشبورد Allure
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
                    echo "Allure publication: ${e.message}"
                }
            }

            // آرشیو تمام فایل‌های خروجی
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
