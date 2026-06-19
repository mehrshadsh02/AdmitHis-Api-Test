*** Settings ***
Resource          Resources/Variables/AdmitHis-variables.resource
Resource          Resources/Keywords/UI/AdmitHis-Playwright-keywords.resource

Suite Setup       Create AdmitHIS Session
Suite Teardown    PW Close Browser


*** Test Cases ***
01-PW - Open Filing Page
    [Documentation]    Playwright smoke test for Admit HIS filing page.
    [Tags]    UI_Test    playwright    smoke    preadmit

    Disable Screenshots
    PW Start Browser AdmitHis With Token
    PW Go To AdmitHis Page
    PW Wait For Page Ready
    Log To Console    ---- PLAYWRIGHT DONE ----

02-PW - Enter National Code Of Preadmit Patient
    [Documentation]    Playwright version of the national code inquiry step.
    [Tags]    UI_Test    playwright    step02    preadmit

    PW Wait For Page Ready
    PW Input Text            xpath=//input[@formcontrolname='nationalCode']    ${nationalCode}
    PW Click Element Safe    id=button-addon3
    PW Wait For Page Ready
