# Playwright Migration Plan

This project is currently a Robot Framework suite with SeleniumLibrary. The
lowest-risk migration path is to keep Selenium tests working and add Playwright
beside them through Robot Framework Browser.

## Install

Robot Framework Browser needs Node.js and npm before `rfbrowser init` can
finish. Check them first:

```powershell
node -v
npm -v
```

If either command is not recognized, install Node.js LTS and open a new
PowerShell window so PATH is refreshed.

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\rfbrowser.exe init --skip-browsers
```

If the virtual environment is not healthy, recreate it first and then install
the normal project dependencies plus `requirements-playwright.txt`.

## Common Setup Errors

### npm is not recognized

`rfbrowser init` installs the JavaScript wrapper for Robot Framework Browser.
It cannot complete unless `npm` is available in PATH.

Fix:

```powershell
winget install OpenJS.NodeJS.LTS
```

Then close and reopen PowerShell, activate the venv again, and run:

```powershell
node -v
npm -v
.\.venv\Scripts\rfbrowser.exe init
```

### venv points to another project path

If the traceback mentions a different folder, recreate the virtual environment
inside this project instead of copying an existing `.venv`:

```powershell
deactivate
Rename-Item .venv .venv_old
py -3.13 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install robotframework robotframework-seleniumlibrary robotframework-requests robotframework-jsonlibrary robotframework-databaselibrary pymssql jdatetime allure-robotframework
python -m pip install -r requirements-playwright.txt
rfbrowser init --skip-browsers
```

### Playwright browser download returns 403

The official Playwright browser CDN can be blocked by location. This project is
configured to use the installed Google Chrome channel instead of downloading
Chromium. Use:

```powershell
rfbrowser init --skip-browsers
```

## Run The Playwright Smoke Suite

```powershell
.\scripts\run-playwright.ps1
```

The script adds `C:\Program Files\nodejs` to PATH for this run and keeps npm
cache inside `.npm-cache`.

## Suggested Structure

```text
AdmitHis-UI.robot
AdmitHis-UI-Playwright.robot
Resources/
  Variables/
    AdmitHis-variables.resource
  Keywords/
    AdmitHis-UI-keywords.resource
    UI/
      AdmitHis-Playwright-keywords.resource
docs/
  playwright-migration.md
requirements-playwright.txt
```

## Migration Rules

1. Keep existing Selenium suites unchanged until their Playwright replacement is
   stable.
2. Add new Playwright keywords with the `PW` prefix to avoid keyword name
   conflicts between SeleniumLibrary and Browser.
3. Do not import Selenium resources into Playwright suites. Shared non-UI setup
   should live in a neutral resource without SeleniumLibrary or Browser.
4. Migrate one small workflow first: open page, enter national code, submit.
5. Prefer stable locators like `formcontrolname`, `data-testid`, visible text,
   or role-based selectors. Avoid generated ids such as `mat-input-55`.

## Selenium To Playwright Keyword Mapping

```text
Open Browser                  -> New Browser + New Context + New Page
Go To                         -> Go To
Reload Page                   -> Reload
Input Text                    -> Fill Text
Click Element                 -> Click
Wait Until Element Is Visible -> Wait For Elements State    visible
Wait Until Element Is Enabled -> Wait For Elements State    enabled
Scroll Element Into View      -> Scroll To Element
Press Keys                    -> Keyboard Key
```
