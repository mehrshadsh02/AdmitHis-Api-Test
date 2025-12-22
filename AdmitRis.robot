*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
Library           SeleniumLibrary    screenshot_on_failure=False


Suite Setup       Create AdmitRis Session

*** Variables ***
${AdmitRis_Api_URL}       http://192.168.5.19:8023

${AdmitRis_App_URL}       http://192.168.5.19:8024

${Cash_App_URL}       http://192.168.5.19:8075/admit

${BROWSER}        chrome

${CHROME_DRIVER}    C:/chromedriver.exe

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6Ijc0YzcwOGU5LTVkMTEtNDAxMC05ZmFiLTM5ZjUxZDc4MmM0YiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxNzIuMjYuNTkuNyIsIk5QSUQiOiIiLCJ1c2luZiI6IjA2SzB6UUdFeTlNRmFKK0xobzRWdFl4bEowcVcwcktZVTgyUkRSbEtEQ0g2RkhNVk96STJJZGF6Z09DNmp1enNCOTBGMDkyS3RQNjVDNWhDQ2ZReU5ma28zRzg0czB0S242NDZhdG5IUHZYazV0S05MYkh1T1pCTFE0QmRNZVlQIiwiQ0lEIjoiIiwiQUlEIjoiMTAwIiwiQ2VudGVyTmFtZSI6ItmF2LHaqdiyINiq2YfYsdin2YYiLCJVc2VyRW1haWxBZGRyZXNzIjoiIiwiRHluYW1pY1Blcm1pc3Npb25LZXkiOiIzMjM5NjAzOGZjYTAxY2I2OWQyYzQ0YjA5NjQ2MjRkMWZlNDYxYzk3ODBjZmZjN2Y5NTU4MmE4YWE5NzdjMmExIiwiSWRsZXRpbWUiOiIyNDAiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiY2hlY2siLCJyb2xlIl0sIlJvbGVJZCI6MTE5NSwiZXhwIjoxNzY2NDQ4MzQ5LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0Ojc3NDAvIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDoyNjU4LyJ9.vweE9jfBq4xhu_QHkCrL3JwjcdZY1XZUtiSbQ4QYkJU

${COOKIE_TOKEN}   eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6Ijc0YzcwOGU5LTVkMTEtNDAxMC05ZmFiLTM5ZjUxZDc4MmM0YiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxNzIuMjYuNTkuNyIsIk5QSUQiOiIiLCJ1c2luZiI6IjA2SzB6UUdFeTlNRmFKK0xobzRWdFl4bEowcVcwcktZVTgyUkRSbEtEQ0g2RkhNVk96STJJZGF6Z09DNmp1enNCOTBGMDkyS3RQNjVDNWhDQ2ZReU5ma28zRzg0czB0S242NDZhdG5IUHZYazV0S05MYkh1T1pCTFE0QmRNZVlQIiwiQ0lEIjoiIiwiQUlEIjoiMTAwIiwiQ2VudGVyTmFtZSI6ItmF2LHaqdiyINiq2YfYsdin2YYiLCJVc2VyRW1haWxBZGRyZXNzIjoiIiwiRHluYW1pY1Blcm1pc3Npb25LZXkiOiIzMjM5NjAzOGZjYTAxY2I2OWQyYzQ0YjA5NjQ2MjRkMWZlNDYxYzk3ODBjZmZjN2Y5NTU4MmE4YWE5NzdjMmExIiwiSWRsZXRpbWUiOiIyNDAiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiY2hlY2siLCJyb2xlIl0sIlJvbGVJZCI6MTE5NSwiZXhwIjoxNzY2NDQ4MzQ5LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0Ojc3NDAvIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDoyNjU4LyJ9.vweE9jfBq4xhu_QHkCrL3JwjcdZY1XZUtiSbQ4QYkJU

${GLOBAL_SPINNER}     css=.ngx-spinner-overlay,.loading-overlay,.spinner,.mat-progress-spinner,.cdk-overlay-backdrop

${nationalCode}    1520554001

${firstName}    مهرشاد

${lastName}     شیخ الاسلامی    

${fatherName}   مهرداد

${FileFormationID}  683676 

${Admit_ID}    

*** Keywords ***

Create AdmitRis Session
    Create Session    RIS    ${AdmitRis_Api_URL}   verify=${False}
    
# َAdmit_Ris  
Start Browser AdmitRis With Token
    [Documentation]    باز کردن کروم + تزریق کوکی token
    Open Browser    ${AdmitRis_App_URL}    chrome
    Add Cookie    token    ${COOKIE_TOKEN}
    Maximize Browser Window
    Reload Page

Go To AdmitRis Page
    [Documentation]    رفتن مستقیم به صفحه پذیرش طب تصویری
    Go To    ${AdmitRis_App_URL}
    Reload Page

Switch To AdmitRis App
    Go To    ${AdmitRis_App_URL}
    Wait Until Location Contains    8024  
    Wait For Spinner Hidden
    Wait For Page Ready  

# Cash

Switch To Cash App
    Go To    ${Cash_App_URL}
    Wait Until Location Contains    8075
    Wait For Spinner Hidden
    Wait For Page Ready
    

Start Browser Cash With Token
    [Documentation]   باز کردن صندوق وب
    Open Browser    ${Cash_App_URL}    chrome
    Add Cookie    token    ${COOKIE_TOKEN}
    Maximize Browser Window
    Reload Page

Go To Cash Page
    [Documentation]    باز کردن صندوق وب
    Go To    ${Cash_App_URL}
    Reload Page

Cash Pay Patient By National Code
    [Arguments]    ${nationalCode}
    [Documentation]    Open Cash App, search patient by national code and complete payment flow

    Wait For Page Ready
    Switch To Cash App
    Wait For Page Ready
    Wait For Spinner Hidden

    Input Text
    ...    xpath=//input[@formcontrolname='nationalCode']
    ...    ${nationalCode}

    Wait For Page Ready

    Click Element Safe
    ...    xpath=//button[contains(@class,'btn-warning') and .//mat-icon[.='search']]

    Wait For Page Ready
    Wait For Spinner Hidden

    ${row_xpath}=    Set Variable
    ...    //tr[.//td[contains(normalize-space(), '${nationalCode}')]]

    Wait Until Keyword Succeeds
    ...    3x
    ...    5s
    ...    Element Should Be Visible
    ...    ${row_xpath}

    Double Click Element    ${row_xpath}

    Wait Until Element Is Visible
    ...    xpath=//button[normalize-space(text())='پرداخت']
    ...    30s

    Click Element Safe
    ...    xpath=//button[normalize-space(text())='پرداخت']

    Wait For Page Ready

    Click Element Safe
    ...    xpath=//button[contains(@class,'swal2-confirm') and normalize-space(.)='بله']


# General
Wait For Spinner Hidden
    [Documentation]    صبر کردن تا loading Angular ناپدید شود
    Wait Until Element Is Not Visible    css=div.back-spenner.ng-star-inserted    1000

Select From Ng Select
    [Arguments]    ${formcontrol}    ${value}
    Wait For Spinner Hidden

    Wait Until Element Is Visible
    ...    css=ng-select[formcontrolname='${formcontrol}']
    Click Element
    ...    css=ng-select[formcontrolname='${formcontrol}']

    Wait Until Element Is Visible
    ...    css=ng-select[formcontrolname='${formcontrol}'] input[type='text']
    Input Text
    ...    css=ng-select[formcontrolname='${formcontrol}'] input[type='text']
    ...    ${value}

    Wait Until Element Is Visible
    ...    xpath=//div[contains(@class,'ng-option') and contains(normalize-space(.), '${value}')]
    Click Element
    ...    xpath=//div[contains(@class,'ng-option') and contains(normalize-space(.), '${value}')]

    Press Keys
    ...    css=ng-select[formcontrolname='${formcontrol}'] input[type='text']
    ...    TAB

Click Element Safe
    [Arguments]    ${locator}
    Wait For Spinner Hidden
    Wait Until Element Is Visible    ${locator}
    Wait Until Element Is Enabled    ${locator}
    Scroll Element Into View         ${locator}
    Click Element                    ${locator}     

Wait For Page Ready
    [Arguments]    ${timeout}=30

    Run Keyword And Ignore Error
    ...    Wait Until Page Contains Element
    ...    ${GLOBAL_SPINNER}
    ...    3

    Wait Until Element Is Not Visible
    ...    ${GLOBAL_SPINNER}
    ...    ${timeout}      


*** Test Cases ***

1-UI-Open Filing Page
    [Documentation]   باز  کردن صفحه پذیرش طب تصویری
    [Tags]    STEP_01_Open_Browser    UI_Test    
    Start Browser AdmitRis With Token
    Go To AdmitRis Page
    Wait For Spinner Hidden
    Log To Console    ---- DONE ----
