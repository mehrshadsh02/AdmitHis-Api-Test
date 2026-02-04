*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary


Suite Setup       Create AdmitRis Session

*** Variables ***
${AdmitRis_Api_URL}       http://192.168.5.19:8023

${AdmitRis_Base_URL}       http://192.168.5.19:8024

${AdmitRis_App_URL}       http://192.168.5.19:8024/admit

${Cash_App_URL}       http://192.168.5.19:8075/admit

${BROWSER}        chrome

${CHROME_DRIVER}    C:/chromedriver.exe

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjEzZDA1ZDAyLTJhNmMtNDI3Yy1hOTU1LTgwY2U2YzY5MTFlZSIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJTeldwNzAzQXdQcEJoY29yZGhOYWVGZGRuNUFoQzVwQWg4aVNwdzFidHdlN1NwbEF4ZngzWnBpTUJwZjN6T0NUVnBHWFU1WGs2RXl4UE1hYnJlbDdCbmdURlhvSWxnMXB4aWZINkZ3UHM2Nms3WC85alkxTUR5TlVaKy9hd0kvRiIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2OTE5NzUyMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.EO3V9RYmJE6vA3VsTgrr1JXy7b86kwcqzWYD64-lc14

${COOKIE_TOKEN}   eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjEzZDA1ZDAyLTJhNmMtNDI3Yy1hOTU1LTgwY2U2YzY5MTFlZSIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJTeldwNzAzQXdQcEJoY29yZGhOYWVGZGRuNUFoQzVwQWg4aVNwdzFidHdlN1NwbEF4ZngzWnBpTUJwZjN6T0NUVnBHWFU1WGs2RXl4UE1hYnJlbDdCbmdURlhvSWxnMXB4aWZINkZ3UHM2Nms3WC85alkxTUR5TlVaKy9hd0kvRiIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2OTE5NzUyMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.EO3V9RYmJE6vA3VsTgrr1JXy7b86kwcqzWYD64-lc14

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

Post Method
    [Arguments]    ${payload}    ${Api-Url}
    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ${response}=   POST On Session  
    ...    Ris  
    ...    ${Api-Url}
    ...    json=${payload}
    ...    headers=${headers}
    [Return]       ${response}

Get Method
    [Arguments]   ${Api-Url}

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${response}=    GET On Session    
    ...    RIs    
    ...    ${Api-Url}    
    ...    headers=${headers}

    [Return]       ${response}    

*** Test Cases ***

01-Get Configuration
    [Documentation]   دریافت فانفینگ های اعمال شده در appsseting
    [Tags]    API_Configuration    METHOD_GET  

    ${response}=    Get Method
    ...    /api/Configuration/Configuration

    # ---- Status Code ----
    Should Be Equal As Integers    ${response.status_code}    200

    # ---- Convert response to JSON ----
    ${json}=    To JSON    ${response.content}

    # ---- Validate Required Keys Exist ----
    Dictionary Should Contain Key    ${json}    patientConfig
    Dictionary Should Contain Key    ${json}    frontConfiguration

    # ---- Validate patientConfig keys ----
    ${patientCfg}=    Get From Dictionary    ${json}    patientConfig
    Should Contain    ${patientCfg}    maritalStatus
    Should Contain    ${patientCfg}    birthPlace
    Should Contain    ${patientCfg}    city
    Should Contain    ${patientCfg}    insur_Relation
    Should Contain    ${patientCfg}    birthPlaceOut
    Should Contain    ${patientCfg}    mobile
    Should Contain    ${patientCfg}    medicalAllergy
    Should Contain    ${patientCfg}    mainComplaint

    # ---- Validate frontConfiguration keys ----
    ${frontCfg}=    Get From Dictionary    ${json}    frontConfiguration
    Should Contain    ${frontCfg}    salamatPrescriptionApi
    Should Contain    ${frontCfg}    taminPrescriptionApi
    Should Contain    ${frontCfg}    consumptionApi
    Should Contain    ${frontCfg}    reportApi
    Should Contain    ${frontCfg}    directPortSalamat
    Should Contain    ${frontCfg}    directPortTamin
    Should Contain    ${frontCfg}    admitSave
    Should Contain    ${frontCfg}    print
    Should Contain    ${frontCfg}    radiologist
    Should Contain    ${frontCfg}    hasConsuming
    Should Contain    ${frontCfg}    hasInquiry
    Should Contain    ${frontCfg}    validMobileNumber
    Should Contain    ${frontCfg}    hasCpoe
    Should Contain    ${frontCfg}    allowEditAfterAnswering
    Should Contain    ${frontCfg}    centerHasShift
    Should Contain    ${frontCfg}    defaultDateInPatientList
    Should Contain    ${frontCfg}    changeMacAddress
    Should Contain    ${frontCfg}    logoPrintReceipt
    Should Contain    ${frontCfg}    centerPhoneNumber
    Should Contain    ${frontCfg}    centerName
    Should Contain    ${frontCfg}    cashApi

02-Dynamic Role Claims Manager
    [Documentation]   دریافت کد های دسترسی کاربر
    [Tags]    API_DynamicRoleClaimsManager  METHOD_POST  

    ${payload}=     Create List    1195

    ${response}=    Post Method    ${payload}  /api/DynamicRoleClaimsManager/RawDynamicPermissions
    
    Should Be Equal As Integers    ${response.status_code}    200

    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json[0]}    True

03-Get Standard Variables
    [Documentation]    دریافت Standard Variables بر اساس systemCodeId
    [Tags]    API_AdmitRis    METHOD_POST    

    ${payload}=    Create List
    ...    135    136    141    142    137    138
    ...    139    152    234    235    236    233

    ${response}=    Post Method
    ...    ${payload}
    ...    /api/AdmitRis/GetStandardVariables

    Should Be Equal As Integers    ${response.status_code}    200

    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}

    FOR    ${item}    IN    @{json}
        Dictionary Should Contain Key    ${item}    systemCodeId
        Dictionary Should Contain Key    ${item}    standardVariableId
        Dictionary Should Contain Key    ${item}    name
        Dictionary Should Contain Key    ${item}    isActive

        Should Be True    ${item['systemCodeId']} > 0
        Should Be True    ${item['standardVariableId']} > 0
    END

    ${doctor}=    Evaluate
    ...    next(x for x in $json if x['systemCodeId'] == 135)

    Should Be Equal As Strings    ${doctor['name']}    جناب آقاي دكتر
    Should Be Equal As Integers   ${doctor['clinicTitleType']}    0

04-GetReasonsForRemoveFromInsurance
    [Documentation]    دریافت دلایل حذف از لیست ارسال به بیمه
    [Tags]    API_GeneralVariables    METHOD_GET   

    ${response}=    Get Method
    ...    /api/GeneralVariables/GetAllTheReasonsForRemoveFromTheListSentToInsurance

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}

    Should Be True               ${body['isSuccess']}
    Should Be Equal As Integers  ${body['statusCode']}    200
    Should Be Equal As Strings   ${body['message']}       Success

    ${data}=    Set Variable    ${body['data']}
    Should Not Be Empty          ${data}

    FOR    ${item}    IN    @{data}
        Dictionary Should Contain Key    ${item}    reason
        Dictionary Should Contain Key    ${item}    reasonId

        Should Be True    ${item['reasonId']} > 0
        Should Not Be Empty    ${item['reason']}
    END

    ${ids}=    Create List
    FOR    ${item}    IN    @{data}
        Append To List    ${ids}    ${item['reasonId']}
    END

    List Should Not Contain Duplicates    ${ids}

    ${missing_insurance}=    Evaluate
    ...    next((x for x in $data if x['reasonId'] == 157), None)

    Should Not Be Equal    ${missing_insurance}    ${None}
   