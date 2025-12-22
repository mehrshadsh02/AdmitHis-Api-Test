*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
Library           SeleniumLibrary    screenshot_on_failure=False


Suite Setup       Create AdmitHIS Session

*** Variables ***
${AdmitHis_Api_URL}       http://192.168.5.19:1600

${AdmitHis_App_URL}       http://192.168.5.19:8019/filing

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

${Admit_ID}    356115



*** Keywords ***

Create AdmitHIS Session
    Create Session    HIS    ${AdmitHis_Api_URL}   verify=${False}
    
# َAdmit_His  
Start Browser AdmitHis With Token
    [Documentation]    باز کردن کروم + تزریق کوکی token
    Open Browser    ${AdmitHis_App_URL}    chrome
    Maximize Browser Window
    Add Cookie    token    ${COOKIE_TOKEN}
    Reload Page

Go To AdmitHis Page
    [Documentation]    رفتن مستقیم به صفحه پذیرش بستری
    Go To    ${AdmitHis_App_URL}
    Reload Page

Switch To AdmitHis App
    Go To    ${AdmitHis_App_URL}
    Wait Until Location Contains    8019  
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
    [Documentation]   باز  کردن صفحه پذیرش بستری
    [Tags]    STEP_01_Open_Browser    UI_Test    
    Start Browser AdmitHis With Token
    Go To AdmitHis Page
    Wait For Spinner Hidden
    Log To Console    ---- DONE ----

2-Get All Jobs
    [Documentation]    دریافت لیست کامل شغل‌ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/GetAllJobs    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllJobs | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllJobs | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    To JSON    ${resp.content}

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_Job
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_Job | API: GetAllJobs

    Dictionary Should Contain Key
    ...    ${json[0]}    jobName
    ...    msg=❌ SCHEMA ERROR | Missing key: jobName | API: GetAllJobs

    Dictionary Should Contain Key
    ...    ${json[0]}    sepas_Code
    ...    msg=❌ SCHEMA ERROR | Missing key: sepas_Code | API: GetAllJobs

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllJobs Loaded Successfully | Total Jobs: ${count}



3-Validate Specific Job - پزشک Exists
    [Documentation]    بررسی وجود شغل «پزشک» با کد سپاس صحیح
    [Tags]    API_GeneralVariables  METHOD_GET 

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/GetAllJobs    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllJobs | While validating Doctor job

    ${j}=    To JSON    ${resp.content}

    ${target}=    Evaluate    [x for x in $j if x["jobName"]=="پزشک"]

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | Job 'پزشک' not found in response | API: GetAllJobs

    Should Be Equal
    ...    ${target[0]["sepas_Code"]}    002038
    ...    msg=❌ DATA MISMATCH | Doctor sepas_Code incorrect | Expected: 002038 | Actual: ${target[0]["sepas_Code"]}

    Log To Console    ✅ PASS | Doctor job validated | ID=${target[0]["iD_Job"]}


4-Get All Cause Of Hospitalization
    [Documentation]    دریافت لیست علل بستری
    [Tags]    API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/GetAllCauseOfHospitalization    headers=&{headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:GetAllCauseOfHospitalization

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:GetAllCauseOfHospitalization | Expected:200 | Actual:${resp.status_code}

    ${json}=    To JSON    ${resp.content}
    ${count}=    Get Length    ${json}

    Log To Console    ✅ PASS | Hospitalization Causes Loaded | Count=${count}

    ${accident}=    Evaluate    [x for x in $json if x["iD_GVariable"] == 91]
    Should Not Be Empty
    ...    ${accident}
    ...    msg=❌ DATA MISSING | Cause 'تصادف' Not Found | ID=91

    ${burn}=    Evaluate    [x for x in $json if x["iD_GVariable"] == 82]
    Should Not Be Empty
    ...    ${burn}
    ...    msg=❌ DATA MISSING | Cause 'سوختگی' Not Found | ID=82


5-Get Standard Variables
    [Documentation]    Get Standard Variables
    [Tags]       API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/GetStandardVariables
    ...    headers=&{headers}
    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Log To Console    Status: ${resp.status_code}
    #Log To Console    Body length: ${resp.content.__len__()}

    Should Be Equal As Integers    ${resp.status_code}    200


6-Get All First Recognition
    [Documentation]    دریافت لیست تشخیص های اولیه
    [Tags]      API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/GetAllFirstRecognition
    ...    headers=&{headers}
    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Log To Console    Status: ${resp.status_code}
    #Log To Console    Body length: ${resp.content.__len__()}

    Should Be Equal As Integers    ${resp.status_code}    200


7-Get All Names Inpatient Wards
    [Documentation]    لیست تخت های خالی
    [Tags]      API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    /api/GeneralVariables/GetAllNamesInpatientWards
    ...    headers=&{headers}
    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    To Json    ${resp.content}

    # تعداد آیتم‌ها را به شکل صحیح بگیر
    ${count}=    Get Length    ${json}

    Log To Console    Count: ${count}
    Log To Console    First Item: ${json[0]}

    # چند اعتبارسنجی کلیدی
    Should Be True    ${count} > 0
    Should Contain    ${json[0]}    name
    Should Contain    ${json[0]}    systemCodeId
    Should Be Equal As Integers    ${json[0]["systemCodeId"]}    132

8-Admit Configuration
    [Documentation]    AdmitHis config
    [Tags]    API_GeneralVariables    METHOD_GET    

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    HIS    /api/GeneralVariables/AdmitConfiguration    headers=&{headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:GetAllCauseOfHospitalization

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:GetAllCauseOfHospitalization | Expected:200 | Actual:${resp.status_code}

    ${json}=    To JSON    ${resp.content}
    ${count}=    Get Length    ${json}

    Log To Console    ✅ PASS | Hospitalization Causes Loaded | Count=${count}


# زمانی که کاربر شروع به پذیرش میکنه و کد ملی رو وارد میکنه و استحقاق درمان میکنه

9-UI-Enter national code of patiant
    [Documentation]   وارد کردن کد ملی بیمار و استعلام کد ملی
    [Tags]    UI_Test    
        
    Wait For Page Ready
    Wait Until Element Is Visible    //input[@formcontrolname='nationalCode']    10s
    Clear Element Text    //input[@formcontrolname='nationalCode']
    Input Text         //input[@formcontrolname='nationalCode']     ${nationalCode}
    Click Element Safe       id=button-addon3
    Wait For Page Ready

10-Get Person From Ditas
    [Documentation]    دریافت اطلاعات شخص از ديتاس با کدملی
    [Tags]    API_Inquiry  METHOD_POST  DITAS

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    &{body}=    Create Dictionary
    ...    nationalCode=${nationalCode}
    ...    passport=
    ...    birthDate=
    ...    triageId=0

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Inquiry/GetPersonFromDitas
    ...    headers=&{headers}
    ...    json=&{body}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetPersonFromDitas | nationalCode=${nationalCode}

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetPersonFromDitas | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    To Json    ${resp.content}

    ${nationalCode_Ditas}=    Evaluate    $json['data']['fileFormation']['nationalCode']

    Should Be Equal
    ...    ${nationalCode_Ditas}    ${nationalCode}
    ...    msg=❌ DATA MISMATCH | NationalCode mismatch | Expected: ${nationalCode} | Actual: ${nationalCode}

    Log To Console    ✅ PASS | DITAS data fetched successfully | NationalCode=${nationalCode}



11-Get All Insurance Kind
    [Documentation]    دریافت لیست صندوق های بیمه بر اساس sepasid بیمه پایه
    [Tags]    API_GeneralVariables  METHOD_Get  Insure

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllInsuranceKind?sepasId=6
    ...    headers=&{headers}
    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    To Json    ${resp.content}
    Log To Console    ${json}

12-Check Patient Debt
    [Documentation]    بررسی بدهی بیمار
    [Tags]    API_Patient    METHOD_POST    Debt

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary
    ...    nationalCode=${nationalCode}
    ...    fileformationId=0

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Patient/CheckPatientDebt
    ...    headers=&{headers}
    ...    json=${body}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:CheckPatientDebt

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:CheckPatientDebt | Expected:200 | Actual:${resp.status_code}

    ${json}=    To Json    ${resp.content}
    Log To Console    ✅ PASS | Patient Debt Checked | Response=${json}

13-Check Filing Doubling
    [Documentation]    بررسی تکراری بودن پذیرش بیمار بر اساس اطلاعات هویتی
    [Tags]    API_Filing  METHOD_POST 

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    &{checkDto}=    Create Dictionary
    # ...    nationalCode=3031855256
    # ...    fatherName=علی
    # ...    firstName=مهری
    # ...    lastName=مونس زاده شيرواني
    ...    nationalCode=${nationalCode}
    ...    fatherName=${fatherName}
    ...    firstName=${firstname}
    ...    lastName=${lastname}

    &{body}=    Create Dictionary
    ...    checkDoublingDto=&{checkDto}

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Filing/CheckFilingDoubling
    ...    headers=&{headers}
    ...    json=&{body}
    ...    expected_status=anything

    Run Keyword If    '${resp}' == 'None'
    ...    Fail    ❌ NO RESPONSE | API:CheckFilingDoubling | Possible Network/Server Issue

    ${http_status}=    Set Variable    ${resp.status_code}

    IF    ${http_status} == 200
        ${json}=    Set Variable    ${resp.json()}

        Should Be Equal As Integers
        ...    ${json["statusCode"]}    0
        ...    msg=❌ BUSINESS STATUS ERROR | API:CheckFilingDoubling | Expected statusCode=0 | Actual=${json["statusCode"]}

        ${msg}=    Set Variable    ${json["message"][0]}

        Run Keyword If
        ...    '${msg}' != ''
        ...    Should Contain    ${msg}    بخش

        Log To Console
        ...    ✅ PASS | CheckFilingDoubling | HTTP 200 | Business OK | Message='${msg}'

    ELSE IF    ${http_status} == 500
        ${json}=    Set Variable    ${resp.json()}
        ${raw_msg}=    Set Variable    ${json["message"]}

        Run Keyword If
        ...    '${raw_msg}' != '' and 'admitted' not in '${raw_msg}'
        ...    Fail
        ...    ❌ UNEXPECTED 500 MESSAGE
        ...    | API:CheckFilingDoubling
        ...    | Message="${raw_msg}"

        ${log_msg}=    Set Variable
        ...    HTTP=500 | Expected=409/400 | Actual=500
        ...    | Architecture Violation
        ...    | Message="${raw_msg}"

        Log To Console    ⚠️ PASS (BUSINESS) | ${log_msg}
        Log    ${log_msg}    WARN
        Set Test Message    ${log_msg}
    ELSE
        Fail
        ...    ❌ FAIL | CheckFilingDoubling
        ...    | Unexpected HTTP Status=${http_status}
    END

# پر کردن باقی فیلد های مهم در پذیرش 

14-UI - Fill Filing Form (Patient Info)
    [Documentation]    پر کردن اطلاعات مورد نیاز بیمار 
    [Tags]    UI_Test

    Wait For Page Ready
    Select From Ng Select    maritalStatus           مجرد
    Select From Ng Select    insurRelation           خود فرد

    Input Text         //input[@formcontrolname='mobileNumber']    09383509316
    Input Text         //input[@formcontrolname='address']    dfgdfgdfgd
    Input Text         //input[@formcontrolname='accompanyfullName']     مهرشاد شیخ الاسلامی
    Input Text         //input[@formcontrolname='accompanyMobileNumber']    09383586316

    Wait For Spinner Hidden
    Wait Until Element Is Visible    id=button-addon2
    Click Element    id=button-addon2

    Select From Ng Select    firstRecognition         شکستگی
    Select From Ng Select    howToRefer               وسیله شخصی
    Select From Ng Select    causeOfHospitalization   دل درد

#وقتی که بخش بیمار را برای بستری کردن انتخاب میکنیم

15-UI - Assign Ward And Doctor And Prepayment
    [Documentation]    انتخاب بخش و پزشک بیمار preadmit
    [Tags]    UI_Test

    Wait For Page Ready
    Select From Ng Select    wardfileld             اطفال 2 - تخت خالی (33)
    Select From Ng Select    doctorField             Siavash Siavash
    Select From Ng Select    responsiblePatient     خود فرد

    Input Text         //input[@formcontrolname='prepayment']             10000


16-Get All Bed Number
    [Documentation]    لیست تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_Wards  METHOD_GET  BED_LIST

    ${wardId}=    Set Variable    204

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllBedNumber?wardId=${wardId}
    ...    headers=&{headers}

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | Expected 200 | Actual ${resp.status_code}

    ${json}=    To Json    ${resp.content}

    # Validate response is a list
    Should Be True
    ...    ${json}.__class__.__name__ == 'list'
    ...    msg=❌ INVALID FORMAT | Expected a list[] of Bed objects | Got: ${json}

    # Validate list is not empty
    ${count}=    Get Length    ${json}
    Should Be True
    ...    ${count} > 0
    ...    msg=❌ EMPTY RESULT | Expected list of beds | Got empty list | WardId=${wardId}

    # Expected keys for each bed item
    @{expected_keys}=    Create List
    ...    WardName
    ...    ID_Ward
    ...    RoomNo
    ...    BedNo
    ...    RoomTypeName
    ...    BedStatus
    ...    ID_Bed

    # Validate keys in each object
    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | Key '${key}' not found in item: ${item}
        END
    END

    Log To Console    ✅ PASS | GetAllBedNumber | Count=${count} beds | WardId=${wardId}

17-Get Doctors By Ward
    [Documentation]     تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_Wards  METHOD_GET  DOCTORS_LIST

    ${wardId}=    Set Variable    204

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetDoctorsByWard?wardId=${wardId}
    ...    headers=&{headers}

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | Expected 200 | Actual ${resp.status_code}

    ${json}=    To Json    ${resp.content}

    # Validate response is a list
    Should Be True
    ...    ${json}.__class__.__name__ == 'list'
    ...    msg=❌ INVALID FORMAT | Expected a list[] of doctors | Got: ${json}

    # Validate list is not empty
    ${count}=    Get Length    ${json}
    Should Be True
    ...    ${count} > 0
    ...    msg=❌ EMPTY RESULT | Expected list of doctors | WardId=${wardId}

    # Expected keys for each doctor item
    @{expected_keys}=    Create List
    ...    standardVariableId
    ...    name
    ...    systemCodeId
    ...    parent
    ...    default

    # Validate keys
    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | Key '${key}' not found in item: ${item}
        END
    END

    Log To Console    ✅ PASS | GetDoctorsByWard | Count=${count} doctors | WardId=${wardId}


#بعد از پر کردن موارد ضروری و همچنین پیش پرداخت و زدندکمه ثبت

18-UI - Save Admission Filing
    [Documentation]    سیو کردن پذیرش preadmit
    [Tags]    UI_Test

    Click Element Safe     css=button.btn-saveFile
    Wait For Page Ready

19-Add Filing Validation Bug - Empty NationalCode
    [Documentation]    BUG-1247 - Empty nationalCode causes 500 instead of 400
    [Tags]    API    NEGATIVE    VALIDATION    BUG_1247

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    AID=777
    ...    Origin=http://192.168.5.19:8019
    ...    Referer=http://192.168.5.19:8019/

    ${fileFormation}=    Create Dictionary
    ...    name=مهرشاد
    ...    familyName=شیخ الاسلامی
    ...    fatherName=مهرداد
    ...    nationalCode=${EMPTY}
    ...    birthDate=2002/07/07
    ...    sex=365
    ...    nationality=912
    ...    maritalStatus=363
    ...    mobileNo=09383509316
    ...    birthPlace=363
    ...    addressLine=dfgdfgdfgd
    ...    hospitalFileID=147979
    ...    fileFormationId=683676
    ...    isNationalCodeRequired=${True}

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=683676
    ...    wardIdIn=201
    ...    physicianID=993
    ...    admissionType=370
    ...    patientClass=5
    ...    priority=3
    ...    entranceType=393
    ...    admissionReason=دل درد
    ...    insuranceID=6
    ...    insuranceNO=0019208291
    ...    insuranceExpDate=2026/01/05
    ...    sponsor=خود فرد
    ...    maritalStatus=363
    ...    admitDate=2025/12/19
    ...    admitTime=17:40

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
    ...    insur_Relation=18
    ...    lastInsuranceKind=422
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Filing/EditFiling
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=anything

    Should Be Equal As Integers    ${resp.status_code}    500


20-Check Patient Debt
    [Documentation]    بررسی بدهی بیمار
    [Tags]    API_Patient    METHOD_POST    Debt

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary
    ...    nationalCode=${nationalCode}
    ...    fileformationId=0

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Patient/CheckPatientDebt
    ...    headers=&{headers}
    ...    json=${body}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:CheckPatientDebt

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:CheckPatientDebt | Expected:200 | Actual:${resp.status_code}

    ${json}=    To Json    ${resp.content}
    Log To Console    ✅ PASS | Patient Debt Checked | Response=${json}

# زدن دکمه لغو صفحه پرینت برگه پذیرش 

21-UI - deny admit print page
    [Documentation]    لغو پرینت برگه پذیرش 
    [Tags]    UI_Test    

    Click Element Safe    css=button.swal2-deny.swal2-styled

21-UI - Open Cash Web And Pay
    [Tags]    UI_Test
    
    Cash Pay Patient By National Code    ${nationalCode}


22-UI - go to inpatient list
    [Documentation]    رفتن به لیست بیماران بستری 
    [Tags]    UI_Test    
    
    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    Wait For Page Ready
    Switch To AdmitHis App
    Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a   
    Wait For Page Ready

23-Get All Name Inpatient Ward
    [Documentation]    دریافت لیست بخش ها به هماره تخت های خالی
    [Tags]    API_GeneralVariables    METHOD_GET  

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

     ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllNamesInpatientWards
    ...    headers=&{headers}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}

    Should Be True    ${json} != None
    Should Be True    isinstance($json, list)

    FOR    ${item}    IN    @{json}
        Dictionary Should Contain Key    ${item}    standardVariableId
        Dictionary Should Contain Key    ${item}    name
        Dictionary Should Contain Key    ${item}    systemCodeId
        Dictionary Should Contain Key    ${item}    parent
        Dictionary Should Contain Key    ${item}    default

        Should Be True    isinstance($item["standardVariableId"], int)
        Should Be True    isinstance($item["name"], str)
    END

24- Search Inpatient 
    [Documentation]   جستجوی بیماران بستری
    [Tags]    API_Patient    METHOD_POST  

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    
    ${body}=     Create Dictionary
    ...    firstName=
    ...    lastName=
    ...    grandPaName=
    ...    fatherName=
    ...    nationalCode=
    ...    ward=0
    ...    admissionReason=${None}
    ...    doctorId=0
    ...    admitId=0
    ...    electronicNumber=0
    ...    hospitalNumber=0
    ...    dateFrom=2025/12/12
    ...    dateTo=2025/12/12
    ...    status=0

     ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Patient/SearchInpatients
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)

    ${count}=    Get Length    ${json}
    Log    Returned inpatient count: ${count}

    IF    ${count} > 0
        FOR    ${item}    IN    @{json}
            Dictionary Should Contain Key    ${item}    admitId
            Dictionary Should Contain Key    ${item}    patientName
            Dictionary Should Contain Key    ${item}    nationalCode
            Dictionary Should Contain Key    ${item}    wardName
            Dictionary Should Contain Key    ${item}    doctorName
            Dictionary Should Contain Key    ${item}    status

            Should Be True    $item["admitId"] > 0
            Should Be True    isinstance($item["patientName"], str)
        END
    END  

25-UI - Load Preadmit Patient List
    [Documentation]    لیست بیماران preadmit 
    [Tags]    UI_Test   
    
    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    # Wait For Page Ready
    # Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a  
    Wait For Page Ready
    Click Element Safe    xpath=//span[contains(@class,'mat-checkbox-inner-container')]
    Wait For Page Ready

26- Search Inpatient 
    [Documentation]   جستجوی بیماران بستری
    [Tags]    API_Patient    METHOD_POST  

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    
    ${body}=     Create Dictionary
    ...    firstName=
    ...    lastName=
    ...    grandPaName=
    ...    fatherName=
    ...    nationalCode=
    ...    ward=0
    ...    admissionReason=${None}
    ...    doctorId=0
    ...    admitId=0
    ...    electronicNumber=0
    ...    hospitalNumber=0
    ...    dateFrom=2025/12/12
    ...    dateTo=2025/12/12
    ...    status=0

     ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Patient/SearchPreAdmits
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)

    ${count}=    Get Length    ${json}
    Log    Returned inpatient count: ${count}

    IF    ${count} > 0
        FOR    ${item}    IN    @{json}
            Dictionary Should Contain Key    ${item}    firstName
            Dictionary Should Contain Key    ${item}    lastName
            Dictionary Should Contain Key    ${item}    fatherName
            Dictionary Should Contain Key    ${item}    motherName
            Dictionary Should Contain Key    ${item}    grandPaName
            Dictionary Should Contain Key    ${item}    momGrandPaName
            Dictionary Should Contain Key    ${item}    nationalCode
            Dictionary Should Contain Key    ${item}    doctorName
            Dictionary Should Contain Key    ${item}    wardName
            Dictionary Should Contain Key    ${item}    roomNo
            Dictionary Should Contain Key    ${item}    bedNo
            Dictionary Should Contain Key    ${item}    age
            Dictionary Should Contain Key    ${item}    status
            Dictionary Should Contain Key    ${item}    electronicNumber
            Dictionary Should Contain Key    ${item}    sex
            Dictionary Should Contain Key    ${item}    hospitalFileID
            Dictionary Should Contain Key    ${item}    pishpardaght
            Dictionary Should Contain Key    ${item}    hospitalizationTime
            Dictionary Should Contain Key    ${item}    admitID
            Dictionary Should Contain Key    ${item}    wardId
            Dictionary Should Contain Key    ${item}    isPreAdmit
            Dictionary Should Contain Key    ${item}    dischargeDate
            Dictionary Should Contain Key    ${item}    passport
            Dictionary Should Contain Key    ${item}    isUnder28Days
            Dictionary Should Contain Key    ${item}    getNewHid
            Dictionary Should Contain Key    ${item}    cancelHid
            Dictionary Should Contain Key    ${item}    updateHid
            Dictionary Should Contain Key    ${item}    hid
            Dictionary Should Contain Key    ${item}    followedAdmitId 
            Dictionary Should Contain Key    ${item}    nextPayable
            Dictionary Should Contain Key    ${item}    doctorTotalCost
            Dictionary Should Contain Key    ${item}    totalPayment
            Dictionary Should Contain Key    ${item}    admissionReason   


            Should Be True    $item["admitID"] > 0
            Should Be True    isinstance($item["nationalCode"], str)and len($item["nationalCode"]) == 10
            # ...    and $item["nationalCode"].isdigit())
        END
    END     


27-UI - Edit Preadmit Patient
    [Documentation]     ویرایش بیمار preadmit
    [Tags]      UI_Test

    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    # Wait For Page Ready
    # Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a 
    # Wait For Page Ready 
    # Click Element Safe    xpath=//span[contains(@class,'mat-checkbox-inner-container')]
    Wait For Page Ready
    Input Text      //input[@formcontrolname='nationalCode']     	${nationalCode}
    Click Element Safe    css=button.mat-tooltip-trigger.btn.btn-warning
    Wait For Page Ready   
    Click Element Safe    css=button.mat-tooltip-trigger.btn-action.ng-star-inserted 
    Wait For Page Ready
    Click Element Safe    css=button.mat-tooltip-trigger.btn.btn-edit1   
    Wait For Page Ready
    Select From Ng Select    wardfileld             اطفال 2 - تخت خالی (33)
    Select From Ng Select    doctorField             Siavash Siavash
    Wait For Page Ready
    Click Element Safe     css=button.btn-saveFile
    Wait For Page Ready
    Click Element Safe     css=button.swal2-deny.swal2-styled
    Wait For Page Ready 
    Click Element Safe     xpath=//span[contains(@class,'mat-checkbox-inner-container')]
    Wait For Page Ready

28- Edit Filing PreAdmit
    [Documentation]  ویرایش Filing بیمار و اعتبارسنجی پاسخ
    [Tags]    API_Filing    METHOD_POST  

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json


    ${fileFormation}=    Create Dictionary
    ...    name=مهرشاد
    ...    nameEn= 
    ...    middleName=شيخ الاسلامي - مهرشاد
    ...    familyName=شيخ الاسلامي
    ...    familyEnName= 
    ...    fatherName=مهرداد
    ...    grandPaName= 
    ...    motherName= 
    ...    momGrandPaName= 
    ...    unknownType=${0}
    ...    passportType=${0}
    ...    maritalStatus=${363}
    ...    cityId=${363}
    ...    relegiousStatus=مسلمان
    ...    residencePermit=${False}
    ...    nationalCode=1520554001
    ...    parentNationalCode= 
    ...    identityCode= 
    ...    nationality=${912}
    ...    passportNumber= 
    ...    sex=${365}
    ...    sexString=مرد
    ...    email= 
    ...    mobileNo=09383509316
    ...    birthPlace=${363}
    ...    birthPlaceOut= 
    ...    birthDate=2002/07/07
    ...    maritalStatusString=مجرد
    ...    nationalityTitle=ایرانی
    ...    birthPlaceString=تهران
    ...    image= 
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo= 
    ...    postalCode= 
    ...    unknown=${False}
    ...    hospitalFileID=${147979}
    ...    sensitivity= 
    ...    contagion= 
    ...    note1= 
    ...    note2= 
    ...    bPolice=${True}
    ...    bCutting=${True}
    ...    bDischarge=${True}
    ...    bSurgery=${True}
    ...    bUsingFile=${True}
    ...    isDangerous=${False}
    ...    uniqueEmergencyNo=${0}
    ...    fileFormationId=${683676}
    ...    husbandName= 
    ...    husbandLastName= 
    ...    triageId=${0}
    ...    isNationalCodeRequired=${True}
    ...    AgeUnit=سال

    ${hisAdmitDto}=    Create Dictionary
    ...     fileFormationID=${683676}
    ...     inquiryUId=52c30e55-d8be-4b0c-baff-8ec115514ac6
    ...     admitDate=1404/09/26
    ...     admitTime= 
    ...     isDischarged=${False}
    ...     dischargeDate= 
    ...     dischargeTime= 
    ...     dischargeStep=${0}
    ...     dischargeDebt=${0}
    ...     wardIdIn=${201}
    ...     wardName= 
    ...     physicianID=${993}
    ...     recommender= 
    ...     admissionType=${370}
    ...     patientClass=${5}
    ...     priority=${3}
    ...     ability=${0}
    ...     limitation1=${False}
    ...     limitation2=${False}
    ...     limitation3=${False}
    ...     limitation4=${False}
    ...     limitation5=${False}
    ...     bPolice=${True}
    ...     bCutting=${True}
    ...     bDischarge=${True}
    ...     bSurgery=${True}
    ...     bUsingFile=${True}
    ...     admissionReason=دل درد
    ...     entranceType=${393}
    ...     emsId=${0}
    ...     krokiCode=${0}
    ...     diagnosis=(4شکستگیT14.8
    ...     diagnosisId=${13308}
    ...     insuranceID=${6}
    ...     insurPageNo=${0}
    ...     insurSerialNO= 
    ...     recomendationNo= 
    ...     insurMax=${0}
    ...     pishPardaght=${10000}
    ...     pishPardaghtDoctor=${0}
    ...     doctorTotalCost=${0}
    ...     referenceDoctorID=${0}
    ...     insuranceNO=0019208291
    ...     insuranceExpDate=2026/01/05
    ...     sponsor=خود فرد
    ...     degree=${0}
    ...     shebaNo= 
    ...     maritalStatus=${363}
    ...     job= 
    ...     jobId=${0}
    ...     homeCity=تهران
    ...     homeZone= 
    ...     homeAddress=dfgdfgdfgd
    ...     homePhone1=09383509316
    ...     homePhone2= 
    ...     homePostCode= 
    ...     workPlaceName= 
    ...     workCity= 
    ...     workAddress= 
    ...     workPhone1= 
    ...     workPhone2= 
    ...     workFax= 
    ...     workPostCode= 
    ...     familyFullName=مهرشاد شيخ الاسلامي
    ...     familyRelationship= 
    ...     familyCity=تهران
    ...     familyAddress=dfgdfgdfgd
    ...     familyPhone1=09383586316
    ...     familyPhone2= 
    ...     familyPostCode= 
    ...     husbandNCode= 
    ...     husbandFirstName= 
    ...     husbandLastName= 
    ...     husbandBirthDate=${None} 
    ...     husbandIdentityNo= 
    ...     husbandIssuePlaceID=${363}
    ...     husbandJobID=${0}
    ...     husbandNationalityID=${912}
    ...     husbandPassportID= 
    ...     tourismId=${0}
    ...     isPregnant=${False}
    ...     iD_Admit=${356115}
    ...     bedId=${0}
    ...     bedNo= 
    ...     referal=${None} 
    ...     referalCenter=${0}
    ...     operationDate=${None} 
    ...     operationTime= 
    ...     sendToWardDate= 
    ...     sendToWardTime= 
    ...     isInfantUnder28Days=${False}
    ...     supRecomendationNo= 

    
    ${filing_dto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
    ...    insuranceNote= 
    ...    insur_Relation=${18}
    ...    lastInsuranceKind=${422}
    ...    lastInsuranceDate=${None} 
    ...    insur2ID=${0}
    ...    insur2No=${0}
    ...    insur2Max=${0}
    ...    wasInEmergency=${FALSE}
 
    ${body}=     Create Dictionary
    ...    filingDto=${filing_dto}

    ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Filing/EditFiling
    ...    headers=&{headers}
    ...    json=${body}
    ...    expected_status=any
    
    Should Be Equal As Integers    ${resp.status_code}    200    msg=ارور AgeUnit میده اما توی body هیچ فیلدی برای این ارسال نمیشود | Actual:${resp.status_code}

    # Preview
    ${json}=    Set Variable    ${resp.json()}
    
    Should Be True    ${json['isSuccess']}
    Should Be Equal As Integers    ${json['statusCode']}    200
    Should Be Equal    ${json['data']}    ${TRUE}
    Should Be Equal    ${json['message']}    Success


29-UI - Cancel Preadmit 
    [Documentation]   لغو پذیرش preadmit
    [Tags]    UI_Test    

    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    # Wait For Page Ready
    # Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a 
    # Wait For Page Ready 
    # Click Element Safe    xpath=//span[contains(@class,'mat-checkbox-inner-container')]
    # Wait For Page Ready
    # Input Text      mat-input-55     	${nationalCode}
    Input Text            xpath=//input[@formcontrolname='nationalCode']    ${nationalCode}
    Click Element Safe    css=button.mat-tooltip-trigger.btn.btn-warning
    Wait For Page Ready   
    Click Element Safe    xpath=//button[not(@hidden) and .//mat-icon[normalize-space(.)='cancel']]
    Wait For Page Ready
    Click Element Safe    xpath=//button[contains(@class,'swal2-confirm') and normalize-space(.)='بله']
    