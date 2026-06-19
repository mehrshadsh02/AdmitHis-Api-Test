# Playwright Migration Plan

This project is currently a Robot Framework suite with SeleniumLibrary. The
lowest-risk migration path is to keep Selenium tests working and add Playwright
beside them through Robot Framework Browser.

## Install

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements-playwright.txt
.\.venv\Scripts\rfbrowser.exe init
```

If the virtual environment is not healthy, recreate it first and then install
the normal project dependencies plus `requirements-playwright.txt`.

## Run The Playwright Smoke Suite

```powershell
robot -d results-playwright .\AdmitHis-UI-Playwright.robot
```

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
