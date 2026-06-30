$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$nodePath = "C:\Program Files\nodejs"
if (Test-Path $nodePath) {
    $env:Path = "$nodePath;$env:Path"
}

$env:npm_config_cache = Join-Path $projectRoot ".npm-cache"
$env:PYTHONUTF8 = "1"

.\.venv\Scripts\robot.exe -d results-playwright .\AdmitHis-UI-Playwright.robot
