*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
Resource          ../resources/AdmitHis-variables.resource
Resource          ../keywords/AdmitHis-keywords.resource
Resource          ../state/runtime_state.json


Suite Setup       Create AdmitHIS Session
    

*** Test Cases ***

01-Get All Jobs
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



02-Validate Specific Job - پزشک Exists
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


03-Get All Cause Of Hospitalization
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


04-Get Standard Variables
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


05-Get All First Recognition
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


06-Get All Names Inpatient Wards
    [Documentation]    دریافت لیست بخش‌های بستری
    [Tags]    API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    /api/GeneralVariables/GetAllNamesInpatientWards
    ...    headers=&{headers}

    Should Be Equal As Integers    ${resp.status_code}    200

    # ✅ Parse JSON
    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)

    ${count}=    Get Length    ${json}
    Log To Console    🏥 Inpatient wards count: ${count}
    Should Be True    ${count} > 0

    # ✅ Schema validation روی اولین آیتم
    Should Contain    ${json[0]}    name
    Should Contain    ${json[0]}    systemCodeId
    Should Contain    ${json[0]}    standardVariableId
    Should Be Equal As Integers    ${json[0]["systemCodeId"]}    132

    # ✅ بررسی وجود حداقل یک بخش با ظرفیت خالی
    ${HAS_AVAILABLE_WARD}=    Set Variable    ${False}

    FOR    ${item}    IN    @{json}
        Should Contain    ${item}    name
        Should Contain    ${item}    standardVariableId

        ${match}=    Evaluate    re.search("\\((\\d+)\\)", $item["name"])    re
        IF    $match
            ${capacity}=    Evaluate    int($match.group(1))
            IF    ${capacity} > 0
                Log To Console    ✅ Available ward found | ${item["name"]}
                ${HAS_AVAILABLE_WARD}=    Set Variable    ${True}
                Exit For Loop
            END
        END
    END

    Should Be True    ${HAS_AVAILABLE_WARD}
    ...    ❌ No inpatient ward with available capacity found


07-Admit Configuration
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


08-Get Person From Ditas
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



09-Get All Insurance Kind
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

10-Check Patient Debt
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

11-Check Filing Doubling
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


12-Get All Bed Number
    [Documentation]    لیست تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_GeneralVariables  METHOD_GET  BED_LIST

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

    # ✅ Parse JSON (modern)
    ${json}=    Set Variable    ${resp.json()}
    Should Be True
    ...    isinstance($json, list)
    ...    msg=❌ INVALID FORMAT | Expected list[] | Got: ${json}

    ${count}=    Get Length    ${json}
    Should Be True
    ...    ${count} > 0
    ...    msg=❌ EMPTY RESULT | No beds found | WardId=${wardId}

    Log To Console    🛏 Beds found: ${count} | WardId=${wardId}

    # ✅ Expected schema
    @{expected_keys}=    Create List
    ...    WardName
    ...    ID_Ward
    ...    RoomNo
    ...    BedNo
    ...    RoomTypeName
    ...    BedStatus
    ...    ID_Bed

    ${SELECTED_BED_ID}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | '${key}' not found | Item=${item}
        END

        # ✅ انتخاب اولین Bed معتبر (ساده و deterministic)
        IF    ${SELECTED_BED_ID} == ${None}
            ${SELECTED_BED_ID}=    Set Variable    ${item["ID_Bed"]}
            Log To Console
            ...    ✅ Bed selected | ID_Bed=${SELECTED_BED_ID} | Room=${item["RoomNo"]} | BedNo=${item["BedNo"]}
        END
    END

    Should Not Be Equal
    ...    ${SELECTED_BED_ID}    ${None}
    ...    ❌ No valid Bed ID selected

    # ✅ ذخیره state برای تست‌های بعدی (ChangeToAdmit)
    Write State    BED_ID    ${SELECTED_BED_ID}
    Log To Console    💾 BED_ID saved to state: ${SELECTED_BED_ID}

13-Get Doctors By Ward
    [Documentation]     تخت های خالی بر اساس id بخش مثلا بخش 204
    [Tags]    API_GeneralVariables  METHOD_GET  DOCTORS_LIST

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


14-Add Filing Validation Bug - Empty NationalCode
    [Documentation]    BUG-1247 - Empty nationalCode causes 500 instead of 400
    [Tags]    API_Filing    NEGATIVE    VALIDATION    BUG_1247

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
    ...    wardIdIn=${wardId}
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


15-Check Patient Debt
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

16-Get All Name Inpatient Ward
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


17-Search PreAdmit patiant 
    [Documentation]   جستجوی بیماران preadmit
    [Tags]    API_Patient    METHOD_POST  priadmit 

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
    ...    dateFrom=2026/02/27
    ...    dateTo=2026/02/27
    ...    status=0

    ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Patient/SearchPreAdmits
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)

    ${TARGET_NATIONAL_CODE}=    Set Variable    ${nationalCode}
    ${FOUND_ADMIT_ID}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        IF    '${item["nationalCode"]}' == '${TARGET_NATIONAL_CODE}'
            ${FOUND_ADMIT_ID}=    Set Variable    ${item["admitID"]}
            Exit For Loop
        END
    END

    Should Not Be Equal    ${FOUND_ADMIT_ID}    ${None}
    Write State    ADMIT_ID    ${FOUND_ADMIT_ID}

    Log To Console    ✅ ADMIT_ID saved: ${FOUND_ADMIT_ID}


18-Edit Filing PreAdmit
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

19-Get Version
    [Documentation]    دریافت ورژن api
    [Tags]    API_Version    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /version    
    ...    headers=${headers}

    Should Be Equal As Integers    
    ...    ${resp.status_code}    
    ...    200    

    ${json}=    Set Variable    ${resp.json()}

    Set Test Message
    ...    Build Info:\n${json}

20-Change To Admit
    [Documentation]  تبدیل preadmit به بستری
    [Tags]    API_Filing    METHOD_POST  priadmit 

    ${ADMIT_ID}=    Read State    ADMIT_ID
    ${BED_ID}=      Read State    BED_ID

    Log To Console     Using ADMIT_ID=${ADMIT_ID}, BED_ID=${BED_ID}

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    
    &{preAdmitDto}=    Create Dictionary
    ...    admitId=${ADMIT_ID}
    ...    bedId=${BED_ID}

    &{body}=    Create Dictionary
    ...    preAdmitDto=&{preAdmitDto}
    
     ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Filing/ChangeToAdmit 
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}

21-