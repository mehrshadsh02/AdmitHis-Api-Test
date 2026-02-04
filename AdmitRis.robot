*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
# Library           SeleniumLibrary    implicit_wait=0s    timeout=10s    screenshot_on_failure=False


Suite Setup       Create AdmitRis Session

*** Variables ***
${AdmitRis_Api_URL}       http://192.168.5.19:8023

${AdmitRis_Base_URL}       http://192.168.5.19:8024

${AdmitRis_App_URL}       http://192.168.5.19:8024/admit

${Cash_App_URL}       http://192.168.5.19:8075/admit

${BROWSER}        chrome

${CHROME_DRIVER}    C:/chromedriver.exe

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjIxNDUyMTkzLTdhMWYtNDg3Yy1iZWJiLWZmODQ0ZjUxZTZlMyIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJNRTVvS3RaNFQvNkJ1QkpVZkQ4SFBmT0NubWdNM3VubExyQVpFOEE0QS9MUi8xOGowU3JjYmdLSGQ4SjNaUlIwN1QvaHI1bHYzc2E0c056c0xFMVRjSEYrK0pBLzM1c0JnbE9XTm81bmFBTW93d0hrWnVvMXFKVGhaU2dJblJtVSIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2OTI1Njg1MywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.L_Ay_dfiTErMi-48M8yP1LyOgqTS-IJEKMrh4KH-I9Y

${COOKIE_TOKEN}   eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjIxNDUyMTkzLTdhMWYtNDg3Yy1iZWJiLWZmODQ0ZjUxZTZlMyIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJNRTVvS3RaNFQvNkJ1QkpVZkQ4SFBmT0NubWdNM3VubExyQVpFOEE0QS9MUi8xOGowU3JjYmdLSGQ4SjNaUlIwN1QvaHI1bHYzc2E0c056c0xFMVRjSEYrK0pBLzM1c0JnbE9XTm81bmFBTW93d0hrWnVvMXFKVGhaU2dJblJtVSIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2OTI1Njg1MywiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.L_Ay_dfiTErMi-48M8yP1LyOgqTS-IJEKMrh4KH-I9Y

${GLOBAL_SPINNER}     css=.ngx-spinner-overlay,.loading-overlay,.spinner,.mat-progress-spinner,.cdk-overlay-backdrop

${MAC_ADDRESS}    test

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

    Open Browser    ${AdmitRis_Base_URL}    chrome
    Wait For Page Ready
    Add Cookie    token    ${COOKIE_TOKEN}
    Maximize Browser Window


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

Cash Refund Patient By National Code
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

    Input Text
    ...    xpath=//input[@formcontrolname='comment']
    ...    test

    Wait Until Element Is Visible
    ...    xpath=//button[normalize-space(text())='بازپرداخت']
    ...    30s

    Click Element Safe
    ...    xpath=//button[normalize-space(text())='بازپرداخت']

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

Select Option From Dropdown By Label
    [Arguments]    ${dropdown_xpath}    ${option_text}

    # 1. کلیک برای باز کردن لیست
    Wait Until Element Is Enabled    ${dropdown_xpath}
    Click Element    ${dropdown_xpath}

    # 2. انتظار برای نمایش پنل لیست (باید کلاس یا XPath پنل را پیدا کنید)
    # از XPath عمومی برای پنل لیست Angular استفاده می کنیم. این ممکن است نیاز به تنظیم داشته باشد.
    ${panel_xpath}=    Set Variable    xpath=//div[contains(@class, 'ng-dropdown-panel')]

    Wait Until Element Is Visible    ${panel_xpath}    timeout=5s

    # 3. کلیک بر روی گزینه مورد نظر ("انصراف")
    ${option_xpath}=    Set Variable    xpath=${panel_xpath}//span[text()='${option_text}']
    Wait Until Element Is Visible    ${option_xpath}
    Click Element    ${option_xpath}

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

01-UI - Admit Ris Patient With NationalCode   
    [Documentation]      پذیرش بیمار با کد ملی
    [Tags]    UI_Test
    
    Start Browser AdmitRis With Token
    Go To AdmitRis Page
    Wait For Spinner Hidden    
    Wait For Page Ready
    Wait Until Element Is Visible    //input[@formcontrolname='nationalCode']    10s
    Clear Element Text    //input[@formcontrolname='nationalCode']
    Input Text         //input[@formcontrolname='nationalCode']     ${nationalCode}
    Click Element Safe       xpath=//mat-icon[contains(@class,'btn-search')]
    Wait For Page Ready
    Select From Ng Select    therapistName   Siavash
    Select From Ng Select    shift    صبح
    Select From Ng Select    radiologist    سلدا
    Select From Ng Select    mainComplaint    دل درد
    Input Text    css=input[formcontrolname="medicalAllergy"]       استامینوفن    
    Select From Ng Select    mainGroup    سونو
    Wait Until Element Is Visible    css=button.btn-service    10s
    Click Element Safe       xpath=//button[contains(@class,'btn-service')]
    Wait Until Element Is Visible    css=input[formcontrolname="typeOfServices"]    10s
    Input Text                      css=input[formcontrolname="typeOfServices"]    701520
    Press Keys                      css=input[formcontrolname="typeOfServices"]    ENTER

    ${row}=    Set Variable    xpath=//tr[.//td[contains(@class,'mat-column-salamatCode') and normalize-space(.)='701520']]

    Wait Until Page Contains Element    ${row}    20s
    Wait Until Element Is Visible        ${row}    5s
    Double Click Element                 ${row}
    Wait Until Element Is Visible    xpath=//mat-icon[normalize-space(.)='save']    10s
    Click Element                   xpath=//mat-icon[normalize-space(.)='save']
    Wait Until Element Is Visible    css=button.swal2-confirm    10s
    Click Element                   css=button.swal2-confirm
    Wait Until Element Is Visible
    ...    xpath=//button[normalize-space(.)='چاپ']/parent::div
    ...    10s

    Wait Until Keyword Succeeds    10s    500ms
    ...    Click Element
    ...    xpath=//button[normalize-space(.)='چاپ']/parent::div//button[normalize-space(.)='انصراف']

02-UI - Open Cash Web And Pay
    [Tags]    UI_Test
    
    Cash Pay Patient By National Code    ${nationalCode}    

03-UI - Edit Admit Ris Patient
    [Documentation]    رفتن به سوابق پذیرش و ویرایش پذیرش
    [Tags]    UI_Test    
    
    # Start Browser AdmitRis With Token
    # Go To AdmitRis Page
    # Wait For Spinner Hidden    
    # Wait For Page Ready
    Switch To AdmitRis App
    Click Element Safe    xpath=//app-menu-list-item[.//img[contains(@src,'inpatient.svg')]]   
    Wait For Page Ready   
    Input Text      //input[@formcontrolname='nationalCode']     	${nationalCode}
    Click Element Safe    xpath=//mat-icon[contains(@class,'btn') and normalize-space(.)='search']
    Wait For Page Ready   
    ${row_xpath}=    Set Variable
        ...    //tr[.//td[contains(normalize-space(), '${nationalCode}')]]

    Wait Until Keyword Succeeds
    ...    3x
    ...    5s
    ...    Element Should Be Visible
    ...    ${row_xpath}

    Double Click Element    ${row_xpath}  
    Wait For Page Ready
    Click Element Safe    xpath=//mat-icon[contains(@class,'btn') and normalize-space(.)='edit']
    Wait For Page Ready
    Select From Ng Select    mainGroup    سونو
    Wait Until Element Is Visible    css=button.btn-service    10s
    Click Element Safe       xpath=//button[contains(@class,'btn-service')]
    Wait Until Element Is Visible    css=input[formcontrolname="typeOfServices"]    10s
    Input Text                      css=input[formcontrolname="typeOfServices"]    701535
    Press Keys                      css=input[formcontrolname="typeOfServices"]    ENTER

    ${row}=    Set Variable    xpath=//tr[.//td[contains(@class,'mat-column-salamatCode') and normalize-space(.)='701535']]

    Wait Until Page Contains Element    ${row}    20s
    Wait Until Element Is Visible        ${row}    5s
    Double Click Element                 ${row}
    Wait Until Element Is Visible    xpath=//mat-icon[normalize-space(.)='save']    10s
    Click Element                   xpath=//mat-icon[normalize-space(.)='save']
    Wait For Spinner Hidden


04-UI - cancel Admit Ris Patient   
    [Documentation]    کنسل کردن پذیرش بیمار
    [Tags]    UI_Test
    
    # Start Browser AdmitRis With Token
    # Go To AdmitRis Page
    # Wait For Spinner Hidden
    # Wait For Page Ready   
    # Click Element Safe    xpath=//app-menu-list-item[.//img[contains(@src,'inpatient.svg')]] 
    # Wait For Page Ready
    # Switch To AdmitRis App
    
    Wait For Page Ready
    Input Text      //input[@formcontrolname='nationalCode']     	${nationalCode}
    Click Element Safe    xpath=//mat-icon[contains(@class,'btn') and normalize-space(.)='search']
    Wait For Page Ready   
    ${row_xpath}=    Set Variable
        ...    //tr[.//td[contains(normalize-space(), '${nationalCode}')]]

    Wait Until Keyword Succeeds
    ...    3x
    ...    5s
    ...    Element Should Be Visible
    ...    ${row_xpath}

    Double Click Element    ${row_xpath}  
    Wait For Page Ready
    Click Element Safe    xpath=//mat-icon[contains(@class,'btn') and normalize-space(.)='cancel']
    Wait For Spinner Hidden
    Wait For Page Ready
    Click Element    xpath=//ng-select[.//div[contains(text(),'دلایل حذف *')]]
    
    Wait Until Element Is Visible    xpath=//div[contains(@class,'ng-option')]//span[contains(text(),'انصراف')]
    Click Element    xpath=//div[contains(@class,'ng-option')]//span[contains(text(),'انصراف')]
    
    Wait Until Element Is Visible    xpath=//button[contains(@class,'btn-cancel')]/following-sibling::button[contains(@class,'btn-success')]    5s
    Click Element    xpath=//button[contains(@class,'btn-cancel')]/following-sibling::button[contains(@class,'btn-success')]
   
    Wait Until Element Is Visible    xpath=//button[contains(@class,'swal2-confirm') and contains(text(),'بله')]    10s
    Click Element    xpath=//button[contains(@class,'swal2-confirm') and contains(text(),'بله')]
    
05-UI - Open Cash Web And Refund
    [Documentation]   بازپرداخت به بیمار در صندوق
    [Tags]    UI_Test
    
    Cash Refund Patient By National Code    ${nationalCode}
    
    
