*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

Suite Setup       Create HIS Session

*** Variables ***
${BASE_URL}       http://192.168.5.19:1600

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjBiMDg1Zjk4LWMwMmEtNDUyZC05ZmExLTRhMjE4Y2Q4NmQzOSIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjIiLCJOUElEIjoiIiwidXNpbmYiOiJ1R1Zmb3Q0K1lEd3ZoSkhnODRGSWlTeGEyZW1xeEZkbkV5SGxlZ2k0cjN4Z3VEei9lQkl5azdWNENuOTQrdUFZdjJuN3JtS21QcFprRVlING0wcEx0d1JRbVBrYVBCZC9XdHVFdjAzU3laQjliaWZnKzUvbmZPZ2EraGh2aWdUNyIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTM5MzU4NSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.KRj1B3dKlOSaRKbCaR7kkpIBm_2uAwcIpZZcBMsMXKo

${COOKIE_TOKEN}  token=eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjBiMDg1Zjk4LWMwMmEtNDUyZC05ZmExLTRhMjE4Y2Q4NmQzOSIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjIiLCJOUElEIjoiIiwidXNpbmYiOiJ1R1Zmb3Q0K1lEd3ZoSkhnODRGSWlTeGEyZW1xeEZkbkV5SGxlZ2k0cjN4Z3VEei9lQkl5azdWNENuOTQrdUFZdjJuN3JtS21QcFprRVlING0wcEx0d1JRbVBrYVBCZC9XdHVFdjAzU3laQjliaWZnKzUvbmZPZ2EraGh2aWdUNyIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc2NTM5MzU4NSwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.KRj1B3dKlOSaRKbCaR7kkpIBm_2uAwcIpZZcBMsMXKo



*** Keywords ***

Create HIS Session
    Create Session    HIS    ${BASE_URL}    verify=${False}

Safe GET
    [Arguments]    ${url}    ${headers}    ${timeout}=15
    ${status}    ${resp}=    Run Keyword And Ignore Error    GET On Session    HIS    ${url}    headers=${headers}    timeout=${timeout}
    Run Keyword If    '${status}'=='FAIL'    Log To Console    ⚠️ GET Timeout Or Connection Error → ${url}
    [Return]    ${resp}

Safe POST
    [Arguments]    ${url}    ${headers}    ${body}    ${timeout}=30
    ${status}    ${resp}=    Run Keyword And Ignore Error
    ...    POST On Session
    ...    HIS
    ...    ${url}
    ...    headers=${headers}
    ...    json=${body}
    ...    timeout=${timeout}

    Run Keyword If    '${status}'=='FAIL'
    ...    Set Test Variable    ${resp}    ${None}

    [Return]    ${status}    ${resp}


*** Test Cases ***

Get All Jobs
    [Documentation]    دریافت لیست کامل شغل‌ها
    [Tags]    API_GeneralVariables  METHOD_GET  POSITIVE  CRITICAL  P0  MODULE_BASEDATA  JOB_DOCTOR

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



Validate Specific Job - پزشک Exists
    [Documentation]    بررسی وجود شغل «پزشک» با کد سپاس صحیح
    [Tags]    API_GeneralVariables  METHOD_GET  POSITIVE  CRITICAL  P0  MODULE_BASEDATA  JOB_DOCTOR

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


Get All Cause Of Hospitalization
    [Documentation]    دریافت لیست علل بستری
    [Tags]    API_GeneralVariables    METHOD_GET    POSITIVE    CRITICAL    MODULE_ADMISSION

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


Get Standard Variables
    [Documentation]    Get Standard Variables

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


Get All First Recognition
    [Documentation]    دریافت لیست تشخیص های اولیه

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


Get All Names Inpatient Wards
    [Documentation]    لیست تخت های خالی

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

Admit Configuration
    [Documentation]    AdmitHis config
    [Tags]    API_GeneralVariables    METHOD_GET    POSITIVE    CRITICAL    MODULE_ADMISSION

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


Get Person From Ditas
    [Documentation]    دریافت اطلاعات شخص از ديتاس با کدملی
    [Tags]    API_Inquiry  METHOD_POST  POSITIVE  CRITICAL  P0  MODULE_ADMISSION  DITAS

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



Get All Insurance Kind
    [Documentation]    دریافت لیست صندوق های بیمه بر اساس sepasid بیمه پایه

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

Check Patient Debt
    [Documentation]    بررسی بدهی بیمار
    [Tags]    API_Patient    METHOD_POST    POSITIVE    CRITICAL    MODULE_FINANCIAL

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

Check Filing Doubling
    [Documentation]    بررسی تکراری بودن پذیرش بیمار بر اساس اطلاعات هویتی
    [Tags]    API_Filing  METHOD_POST  POSITIVE  CRITICAL  P0  MODULE_ADMISSION  DOUBLING_CHECK

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    &{checkDto}=    Create Dictionary
    ...    nationalCode=3031855256
    ...    fatherName=علي
    ...    firstName=مهری
    ...    lastName=مونس زاده شیروانی

    &{body}=    Create Dictionary
    ...    checkDoublingDto=&{checkDto}

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Filing/CheckFilingDoubling
    ...    headers=&{headers}
    ...    json=&{body}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:CheckFilingDoubling | nationalCode=3031855256 | Possible Network/Server Issue

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:CheckFilingDoubling | Expected:200 | Actual:${resp.status_code}

    ${json}=    To Json    ${resp.content}

    Should Be Equal As Integers
    ...    ${json["statusCode"]}    0
    ...    msg=❌ BUSINESS STATUS ERROR | API:CheckFilingDoubling | Expected statusCode:0 | Actual:${json["statusCode"]}

    ${msg}=   Set Variable    ${json["message"][0]}

    Should Contain
    ...    ${msg}    بخش
    ...    msg=❌ WRONG MESSAGE | API:CheckFilingDoubling | Expected message contains 'بخش' | Actual:${msg}

    Log To Console    ✅ PASS | CheckFilingDoubling | Patient is already admitted | Message=${msg}

#وقتی که بخش بیمار را برای بستری کردن انتخاب میکنیم

Get All Bed Number
    [Documentation]    لیست تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_Wards  METHOD_GET  POSITIVE  CRITICAL  P0  MODULE_WARDS  BED_LIST

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

Get Doctors By Ward
    [Documentation]     تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_Wards  METHOD_GET  POSITIVE  CRITICAL  P0  MODULE_WARDS  DOCTORS_LIST

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

Add Filing Validation Bug Test
    [Documentation]    بررسی باگ: API در صورت عدم ارسال فیلدهای اجباری به جای 400، خطای سرور 500 برمی‌گرداند
    ...    Expected: باید 400 Bad Request با پیام اعتبارسنجی برگردد
    ...    Actual: 500 Internal Server Error (Bug)
    [Tags]    API_Filing  METHOD_POST  NEGATIVE  VALIDATION  BUG  P0  CRITICAL  500InsteadOf400  MODULE_ADMISSION

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
