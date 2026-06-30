*** Settings ***
Library           Browser     auto_closing_level=SUITE
Library           RequestsLibrary

Resource          ../../Variables/AdmitHis-variables.resource


*** Variables ***
${PW_BROWSER}             chromium
${PW_CHANNEL}             chrome
${PW_HEADLESS}            ${False}
${PW_TIMEOUT}             30s


*** Keywords ***
Create AdmitHIS Session
    Create Session    HIS    ${AdmitHis_Api_URL}    verify=${False}

Disable Screenshots
    No Operation

PW Start Browser AdmitHis With Token
    [Documentation]    Opens Admit HIS with Playwright and injects token cookie.
    New Browser    ${PW_BROWSER}    headless=${PW_HEADLESS}    channel=${PW_CHANNEL}
    # New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${AdmitHis_App_URL}
    Add Cookie     token    ${COOKIE_TOKEN}    url=${AdmitHis_App_URL}
    Reload
    PW Wait For Page Ready

PW Start Browser Cash With Token
    [Documentation]    Opens Cash app with Playwright and injects token cookie.
    New Browser    ${PW_BROWSER}    headless=${PW_HEADLESS}    channel=${PW_CHANNEL}
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${Cash_App_URL}
    Add Cookie     token    ${COOKIE_TOKEN}    url=${Cash_App_URL}
    Reload
    PW Wait For Page Ready

PW Go To AdmitHis Page
    Go To    ${AdmitHis_App_URL}
    # Reload
    PW Wait For Page Ready

PW Switch To AdmitHis App
    Go To    ${AdmitHis_App_URL}
    Wait For Load State    domcontentloaded
    PW Wait For Page Ready

PW Switch To Cash App
    Go To    ${Cash_App_URL}
    Wait For Load State    domcontentloaded
    PW Wait For Page Ready

PW Wait For Spinner Hidden
    [Arguments]    ${timeout}=${PW_TIMEOUT}
    Wait For Elements State    ${GLOBAL_SPINNER}    hidden    timeout=${timeout}

PW Wait For Page Ready
    [Arguments]    ${timeout}=${PW_TIMEOUT}
    Wait For Load State    domcontentloaded
    Run Keyword And Ignore Error
    ...    PW Wait For Spinner Hidden
    ...    ${timeout}

PW Click Element Safe
    [Arguments]    ${locator}
    PW Wait For Page Ready
    Wait For Elements State    ${locator}    visible    timeout=${PW_TIMEOUT}
    Scroll To Element          ${locator}
    Click                      ${locator}

PW Input Text
    [Arguments]    ${locator}    ${text}
    PW Wait For Page Ready
    Wait For Elements State    ${locator}    visible    timeout=${PW_TIMEOUT}
    Fill Text                  ${locator}    ${text}

PW Select From Ng Select
    [Arguments]    ${formcontrol}    ${value}
    PW Wait For Page Ready
    PW Click Element Safe    css=ng-select[formcontrolname='${formcontrol}']
    PW Input Text            css=ng-select[formcontrolname='${formcontrol}'] input[type='text']    ${value}
    PW Click Element Safe    xpath=//div[contains(@class,'ng-option') and contains(normalize-space(.), '${value}')]
    Keyboard Key             press    Tab

PW Close Browser
    Close Browser
