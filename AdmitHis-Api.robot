*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
Library           JSONLibrary
Library           DatabaseLibrary
Library           pymssql
Library           jdatetime

Resource          ../resources/AdmitHis-variables.resource
Resource          ../keywords/AdmitHis-keywords.resource
Resource          ../keywords/AdmitHis-DB-keywords.resource

Suite Setup       Create All Sessions   
    

*** Test Cases ***

001-Get Version
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
    ...    Response: ${resp.status_code}\nBuild Info:\n${json}
  
001-Get Token Data
    [Documentation]    دریافت اطلاعات کاربر لاگین کننده
    [Tags]    API_DynamicRoleClaimsManager    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/DynamicRoleClaimsManager/GetTokenData    
    ...    headers=${headers}

    Should Be Equal As Integers    
    ...    ${resp.status_code}    
    ...    200    

    ${json}=    Set Variable    ${resp.json()}  

    ${LOGIN_user_name}=           Set Variable    ${json["username"]}
    ${LOGIN_person_Id}=           Set Variable    ${json["personId"]}
    ${LOGIN_display_Name}=           Set Variable    ${json["displayName"]}

    Write State    Login_User_Name    ${LOGIN_user_name} 
    Write State    Login_Person_Id    ${LOGIN_person_Id} 
    Write State    Login_Display_Name    ${LOGIN_display_Name} 

    
    Set Test Message
    ...    Response: ${resp.status_code}\nUser Info:\n${LOGIN_user_name} / ${LOGIN_person_Id} / ${LOGIN_display_Name}

002-Get Patient By FileFormationID
    [Documentation]    دریافت اطلاعات بیمار با استفاده از شماره الکترونیکی
    [Tags]    API_Patient    METHOD_POST    

    Run Keyword If    '${FileFormationID}'=='null' 
    ...    fail   
    ...    FileFormationID Is NULL !!!!!    

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary
    ...    name=
    ...    lastName=
    ...    triageId=0
    ...    fatherName=
    ...    nationalityId=912
    ...    nationalCode=
    ...    PassportNo=
    ...    grandPaName=
    ...    motherName=
    ...    momGrandPaName=
    ...    fileFormationId=${FileFormationID}
    ...    hospitalCodeId=0

    ${resp}=    POST On Session
    ...    HIS
    ...    /api/Patient/GetPatientByNationalCode
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty    ${json}

    FOR    ${item}    IN    @{json}
        IF    ${item["iD_FileFormation"]} == ${FileFormationID}
            ${FOUND_Hospital_FileID}=    Set Variable    ${item["hospitalFileID"]}
            ${FOUND_National_Code}=    Set Variable    ${item["nCode"]}
            ${FOUND_First_Name}=    Set Variable    ${item["firstName"]}
            ${FOUND_Last_Name}=    Set Variable    ${item["lastName"]}
            ${FOUND_Father_Name}=    Set Variable    ${item["fatherName"]}
            ${FOUND_display_Name}=    Set Variable    ${item["displayName"]}
            ${FOUND_sex}=    Set Variable    ${item["sex"]}
            ${FOUND_mobile}=    Set Variable    ${item["mobile"]}
            ${FOUND_lastHomeCity}=    Set Variable    ${item["lastHomeCity"]}
            ${FOUND_lastInsuranceNO}=    Set Variable    ${item["lastInsuranceNO"]}
            ${FOUND_religion}=    Set Variable    ${item["religion"]}
            ${FOUND_nationalityID}=    Set Variable    ${item["nationalityID"]}
            ${FOUND_lastMaritalStatus}=    Set Variable    ${item["lastMaritalStatus"]}
            ${FOUND_birthCityID}=    Set Variable    ${item["birthCityID"]}
            # ${FOUND_uniqueEmergencyNo}=    Set Variable    ${item["uniqueEmergencyNo"]}
            ${FOUND_lastCityID}=    Set Variable    ${item["lastCityID"]}
            ${FOUND_lastInsurBox_SepasID}=    Set Variable    ${item["lastInsurBox_SepasID"]}
            ${FOUND_sexId}=    Set Variable    ${item["sexId"]}
            ${FOUND_inquiryUId}=    Set Variable    ${item["inquiryUId"]}
            ${FOUND_Fileformation_Id}=    Set Variable    ${item["iD_FileFormation"]}
            ${FOUND_lastInsurance_ID}=    Set Variable    ${item["lastInsuranceID"]}
            ${FOUND_lastInsurance_ExpDate}=    Set Variable    ${item["lastInsuranceExpDate"]}
            
            Exit For Loop
        END
    END

    Write State    DISPLAYNAME    ${FOUND_display_Name}
    Write State    SEX    ${FOUND_sex}
    Write State    SEXID    ${FOUND_sexId}
    Write State    MOBILE    ${FOUND_mobile}
    Write State    LASTHOMECITY    ${FOUND_lastHomeCity}
    Write State    LASTINSURANCENO    ${FOUND_lastInsuranceNO}
    Write State    RELIGION    ${FOUND_religion}
    Write State    NATIONALITYID    ${FOUND_nationalityID}
    Write State    LASTMARITALSTATUS    ${FOUND_lastMaritalStatus}
    Write State    BIRTHCITYID    ${FOUND_birthCityID}
    # Write State    UNIQUEMERGENCYNO    ${FOUND_uniqueEmergencyNo}
    Write State    LASTCITYID    ${FOUND_lastCityID}
    Write State    LASTINSURBOX_SEPASID    ${FOUND_lastInsurBox_SepasID}
    Write State    INQUIRYUID    ${FOUND_inquiryUId}
    Write State    HOSPITALFILEID    ${FOUND_Hospital_FileID}  
    Write State    NATIONALCODE      ${FOUND_National_Code}
    Write State    iD_FileFormation    ${FOUND_Fileformation_Id}
    Write State    FIRSTNAME         ${FOUND_First_Name}
    Write State    LASTNAME          ${FOUND_Last_Name}
    Write State    FATHERNAME        ${FOUND_Father_Name}  
    Write State    lastInsurance_ID        ${FOUND_lastInsurance_ID}
    Write State    lastInsurance_ExpDate        ${FOUND_lastInsurance_ExpDate}

    Set Test Message
    ...    Response: ${resp.status_code}\n  


003-Get All Jobs
    [Documentation]    دریافت لیست کامل شغل‌ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllJobs    
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllJobs | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllJobs | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    To JSON    ${resp.content}

    ${target}=    Evaluate    [x for x in $json if x["jobName"]=="پزشک"]

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

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | Job 'پزشک' not found in response | API: GetAllJobs

    Should Be Equal
    ...    ${target[0]["sepas_Code"]}    002038
    ...    msg=❌ DATA MISMATCH | Doctor sepas_Code incorrect | Expected: 002038 | Actual: ${target[0]["sepas_Code"]}

    Log To Console    ✅ PASS | Doctor job validated | ID=${target[0]["iD_Job"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n 


004-Get All Cause Of Hospitalization
    [Documentation]    دریافت لیست علل بستری
    [Tags]    API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllCauseOfHospitalization    
    ...    headers=&{headers}

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

    ${FOUND_Cause_Of_Hospitalization_ID}=    Set Variable    ${burn[0]["iD_GVariable"]}
    ${FOUND_Cause_Of_Hospitalization_Name}=    Set Variable    ${burn[0]["name"]}
    ${FOUND_Cause_Of_Hospitalization_ID_Edit}=    Set Variable    ${accident[0]["iD_GVariable"]}
    ${FOUND_Cause_Of_Hospitalization_Name_Edit}=    Set Variable    ${accident[0]["name"]}


    Write State    Cause_Of_Hospitalization_ID    ${FOUND_Cause_Of_Hospitalization_ID}
    Write State    Cause_Of_Hospitalization_Name    ${FOUND_Cause_Of_Hospitalization_Name}
    Write State    Cause_Of_Hospitalization_ID_Edit    ${FOUND_Cause_Of_Hospitalization_ID_Edit}
    Write State    Cause_Of_Hospitalization_Name_Edit   ${FOUND_Cause_Of_Hospitalization_Name_Edit}

    Set Test Message
    ...    Response: ${resp.status_code}\n 


005-Get Standard Variables
    [Documentation]    لیست شهرها و وضعیت تاهل و ملیت و نام بیمه ها و نسبیت ها  و نوع بستری و نام بیمه های تکمیلی و تحصیلات و نام پزشک ها وجنسیت و استان ها و نحوه مراجعه
    [Tags]       API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetStandardVariables
    ...    headers=&{headers}

    Run Keyword If    '${resp}'=='None'    
    ...    Return From Keyword

    Log To Console    Status: ${resp.status_code}

    Should Be Equal As Integers    ${resp.status_code}    200

    Set Test Message
    ...    Response: ${resp.status_code}\n 


006-Get All First Recognition
    [Documentation]    دریافت لیست تشخیص های اولیه
    [Tags]      API_GeneralVariables    METHOD_GET

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session   
    ...     HIS    
    ...    /api/GeneralVariables/GetAllFirstRecognition
    ...    headers=&{headers}

    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Log To Console    Status: ${resp.status_code}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty    ${json}
    
    ${target}=    Evaluate    [x for x in $json if x["iD_GVariable"]==13309]
    ${target_2}=    Evaluate    [x for x in $json if x["iD_GVariable"]==35543]  

    ${FOUND_Diagnosis_Name}=    Set Variable    ${target[0]["name"]}
    ${FOUND_Diagnosis_ID}=    Set Variable    ${target[0]["iD_GVariable"]}
    ${FOUND_Diagnosis_Name-Edit}=    Set Variable    ${target_2[0]["name"]}
    ${FOUND_Diagnosis_ID-Edit}=    Set Variable    ${target_2[0]["iD_GVariable"]}


    Write State    Diagnosis-ID    ${FOUND_Diagnosis_ID}
    Write State    Diagnosis-Name    ${FOUND_Diagnosis_Name}
    Write State    Diagnosis-ID-Edit    ${FOUND_Diagnosis_ID-Edit}
    Write State    Diagnosis-Name-Edit   ${FOUND_Diagnosis_Name-Edit}
    
    Set Test Message
    ...    Response: ${resp.status_code}\n


007-Get All Inpatient Wards Names
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

    Should Contain    ${json[0]}    name
    Should Contain    ${json[0]}    systemCodeId
    Should Contain    ${json[0]}    standardVariableId
    Should Be Equal As Integers    ${json[0]["systemCodeId"]}    132

    #  بررسی وجود حداقل یک بخش با ظرفیت خالی
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

    ${target}=    Evaluate    [x for x in $json if x["standardVariableId"]==${wardId}]
    ${target_2}=    Evaluate    [x for x in $json if x["standardVariableId"]==${wardId_edit}]
    
    ${FOUND_INPATIONT_WARD_ID}=    Set Variable    ${target[0]["standardVariableId"]}
    ${FOUND_INPATIONT_WARD_NAME}=    Set Variable    ${target[0]["name"]}
    ${FOUND_INPATIONT_WARD_ID_EDIT}=    Set Variable    ${target_2[0]["standardVariableId"]}
    ${FOUND_INPATIONT_WARD_NAME_EDIT}=    Set Variable    ${target_2[0]["name"]}

    Write State    INPATIONT_WARD_ID    ${FOUND_INPATIONT_WARD_ID} 
    Write State    INPATIONT_WARD_NAME    ${FOUND_INPATIONT_WARD_NAME}
    Write State    INPATIONT_WARD_ID_EDIT    ${FOUND_INPATIONT_WARD_ID_EDIT}
    Write State    INPATIONT_WARD_NAME_EDIT    ${FOUND_INPATIONT_WARD_NAME_EDIT}   

    Log To Console    ✅ INPATIONT_WARD_NAME saved: ${FOUND_INPATIONT_WARD_NAME}

    Set Test Message
    ...    Response: ${resp.status_code}\n


008-Admit Configuration
    [Documentation]    گرفتن فایل confing در admithis
    [Tags]    API_GeneralVariables    METHOD_GET    

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/AdmitConfiguration    
    ...    headers=&{headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API:AdmitConfiguration

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API:AdmitConfiguration | Expected:200 | Actual:${resp.status_code}

    ${json}=    To JSON    ${resp.content}
    ${count}=    Get Length    ${json}

    Log To Console    ✅ PASS | Hospitalization Causes Loaded | Count=${count}

    Set Test Message
    ...    Response: ${resp.status_code}\n


009-Get Person From Ditas
    [Documentation]    دریافت اطلاعات شخص از ديتاس با کدملی
    [Tags]    API_Inquiry  METHOD_POST  DITAS
        
    Run Keyword If    
    ...    '${nationalCode}'=='null'
    ...    Fail    National Code Is Null !!!

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

    ${json}=    Set Variable    ${resp.json()}

    ${nationalCode_Ditas}=    Evaluate    $json['data']['fileFormation']['nationalCode']

    Should Be Equal
    ...    ${nationalCode_Ditas}    ${nationalCode}
    ...    msg=❌ DATA MISMATCH | NationalCode mismatch | Message: Ditas service failed.

    Log To Console    ✅ PASS | DITAS data fetched successfully | NationalCode=${nationalCode_Ditas}

    FOR    ${item}    IN    @{json}
        IF    ${nationalCode} == ${nationalCode_Ditas}
            ${FOUND_Hospital_FileID}=   Evaluate    $json['data']['fileFormation']['hospitalFileID']
            ${FOUND_National_Code}=    Evaluate     $json['data']['fileFormation']["nationalCode"]
            ${FOUND_First_Name}=       Evaluate     $json['data']['fileFormation']["name"]
            ${FOUND_Last_Name}=        Evaluate     $json['data']['fileFormation']["familyName"]
            ${FOUND_Father_Name}=      Evaluate     $json['data']['fileFormation']["fatherName"]
            ${FOUND_display_Name}=     Evaluate     $json['data']['fileFormation']["middleName"]
            ${FOUND_sex}=              Evaluate     $json['data']['fileFormation']["sexString"]
            ${FOUND_mobile}=           Evaluate     $json['data']['fileFormation']["mobileNo"]
            ${FOUND_lastHomeCity}=     Evaluate     $json['data']['fileFormation']["addressLine"]
            ${FOUND_lastInsuranceNO}=  Evaluate     $json['data']['hisAdmitDto']["insuranceNO"]
            # ${FOUND_religion}=         Evaluate     $json['data']['fileFormation']["religion"]
            ${FOUND_nationalityID}=    Evaluate     $json['data']['fileFormation']["nationality"]
            ${FOUND_lastMaritalStatus}=     Evaluate     $json['data']['fileFormation']["maritalStatus"]
            ${FOUND_birthCityID}=           Evaluate     $json['data']['fileFormation']["cityId"]
            ${FOUND_lastCityID}=       Evaluate          $json['data']['hisAdmitDto']["homeCity"]
            ${FOUND_lastInsurBox_SepasID}=   Evaluate    $json['data']["lastInsuranceKind"]
            ${FOUND_sexId}=                  Evaluate    $json['data']['fileFormation']["sex"]
            ${FOUND_inquiryUId}=             Evaluate    $json['data']['hisAdmitDto']["inquiryUId"]
            ${FOUND_lastInsurance_ExpDate}=    Evaluate     $json['data']['hisAdmitDto']["insuranceExpDate"]
            ${FOUND_lastInsurance_ID}=    Evaluate     $json['data']['hisAdmitDto']["insuranceID"]
            Exit For Loop
        END
    END
    
    Write State    FIRSTNAME         ${FOUND_First_Name}
    Write State    LASTNAME          ${FOUND_Last_Name}
    Write State    DISPLAYNAME    ${FOUND_display_Name}
    Write State    SEX    ${FOUND_sex}
    Write State    SEXID    ${FOUND_sexId}
    Write State    MOBILE    ${FOUND_mobile}
    Write State    LASTHOMECITY    ${FOUND_lastHomeCity}
    Write State    LASTINSURANCENO    ${FOUND_lastInsuranceNO}
    # Write State    RELIGION    ${FOUND_religion}
    Write State    NATIONALITYID    ${FOUND_nationalityID}
    Write State    LASTMARITALSTATUS    ${FOUND_lastMaritalStatus}
    Write State    BIRTHCITYID    ${FOUND_birthCityID}
    # Write State    UNIQUEMERGENCYNO    ${FOUND_uniqueEmergencyNo}
    Write State    LASTCITYID    ${FOUND_lastCityID}
    Write State    LASTINSURBOX_SEPASID    ${FOUND_lastInsurBox_SepasID}
    Write State    INQUIRYUID    ${FOUND_inquiryUId}
    Write State    HOSPITALFILEID    ${FOUND_Hospital_FileID}  
    Write State    NATIONALCODE      ${FOUND_National_Code}
    Write State    lastInsurance_ID        ${FOUND_lastInsurance_ID}
    Write State    lastInsurance_ExpDate        ${FOUND_lastInsurance_ExpDate}

    Set Test Message
    ...    Response: ${resp.status_code}\n
       

010-Get List of Insurance Funds
    [Documentation]    دریافت لیست صندوق های بیمه بر اساس sepasid بیمه پایه
    [Tags]    API_GeneralVariables  METHOD_Get  Insure

    ${lastInsurance_ID}=   Read State    lastInsurance_ID

    Run Keyword If    
    ...    ${lastInsurance_ID} ==1
    ...    Fail    
    ...    Bimeh Azad !!!

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */*
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllInsuranceKind?sepasId=${lastInsurance_ID}
    ...    headers=&{headers}
    Run Keyword If    '${resp}'=='None'    Return From Keyword

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    To Json    ${resp.content}
    Log To Console    ${json}

    Set Test Message
    ...    Response: ${resp.status_code}\n

011-Get All Bed Number
    [Documentation]    لیست تخت های خالی بر اساس id بخش مثلا بخش 201 و 224
    [Tags]    API_GeneralVariables  METHOD_GET  BED_LIST

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllBedNumber?wardId=${wardId}
    ...    headers=&{headers}

    ${resp_edit}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllBedNumber?wardId=${wardId_edit}
    ...    headers=&{headers}

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | Expected 200 | Actual ${resp.status_code}

    Should Be Equal As Integers
    ...    ${resp_edit.status_code}    200
    ...    msg=❌ WRONG STATUS | Expected 200 | Actual ${resp_edit.status_code}

    # ✅ Parse JSON (modern)
    ${json}=    Set Variable    ${resp.json()}
    
    ${json_edit}=    Set Variable    ${resp_edit.json()}

    Should Be True
    ...    isinstance($json, list)
    ...    msg=❌ INVALID FORMAT | Expected list[] | Got: ${json}

    Should Be True
    ...    isinstance($json_edit, list)
    ...    msg=❌ INVALID FORMAT | Expected list[] | Got: ${json_edit}

    ${count}=    Get Length    ${json}

    ${count_edit}=    Get Length    ${json_edit}

    Should Be True
    ...    ${count} > 0
    ...    msg=❌ EMPTY RESULT | No beds found | WardId=${wardId}

    Should Be True
    ...    ${count_edit} > 0
    ...    msg=❌ EMPTY RESULT | No beds found | WardId=${wardId_edit}

    Log To Console    🛏 Beds found: ${count} | WardId=${wardId}

    Log To Console    🛏 Beds found: ${count_edit} | WardId=${wardId_edit}

    # ✅ Expected schema
    @{expected_keys}=    Create List
    ...    WardName
    ...    ID_Ward
    ...    RoomNo
    ...    BedNo
    ...    RoomTypeName
    ...    BedStatus
    ...    ID_Bed

    ${SELECTED_INPATIONT_BED_ID}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | '${key}' not found | Item=${item}
        END

        # ✅ انتخاب اولین Bed معتبر (ساده و deterministic)
        IF    ${SELECTED_INPATIONT_BED_ID} == ${None}
            ${SELECTED_INPATIONT_BED_ID}=    Set Variable    ${item["ID_Bed"]}
            ${SELECTED_INPATIONT_BED_NO}=    Set Variable    ${item["RoomTypeName"]}
            Log To Console
            ...    ✅ Bed selected | ID_Bed=${SELECTED_INPATIONT_BED_ID} | Room=${item["RoomNo"]} | BedNo=${item["BedNo"]}
        END
    END

    Should Not Be Equal
    ...    ${SELECTED_INPATIONT_BED_ID}    ${None}
    ...    ❌ No valid Bed ID selected

    ${INPATIONT_BED_ID_EDIT}=           Set Variable    ${json_edit[0]["ID_Bed"]}
    ${INPATIONT_BED_NO_EDIT}=           Set Variable    ${json_edit[0]["RoomTypeName"]}

    # ✅ ذخیره state برای تست‌های بعدی (ChangeToAdmit)
    Write State    INPATIONT_BED_ID    ${SELECTED_INPATIONT_BED_ID}
    Write State    INPATIONT_BED_NO    ${SELECTED_INPATIONT_BED_NO}
    Write State    INPATIONT_BED_ID_Edit    ${INPATIONT_BED_ID_EDIT}
    Write State    INPATIONT_BED_NO_Edit    ${INPATIONT_BED_NO_EDIT}
    Log To Console    💾 BED_ID saved to state: ${SELECTED_INPATIONT_BED_ID}

    Set Test Message
    ...    Response: ${resp.status_code}\n

012-Get Doctors By Ward Id
    [Documentation]     تخت های خالی بر اساس id بخش مثلا بخش 201
    [Tags]    API_GeneralVariables  METHOD_GET  DOCTORS_LIST

    # ${wardId}=    Set Variable    204

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

    ${target}=    Evaluate    [x for x in $json if x["standardVariableId"]==${Doctor_ID}]
    ${target_2}=    Evaluate    [x for x in $json if x["standardVariableId"]==${Doctor_ID_Edit}]
    
    ${FOUND_Doctor_ID}=    Set Variable    ${target[0]["standardVariableId"]}
    ${FOUND_Doctor_NAME}=    Set Variable    ${target[0]["name"]}
    ${FOUND_Doctor_ID_EDIT}=    Set Variable    ${target_2[0]["standardVariableId"]}
    ${FOUND_Doctor_NAME_EDIT}=    Set Variable    ${target_2[0]["name"]}

    Write State    Doctor_ID    ${FOUND_Doctor_ID} 
    Write State    Doctor_NAME    ${FOUND_Doctor_NAME}
    Write State    Doctor_ID_EDIT    ${FOUND_Doctor_ID_EDIT}
    Write State    Doctor_NAME_EDIT    ${FOUND_Doctor_NAME_EDIT}  

    Log To Console    ✅ PASS | GetDoctorsByWard | Count=${count} doctors | WardId=${wardId}

    Set Test Message
    ...    Response: ${resp.status_code}\n


013-Get Emergency Wards
    [Documentation]    نام بخش های اورژانس تحت نظر 
    [Tags]    API_GeneralVariables  METHOD_GET  Emergency_Ward_LIST  Emergency

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetEmergencyWards
    ...    headers=&{headers}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=     Set Variable    ${resp.json()}
    
    FOR    ${item}    IN    @{json}
        IF    ${item["standardVariableId"]} == 200
            ${EMERGENCY_WARD_ID}=      Set Variable    ${item["standardVariableId"]}
            ${EMERGENCY_WARD_NAME}=    Set Variable    ${item["name"]}
            Exit For Loop
        END
    END
    
    &{WARD}=    Create Dictionary
    ...    id=${EMERGENCY_WARD_ID}
    ...    name=${EMERGENCY_WARD_NAME}

    Write State    EMERGENCY_WARD_ID      ${EMERGENCY_WARD_ID}
    Write State    EMERGENCY_WARD_NAME    ${EMERGENCY_WARD_NAME}  

    Set Test Message
    ...    Response: ${resp.status_code}\n   

014-Get All Bed Number Of Emengemcy Ward
    [Documentation]   دریافت لیست تخت های خالی اورژانس تحت نظر 
    [Tags]    API_GeneralVariables  METHOD_GET  EMERGENCY_BED_ID_LIST  Emergency

    &{headers}=    Create Dictionary
    ...    Accept=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/GeneralVariables/GetAllBedNumber?wardId=200
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
    ...    msg=❌ EMPTY RESULT | No beds found | WardId=200

    Log To Console    🛏 Beds found: ${count} | WardId=200

    # ✅ Expected schema
    @{expected_keys}=    Create List
    ...    WardName
    ...    ID_Ward
    ...    RoomNo
    ...    BedNo
    ...    RoomTypeName
    ...    BedStatus
    ...    ID_Bed

    ${SELECTED_EMERGEMCY_BED_ID}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | '${key}' not found | Item=${item}
        END

        # ✅ انتخاب اولین Bed معتبر (ساده و deterministic)
        IF    ${SELECTED_EMERGEMCY_BED_ID} == ${None}
            ${SELECTED_EMERGEMCY_BED_ID}=    Set Variable    ${item["ID_Bed"]}
            ${SELECTED_EMERGEMCY_BED_NO}=    Set Variable    ${item["RoomTypeName"]}
            Log To Console
            ...    ✅ Bed selected | ID_Bed=${SELECTED_EMERGEMCY_BED_ID} | Room=${item["RoomNo"]} | BedNo=${item["BedNo"]}
        END
    END

    Should Not Be Equal
    ...    ${SELECTED_EMERGEMCY_BED_ID}    ${None}
    ...    ❌ No valid Bed ID selected

    # ✅ ذخیره state برای تست‌های بعدی (ChangeToAdmit)
    Write State    EMERGEMCY_BED_ID    ${SELECTED_EMERGEMCY_BED_ID}
    Write State    EMERGEMCY_BED_NO    ${SELECTED_EMERGEMCY_BED_NO}

    Log To Console    💾 EMERGEMCY_BED_ID saved to state: ${SELECTED_EMERGEMCY_BED_ID}

    Set Test Message
    ...    Response: ${resp.status_code}\n

015-Get All City
    [Documentation]    دریافت لیست کامل شهر ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllCity   
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllCity | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllCity | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["city_Default"]=="1"]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_CityBase
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_CityBase | API: GetAllJobs

    Dictionary Should Contain Key
    ...    ${json[0]}    city_Name
    ...    msg=❌ SCHEMA ERROR | Missing key: city_Name | API: GetAllJobs

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_State
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_State | API: GetAllCity

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllCity Loaded Successfully | Total City: ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | City 'تهران' not found in response | API: GetAllCity

    ${city_Base_Name}=    Set Variable    ${target[0]["city_Name"]}
    ${city_Base_ID}=           Set Variable    ${target[0]["iD_CityBase"]}

    Write State    city_Base_ID    ${city_Base_ID}
    Write State    city_Base_Name    ${city_Base_Name}

    Log To Console    ✅ PASS | city validated | ID=${target[0]["iD_CityBase"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n


016-Get All Marital Status
    [Documentation]    دریافت لیست وضعیت تاهل
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllMaritalStatus
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllMaritalStatus | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllMaritalStatus | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["iD_Sepas"]==363]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_Sepas
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_Sepas | API: GetAllMaritalStatus

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ SCHEMA ERROR | Missing key: name | API: GetAllMaritalStatus

    Dictionary Should Contain Key
    ...    ${json[0]}    sepas_Code
    ...    msg=❌ SCHEMA ERROR | Missing key: sepas_Code | API: GetAllMaritalStatus

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllMaritalStatus Loaded Successfully | Total MaritalStatus : ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | MaritalStatus '363' not found in response | API: GetAllMaritalStatus

    ${Marital_Status_ID}=    Set Variable    ${target[0]["iD_Sepas"]}
    ${Marital_Status_Name}=           Set Variable    ${target[0]["name"]}

    Write State    Marital_Status_ID    ${Marital_Status_ID}
    Write State    Marital_Status_Name    ${Marital_Status_Name}

    Log To Console    ✅ PASS | Marital Status validated | ID=${target[0]["iD_Sepas"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n


017-Get All Nationality
    [Documentation]    دریافت لیست ملیت ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllNationality
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllNationality | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllNationality | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["iD_GVariable"]==912]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_GVariable
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_GVariable | API: GetAllNationality

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ SCHEMA ERROR | Missing key: name | API: GetAllNationality

    Dictionary Should Contain Key
    ...    ${json[0]}    sepas_Code
    ...    msg=❌ SCHEMA ERROR | Missing key: sepas_Code | API: GetAllNationality

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllNationality Loaded Successfully | Total Nationality : ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | Nationality '912' not found in response | API: GetAllNationality

    ${Nationality_ID}=    Set Variable    ${target[0]["iD_GVariable"]}
    ${Nationality_Name}=           Set Variable    ${target[0]["name"]}

    Write State    Nationality_ID      ${Nationality_ID}
    Write State    Nationality_Name    ${Nationality_Name}

    Log To Console    ✅ PASS | Marital Status validated | ID=${target[0]["iD_GVariable"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n

018-Get All Insurance
    [Documentation]    دریافت لیست بیمه ها 
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllInsurance
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllInsurance | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllInsurance | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target_Azad}=    Evaluate    [x for x in $json if x["standardVariableId"]==1]
    ${target_Tamin}=    Evaluate    [x for x in $json if x["standardVariableId"]==6]

    Dictionary Should Contain Key
    ...    ${json[0]}    standardVariableId
    ...    msg=❌ SCHEMA ERROR | Missing key: standardVariableId | API: GetAllInsurance

    Dictionary Should Contain Key
    ...    ${json[0]}    sepasId
    ...    msg=❌ SCHEMA ERROR | Missing key: sepasId | API: GetAllInsurance

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllInsurance Loaded Successfully | Total Insurance : ${count}

    Should Not Be Empty
    ...    ${target_Azad}
    ...    msg=❌ DATA ERROR | sepasId '127' not found in response | API: GetAllInsurance

    ${Azad_Insurance_Sepas_ID}=    Set Variable    ${target_Azad[0]["sepasId"]}
    ${Azad_Insurance_name}=    Set Variable    ${target_Azad[0]["name"]}
    ${Tamin_Insurance_Sepas_ID}=    Set Variable    ${target_Tamin[0]["sepasId"]}
    ${Tamin_Insurance_name}=    Set Variable    ${target_Tamin[0]["name"]}

    Write State    Azad_Insurance_Sepas_ID      ${Azad_Insurance_Sepas_ID}
    Write State    Azad_Insurance_name          ${Azad_Insurance_name}
    Write State    Tamin_Insurance_Sepas_ID     ${Tamin_Insurance_Sepas_ID}
    Write State    Tamin_Insurance_name         ${Tamin_Insurance_name}

019-Get All Relationship
    [Documentation]    دریافت لیست نسبیت ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllRelationship
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllRelationship | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllRelationship | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["relationshipName"]=="پدر"]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_Relationship
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_Relationship | API: GetAllRelationship

    Dictionary Should Contain Key
    ...    ${json[0]}    relationshipName
    ...    msg=❌ SCHEMA ERROR | Missing key: relationshipName | API: GetAllRelationship

    Dictionary Should Contain Key
    ...    ${json[0]}    iD2
    ...    msg=❌ SCHEMA ERROR | Missing key: iD2 | API: GetAllRelationship

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllRelationship Loaded Successfully | Total Relationship : ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | relationshipName 'پدر' not found in response | API: GetAllRelationship

    ${Relationship_Name}=           Set Variable    ${target[0]["relationshipName"]}

    Write State    Relationship_Name    ${Relationship_Name}

    Log To Console    ✅ PASS | Relationship validated | ID=${target[0]["relationshipName"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n


020-Get All Type Admission
    [Documentation]    دریافت لیست نوع پذیرش
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllTypeAdmission
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllTypeAdmission | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllTypeAdmission | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target_inpationt}=    Evaluate    [x for x in $json if x["iD_Sepas"]==370]
    ${target_emergency}=    Evaluate    [x for x in $json if x["iD_Sepas"]==372]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_Sepas
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_Sepas | API: GetAllTypeAdmission

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ SCHEMA ERROR | Missing key: name | API: GetAllTypeAdmission

    Dictionary Should Contain Key
    ...    ${json[0]}    sepas_Code
    ...    msg=❌ SCHEMA ERROR | Missing key: sepas_Code | API: GetAllTypeAdmission

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllTypeAdmission Loaded Successfully | Total Type Admission : ${count}

    ${Inpationt_Admission_Type_Sepas}=           Set Variable    ${target_inpationt[0]["iD_Sepas"]}
    ${Inpationt_Admission_Type_Name}=           Set Variable    ${target_inpationt[0]["name"]}
    ${Emergency_Admission_Type_Sepas}=           Set Variable    ${target_emergency[0]["iD_Sepas"]}
    ${Emergency_Admission_Type_Name}=           Set Variable    ${target_emergency[0]["name"]}

    Write State    Inpationt_Admission_Type_Sepas    ${Inpationt_Admission_Type_Sepas}
    Write State    Inpationt_Admission_Type_Name    ${Inpationt_Admission_Type_Name}
    Write State    Emergency_Admission_Type_Sepas    ${Emergency_Admission_Type_Sepas}
    Write State    Emergency_Admission_Type_Name    ${Emergency_Admission_Type_Name}

    Set Test Message
    ...    Response: ${resp.status_code}\n


021-Get All Doctors
    [Documentation]    دریافت لیست پزشکان
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllDoctors
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllDoctors | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ \n WRONG STATUS \n API: GetAllDoctors \n Expected: 200 \n Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Set Test Message
    ...    Response: ${resp.status_code}\n


022-Get All Doctor 
    [Documentation]    دریافت لیست پزشکان
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    url=/api/GeneralVariables/GetAllDoctor?wardId=${wardId}
    ...    headers=${headers}

    Log To Console    STATUS : ${resp.status_code}
    Log To Console    BODY   : ${resp.text}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllDoctor | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllDoctor | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty   
    ...    ${json}    
    ...    msg=❌ \n API: GetAllDoctor \n Body Is Empty \n Body : ${json} \n Response: ${resp.status_code}

    Set Test Message
    ...    Response: ${resp.status_code}\n


023-Get All Supplementary Insurance
    [Documentation]    دریافت لیست بیمه های تکمیلی
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllSupplementaryInsurance
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllSupplementaryInsurance | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllSupplementaryInsurance | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["sepasID"]==98]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_Insurance2
    ...    msg=❌ SCHEMA ERROR | Missing key: iD_Insurance2 | API: GetAllSupplementaryInsurance

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ SCHEMA ERROR | Missing key: name | API: GetAllSupplementaryInsurance

    Dictionary Should Contain Key
    ...    ${json[0]}    sepasID
    ...    msg=❌ SCHEMA ERROR | Missing key: sepasID | API: GetAllSupplementaryInsurance

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS | GetAllSupplementaryInsurance Loaded Successfully | Total Insurance2 : ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ DATA ERROR | iD_Insurance2 '19' not found in response | API: GetAllSupplementaryInsurance

    ${iD_Insurance2}=           Set Variable    ${target[0]["sepasID"]}
    ${Name_Insurance2}=           Set Variable    ${target[0]["name"]}

    Write State    Insurance2_ID    ${iD_Insurance2}
    Write State    Insurance2_Name    ${Name_Insurance2}

    Log To Console    ✅ PASS | Name_Insurance2 validated | ID=${target[0]["name"]}

    Set Test Message
    ...    Response: ${resp.status_code}\n

024-Get All Referral Centers
    [Documentation]    دریافت مراکز ارجاع 
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllReferralCenters
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllReferralCenters | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllReferralCenters | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty   
    ...    ${json}    
    ...    msg=❌ \n API: GetAllReferralCenters \n Body Is Empty \n Body : ${json} 

    Set Test Message
    ...    Response: ${resp.status_code}\n

025-Get All Type Treatment For Certain Centers
    [Documentation]   دریافت همه انواع خدمات درمانی برای مراکز مشخص
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllTypeTreatmentForCertainCenters
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllTypeTreatmentForCertainCenters | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ \n WRONG STATUS \n API: GetAllTypeTreatmentForCertainCenters \n Expected: 200 \n Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Set Test Message
    ...    Response: ${resp.status_code}\n

026-Get All Physician Special Centers
    [Documentation]  دریافت تمام مراکز تخصصی پزشکان
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllPhysicianSpecialCenters
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllPhysicianSpecialCenters | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ \n WRONG STATUS \n API: GetAllPhysicianSpecialCenters \n Expected: 200 \n Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Set Test Message
    ...    Response: ${resp.status_code}\n

027-Get All Translators
    [Documentation]   دریافت همه مترجمان
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllTranslators
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllTranslators | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllTranslators | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty   
    ...    ${json}    
    ...    msg=❌ \n API: GetAllTranslators \n Body Is Empty \n Body : ${json} 

    Set Test Message
    ...    Response: ${resp.status_code}\n


028-Get All Education
    [Documentation]   دریافت لیست تحصیلات 
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllEducation
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetAllEducation | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetAllEducation | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty   
    ...    ${json}    
    ...    msg=❌ API: GetAllTranslators | Body Is Empty | Body : ${json} 

029-Get All RoomType
    [Documentation]    دریافت لیست نوع اتاق های بیمارستان
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllRoomType
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ \n NO RESPONSE \n API: GetAllRoomType \n Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ \n WRONG STATUS \n API: GetAllRoomType \n Expected: 200 \n Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    ${target}=    Evaluate    [x for x in $json if x["Status_RoomType"]==0]

    Dictionary Should Contain Key
    ...    ${json[0]}    ID_RoomType
    ...    msg=❌ SCHEMA ERROR \n Missing key: ID_RoomType \n API: GetAllRoomType

    Dictionary Should Contain Key
    ...    ${json[0]}    RoomTypeName
    ...    msg=❌ SCHEMA ERROR \n Missing key: RoomTypeName \n API: GetAllRoomType

    Dictionary Should Contain Key
    ...    ${json[0]}    Status_RoomType
    ...    msg=❌ \n SCHEMA ERROR \n Missing key: Status_RoomType \n API: GetAllRoomType

    ${count}=    Get Length    ${json}
    Log To Console    ✅ PASS \n GetAllRoomType Loaded Successfully \n Total Insurance2 : ${count}

    Should Not Be Empty
    ...    ${target}
    ...    msg=❌ \n DATA ERROR \n RoomType not found in response \n API: GetAllRoomType

    Set Test Message
    ...    Response: ${resp.status_code}\n


030-Get All State
    [Documentation]    دریافت لیست نام تمام استان ها 
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetAllState
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ \n NO RESPONSE \n API: GetAllState \n Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ \n WRONG STATUS \n API: GetAllState \n Expected: 200 \n Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    # ${target}=    Evaluate    [x for x in $json if x["Status_RoomType"]==0]

    Dictionary Should Contain Key
    ...    ${json[0]}    iD_State
    ...    msg=❌ \n SCHEMA ERROR \n Missing key: iD_State \n API: GetAllState

    Dictionary Should Contain Key
    ...    ${json[0]}    code
    ...    msg=❌ \n SCHEMA ERROR \n Missing key: code \n API: GetAllState

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ \n SCHEMA ERROR \n Missing key: name \n API: GetAllState

    ${count}=    
    ...    Get Length    ${json}
    Log To Console    ✅ \n PASS \n All State Loaded Successfully \n Total State : ${count}

    Should Not Be Empty
    ...    ${json}
    ...    msg=❌ \n DATA ERROR \n State not found in response \n API: GetAllState

    Set Test Message
    ...    Response: ${resp.status_code}\n


031-Get Genders
    [Documentation]    دریافت لیست جنسیت ها
    [Tags]    API_GeneralVariables    METHOD_GET  

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session    
    ...    HIS    
    ...    /api/GeneralVariables/GetGenders
    ...    headers=${headers}

    Run Keyword If    '${resp}'=='None'
    ...    Fail    ❌ NO RESPONSE | API: GetGenders | Server did not respond (Timeout / Network)

    Should Be Equal As Integers
    ...    ${resp.status_code}    200
    ...    msg=❌ WRONG STATUS | API: GetGenders | Expected: 200 | Actual: ${resp.status_code}

    ${json}=    Set Variable    ${resp.json()}

    # ${target}=    Evaluate    [x for x in $json if x["Status_RoomType"]==0]

    Dictionary Should Contain Key
    ...    ${json[0]}    id
    ...    msg=❌ SCHEMA ERROR | Missing key: id | API: GetGenders

    Dictionary Should Contain Key
    ...    ${json[0]}    name
    ...    msg=❌ SCHEMA ERROR | Missing key: name | API: GetGenders

    Dictionary Should Contain Key
    ...    ${json[0]}    sepas_Code
    ...    msg=❌ SCHEMA ERROR | Missing key: sepas_Code | API: GetGenders

    ${count}=    
    ...    Get Length    ${json}
    Log To Console    ✅ PASS | Genders Loaded Successfully | Total Genders : ${count}

    Should Not Be Empty
    ...    ${json}
    ...    msg=❌ DATA ERROR | Genders not found in response | API: GetGenders

    Set Test Message
    ...    Response: ${resp.status_code}\n


032-Check Filing Doubling
    [Documentation]    بررسی تکراری بودن پذیرش بیمار بر اساس اطلاعات هویتی
    [Tags]    API_Filing  METHOD_POST 

    ${nationalCode}=   Read State    NATIONALCODE
    ${firstname}=      Read State    FIRSTNAME
    ${lastname}=       Read State    LASTNAME
    ${fatherName}=     Read State    FATHERNAME

    &{headers}=    Create Dictionary
    ...    Accept=application/json, text/plain, */* 
    ...    Content-Type=application/json
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN} 
    ...    Accept-Language=en

    &{checkDto}=    Create Dictionary
    ...    nationalCode=${nationalCode}
    ...    firstName=${firstname}
    ...    lastName=${lastname}
    ...    fatherName=${fatherName}

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

        Set Test Message
        ...    Response: ${resp.status_code}\n 

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

        Fail
        ...    ❌ FAIL \n CheckFilingDoubling \n Unexpected HTTP Status=${http_status} \n  Patient already admitted !!!

    ELSE
        Fail
        ...    ❌ FAIL | CheckFilingDoubling
        ...    | Unexpected HTTP Status=${http_status}
    END

    



033-Check Patient Debt
    [Documentation]    بررسی بدهی بیمار
    [Tags]    API_Patient    METHOD_POST    Debt

    ${nationalCode}=      Read State    NATIONALCODE

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json 
    ...    Content-Type=application/json
    ...    Accept-Language=en

    &{body}=    Create Dictionary
    ...    fileFormationId=0
    ...    nationalCode=${nationalCode}

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

    ${json}=    Evaluate    $resp.json()
    Log    ${resp.json()}

    ${extra_msg}=    Set Variable    ${json['amount']}

    IF    ${extra_msg} == 0.0
    
        ${json}=    Evaluate    $resp.json()

        ${STATUS}=    Set Variable    OK

        Set Test Message
        ...    Response: ${resp.status_code}\n Message: ${json['message']} \n ${STATUS}

    ELSE IF    ${extra_msg} != 0.0
         ${json}=    Evaluate    $resp.json()

        ${STATUS}=    Set Variable    ⚠️ Patient has debt: ${json['amount']}

        Set Test Message
        ...    Response: ${resp.status_code}\n Message: ${json['message']} \n ${STATUS}

    END


034-Add Filing Preadmit Resarve
    [Documentation]   پذیرش بیمار preadmit
    [Tags]    API_Filing    METHOD_POST    preadmit

    ${ward_value}=      Read State    INPATIONT_WARD_NAME
    ${nationalCode}=      Read State    NATIONALCODE
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Inpationt_Admission_Type_Sepas}=    Read State    Inpationt_Admission_Type_Sepas
    ${Inpationt_Admission_Type_Name}=    Read State    Inpationt_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${wardId}
	...    wardName=${ward_value}
    ...    physicianID=599
    ...    recommender=
    ...    admissionType=${Inpationt_Admission_Type_Sepas}
    ...    patientClass=5    #
    ...    priority=3        #
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${True}
    ...    bCutting=${True}
    ...    bDischarge=${True}
    ...    bSurgery=${True}
    ...    bUsingFile=${True}
    ...    admissionReason=دل درد
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=(1تروماP14.9
    ...    diagnosisId=13309
    ...    insuranceID=6
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=${pishPardaght}
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=2028/04/04
    ...    sponsor=خود فرد
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${Marital_Status_ID}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=dfgdfgdfgd
    ...    familyPhone1=09373969517
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=0
    ...    bedId=0
    ...    bedNo=
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/AddFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Log To Console    Response Status: ${resp.status_code}
    Log To Console    Response Body: ${resp.text}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    ${FOUND_PREADMIT_ADMIT_ID}=    Set Variable    ${json["admitId"]}
    ${FOUND_PREADMIT_ADMIT_DATE}=    Set Variable    ${json["admitDate"]}
    ${FOUND_PREADMIT_TITLE_TYPE}=    Set Variable    ${json["titleType"]}
    ${FOUND_PREADMIT_FILEFORMATION_ID}=    Set Variable    ${json["fileFormationId"]}


    Write State    PREADMIT_ADMIT_ID    ${FOUND_PREADMIT_ADMIT_ID}  
    Write State    PREADMIT_ADMIT_DATE    ${FOUND_PREADMIT_ADMIT_DATE}
    Write State    PREADMIT_TITLE_TYPE    ${FOUND_PREADMIT_TITLE_TYPE}
    Write State    PREADMIT_FILEFORMATION_ID    ${FOUND_PREADMIT_FILEFORMATION_ID}  

    Log To Console    ✅ ADMIT_ID saved: ${FOUND_PREADMIT_ADMIT_ID}

    Set Test Message
    ...    Response: ${resp.status_code}\n Patient Admit.

035-Validate Database After Preadmit Rezerve 
    [Documentation]   تست دیتابیس بعد از پذیرش پری ادمیت
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    Validate AdmitHIS After Preadmit    ${FOUND_PREADMIT_FILEFORMATION_ID}
    Validate Pationt-Movement After Preadmit    ${FOUND_PREADMIT_FILEFORMATION_ID}
    Validate Tbl-Bed After Preadmit    ${FOUND_PREADMIT_FILEFORMATION_ID}

    Set Test Message
    ...    Response: 200 \n Message: Validate Database After Preadmit Rezerve Pass


036-Search PreAdmit patiant 
    [Documentation]   جستجوی بیماران preadmit
    [Tags]    API_Patient    METHOD_POST  priadmit 

    ${nationalCode}=      Read State    NATIONALCODE

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
    ...    dateFrom=2026/01/01
    ...    dateTo=2026/12/12
    ...    status=0

    ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Patient/SearchPreAdmits
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)


037-Edit Filing Preadmit
    [Documentation]   ویرایش بیمار preadmit
    [Tags]    API_Filing    METHOD_POST    preadmit

    ${ward_value}=      Read State    INPATIONT_WARD_NAME
    ${ADMIT_ID}=      Read State    PREADMIT_ADMIT_ID
    ${ADMIT_DATE}=      Read State    PREADMIT_ADMIT_DATE
    ${TITLE_TYPE}=      Read State    PREADMIT_TITLE_TYPE
    ${PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID
    
    ${ward_value_edit}=      Read State    INPATIONT_WARD_ID_EDIT
    ${nationalCode}=      Read State    NATIONALCODE
    ${EMERGENCY_ward_NAME}=      Read State    EMERGENCY_WARD_NAME
    ${EMERGENCY_WARD_ID}=      Read State    EMERGENCY_WARD_ID
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${EMERGEMCY_BED_NO}=      Read State    EMERGEMCY_BED_NO
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Inpationt_Admission_Type_Sepas}=    Read State    Inpationt_Admission_Type_Sepas
    ${Inpationt_Admission_Type_Name}=    Read State    Inpationt_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${Doctor_ID_EDIT}=    Read State    Doctor_ID_EDIT
    ${Diagnosis-Name-Edit}=    Read State    Diagnosis-Name-Edit
    ${Diagnosis-ID-Edit}=    Read State    Diagnosis-ID-Edit
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  
    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${PREADMIT_FILEFORMATION_ID}
	...    inquiryUId=250bf58f-4c2d-4cd5-9d78-c0d45bcdee99
    ...    admitDate=${ADMIT_DATE}
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${ward_value_edit}         # new ward
	...    wardName=
    ...    physicianID=${Doctor_ID_EDIT}        # new doctor
    ...    recommender=
    ...    admissionType=370
    ...    patientClass=5
    ...    priority=3
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${True}
    ...    bCutting=${True}
    ...    bDischarge=${True}
    ...    bSurgery=${True}
    ...    bUsingFile=${True}
    ...    admissionReason=گلودرد        # new admissionreason
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=${Diagnosis-Name-Edit}       # new diadnosis
    ...    diagnosisId=${Diagnosis-ID-Edit}                # new diagnosisid
    ...    insuranceID=6
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=${pishPardaght}           # ziro paishpardaght
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=0019208291
    ...    insuranceExpDate=2028/04/04
    ...    sponsor=شوهر        # new sponsor
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=363
	...    job=
    ...    jobId=0
    ...    homeCity=تهران
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=09196964067        # new homePhone1    
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=مهرشاد شیخ الاسلامی     #
    ...    familyRelationship=پدر
    ...    familyCity=تهران
    ...    familyAddress=ویرایش1        # new familyAddress
    ...    familyPhone1=09217460838        # new familyphone1
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=363
    ...    husbandJobID=0
    ...    husbandNationalityID=912
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=${ADMIT_ID}
    ...    bedId=0
    ...    bedNo=
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/EditFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Be True    ${json["isSuccess"]}
    Should Be Equal As Integers    ${json["statusCode"]}    200
    Should Be Equal    ${json["message"]}    Success

038-Validate DataBase After Edit Preadmit
    [Documentation]   تست دیتابیس بعد از ویرایش  پذیرش Preafmit
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DB After Edit Preadmit    ${FOUND_PREADMIT_FILEFORMATION_ID}


039-Change To Admit From Preadmit
    [Documentation]  تبدیل preadmit به بستری
    [Tags]    API_Filing    METHOD_POST  priadmit 

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID 
    ${BED_ID}=      Read State    INPATIONT_BED_ID_Edit

    Log To Console     Using ADMIT_ID=${PREADMIT_ADMIT_ID}, BED_ID=${BED_ID}

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    
    &{preAdmitDto}=    Create Dictionary
    ...    admitId=${PREADMIT_ADMIT_ID}
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

040-Validate DataBase After Change Preadmit To Admit
    [Documentation]   تست دیتابیس بعد از رزرو preadmit
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DateBase After Change Preadmit To Admit    ${FOUND_PREADMIT_FILEFORMATION_ID}


041-Add Filing Preadmit Part2 For Cancel Reserve
    [Documentation]   پذیرش بیمار preadmit برای کنسل کردن 
    [Tags]    API_Filing    METHOD_POST    preadmit

    ${ward_value}=      Read State    INPATIONT_WARD_NAME
    ${nationalCode}=      Read State    NATIONALCODE
    ${EMERGENCY_ward_NAME}=      Read State    EMERGENCY_WARD_NAME
    ${EMERGENCY_WARD_ID}=      Read State    EMERGENCY_WARD_ID
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${EMERGEMCY_BED_NO}=      Read State    EMERGEMCY_BED_NO
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Inpationt_Admission_Type_Sepas}=    Read State    Inpationt_Admission_Type_Sepas
    ${Inpationt_Admission_Type_Name}=    Read State    Inpationt_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${wardId}
	...    wardName=${ward_value}
    ...    physicianID=599
    ...    recommender=
    ...    admissionType=${Inpationt_Admission_Type_Sepas}
    ...    patientClass=5    #
    ...    priority=3        #
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${True}
    ...    bCutting=${True}
    ...    bDischarge=${True}
    ...    bSurgery=${True}
    ...    bUsingFile=${True}
    ...    admissionReason=دل درد
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=(1تروماP14.9
    ...    diagnosisId=13309
    ...    insuranceID=6
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=${pishPardaght}
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=2028/04/04
    ...    sponsor=خود فرد
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${Marital_Status_ID}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=dfgdfgdfgd
    ...    familyPhone1=09373969517
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=0
    ...    bedId=0
    ...    bedNo=
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/AddFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Log To Console    Response Status: ${resp.status_code}
    Log To Console    Response Body: ${resp.text}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    ${FOUND_PREADMIT_ADMIT_ID}=    Set Variable    ${json["admitId"]}
    ${FOUND_PREADMIT_ADMIT_DATE}=    Set Variable    ${json["admitDate"]}
    ${FOUND_PREADMIT_TITLE_TYPE}=    Set Variable    ${json["titleType"]}
    ${FOUND_PREADMIT_FILEFORMATION_ID}=    Set Variable    ${json["fileFormationId"]}


    Write State    PREADMIT_ADMIT_ID    ${FOUND_PREADMIT_ADMIT_ID}  
    Write State    PREADMIT_ADMIT_DATE    ${FOUND_PREADMIT_ADMIT_DATE}
    Write State    PREADMIT_TITLE_TYPE    ${FOUND_PREADMIT_TITLE_TYPE}
    Write State    PREADMIT_FILEFORMATION_ID    ${FOUND_PREADMIT_FILEFORMATION_ID}  

    Log To Console    ✅ ADMIT_ID saved: ${FOUND_PREADMIT_ADMIT_ID}

042-Cancel Reserve PreAdmit
    [Documentation]    کنسل کردن پذیرش بیمار preadmit
    [Tags]    API_FILING    METHOD_POST   Catable    preadmit 

    ${PREADMIT_ADMIT_ID}=      Read State    PREADMIT_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary     
    ...    admitId=${PREADMIT_ADMIT_ID}


    ${resp}=    POST On Session    
    ...    HIS
    ...    /api/Filing/CancelPreAdmit
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}


043-Validate DataBase After Cancel Preadmit Reserve
    [Documentation]   تست دیتابیس بعد از پذیرش پری ادمیت
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DB After Cancel Preadmit Reserve    ${FOUND_PREADMIT_FILEFORMATION_ID}

044-Add Filing Preadmit Part3 For Cancel Admit
    [Documentation]   پذیرش قطعی بیمار preadmit برای کنسل کردن 
    [Tags]    API_Filing    METHOD_POST    preadmit

    ${ward_value}=      Read State    INPATIONT_WARD_NAME
    ${nationalCode}=      Read State    NATIONALCODE
    ${EMERGENCY_ward_NAME}=      Read State    EMERGENCY_WARD_NAME
    ${EMERGENCY_WARD_ID}=      Read State    EMERGENCY_WARD_ID
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${EMERGEMCY_BED_NO}=      Read State    EMERGEMCY_BED_NO
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Inpationt_Admission_Type_Sepas}=    Read State    Inpationt_Admission_Type_Sepas
    ${Inpationt_Admission_Type_Name}=    Read State    Inpationt_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${wardId}
	...    wardName=${ward_value}
    ...    physicianID=599
    ...    recommender=
    ...    admissionType=${Inpationt_Admission_Type_Sepas}
    ...    patientClass=5    #
    ...    priority=3        #
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${True}
    ...    bCutting=${True}
    ...    bDischarge=${True}
    ...    bSurgery=${True}
    ...    bUsingFile=${True}
    ...    admissionReason=دل درد
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=(1تروماP14.9
    ...    diagnosisId=13309
    ...    insuranceID=6
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=${pishPardaght}
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=2028/04/04
    ...    sponsor=خود فرد
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${Marital_Status_ID}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=dfgdfgdfgd
    ...    familyPhone1=09373969517
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=0
    ...    bedId=0
    ...    bedNo=
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/AddFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Log To Console    Response Status: ${resp.status_code}
    Log To Console    Response Body: ${resp.text}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    ${FOUND_PREADMIT_ADMIT_ID}=    Set Variable    ${json["admitId"]}
    ${FOUND_PREADMIT_ADMIT_DATE}=    Set Variable    ${json["admitDate"]}
    ${FOUND_PREADMIT_TITLE_TYPE}=    Set Variable    ${json["titleType"]}
    ${FOUND_PREADMIT_FILEFORMATION_ID}=    Set Variable    ${json["fileFormationId"]}


    Write State    PREADMIT_ADMIT_ID    ${FOUND_PREADMIT_ADMIT_ID}  
    Write State    PREADMIT_ADMIT_DATE    ${FOUND_PREADMIT_ADMIT_DATE}
    Write State    PREADMIT_TITLE_TYPE    ${FOUND_PREADMIT_TITLE_TYPE}
    Write State    PREADMIT_FILEFORMATION_ID    ${FOUND_PREADMIT_FILEFORMATION_ID}  

    Log To Console    ✅ ADMIT_ID saved: ${FOUND_PREADMIT_ADMIT_ID}

045-Save Pay Naghdi From Cash
    [Documentation]   پرداخت پیش پرداخت بیمار preadmit
    [Tags]    API_Cash    METHOD_POST    Cash      preadmit 
    
    ${ward_value}=      Read State    INPATIONT_WARD_NAME
    ${nationalCode}=      Read State    NATIONALCODE
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Inpationt_Admission_Type_Sepas}=    Read State    Inpationt_Admission_Type_Sepas
    ${Inpationt_Admission_Type_Name}=    Read State    Inpationt_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_FILEFORMATION_ID}=    Read State    PREADMIT_FILEFORMATION_ID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE
    ${Doctor_ID}=    Read State    Doctor_ID  
    ${Doctor_NAME}=    Read State    Doctor_NAME  


    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${listAdded}=    Create Dictionary     
    ...		iD_TotalCash=0
    ...		admitID=${PREADMIT_ADMIT_ID}
    ...		clinicTitleType=249
    ...		fileFormationID=${PREADMIT_FILEFORMATION_ID}
    ...		patientPayment=${pishPardaght}
    ...		cashPayment=0
    ...		reduction=0
    ...		realPrice=${pishPardaght} 
    ...		cashType=5
    ...		note=
    ...		fromPos=false
    ...		fromBank=false
    ...		fromInternet=false
    ...		discountTypeID=0
    ...		iD_ClinicCash=0
    ...		ticketNo=
    ...		operatorName=
    ...		operatorDate=
    ...		operatorTime=
    ...		opName=
    ...		opDate=
    ...		opTime=
    ...		opNameE=
    ...		opDateE=
    ...		opTimeE=
    ...		bankSn=0
    ...		posSerialNo=
    ...		contractEntityId=0
    ...		currencyID=0
    ...		currencyPrice=0
    ...		date=
    ...		chequeID=0
    ...		paymentReasonID=0
    ...		indexString=
    ...		personPaymentID=0
    ...		clinicTitleTypeString=
    ...		freeBedID=0

    ${listBastari}=    Create Dictionary
    ...		id=1
    ...		admitID=${PREADMIT_ADMIT_ID}
    ...		fileFormationID=${PREADMIT_FILEFORMATION_ID}
    ...		hospitalID=${HOSPITALFILEID}
    ...		patientName=${FIRSTNAME} ${LASTNAME}
    ...		date=${PREADMIT_ADMIT_DATE}
    ...		type=249
    ...		cashType=5
    ...		discount=0
    ...		payableForHospital=0
    ...		accountNoForHospital=IR HOS Darman
    ...		payableForDoctor=0
    ...		doctorID=${Doctor_ID}
    ...		accountNoForDoctor=
    ...		payableForDarman=${pishPardaght}
    ...		payableForDaroo=0
    ...		payable=${pishPardaght}
    ...		typeString=بستري
    ...		phonenumber=${MOBILE}
    ...		services=null
    ...		fatherName=${FATHERNAME}
    ...		doctorName=${Doctor_NAME}
    ...		insuranceName=تامين اجتماعي
    ...		nCode=1520554001
    ...		emergencyNo=140300250
    ...		admitOperator=آزيتا فشارکي نيا
    ...		patientServicePrice=0
    ...		patientPaid=0
    ...		accountNoForDarman=IR HOS Darman
    ...		darmanID=null
    ...		accountNoForDaroo=
    ...		darooID=
    ...		patientStatus=5
    ...		searchField=شيخالاسلاميمهرشاد3563466836761520554001
    ...		debt=0
    ...		insurID=6
    ...		radifNo=1
    ...		clinicTitleName=بستري
    ...		grandPaName=0
    ...		iD_TotalCash=0
    ...		checkbox=true
    ...		refund=0
    ...		payment=10000
    ...		selected=true
    ...		TodayDate=true
    ...		clearing=false
    ...		disabled=true

    ${nonCash}=    Create Dictionary
    ...		cardNo=
    ...		shebaNo=
    ...		name=
    ...		relationID=0
    ...		note=
    ...		iD_NonCashRePayment=0
    ...		clinicCashID=0
    ...		type=0
    ...		status=0
    ...		opName=
    ...		opDate=
    ...		opTime=
    ...		opNameE=
    ...		opDateE=
    ...		opTimeE=
    ...		admitID=0
    ...		price=0
    ...		fullName=

    ${body}=    Create Dictionary
    ...    listAdded=${listAdded}
    ...    listBastari=${listBastari}
    ...    nonCashRePayment=${nonCash}
    ...    ravashPardakht=0
    ...    offline=${False}
    ...    offlineRRN=
    ...    offlineNote=
    ...    posConfigID=0
    ...    macAddress=70-32-17-60-A8-9B


    ${resp}=    POST On Session    
    ...    Cash
    ...    /api/Cash/SavePayNaghdi
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 


046-Cancel Admit PreAdmit
    [Documentation]    کنسل کردن پذیرش بیمار preadmit
    [Tags]    API_FILING    METHOD_POST    preadmit 

    ${PREADMIT_ADMIT_ID}=      Read State    PREADMIT_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary     
    ...    admitId=${PREADMIT_ADMIT_ID}


    ${resp}=    POST On Session    
    ...    HIS
    ...    /api/Filing/CancelPreAdmit
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

047-Validate DataBase After Cancel Preadmit Admit
    [Documentation]   تست دیتابیس بعد از پذیرش پری ادمیت
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DB After Cancel Preadmit Admit    ${FOUND_PREADMIT_FILEFORMATION_ID}

048-Add Filing Emergency Patient
    [Documentation]   پذیرش بیمار اورژانس تحت نظر
    [Tags]    API_Filing    METHOD_POST    Emergency

    ${EMERGENCY_ward_NAME}=      Read State    EMERGENCY_WARD_NAME
    ${EMERGENCY_WARD_ID}=      Read State    EMERGENCY_WARD_ID
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${EMERGEMCY_BED_NO}=      Read State    EMERGEMCY_BED_NO
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Emergency_Admission_Type_Sepas}=    Read State    Emergency_Admission_Type_Sepas
    ${Emergency_Admission_Type_Name}=    Read State    Emergency_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${Diagnosis_ID}=    Read State    Diagnosis-ID
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${insuranceExpDate}=    Convert Jalali To Gregorian    ${lastInsurance_ExpDate}

  
    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${EMERGENCY_WARD_ID}
	...    wardName=${EMERGENCY_ward_NAME}
    ...    physicianID=592
    ...    recommender=
    ...    admissionType=${Emergency_Admission_Type_Sepas}
    ...    patientClass=0
    ...    priority=2
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${False}
    ...    bCutting=${False}
    ...    bDischarge=${False}
    ...    bSurgery=${False}
    ...    bUsingFile=${False}
    ...    admissionReason=سوختگي
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=${Diagnosis_Name}
    ...    diagnosisId=${Diagnosis_ID}
    ...    insuranceID=${lastInsurance_ID}
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=0
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=${insuranceExpDate}
    ...    sponsor=اورژانس
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${LASTMARITALSTATUS}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=dfgdfgdfgd
    ...    familyPhone1=09126944812
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=0
    ...    bedId=${EMERGEMCY_BED_ID}
    ...    bedNo=${EMERGEMCY_BED_NO}
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/AddFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    ${FOUND_EMERGENCY_ADMIT_ID}=    Set Variable    ${json["admitId"]}
    ${FOUND_EMERGENCY_ADMIT_DATE}=    Set Variable    ${json["admitDate"]}
    ${FOUND_EMERGENCY_TITLE_TYPE}=    Set Variable    ${json["titleType"]}
    ${FOUND_EMERGENCY_FILEFORMATION_ID}=    Set Variable    ${json["fileFormationId"]}


    Write State    EMERGENCY_ADMIT_ID    ${FOUND_EMERGENCY_ADMIT_ID}  
    Write State    EMERGENCY_ADMIT_DATE    ${FOUND_EMERGENCY_ADMIT_DATE}
    Write State    EMERGENCY_TITLE_TYPE    ${FOUND_EMERGENCY_TITLE_TYPE}
    Write State    EMERGENCY_FILEFORMATION_ID    ${FOUND_EMERGENCY_FILEFORMATION_ID}  

    Log To Console    ✅ EMERGENCY_ADMIT_ID saved: ${FOUND_EMERGENCY_ADMIT_ID}

049-Validate DataBase After Admit Emergency Patient
    [Documentation]   تست دیتابیس بعد از پذیرش بیمار تحت نظر
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DB After Admit Emergency Patient    ${FOUND_PREADMIT_FILEFORMATION_ID}

050-Search Patient Emergency
    [Documentation]   جستجوی بیماران اورژانس تحت نظر
    [Tags]    API_Patient    METHOD_POST  Emergency 

    ${nationalCode}=      Read State    NATIONALCODE

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    
    ${body}=     Create Dictionary
    ...    firstName=
    ...    grandPaName=
    ...    fatherName=
    ...    lastName=
    ...    nationalCode=${nationalCode}
    ...    electronicNumber=${0}
    ...    dateFrom=${None}
    ...    fromHours=${None}
    ...    toHours=${None}
    ...    ward=${0}
    ...    hospitalNumber=${0}

    ${resp}=    POST On Session
    ...    HIS
    ...    url=/api/Patient/SearchPatientEmergency
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200

    ${json}=    Set Variable    ${resp.json()}
    Should Be True    isinstance($json, list)


051-Get Patient By AdmitID
    [Documentation]   دریافت اطلاعات بیمار بستری اورژانش با شماره پذیرش
    [Tags]    API_Patient    METHOD_GET    Emergency    

    ${EMERGENCY_ADMIT_ID} =    Read State    EMERGENCY_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/Patient/GetPatientByAdmitID?admitId=${EMERGENCY_ADMIT_ID}
    ...    headers=&{headers}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty    ${json}

052-Edit Filing Emergency Patient
    [Documentation]   ویرایش بیمار بستری اورژانس تحت نظر
    [Tags]    API_Filing    METHOD_POST    Emergency

    ${EMERGENCY_ADMIT_ID}=      Read State    EMERGENCY_ADMIT_ID
    ${EMERGENCY_ADMIT_DATE}=      Read State    EMERGENCY_ADMIT_DATE
    ${EMERGENCY_ward_NAME}=      Read State    EMERGENCY_WARD_NAME
    ${EMERGENCY_WARD_ID}=      Read State    EMERGENCY_WARD_ID
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${EMERGEMCY_BED_NO}=      Read State    EMERGEMCY_BED_NO
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Emergency_Admission_Type_Sepas}=    Read State    Emergency_Admission_Type_Sepas
    ${Emergency_Admission_Type_Name}=    Read State    Emergency_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${Diagnosis_ID}=    Read State    Diagnosis-ID
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${insuranceExpDate}=    Convert Jalali To Gregorian    ${lastInsurance_ExpDate}
    

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=${EMERGENCY_ADMIT_DATE}
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${EMERGENCY_WARD_ID}
	...    wardName=${EMERGENCY_ward_NAME}
    ...    physicianID=592
    ...    recommender=
    ...    admissionType=${Emergency_Admission_Type_Sepas}
    ...    patientClass=0
    ...    priority=2
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${False}
    ...    bCutting=${False}
    ...    bDischarge=${False}
    ...    bSurgery=${False}
    ...    bUsingFile=${False}
    ...    admissionReason=سوختگي
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=${Diagnosis_Name}
    ...    diagnosisId=${Diagnosis_ID}
    ...    insuranceID=${lastInsurance_ID}
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=0
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=${insuranceExpDate}
    ...    sponsor=خود فرد        #edit
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${LASTMARITALSTATUS}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=تهران خ قزوین    #edit
    ...    familyPhone1=0912656565        #edit
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=false
    ...    iD_Admit=${EMERGENCY_ADMIT_ID}
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${False}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/EditFiling
    ...    headers=&{headers} 
    ...    data=${json_string}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Be True    ${json["isSuccess"]}
    Should Be Equal As Integers    ${json["statusCode"]}    200
    Should Be Equal    ${json["message"]}    Success

053-Patient Admission Order From Cartable
    [Documentation]    بستری بیمار تحت نظر از کارتابل
    [Tags]    API_Patient    METHOD_POST   Catable    Emergency 

    ${EMERGENCY_ADMIT_ID}=      Read State    EMERGENCY_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    &{body}=    Create Dictionary     
    ...    admitId=${EMERGENCY_ADMIT_ID}


    ${resp}=    POST On Session    
    ...    Cartable
    ...    /api/Patient/PatientAdmissionOrder
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Be True    ${json["isSuccess"]}
    Should Be Equal As Integers    ${json["statusCode"]}    200
    Should Be Equal    ${json["message"]}    Operation completed


    ${server_date}=    Get From Dictionary    ${resp.headers}    Date

    ${expected}=    Evaluate    (lambda d:(lambda dt:(lambda iran:(lambda j:(j.strftime("%Y/%m/%d"), j.strftime("%H:%M")))(__import__('jdatetime').datetime.fromgregorian(datetime=iran)))(dt+__import__('datetime').timedelta(hours=3,minutes=30)))(__import__('datetime').datetime.strptime(d,"%a, %d %b %Y %H:%M:%S GMT")))($server_date)


    ${expected_date}=    Set Variable    ${expected}[0]
    ${expected_time}=    Set Variable    ${expected}[1]

    Write State    Send_To_Ward_Date    ${expected_date}
    Write State    Send_To_Ward_Time    ${expected_time}


054-Validate DataBase After Patient Admission Order From Cartable
    [Documentation]   تست دیتابیس بعد از پذیرش بیمار تحت نظر
    [Tags]    DB-Test    preadmit

    ${FOUND_PREADMIT_FILEFORMATION_ID}=      Read State    PREADMIT_FILEFORMATION_ID

    
    Validate DB After Patient Admission Order From Cartable    ${FOUND_PREADMIT_FILEFORMATION_ID}

055-Get Information Of Patient Before Sent To Ward
    [Documentation]      دریافت اطلاعات بیمار  اورژانس جهت انتقال به بخش
    [Tags]    API_Patient    METHOD_GET    Emergency    

    ${EMERGENCY_ADMIT_ID} =    Read State    EMERGENCY_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${resp}=    GET On Session
    ...    HIS
    ...    url=/api/Patient/SendPatientFromEmergencyToWard?admitId=${EMERGENCY_ADMIT_ID}
    ...    headers=&{headers}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    Should Not Be Empty    ${json}

    ${EMERGENCY_UNIQUE_NO}=    Set Variable    ${json["fileFormation"]["uniqueEmergencyNo"]}

    Write State    UNIQUEMERGENCYNO    ${EMERGENCY_UNIQUE_NO}

056-1-Get All Bed Number For Send To Ward
    [Documentation]    لیست تخت های خالی بر اساس id بخش مثلا بخش 201
    [Tags]    API_GeneralVariables  METHOD_GET  BED_LIST    Emergency

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

    ${SELECTED_INPATIONT_BED_ID}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        FOR    ${key}    IN    @{expected_keys}
            Run Keyword If    '${key}' not in ${item}
            ...    Fail    ❌ MISSING KEY | '${key}' not found | Item=${item}
        END

        # ✅ انتخاب اولین Bed معتبر (ساده و deterministic)
        IF    ${SELECTED_INPATIONT_BED_ID} == ${None}
            ${SELECTED_INPATIONT_BED_ID}=    Set Variable    ${item["ID_Bed"]}
            ${SELECTED_INPATIONT_BED_NO}=    Set Variable    ${item["RoomTypeName"]}
            Log To Console
            ...    ✅ Bed selected | ID_Bed=${SELECTED_INPATIONT_BED_ID} | Room=${item["RoomNo"]} | BedNo=${item["BedNo"]}
        END
    END

    Should Not Be Equal
    ...    ${SELECTED_INPATIONT_BED_ID}    ${None}
    ...    ❌ No valid Bed ID selected

    # ✅ ذخیره state برای تست‌های بعدی (ChangeToAdmit)
    Write State    INPATIONT_BED_ID    ${SELECTED_INPATIONT_BED_ID}
    Write State    INPATIONT_BED_NO    ${SELECTED_INPATIONT_BED_NO}
    Log To Console    💾 BED_ID saved to state: ${SELECTED_INPATIONT_BED_ID}

056-2-Get All Names Inpatient Wards For Send To Ward
    [Documentation]    دریافت لیست بخش‌های بستری
    [Tags]    API_GeneralVariables    METHOD_GET    Emergency

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

    ${TARGET_WARD_NAME}=    Set Variable    ${wardId}
    ${FOUND_INPATIONT_WARD_NAME}=    Set Variable    ${None}

    FOR    ${item}    IN    @{json}
        IF    '${item["standardVariableId"]}' == '${TARGET_WARD_NAME}'
            ${FOUND_INPATIONT_WARD_NAME}=    Set Variable    ${item["name"]}
            Exit For Loop
        END
    END

    Write State    INPATIONT_WARD_NAME    ${FOUND_INPATIONT_WARD_NAME}    

    Log To Console    ✅ INPATIONT_WARD_NAME saved: ${FOUND_INPATIONT_WARD_NAME}


056-3-Send To Ward Emergency Patient
    [Documentation]     انتقال بیمار اورژانس به بخش 
    [Tags]    API_FILING    METHOD_POST    Emergency

    ${INPATIONT_WARD_NAME}=      Read State  INPATIONT_WARD_NAME
    ${INPATIONT_BED_ID}=      Read State     INPATIONT_BED_ID
    ${INPATIONT_BED_NO}=      Read State     INPATIONT_BED_NO
    ${EMERGENCY_ADMIT_ID}=    Read State    EMERGENCY_ADMIT_ID
    ${EMERGENCY_ADMIT_DATE}=    Read State    EMERGENCY_ADMIT_DATE
    ${HOSPITALFILEID}=      Read State    HOSPITALFILEID
    ${NATIONALCODE}=      Read State    NATIONALCODE
    ${FIRSTNAME}=      Read State    FIRSTNAME
    ${LASTNAME}=      Read State    LASTNAME
    ${FATHERNAME}=      Read State    FATHERNAME
    ${DISPLAYNAME}=      Read State    DISPLAYNAME
    ${LASTMARITALSTATUS}=      Read State    LASTMARITALSTATUS
    ${LASTCITYID}=      Read State    LASTCITYID
    ${RELIGION}=      Read State    RELIGION
    ${NATIONALITYID}=      Read State    NATIONALITYID
    ${SEXID}=      Read State    SEXID
    ${SEX}=      Read State    SEX
    ${MOBILE}=      Read State    MOBILE
    ${BIRTHCITYID}=      Read State    BIRTHCITYID
    ${LASTINSURANCENO}=      Read State    LASTINSURANCENO
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${UNIQUEMERGENCYNO}=    Read State    UNIQUEMERGENCYNO
    ${Marital_Status_ID}=    Read State    Marital_Status_ID
    ${city_Base_ID}=    Read State    city_Base_ID
    ${city_Base_Name}=    Read State    city_Base_Name
    ${Marital_Status_Name}=    Read State    Marital_Status_Name
    ${Nationality_Name}=    Read State    Nationality_Name
    ${INQUIRYUID}=    Read State    INQUIRYUID
    ${Emergency_Admission_Type_Sepas}=    Read State    Emergency_Admission_Type_Sepas
    ${Emergency_Admission_Type_Name}=    Read State    Emergency_Admission_Type_Name
    ${Relationship_Name}=    Read State    Relationship_Name
    ${LASTINSURBOX_SEPASID}=    Read State    LASTINSURBOX_SEPASID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${Diagnosis_ID}=    Read State    Diagnosis-ID
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${insuranceExpDate}=    Convert Jalali To Gregorian    ${lastInsurance_ExpDate}
  
    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json
    ...    Content-Type=application/json
    ...    charset=utf-8

    ${fileFormation}=    Create Dictionary
    ...    name=${FIRSTNAME}
    ...    nameEn=
    ...    middleName=${DISPLAYNAME}
    ...    familyName=${LASTNAME}
    ...    familyEnName=
    ...    fatherName=${FATHERNAME}
    ...    grandPaName=
	...    motherName=
    ...    momGrandPaName=
    ...    maritalStatus=${Marital_Status_ID}
    ...    cityId=${city_Base_ID}
    ...    relegiousStatus=${RELIGION}
    ...    unknownType=0
    ...    passportType=0
    ...    residencePermit=${False}
    ...    nationalCode=${nationalCode}
	...    parentNationalCode=
    ...    identityCode=
    ...    nationality=${NATIONALITYID}
    ...    passportNumber=
    ...    sex=${SEXID}
    ...    sexString=${SEX}
    ...    email=
    ...    mobileNo=${MOBILE}
    ...    birthPlace=${city_Base_ID}
    ...    birthPlaceOut=
    ...    birthDate=2002/07/07
	...    maritalStatusString=${Marital_Status_Name}
    ...    nationalityTitle=${Nationality_Name}
    ...    birthPlaceString=${city_Base_Name}
    ...    image=
    ...    addressLine=dfgdfgdfgd
    ...    phoneNo=
    ...    postalCode=
    ...    unknown=${False}
    ...    hospitalFileID=${HOSPITALFILEID}
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
    ...    uniqueEmergencyNo=0
    ...    fileFormationId=${FileFormationID}
    ...    husbandName=
    ...    husbandLastName=
    ...    triageId=0
    ...    isNationalCodeRequired=${True}
  

    ${hisAdmitDto}=    Create Dictionary
    ...    fileFormationID=${FileFormationID}
	...    inquiryUId=${INQUIRYUID}
    ...    admitDate=${EMERGENCY_ADMIT_DATE}    #
    ...    admitTime=
    ...    isDischarged=${False}
    ...    dischargeDate=
    ...    dischargeTime=
    ...    dischargeStep=0
    ...    dischargeDebt=0
    ...    wardIdIn=${wardId}
	...    wardName=${INPATIONT_WARD_NAME}
    ...    physicianID=592
    ...    recommender=
    ...    admissionType=${Emergency_Admission_Type_Sepas}
    ...    patientClass=2    #
    ...    priority=2
	...    ability=0
    ...    limitation1=${False}
    ...    limitation2=${False}
    ...    limitation3=${False}
    ...    limitation4=${False}
    ...    limitation5=${False}
    ...    bPolice=${False}
    ...    bCutting=${False}
    ...    bDischarge=${False}
    ...    bSurgery=${False}
    ...    bUsingFile=${False}
    ...    admissionReason=سوختگي
    ...    entranceType=393
	...    emsId=0
    ...    krokiCode=0
    ...    diagnosis=${Diagnosis_Name}
    ...    diagnosisId=${Diagnosis_ID}
    ...    insuranceID=${lastInsurance_ID}
	...    insurPageNo=0
    ...    insurSerialNO=
    ...    recomendationNo=
    ...    insurMax=0
    ...    pishPardaght=0
    ...    pishPardaghtDoctor=0
    ...    doctorTotalCost=0
    ...    referenceDoctorID=0
    ...    insuranceNO=${LASTINSURANCENO}
    ...    insuranceExpDate=${insuranceExpDate}
    ...    sponsor=خود فرد
    ...    degree=0         
    ...    shebaNo=
    ...    maritalStatus=${LASTMARITALSTATUS}
	...    job=
    ...    jobId=0
    ...    homeCity=${city_Base_Name}
    ...    homeZone=
    ...    homeAddress=dfgdfgdfgd
    ...    homePhone1=${MOBILE}
    ...    homePhone2=
    ...    homePostCode=
    ...    workPlaceName=
    ...    workCity=
    ...    workAddress=
    ...    workPhone1=
    ...    workPhone2=
    ...    workFax=
    ...    workPostCode=
    ...    familyFullName=${FATHERNAME}
    ...    familyRelationship=${Relationship_Name}
    ...    familyCity=${city_Base_Name}
    ...    familyAddress=تهران خ قزوین 
    ...    familyPhone1=0912656565
    ...    familyPhone2=
    ...    familyPostCode=
    ...    husbandNCode=
    ...    husbandFirstName=
    ...    husbandLastName=
    ...    husbandBirthDate=
    ...    husbandIdentityNo=
    ...    husbandIssuePlaceID=0
    ...    husbandJobID=0
    ...    husbandNationalityID=0
    ...    husbandPassportID=
    ...    tourismId=0
    ...    isPregnant=${False}
    ...    iD_Admit=${EMERGENCY_ADMIT_ID}
    ...    bedId=${INPATIONT_BED_ID}
    ...    bedNo=${INPATIONT_BED_NO}
    ...    referal=
    ...    referalCenter=0
    ...    operationDate=
    ...    operationTime=
    ...    sendToWardDate=
    ...    sendToWardTime=
    ...    followUpAdmitId=0
    ...    isInfantUnder28Days=${False}
    ...    supRecomendationNo=

    ${filingDto}=    Create Dictionary
    ...    fileFormation=${fileFormation}
    ...    hisAdmitDto=${hisAdmitDto}
	...    insuranceNote=
    ...    insur_Relation=18
    ...    lastInsuranceKind=${LASTINSURBOX_SEPASID}
	...    lastInsuranceDate=
    ...    insur2ID=0
    ...    insur2No=0
    ...    insur2Max=0
    ...    wasInEmergency=${True}

    ${body}=    Create Dictionary
    ...    filingDto=${filingDto}

    ${json_string}=    Evaluate    json.dumps(${body}, ensure_ascii=False)    json

    ${resp}=    POST On Session
    ...    HIS 
    ...    url=/api/Filing/SendToWard
    ...    headers=&{headers} 
    ...    data=${json_string}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

    ${FOUND_INPATIENT_ADMIT_ID}=    Set Variable    ${json["data"]["admitId"]}
    ${FOUND_INPATIENT_ADMIT_DATE}=    Set Variable    ${json["data"]["admitDate"]}
    ${FOUND_INPATIENT_TITLE_TYPE}=    Set Variable    ${json["data"]["titleType"]}
    ${FOUND_INPATIENT_FILEFORMATION_ID}=    Set Variable    ${json["data"]["fileFormationId"]}


    Write State    INPATIENT_ADMIT_ID            ${FOUND_INPATIENT_ADMIT_ID}  
    Write State    INPATIENT_ADMIT_DATE          ${FOUND_INPATIENT_ADMIT_DATE}
    Write State    INPATIENT_TITLE_TYPE          ${FOUND_INPATIENT_TITLE_TYPE}
    Write State    INPATIENT_FILEFORMATION_ID    ${FOUND_INPATIENT_FILEFORMATION_ID}  

    
057-Changing Sheba No
    [Documentation]    عوض کردن شماره شبای وارد شده برای بیمار 
    [Tags]    API_FILING    METHOD_POST    PUBLIC    

    ${INPATIENT_ADMIT_ID}=    Read State    INPATIENT_ADMIT_ID

    &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${changingShebaNoDto}=    Create Dictionary
    ...    shebaNo=1425100000015236251
    ...    admitId=${INPATIENT_ADMIT_ID}


    ${body}=    Create Dictionary
    ...    changingShebaNoDto=${changingShebaNoDto}

    ${resp}=    POST On Session    
    ...    HIS
    ...    /api/Filing/ChangingShebaNo
    ...    headers=&{headers}
    ...    json=${body}

    Should Be Equal As Integers    ${resp.status_code}    200 

    ${json}=    Set Variable    ${resp.json()}

058-Send To His Live
    [Documentation]    ارسال پذیرش برای His Live
    [Tags]    API_FILING    METHOD_POST    PUBLIC    

    ${INPATIENT_ADMIT_ID}=    Read State    INPATIENT_ADMIT_ID

   &{headers}=    Create Dictionary
    ...    Authorization=${AUTH_BEARER}
    ...    Cookie=${COOKIE_TOKEN}
    ...    Accept=application/json

    ${body}=    Create Dictionary
    ...    changingShebaNoDto=${changingShebaNoDto}

    ${resp}=    POST On Session    
    ...    HIS
    ...    /api/Filing/ChangingShebaNo
    ...    headers=&{headers}
    ...    json=${body}
34-
35-