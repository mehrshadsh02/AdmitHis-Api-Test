<#
.SYNOPSIS
    HIS Test Automation Runner Script (Robot Framework & Allure)
.DESCRIPTION
    Executes Robot Framework tests inside the local virtual environment (venv)
    with support for tags, suites, output customization, and Allure reporting.
.EXAMPLE
    .\run_tests.ps1
    .\run_tests.ps1 -Tag API_GeneralVariables
    .\run_tests.ps1 -Tag DOCTORS_LIST
    .\run_tests.ps1 -Suite AdmitHis-Api.robot -Tag SMOKE
    .\run_tests.ps1 -OpenReport:$false   # برای محیط CI/CD یا جنکینز بدون باز کردن مرورگر
#>

param (
    [Parameter(Mandatory = $false)]
    [string]$Tag = "",

    [Parameter(Mandatory = $false)]
    [string]$Suite = "AdmitHis-Api.robot",

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = "results",

    [Parameter(Mandatory = $false)]
    [bool]$Allure = $true,

    [Parameter(Mandatory = $false)]
    [bool]$OpenReport = $true
)

# 1. تنظیم انکودینگ خروجی روی UTF-8 برای لاگ‌های فارسی و ایموجی‌ها
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "         HIS AUTOMATION TEST RUNNER                     " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 2. بررسی وجود و سلامت محیط مجازی (venv)
$RobotExe = ".\venv\Scripts\robot.exe"
if (-not (Test-Path $RobotExe)) {
    Write-Host "`n[ERROR] Virtual environment (venv) or robot.exe not found!" -ForegroundColor Red
    Write-Host "[!] Please run '.\setup_env.bat' first to prepare the environment.`n" -ForegroundColor Yellow
    exit 1
}

# 3. آماده‌سازی پوشه نتایج Allure
$AllureResultsDir = "$OutputDir/allure-results"
if ($Allure) {
    if (Test-Path $AllureResultsDir) {
        # پاک‌سازی نتایج اجرای قبلی جهت جلوگیری از تداخل داده‌ها
        Remove-Item -Path "$AllureResultsDir\*" -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        New-Item -ItemType Directory -Path $AllureResultsDir -Force | Out-Null
    }
}

# 4. آماده‌سازی آرگومان‌های پایه Robot Framework
$RobotArgs = @(
    "-d", $OutputDir,
    "-L", "INFO",
    "--consolecolors", "on"
)

# 5. فعال‌سازی Allure Listener
if ($Allure) {
    Write-Host "[+] Allure Listener Enabled: output -> $AllureResultsDir" -ForegroundColor DarkCyan
    $RobotArgs += @(
        "--listener", "allure_robotframework:$AllureResultsDir"
    )
}

# 6. اعمال فیلتر تگ در صورت وجود
if (-not [string]::IsNullOrWhiteSpace($Tag)) {
    $RobotArgs += @("-i", $Tag)
    Write-Host "[*] Filtering by Tag: $Tag" -ForegroundColor Magenta
}

# 7. بررسی وجود سوئیت تست و افزودن آن به آرگومان‌ها
if (-not (Test-Path $Suite)) {
    Write-Host "`n[ERROR] Test suite file '$Suite' does not exist!" -ForegroundColor Red
    exit 1
}
$RobotArgs += $Suite

Write-Host "[*] Target Suite: $Suite" -ForegroundColor Gray
Write-Host "[*] Executing Command: $RobotExe $($RobotArgs -join ' ')" -ForegroundColor DarkGray
Write-Host "--------------------------------------------------------" -ForegroundColor Gray

# 8. اجرای تست‌ها
& $RobotExe $RobotArgs
$ExitCode = $LASTEXITCODE

Write-Host "--------------------------------------------------------" -ForegroundColor Gray

# 9. بررسی نتیجه خروجی
if ($ExitCode -eq 0) {
    Write-Host "`n[PASS] All Tests Completed Successfully!" -ForegroundColor Green
} else {
    Write-Host "`n[FAIL] Execution Finished with Failures (Exit Code: $ExitCode)" -ForegroundColor Red
}

Write-Host "[*] Native Robot Report: $OutputDir\report.html" -ForegroundColor Cyan
Write-Host "[*] Native Robot Log:    $OutputDir\log.html" -ForegroundColor Cyan

# 10. مدیریت و باز کردن گزارش Allure
if ($Allure -and $OpenReport) {
    $JsonFiles = Get-ChildItem -Path $AllureResultsDir -Filter "*.json" -ErrorAction SilentlyContinue
    
    if ($JsonFiles -and $JsonFiles.Count -gt 0) {
        Write-Host "`n[*] Launching Allure Report via NPX server in background..." -ForegroundColor Yellow
        
        # اجرای Allure serve در یک پراسس مجزا برای جلوگیری از مسدود شدن شل
        Start-Process cmd.exe -ArgumentList "/c npx allure serve `"$AllureResultsDir`"" -WindowStyle Minimized
        
        Write-Host "[+] Allure Dashboard should open automatically in your default browser." -ForegroundColor Green
    } else {
        Write-Host "`n[!] Warning: No Allure JSON result files found in '$AllureResultsDir'." -ForegroundColor Yellow
        Write-Host "[*] Opening standard HTML report as fallback..." -ForegroundColor Gray
        if (Test-Path "$OutputDir\report.html") {
            Start-Process "$OutputDir\report.html"
        }
    }
}

Write-Host "========================================================`n" -ForegroundColor Cyan

# برگرداندن Exit Code واقعی برای پایپ‌لاین‌های CI/CD
exit $ExitCode
