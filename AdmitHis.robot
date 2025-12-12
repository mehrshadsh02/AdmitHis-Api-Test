*** Setting ****
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary

Suite Setup       Create HIS Session

*** Variables ***
${BASE_URL}       http://192.168.5.19:1600

${FILING_URL}       http://192.168.5.19:8019/filing

${CHROME_DRIVER}    C:/chromedriver.exe

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjM1OGI1OGFlLWRlZGEtNGQ1YS1hNWY1LTBhYWJkYjAyYmNmMCIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJHam5ma3lqbWFjSk96bU84N1NBYTAxdVlLK0NTMkFleFc5ZVpnRkZnUXFyMFAwNDVJUkZFTEtnNVUrSHpIMkFzSmY3RXpVQk9BZ2tsRHlVaVcybFhtdE53bkZCSGdUVlVIZHNzdXd1ZjZaamFIaDc1UDJzMHZpaFlqd2dYYkJVNCIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTU5Mjc2MiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.pgkeGjZ2rCxWAZrpo0IidJFY0OZVp0b4w4i3XEwrYGo

${COOKIE_TOKEN}  eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjM1OGI1OGFlLWRlZGEtNGQ1YS1hNWY1LTBhYWJkYjAyYmNmMCIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJHam5ma3lqbWFjSk96bU84N1NBYTAxdVlLK0NTMkFleFc5ZVpnRkZnUXFyMFAwNDVJUkZFTEtnNVUrSHpIMkFzSmY3RXpVQk9BZ2tsRHlVaVcybFhtdE53bkZCSGdUVlVIZHNzdXd1ZjZaamFIaDc1UDJzMHZpaFlqd2dYYkJVNCIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTU5Mjc2MiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.pgkeGjZ2rCxWAZrpo0IidJFY0OZVp0b4w4i3XEwrYGo

${GLOBAL_SPINNER}     css=.ngx-spinner-overlay,.loading-overlay,.spinner,.mat-progress-spinner,.cdk-overlay-backdrop

${nationalCode}    1520554001

*** Keywords ***

Create HIS Session
    Create Session    HIS    ${BASE_URL}    verify=${False}

Start Browser With Token
    [Documentation]    باز کردن کروم + تزریق کوکی token
    Open Browser    ${FILING_URL}    chrome
    Maximize Browser Window
    Add Cookie    token    ${COOKIE_TOKEN}
    Reload Page

Go To Filing Page
    [Documentation]    رفتن مستقیم به صفحه پذیرش بستری
    Go To    ${FILING_URL}
    Reload Page

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

Fill Input By Id
    [Arguments]    ${id}    ${value}
    Wait For Spinner Hidden
    Wait Until Element Is Visible    id=${id}
    Clear Element Text    id=${id}
    Input Text    id=${id}    ${value}     

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
    Start Browser With Token
    Go To Filing Page
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

    Fill Input By Id         mat-input-3            1520554001
    Click Element Safe       id=button-addon3

10-Get Person From Ditas
    [Documentation]    دریافت اطلاعات شخص از ديتاس با کدملی
    [Tags]    API_Inquiry  METHOD_POST  DITAS

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    &{body}=    Create Dictionary
    ...    nationalCode=1520554001
    ...    passport=
    ...    birthDate=
    ...    triageId=0

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Inquiry/GetPersonFromDitas
    ...    headers=&{headers}
    ...    json=&{body}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetPersonFromDitas | nationalCode=1520554001

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetPersonFromDitas | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    To Json    ${resp.content}

    ${nationalCode}=    Evaluate    $json['data']['fileFormation']['nationalCode']

    Should Be Equal
    ...    ${nationalCode}    1520554001
    ...    msg=❌ DATA MISMATCH | NationalCode mismatch | Expected: 1520554001 | Actual: ${nationalCode}

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
    ...    nationalCode=1520554001
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
    ...    nationalCode=3031855256
    ...    fatherName=علی
    ...    firstName=مهری
    ...    lastName=مونس زاده شيرواني
    # --- Alternative test data ---
    # ...    nationalCode=1520554001
    # ...    fatherName=مهرداد
    # ...    firstName=مهرشاد
    # ...    lastName=شیخ الاسلامی

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

    Select From Ng Select    maritalStatus           مجرد
    Select From Ng Select    insurRelation           خود فرد

    Fill Input By Id         mat-input-31            09383509316
    Fill Input By Id         mat-input-34            dfgdfgdfgd
    Fill Input By Id         mat-input-35            مهرشاد شیخ الاسلامی
    Fill Input By Id         mat-input-36            09383586316

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
    Select From Ng Select    wardfileld             اطفال 2 - تخت خالی (33)
    Select From Ng Select    doctorField             Siavash Siavash
    Select From Ng Select    responsiblePatient     خود فرد

    Fill Input By Id         mat-input-40            10000


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

19-Add Filing Validation Bug Test
    [Documentation]    بررسی باگ: API در صورت عدم ارسال فیلدهای اجباری به جای 400، خطای سرور 500 برمی‌گرداند
    ...    Expected: باید 400 Bad Request با پیام اعتبارسنجی برگردد
    ...    Actual: 500 Internal Server Error (Bug)
    [Tags]    API_Filing  METHOD_POST  500InsteadOf400 

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Content-Type=application/json
    ...    Accept=application/json

    # سناریو ۱: بدون کد ملی (nationalCode الزامی است)
    ${resp}=    POST On Session    HIS    /api/Filing/AddFiling    json={"filingDto":{"fileFormation":{"name":"تست","familyName":"تست"},"hisAdmitDto":{"physicianID":993,"wardIdIn":204}}}    headers=${headers}    expected_status=anything
    Status Should Be    500    ${resp}    msg=باگ: عدم ارسال nationalCode باید 400 بدهد، نه 500
    Should Contain    ${resp.text}    Exception    msg=خطای سرور رخ داده (تأیید باگ)

    # سناریو ۲: بدون نام و نام خانوادگی (name و familyName الزامی‌اند)
    ${resp}=    POST On Session    HIS    /api/Filing/AddFiling    json={"filingDto":{"fileFormation":{"nationalCode":"1520554001"},"hisAdmitDto":{"physicianID":993,"wardIdIn":204}}}    headers=${headers}    expected_status=anything
    Status Should Be    500    ${resp}    msg=باگ: عدم ارسال name/familyName باید 400 بدهد، نه 500

    # سناریو ۳: بدون physicianID و wardIdIn (الزامی در پذیرش)
    ${resp}=    POST On Session    HIS    /api/Filing/AddFiling    json={"filingDto":{"fileFormation":{"nationalCode":"1520554001","name":"تست","familyName":"تست"},"hisAdmitDto":{}}}    headers=${headers}    expected_status=anything
    Status Should Be    500    ${resp}    msg=باگ: عدم ارسال physicianID/wardIdIn باید 400 بدهد، نه 500

    Log To Console    \nباگ تأیید شد: API به‌جای 400 Bad Request، خطای 500 Internal Server Error برمی‌گرداند
    Log    BUG-1247: AddFiling returns 500 instead of 400 on missing required fields    level=WARN

20-Check Patient Debt
    [Documentation]    بررسی بدهی بیمار
    [Tags]    API_Patient    METHOD_POST    Debt

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary
    ...    nationalCode=1520554001
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

22-UI - go to inpatient list
    [Documentation]    رفتن به لیست بیماران بستری 
    [Tags]    UI_Test    
    
    # Start Browser With Token
    # Go To Filing Page
    Wait For Page Ready
    Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a   

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
    
    # Start Browser With Token
    # Go To Filing Page
    # Wait For Page Ready
    # Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a  
    Wait For Page Ready
    Click Element Safe    xpath=//span[contains(@class,'mat-checkbox-inner-container')]

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