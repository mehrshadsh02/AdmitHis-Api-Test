*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary


Suite Setup       Create AdmitHIS Session

*** Variables ***
${AdmitHis_Api_URL}       http://192.168.5.19:1600

${AdmitHis_App_URL}       http://192.168.5.19:8019/filing

${Cash_App_URL}       http://192.168.5.19:8075/admit

${BROWSER}        chrome

${CHROME_DRIVER}    C:/chromedriver.exe

${AUTH_BEARER}    bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjU4NmM4ZTIyLTNjMmEtNGZlYi05ZjUwLWMwNzk4ZGFlNDk5MyIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJCLzJxS1BFUUNYTXBaZjF3ay9GUGZZeGlWRWVNUEdqM3JMSVB4TTMyR3lJVXJJV3dZWUxkQnd0R29pZ25ENGpmNEQwa1RLa3U0WjZMcm9zWXh1dHZ3UnM0bDRER1pKNjJueS9MZkpGYjNqU2hFc2oxR3l0R081cDlHemkwZEF5SSIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc3MDI2MjY0NCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.5yu1hH5l8qWWrG-sO3xPdv2aPsVmqbg9sDI2DIBH840

${COOKIE_TOKEN}   eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsImtpZCI6IjU4NmM4ZTIyLTNjMmEtNGZlYi05ZjUwLWMwNzk4ZGFlNDk5MyIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3VzZXJkYXRhIjoiOSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiIzMDYyNyIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvc2VyaWFsbnVtYmVyIjoiMzhmMTZmMWNmNjNlODJlZjM1YTU5MTg4YWExYWFhZWQzNTg2M2YxNTgzYTY3NTJmMmYxNWMyNmUwNDIzNzEwNyIsIlVzZXJJZCI6IjkiLCJVc2VyRGlzcGxheU5hbWUiOiLYotiy24zYqtinINmB2LTYp9ix2qnbjCDZhtuM2KciLCJUZW5hbnRJZCI6IjEwMDE1IiwiQ2l0eUlkIjowLCJQZXJzb25JZCI6OTIzLCJMb2dpblBhZ2VVcmwiOiIxOTIuMTY4LjUuNjYiLCJOUElEIjoiIiwidXNpbmYiOiJCLzJxS1BFUUNYTXBaZjF3ay9GUGZZeGlWRWVNUEdqM3JMSVB4TTMyR3lJVXJJV3dZWUxkQnd0R29pZ25ENGpmNEQwa1RLa3U0WjZMcm9zWXh1dHZ3UnM0bDRER1pKNjJueS9MZkpGYjNqU2hFc2oxR3l0R081cDlHemkwZEF5SSIsIkNJRCI6IiIsIkFJRCI6IjEwMCIsIkNlbnRlck5hbWUiOiLZhdix2qnYsiDYqtmH2LHYp9mGIiwiVXNlckVtYWlsQWRkcmVzcyI6IiIsIkR5bmFtaWNQZXJtaXNzaW9uS2V5IjoiMzIzOTYwMzhmY2EwMWNiNjlkMmM0NGIwOTY0NjI0ZDFmZTQ2MWM5NzgwY2ZmYzdmOTU1ODJhOGFhOTc3YzJhMSIsIklkbGV0aW1lIjoiMjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbImNoZWNrIiwicm9sZSJdLCJSb2xlSWQiOjExOTUsImV4cCI6MTc3MDI2MjY0NCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo3NzQwLyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MjY1OC8ifQ.5yu1hH5l8qWWrG-sO3xPdv2aPsVmqbg9sDI2DIBH840

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

Disable Screenshots
    Register Keyword To Run On Failure    NONE    
    
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

# PreAdmit Test
01-UI - Open Filing Page
    [Documentation]   باز  کردن صفحه پذیرش بستری
    [Tags]    STEP_01_Open_Browser    UI_Test    
    Start Browser AdmitHis With Token
    Go To AdmitHis Page
    Wait For Spinner Hidden
    Log To Console    ---- DONE ----

# زمانی که کاربر شروع به پذیرش میکنه و کد ملی رو وارد میکنه و استحقاق درمان میکنه

02-UI - Enter national code of preadmit patient
    [Documentation]   وارد کردن کد ملی بیمار و استعلام کد ملی
    [Tags]    UI_Test    
        
    Wait For Page Ready
    Wait Until Element Is Visible    //input[@formcontrolname='nationalCode']    10s
    Clear Element Text    //input[@formcontrolname='nationalCode']
    Input Text         //input[@formcontrolname='nationalCode']     ${nationalCode}
    Click Element Safe       id=button-addon3
    Wait For Page Ready


# پر کردن باقی فیلد های مهم در پذیرش 

03-UI - Fill Patient PreAdmit Info
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

04-UI - Assign Ward And Doctor And Prepayment
    [Documentation]    انتخاب بخش و پزشک بیمار preadmit
    [Tags]    UI_Test

    Wait For Page Ready
    Select From Ng Select    wardfileld             اطفال 2 - تخت خالی (33)
    Select From Ng Select    doctorField             Siavash Siavash
    Select From Ng Select    responsiblePatient     خود فرد

    Input Text         //input[@formcontrolname='prepayment']             10000

05-UI - Save Admission Filing
    [Documentation]    سیو کردن پذیرش preadmit
    [Tags]    UI_Test

    Click Element Safe     css=button.btn-saveFile
    Wait For Page Ready


# زدن دکمه لغو صفحه پرینت برگه پذیرش 

06-UI - deny admit print page
    [Documentation]    لغو پرینت برگه پذیرش 
    [Tags]    UI_Test    

    Click Element Safe    css=button.swal2-deny.swal2-styled

07-UI - Open Cash Web And Pay
    [Documentation]     باز کردن صندوق و دریافت پیش پرداخت بیمار پری ادمیت
    [Tags]    UI_Test
    
    Cash Pay Patient By National Code    ${nationalCode}


08-UI - go to inpatient list
    [Documentation]    رفتن به لیست بیماران بستری 
    [Tags]    UI_Test    
    
    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    Wait For Page Ready
    Switch To AdmitHis App
    Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a   
    Wait For Page Ready


09-UI - Load Preadmit Patient List
    [Documentation]    لیست بیماران preadmit 
    [Tags]    UI_Test   
    
    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    # Wait For Page Ready
    # Click Element Safe    xpath=//img[@src='assets/icons/inpatient.svg']/ancestor::a  
    Wait For Page Ready
    Click Element Safe    xpath=//span[contains(@class,'mat-checkbox-inner-container')]
    Wait For Page Ready

10-UI - Edit Preadmit Patient
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

11-UI - Cancel Preadmit 
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

12-UI - Open Cash Web And Refund
    [Documentation]   بازپرداخت به بیمار در صندوق
    [Tags]    UI_Test
    
    Cash Refund Patient By National Code    ${nationalCode}   

#------------------------------------------------------------------------------
# Inpatient Admit Test

13-UI - Open Filling Page
    [Documentation]   باز  کردن صفحه پذیرش بستری
    [Tags]    Open_Browser    UI_Test    step13    inpatient
    Disable Screenshots
    Start Browser AdmitHis With Token
    Go To AdmitHis Page
    Wait For Page Ready
    # Switch To AdmitHis App
    Wait For Spinner Hidden
    Log To Console    ---- DONE ----

14- Enter national code of inpatient 
    [Documentation]   وارد کردن کد ملی بیمار و استعلام کد ملی
    [Tags]    UI_Test    step14    inpatient

    Disable Screenshots    
    Wait For Page Ready
    Wait Until Element Is Visible    //input[@formcontrolname='nationalCode']    10s
    Clear Element Text    //input[@formcontrolname='nationalCode']
    Input Text         //input[@formcontrolname='nationalCode']     ${nationalCode}
    Click Element Safe       id=button-addon3
    Wait For Page Ready     

15-UI - Fill inpatient Info
    [Documentation]    پر کردن اطلاعات مورد نیاز بیمار 
    [Tags]    UI_Test    step15    inpatient
    
    Disable Screenshots
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

    Select From Ng Select    patientClass            بستری
    Select From Ng Select    firstRecognition         شکستگی
    Select From Ng Select    howToRefer               وسیله شخصی
    Select From Ng Select    causeOfHospitalization   دل درد

16-UI - Assign Ward And Doctor 
    [Documentation]    انتخاب بخش و پزشک بیمار preadmit
    [Tags]    UI_Test    step16    inpatient
    
    Disable Screenshots
    # Start Browser AdmitHis With Token
    # Go To AdmitHis Page
    # Wait For Page Ready
    Select From Ng Select    wardfileld             اطفال 2 - تخت خالی (33)
    Select From Ng Select    bedNum            اتاق1 - تخت عمومي - تخت18
    Select From Ng Select    doctorField             Siavash Siavash
    Select From Ng Select    responsiblePatient     خود فرد
  
17-UI - Save Admission Filing
    [Documentation]    سیو کردن پذیرش preadmit
    [Tags]    UI_Test  step17  inpatient

    Click Element Safe     css=button.btn-saveFile
    Click Element Safe    css=button.swal2-confirm.swal2-styled
    Wait For Page Ready

18-UI - deny admit print page
    [Documentation]    لغو پرینت برگه پذیرش 
    [Tags]    UI_Test  step18  inpatient

    Click Element Safe    css=button.swal2-deny.swal2-styled
