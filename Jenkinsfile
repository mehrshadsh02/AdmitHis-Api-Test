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

        // Python must be accessible to the Jenkins service account.
        PYTHON_EXE = 'C:\\Users\\Administrator\\AppData\\Local\\Programs\\Python\\Python314\\python.exe'
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
                echo 'Creating virtual environment and installing dependencies...'

                bat '''@echo off
chcp 65001 > nul
setlocal

echo ========================================================
echo   HIS Test Environment Setup
echo ========================================================

set "PY_BIN=%PYTHON_EXE%"
set "VENV_PYTHON=venv\\Scripts\\python.exe"

echo [INFO] Checking Python installation...

if not exist "%PY_BIN%" goto :python_not_found

echo [INFO] Using Python:
echo        %PY_BIN%

"%PY_BIN%" --version
if errorlevel 1 goto :python_failed

if exist "%VENV_PYTHON%" goto :venv_ready

echo [INFO] Creating fresh virtual environment...
"%PY_BIN%" -m venv venv
if errorlevel 1 goto :venv_creation_failed

:venv_ready
echo [INFO] Virtual environment is ready.

if not exist "%VENV_PYTHON%" goto :venv_python_not_found
if not exist "requirements.txt" goto :requirements_not_found

echo [INFO] Upgrading pip...
call "%VENV_PYTHON%" -m pip install --upgrade pip
if errorlevel 1 goto :pip_upgrade_failed

echo [INFO] Installing project dependencies...
call "%VENV_PYTHON%" -m pip install -r requirements.txt
if errorlevel 1 goto :requirements_install_failed

echo.
echo ========================================================
echo   [SUCCESS] Environment setup completed successfully.
echo ========================================================

endlocal
exit /b 0


:python_not_found
echo.
echo [ERROR] Python executable was not found:
echo         %PY_BIN%
endlocal
exit /b 1


:python_failed
echo.
echo [ERROR] Python could not be executed.
endlocal
exit /b 1


:venv_creation_failed
echo.
echo [ERROR] Failed to create the virtual environment.
endlocal
exit /b 1


:venv_python_not_found
echo.
echo [ERROR] Python executable was not found inside venv.
echo         Expected path: %VENV_PYTHON%
endlocal
exit /b 1


:requirements_not_found
echo.
echo [ERROR] requirements.txt was not found in the workspace.
endlocal
exit /b 1


:pip_upgrade_failed
echo.
echo [ERROR] Failed to upgrade pip.
endlocal
exit /b 1


:requirements_install_failed
echo.
echo [ERROR] Failed to install project dependencies.
endlocal
exit /b 1
'''
            }
        }

        stage('Verify Test Environment') {
            steps {
                echo 'Verifying Robot Framework and Allure listener...'

                bat '''@echo off
chcp 65001 > nul
setlocal

set "VENV_PYTHON=venv\\Scripts\\python.exe"
set "ROBOT_EXE=venv\\Scripts\\robot.exe"

if not exist "%VENV_PYTHON%" goto :venv_not_found
if not exist "%ROBOT_EXE%" goto :robot_not_found

echo [INFO] Python virtual environment:
call "%VENV_PYTHON%" --version
if errorlevel 1 goto :verification_failed

echo.
echo [INFO] Robot Framework:
call "%ROBOT_EXE%" --version
if errorlevel 1 goto :verification_failed

echo.
echo [INFO] Checking Allure Robot Framework listener...
call "%VENV_PYTHON%" -c "import allure_robotframework; print('[SUCCESS] allure_robotframework is installed.')"
if errorlevel 1 goto :allure_listener_not_found

endlocal
exit /b 0


:venv_not_found
echo [ERROR] Virtual environment Python was not found.
echo         Expected path: %VENV_PYTHON%
endlocal
exit /b 1


:robot_not_found
echo [ERROR] Robot Framework executable was not found.
echo         Expected path: %ROBOT_EXE%
endlocal
exit /b 1


:allure_listener_not_found
echo [ERROR] allure-robotframework is not installed.
echo [ERROR] Add allure-robotframework to requirements.txt.
endlocal
exit /b 1


:verification_failed
echo [ERROR] Test environment verification failed.
endlocal
exit /b 1
'''
            }
        }

        stage('Prepare Test Results') {
            steps {
                echo 'Preparing clean results directories...'

                bat '''@echo off
chcp 65001 > nul

if exist "results" rmdir /s /q "results"
if errorlevel 1 exit /b 1

mkdir "results"
if errorlevel 1 exit /b 1

mkdir "results\\allure-results"
if errorlevel 1 exit /b 1

echo [SUCCESS] Test results directories are ready.
exit /b 0
'''
            }
        }

        stage('Execute Automation Tests') {
            steps {
                echo 'Running Robot Framework tests...'

                bat '''@echo off
chcp 65001 > nul
setlocal

set "ROBOT_EXE=venv\\Scripts\\robot.exe"
set "ROBOT_TEST=AdmitHis-Api.robot"

echo ========================================================
echo   HIS Robot Framework Test Execution
echo ========================================================

if not exist "%ROBOT_EXE%" goto :robot_not_found
if not exist "%ROBOT_TEST%" goto :test_file_not_found

echo [INFO] Executing test suite:
echo        %ROBOT_TEST%
echo.

call "%ROBOT_EXE%" ^
    --listener "allure_robotframework:results\\allure-results" ^
    --outputdir "results" ^
    --loglevel INFO ^
    --consolecolors on ^
    "%ROBOT_TEST%"

set "TEST_EXIT_CODE=%ERRORLEVEL%"

echo.
echo ========================================================

if "%TEST_EXIT_CODE%"=="0" goto :tests_passed

echo   [RESULT: FAIL] Robot Framework exit code: %TEST_EXIT_CODE%
echo ========================================================

endlocal & exit /b %TEST_EXIT_CODE%


:tests_passed
echo   [RESULT: PASS] All tests completed successfully.
echo ========================================================

endlocal
exit /b 0


:robot_not_found
echo [ERROR] Robot Framework executable was not found.
echo         Expected path: %ROBOT_EXE%
endlocal
exit /b 1


:test_file_not_found
echo [ERROR] Robot Framework test file was not found.
echo         Expected file: %ROBOT_TEST%
endlocal
exit /b 1
'''
            }
        }
    }

    post {
        always {
            echo '========================================================'
            echo '  Publishing Reports and Artifacts'
            echo '========================================================'

            script {
                if (fileExists('results/report.html')) {
                    publishHTML(target: [
                        allowMissing         : false,
                        alwaysLinkToLastBuild: true,
                        keepAll              : true,
                        reportDir            : 'results',
                        reportFiles          : 'report.html',
                        reportName           : 'Robot Framework Report',
                        reportTitles         : 'Robot Framework Report'
                    ])
                } else {
                    echo 'Robot Framework report.html was not generated.'
                }

                if (fileExists('results/log.html')) {
                    publishHTML(target: [
                        allowMissing         : false,
                        alwaysLinkToLastBuild: true,
                        keepAll              : true,
                        reportDir            : 'results',
                        reportFiles          : 'log.html',
                        reportName           : 'Robot Framework Log',
                        reportTitles         : 'Robot Framework Log'
                    ])
                } else {
                    echo 'Robot Framework log.html was not generated.'
                }

                if (fileExists('results/allure-results')) {
                    try {
                        allure([
                            includeProperties: false,
                            jdk              : '',
                            properties       : [],
                            reportBuildPolicy: 'ALWAYS',
                            results          : [
                                [path: 'results/allure-results']
                            ]
                        ])
                    } catch (Exception exception) {
                        echo "Allure report publication failed: ${exception.message}"
                    }
                } else {
                    echo 'Allure results directory was not generated.'
                }
            }

            archiveArtifacts(
                artifacts: 'results/**/*',
                allowEmptyArchive: true,
                fingerprint: true
            )
        }

        success {
            echo 'All tests executed and passed successfully.'
        }

        unstable {
            echo 'Pipeline completed with an unstable result.'
        }

        failure {
            echo 'Pipeline completed with test failures or environment errors.'
        }

        cleanup {
            echo "Finished Jenkins build: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
    }
}
