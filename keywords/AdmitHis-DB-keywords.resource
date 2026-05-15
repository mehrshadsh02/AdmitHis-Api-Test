*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem
Library           SeleniumLibrary
Library           JSONLibrary
Library           DatabaseLibrary
Library           pymssql

Resource          ../resources/AdmitHis-variables.resource
Resource          ../keywords/AdmitHis-keywords.resource


*** Keywords ***
Connect To HIS Database
    Connect To Database
    ...    db_module=pymssql
    ...    db_name=${DB_NAME}
    ...    db_user=${DB_USER}
    ...    db_password=${DB_PASS}
    ...    db_host=${DB_HOST} 
    ...    charset=cp1256
    



Validate FileFormation After Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${query}=    Set Variable    SELECT ID_FileFormation, NationalCode, FirstName, LastName, Status_FileFormation FROM FileFormation${\n}WHERE ID_FileFormation=${fileFormationId}
    ${rows}=    Query    ${query}    


    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}

    Should Be Equal As Integers    ${row[4]}    0
    Should Not Be Empty            ${row[1]}

    Set Test Message    Validate Fileformation After Preadmit Pass


Validate AdmitHIS After Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID

    ${rows}=    Query   SELECT ID_Admit, FileFormationID, DischargeStep , WardIdIn, PatientClass ,Priority ,Status_AdmitHIS, PishPardaght FROM Admit_HIS WHERE ID_Admit=${PREADMIT_ADMIT_ID}

    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    

    Should Be Equal As Integers    ${row[0]}    ${PREADMIT_ADMIT_ID}           msg= Admit Id Not Mach
    Should Be Equal As Integers    ${row[1]}    ${PREADMIT_iD_FileFormation}   msg= Fileformation Id Not Mach
    Should Be Equal As Integers    ${row[2]}    14                             msg= Discharge Step Is Not 14
    Should Be Equal As Integers    ${row[3]}    ${wardId}                      msg= Ward Id Is Not Mach
    Should Be Equal As Integers    ${row[4]}    5                              msg= PatientClass Is Not 5
    Should Be Equal As Integers    ${row[5]}    3                              msg= Priority Is Not 3
    Should Be Equal As Integers    ${row[6]}    0                              msg= Admit Status Is Not 0
    Should Be Equal As Integers    ${row[7]}    ${pishPardaght}                msg= Pishpardakht Is Not Mach

    Set Test Message    Validate AdmitHis After Preadmit Pass

Validate HospitalID After Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID

    ${rows}=    Query     SELECT HospitalID, HisAdmitID, Status FROM Hospital_ID FROM FileFormation WHERE HisAdmitID=${PREADMIT_ADMIT_ID}

    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}

    Should Be Equal As Integers    ${row[2]}    0

    Set Test Message    Validate HospitalID After Preadmit Pass  

Validate Pationt-Movement After Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID

    ${rows}=    Query   SELECT AdmitID, PreBedID, BedID, Date, Time, Type From Patient_Movement WHERE AdmitID=${PREADMIT_ADMIT_ID}

    Should Be Empty    ${rows}    msg= Pationt-Movement Has Record

    Set Test Message    Validate Pationt-Movement After Preadmit Pass  

Validate Tbl-Bed After Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID

    ${rows}=    Query   SELECT ID_Bed, WardID, RoomNo, BedNo, AdmitID, BedStatus From Tbl_Bed WHERE AdmitID=${PREADMIT_ADMIT_ID}

    Should Be Empty    ${rows}    msg= Tbl-Bed has record
    
 
Validate DB After Edit Preadmit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE

    ${query}=    Catenate     
    ...    SELECT ${PREADMIT_ADMIT_ID}  AS AdmitId, ISNULL(id_bed,0) as BedId, ISNULL(ID_PatientMovement, 0) AS PatientMovementId, dbo.Fn_GetPatientInfo(${PREADMIT_iD_FileFormation}) AS Name,
    ...    ISNULL(ID_HospitalFileID,0) AS HospitalFileID ,ISNULL(ID_Triage, 0) AS TriageID, ${PREADMIT_iD_FileFormation} AS FileFormationId, 
    ...    AdmitDate, Sepas_Code, ID_ICDMadarek AS ICDMadarekId  
    ...    FROM  admit_his INNER JOIN
    ...    fileformation on FileFormationID = ID_FileFormation INNER JOIN 
    ...    Tbl_Insurance ON Admit_HIS.InsuranceID = Tbl_Insurance.ID_Insurance INNER JOIN 
    ...    sepas ON Tbl_Insurance .SepasID = sepas.ID_Sepas LEFT OUTER JOIN 
    ...    tbl_bed ON id_admit= tbl_bed.AdmitID LEFT OUTER JOIN 
    ...    Patient_Movement ON id_admit= Patient_Movement.AdmitID LEFT OUTER JOIN
    ...    Personal_ID  ON admit_his.fileformationid= Personal_ID.fileformationId LEFT OUTER JOIN 
    ...    Triage  ON admit_his.ID_Admit= triage.Admit_EmergencyID LEFT OUTER JOIN 
    ...    ICD_Madarek  ON admit_his.ID_Admit= ICD_Madarek.AdmitID  
    ...    WHERE id_admit = ${PREADMIT_ADMIT_ID};

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Be Equal As Integers    ${row[1]}    0                               msg= Bed Id not 0
    Should Be Equal As Integers    ${row[2]}    0                               msg= Pationt Movment ID Is NOT 0
    Should Contain                 ${row[3]}    ${NATIONALCODE}                 msg= National Code Wrong   
    Should Be Equal As Integers    ${row[4]}    ${HOSPITALFILEID}               msg= Hospital File ID Not Mach  
    Should Be True                 ${row[5]} >= 0                               msg= Triage ID Not Correct
    Should Be Equal As Integers    ${row[6]}    ${PREADMIT_iD_FileFormation}    msg= Fileformation ID Not Mach
    # Should Be Equal As Integers    ${row[7]}    ${PREADMIT_ADMIT_DATE}

    Set Test Message    Validate DB After Edit Preadmit Pass         

Validate DB After Change Preadmit Rezerve To Admit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE
    ${BED_ID}=      Read State    INPATIONT_BED_ID_Edit
    ${INPATIONT_WARD_ID_EDIT}=    Read State    INPATIONT_WARD_ID_EDIT
  
    ${query_admithis}=    Catenate   
    ...    SELECT ID_Admit, AdmitTime, AdmitDate, PatientClass, DischargeStep, OpNameE, OpDateE, OpTimeE, Status_AdmitHIS 
    ...    FROM Admit_HIS 
    ...    WHERE ID_Admit=${PREADMIT_ADMIT_ID}

    ${query_PatientMovement}=    Catenate   
    ...    SELECT AdmitID, PreBedId, BedId, Date, Time, Type, SysDate, OperatorName, OperatorDate, BedCost, AttendantCost 
    ...    FROM Patient_Movement
    ...    WHERE AdmitID=${PREADMIT_ADMIT_ID}

    ${query_TblBed}=    Catenate   
    ...    SELECT  ID_Bed, WardID, RoomNo, BedNo, AdmitID, BedStatus 
    ...    FROM Tbl_Bed
    ...    WHERE AdmitID=${PREADMIT_ADMIT_ID}


    ${rows_admithis}=    Query    ${query_admithis}
    Should Not Be Empty    ${rows_admithis}
    ${record_admithis}=    Set Variable    ${rows_admithis[0]}

    ${rows_PatientMovement}=    Query    ${query_PatientMovement}
    Should Not Be Empty    ${rows_PatientMovement}
    ${record_PatientMovement}=    Set Variable    ${rows_PatientMovement[0]}

    ${rows_TblBed}=    Query    ${query_TblBed}
    Should Not Be Empty    ${rows_TblBed}
    ${record_TblBed}=    Set Variable    ${rows_TblBed[0]}
    
   
    Should Be Equal As Integers    ${record_admithis[0]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Not Be Empty            ${record_admithis[1]}                                    msg= Admit Time Is Null
    Should Not Be Empty            ${record_admithis[2]}                                    msg= Admit Date ID Is Null
    Should Be Equal As Integers    ${record_admithis[3]}    2                               msg= PatientClass Must Be 2   
    Should Be Equal As Integers    ${record_admithis[4]}    0                               msg= DischargeStep Must Be 0
    Should Not Be Empty            ${record_admithis[5]}                                    msg= OpNameE Is Null
    Should Not Be Empty            ${record_admithis[6]}                                    msg= OpDateE Is Null
    Should Not Be Empty            ${record_admithis[7]}                                    msg= OpTimeE Is Null
    Should Be Equal As Integers    ${record_admithis[8]}    0                               msg= Status_AdmitHIS Is Not 0

    Should Be Equal As Integers    ${record_PatientMovement[0]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Be Equal As Integers    ${record_PatientMovement[1]}    0                               msg= PreBedId Is Not 0
    Should Be Equal As Integers    ${record_PatientMovement[2]}    ${BED_ID}                       msg= BedId Not Mach
    Should Not Be Empty            ${record_PatientMovement[3]}                                    msg= Date Is Null
    Should Not Be Empty            ${record_PatientMovement[4]}                                    msg= Time Is Null
    Should Be True    ${record_PatientMovement[5]} >= 0 and ${record_PatientMovement[5]} <= 4      msg= Type Is Not In Range 0 To 4
    Should Be True                 ${record_PatientMovement[6]}                                    msg= SysDate Is Null
    Should Not Be Empty            ${record_PatientMovement[7]}                                    msg= OperatorName Is Null
    Should Not Be Empty            ${record_PatientMovement[8]}                                    msg= OperatorDate Is Null
    # Should Be True                 ${record_PatientMovement[9]}                                    msg= BedCost Error patientmovment
    # Should Be True                 ${record_PatientMovement[10]}                                   msg= AttendantCost Is Null

    Should Be Equal As Integers    ${record_TblBed[0]}    ${BED_ID}                       msg= Bed ID Not Mach
    Should Be Equal As Integers    ${record_TblBed[1]}    ${INPATIONT_WARD_ID_EDIT}       msg= WardIn Error
    Should Be True                 ${record_TblBed[2]}                                    msg= RoomNo Error
    Should Be True                 ${record_TblBed[3]}                                    msg= BedNo Error  
    Should Be Equal As Integers    ${record_TblBed[4]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Be Equal As Integers    ${record_TblBed[5]}    3                               msg= BedStatus Error

     
    Set Test Message    Validate DB After Edit Preadmit Pass / Admit_His & Patient_Movment & Tbl_Bed Check    


Cancel Preadmit Reserve After Admited
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID

    ${query}=    Catenate     
    ...    UPDATE Admit_HIS
    ...    SET    Status_AdmitHIS = 2
    ...    WHERE  ID_Admit = ${PREADMIT_ADMIT_ID}

    Execute Sql String    ${query}

    ${rows}=    Query    SELECT Status_AdmitHIS FROM Admit_HIS WHERE ID_Admit = ${PREADMIT_ADMIT_ID}

    ${row}=    Set Variable    ${rows[0]}
    Should Be Equal As Integers    ${row[0]}    2


Validate DB After Cancel Preadmit Reserve
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE
    ${Login_Person_Id}=    Read State    Login_Person_Id
    ${Login_Display_Name}=    Read State    Login_Display_Name
    ${Login_User_Name}=     Read State    Login_User_Name
    

    ${query}=    Catenate 
    ...    SELECT TotalCash.ID_TotalCash, TotalCash.FileFormationID, TotalCash.AdmitID, TotalCash.ClinicTitleType, TotalCash.Credit, 
    ...    TotalCash.OperatorID, TotalCash.OperatorName, TotalCash.Note, TotalCash.CashType, Admit_HIS.DischargeStep, 
    ...    Admit_HIS.CancelReasonID,Admit_HIS.PishPardaght, Admit_HIS.DischargeDebt, Admit_HIS.Status_AdmitHIS
    ...    FROM        TotalCash INNER JOIN Admit_HIS ON TotalCash.AdmitID = Admit_HIS.ID_Admit
    ...    WHERE     TotalCash.AdmitID = ${PREADMIT_ADMIT_ID} ORDER BY dbo.TotalCash.ID_TotalCash DESC

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be True                 ${row[0]}                                    msg= ID_TotalCash is Null
    Should Be Equal As Integers    ${row[1]}    ${PREADMIT_iD_FileFormation}    msg= FileFormationID != ${PREADMIT_iD_FileFormation}
    Should Be Equal As Integers    ${row[2]}    ${PREADMIT_ADMIT_ID}            msg= PREADMIT ADMIT ID != ${PREADMIT_ADMIT_ID}
    Should Be Equal As Integers    ${row[3]}    249                             msg= ClinicTitleType != 249 
    Should Be Equal As Integers    ${row[4]}    0                               msg= Credit != 0
    Should Be Equal As Integers    ${row[5]}    ${Login_Person_Id}              msg= Login Person Id != ${Login_Person_Id}
    Should Contain                 ${row[6]}    (${Login_User_Name})            msg= Login User Name doesnt contain
    Should Be True                 ${row[7]} is None or '${row[7]}' != ''       msg= Note 
    Should Be Equal As Integers    ${row[8]}    54                              msg= CashType != 54
    Should Be Equal As Integers    ${row[9]}    54                              msg= DischargeStep != 54 
    Should Be Equal As Integers    ${row[10]}   12                              msg= CancelReasonID != 12
    Should Be Equal As Integers    ${row[11]}   0                               msg= PishPardaght != 0
    Should Be Equal As Integers    ${row[12]}   0                               msg= DischargeDebt != 0
    Should Be Equal As Integers    ${row[13]}   2                               msg= Status_AdmitHIS != 2


Validate DB After Cancel Preadmit Admit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE
    ${Login_Person_Id}=    Read State    Login_Person_Id
    ${Login_Display_Name}=    Read State    Login_Display_Name
    ${Login_User_Name}=     Read State    Login_User_Name
    

    ${query}=    Catenate 
    ...    SELECT TotalCash.ID_TotalCash, TotalCash.FileFormationID, TotalCash.AdmitID, TotalCash.ClinicTitleType, 
    ...    TotalCash.Credit, 
    ...    TotalCash.OperatorID, TotalCash.OperatorName, TotalCash.Note, TotalCash.CashType, Admit_HIS.DischargeStep, 
    ...    Admit_HIS.CancelReasonID,Admit_HIS.PishPardaght, Admit_HIS.DischargeDebt, Admit_HIS.Status_AdmitHIS
    ...    FROM        TotalCash INNER JOIN Admit_HIS ON TotalCash.AdmitID = Admit_HIS.ID_Admit
    ...    WHERE     TotalCash.AdmitID = ${PREADMIT_ADMIT_ID} ORDER BY dbo.TotalCash.ID_TotalCash DESC

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be True                 ${row[0]}                                    msg= ID_TotalCash is Null
    Should Be Equal As Integers    ${row[1]}    ${PREADMIT_iD_FileFormation}    msg= FileFormationID != ${PREADMIT_iD_FileFormation}
    Should Be Equal As Integers    ${row[2]}    ${PREADMIT_ADMIT_ID}            msg= PREADMIT ADMIT ID != ${PREADMIT_ADMIT_ID}
    Should Be Equal As Integers    ${row[3]}    249                             msg= ClinicTitleType != 249 
    Should Be Equal As Integers    ${row[4]}    ${pishPardaght}                 msg= Credit != ${pishPardaght}
    Should Be Equal As Integers    ${row[5]}    ${Login_Person_Id}              msg= Login Person Id != ${Login_Person_Id}
    Should Contain                 ${row[6]}    (${Login_User_Name})            msg= Login User Name doesnt contain
    Should Be True                 ${row[7]} is None or '${row[7]}' != ''       msg= Note 
    Should Be Equal As Integers    ${row[8]}    55                              msg= CashType != 55
    Should Be Equal As Integers    ${row[9]}    55                              msg= DischargeStep != 55 
    Should Be Equal As Integers    ${row[10]}   12                              msg= CancelReasonID != 12
    Should Be Equal As Integers    ${row[11]}   0                               msg= PishPardaght != 0
    Should Be Equal As Integers    ${row[12]}   0                               msg= DischargeDebt != 0
    Should Be Equal As Integers    ${row[13]}   2                               msg= Status_AdmitHIS != 2


Validate DB After Admit Emergency Patient
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${EMERGENCY_ADMIT_ID}=    Read State    EMERGENCY_ADMIT_ID
    ${EMERGENCY_ADMIT_DATE}=    Read State    EMERGENCY_ADMIT_DATE
    ${EMERGENCY_FILEFORMATION_ID}=    Read State    EMERGENCY_FILEFORMATION_ID
    ${EMERGENCY_TITLE_TYPE}=    Read State    EMERGENCY_TITLE_TYPE
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${Login_Person_Id}=    Read State    Login_Person_Id
    ${Login_Display_Name}=    Read State    Login_Display_Name
    ${Login_User_Name}=     Read State    Login_User_Name
    ${EMERGENCY_WARD_ID}=    Read State    EMERGENCY_WARD_ID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    

    ${query}=    Catenate 
    ...    SELECT     dbo.Admit_HIS.ID_Admit, dbo.Admit_HIS.FileFormationID, dbo.Admit_HIS.AdmitDate, dbo.Admit_HIS.DischargeStep, 
    ...    dbo.Admit_HIS.WardIdIn, dbo.Admit_HIS.PatientClass, dbo.Admit_HIS.Priority, dbo.Admit_HIS.Diagnosis, 
    ...    dbo.Admit_HIS.InsuranceID, dbo.Admit_HIS.InsuranceExpDate, 
    ...    dbo.Admit_HIS.Status_AdmitHIS, dbo.Admit_HIS.EmergencyNo, dbo.Patient_Movement.PreBedID, 
    ...    dbo.Patient_Movement.BedID, dbo.Tbl_Bed.ID_Bed, dbo.Tbl_Bed.BedStatus, dbo.Tbl_Bed.WardID, dbo.ICD_Madarek.ICDCode, 
    ...    dbo.TotalCash.ClinicTitleType, dbo.TotalCash.CashType
    ...    FROM        dbo.Admit_HIS INNER JOIN
    ...    dbo.Patient_Movement ON dbo.Admit_HIS.ID_Admit = dbo.Patient_Movement.AdmitID INNER JOIN
    ...    dbo.Tbl_Bed ON dbo.Patient_Movement.AdmitID = dbo.Tbl_Bed.AdmitID INNER JOIN
    ...    dbo.ICD_Madarek ON dbo.Tbl_Bed.AdmitID = dbo.ICD_Madarek.AdmitID INNER JOIN
    ...    dbo.TotalCash ON dbo.ICD_Madarek.AdmitID = dbo.TotalCash.AdmitID
    ...    WHERE     dbo.Admit_HIS.ID_Admit = ${EMERGENCY_ADMIT_ID}

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${EMERGENCY_ADMIT_ID}           msg= EMERGENCY_ADMIT_ID is Null
    Should Be Equal As Integers    ${row[1]}    ${EMERGENCY_FILEFORMATION_ID}   msg= FileFormationID != ${EMERGENCY_FILEFORMATION_ID}
    Should Contain                 ${row[2]}    ${EMERGENCY_ADMIT_DATE}         msg= EMERGENCY ADMIT DATE != ${EMERGENCY_ADMIT_DATE}
    Should Be Equal As Integers    ${row[3]}    4                               msg= DischargeStep != 4 
    Should Be Equal As Integers    ${row[4]}    ${EMERGENCY_WARD_ID}            msg= WARD In != ${EMERGENCY_WARD_ID}
    Should Be Equal As Integers    ${row[5]}    0                               msg= PatientClass != 0
    Should Be Equal As Integers    ${row[6]}    2                               msg= Priority !=2
    Should Contain                 ${row[7]}    ${Diagnosis_Name}               msg= Diagnosis Name != ${Diagnosis_Name}
    Should Be Equal As Integers    ${row[8]}    ${lastInsurance_ID}             msg= lastInsurance_ID Not Mach
    Should Contain                 ${row[9]}    ${lastInsurance_ExpDate}        msg= lastInsurance ExpDate Not Mach 
    Should Be Equal As Integers    ${row[10]}   0                               msg= Status_AdmitHIS != 0
    Should Be True                 ${row[11]}                                   msg= EmergencyNo Is Null
    Should Be Equal As Integers    ${row[12]}   0                               msg= PreBedID != 0
    Should Be Equal As Integers    ${row[13]}   ${EMERGEMCY_BED_ID}             msg= dbo.Patient_Movement.BedID Not Mach 
    Should Be Equal As Integers    ${row[14]}   ${EMERGEMCY_BED_ID}             msg= Tbl_Bed.ID_Bed Not Mach 
    Should Be Equal As Integers    ${row[15]}   1                               msg= BedStatus != 1 
    Should Be Equal As Integers    ${row[16]}   ${EMERGENCY_WARD_ID}            msg= Tbl_Bed.WardID != ${EMERGENCY_WARD_ID}
    Should Not Be Empty            ${row[17]}                                   msg= ICDCode Is Null 
    Should Be Equal As Integers    ${row[18]}   249                             msg= ClinicTitleType != 249
 

Validate DB After Patient Admission Order From Cartable
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${EMERGENCY_ADMIT_ID}=    Read State    EMERGENCY_ADMIT_ID
    ${Send_To_Ward_Date}=    Read State    Send_To_Ward_Date
    ${EMERGENCY_FILEFORMATION_ID}=    Read State    EMERGENCY_FILEFORMATION_ID
    ${Send_To_Ward_Time}=    Read State    Send_To_Ward_Time
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${Login_Person_Id}=    Read State    Login_Person_Id
    ${Login_Display_Name}=    Read State    Login_Display_Name
    ${Login_User_Name}=     Read State    Login_User_Name
    ${EMERGENCY_WARD_ID}=    Read State    EMERGENCY_WARD_ID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    

    ${query}=    Catenate 
    ...    SELECT ID_Admit, DischargeStep, SendToWardDate, SendToWardTime
    ...    FROM dbo.Admit_HIS
    ...    WHERE ID_Admit = ${EMERGENCY_ADMIT_ID}

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${EMERGENCY_ADMIT_ID}           msg= EMERGENCY_ADMIT_ID is Null
    Should Be Equal As Integers    ${row[1]}    5                               msg= DischargeStep != 5
    Should Contain                 ${row[2]}    ${Send_To_Ward_Date}            msg= Send_To_Ward_Date Not Mach
    Should Contain                 ${row[3]}    ${Send_To_Ward_Time}            msg= Send_To_Ward_Time Not Mach
    

Validate DB After Save PreAdmit Pishpardakht
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${Patient_Insurance_name}=    Read State    Patient_Insurance_name
    ${FIRSTNAME}=    Read State    FIRSTNAME
    ${LASTNAME}=    Read State    LASTNAME
    ${HOSPITALFILEID}=     Read State    HOSPITALFILEID
    

    ${query}=    Catenate 
    ...    SELECT        Admit_HIS.ID_Admit, FileFormation.FirstName, FileFormation.LastName, FileFormation.HospitalFileID, 
    ...    Clinic_Cash.ClinicTitleType, Clinic_Cash.PatientPayment, Clinic_Cash.FromPos, Tbl_Insurance.InsuranceName, 
    ...    FileFormation.ID_FileFormation, FileFormation.NCode, Admit_HIS.DischargeStep,Admit_HIS.PishPardaght
    ...    FROM            dbo.Clinic_Cash AS Clinic_Cash INNER JOIN
    ...                            dbo.Admit_HIS AS Admit_HIS ON Clinic_Cash.AdmitID = Admit_HIS.ID_Admit INNER JOIN
    ...                            dbo.FileFormation AS FileFormation ON Admit_HIS.FileFormationID = FileFormation.ID_FileFormation INNER JOIN
    ...                            dbo.Tbl_Insurance AS Tbl_Insurance ON Admit_HIS.InsuranceID = Tbl_Insurance.ID_Insurance
    ...    WHERE        (Clinic_Cash.ClinicTitleType = 249) AND  (Admit_HIS.ID_Admit = ${PREADMIT_ADMIT_ID})

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${PREADMIT_ADMIT_ID}            msg= PREADMIT_ADMIT_ID is Null
    Should Be Equal As Strings     ${row[1]}    ${FIRSTNAME}                    msg= FIRSTNAME != ${FIRSTNAME}
    Should Not Be Empty            ${row[2]}                                    msg= LASTNAME != ${LASTNAME}
    Should Be Equal As Strings     ${row[3]}    ${HOSPITALFILEID}               msg= HOSPITALFILEID != ${HOSPITALFILEID} 
    Should Be Equal As Integers    ${row[4]}    249                             msg= ClinicTitleType != 249
    Should Be Equal As Integers    ${row[5]}    ${pishPardaght}                 msg= PatientPayment != ${pishPardaght}
    # Should Be Equal              ${row[6]}    False                           msg= FromPos is True or Null
    Should Not Be Empty            ${row[7]}                                    msg= Insurance_name Is Empty
    Should Be Equal As Integers    ${row[8]}    ${PREADMIT_iD_FileFormation}    msg= FileFormation Not Mach
    Should Be Equal As Integers    ${row[9]}    ${NATIONALCODE}                 msg= NATIONALCODE Not Mach
    Should Be Equal As Integers    ${row[10]}   15                              msg= DischargeStep != 15
    Should Be Equal As Integers    ${row[11]}   0                               msg= PishPardaght In AdmitHis != 0


Cancel Admit Patient After Send To Ward
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${INPATIENT_ADMIT_ID}=    Read State    INPATIENT_ADMIT_ID
    ${INPATIONT_BED_ID}=    Read State    INPATIONT_BED_ID

    ${query_AdmitHis}=    Catenate     
    ...    UPDATE Admit_HIS
    ...    SET    Status_AdmitHIS = 2
    ...    WHERE  ID_Admit = ${INPATIENT_ADMIT_ID}

    ${query_Tbl_Bed}=    Catenate     
    ...    UPDATE   Tbl_Bed
    ...    SET      AdmitID = 0, BedStatus = 0
    ...    WHERE    AdmitID = ${INPATIENT_ADMIT_ID}

    Execute Sql String    ${query_AdmitHis}

    Execute Sql String    ${query_Tbl_Bed}

    ${rows_AdmitHis}=    Query    SELECT Status_AdmitHIS FROM Admit_HIS WHERE ID_Admit = ${INPATIENT_ADMIT_ID}

    ${rows_Tbl_Bed}=    Query     SELECT ID_Bed, AdmitID, BedStatus FROM Tbl_Bed WHERE ID_Bed = ${INPATIONT_BED_ID}

    ${row_AdmitHis}=    Set Variable    ${rows_AdmitHis[0]}
    Should Be Equal As Integers    ${row_AdmitHis[0]}    2

    ${row_Tbl_Bed}=    Set Variable    ${rows_Tbl_Bed[0]}
    Should Be Equal As Integers    ${row_Tbl_Bed[0]}    ${INPATIONT_BED_ID}
    Should Be Equal As Integers    ${row_Tbl_Bed[1]}    0
    Should Be Equal As Integers    ${row_Tbl_Bed[2]}    0

Validate DB After Send To Ward Emergency Patient
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${EMERGENCY_ADMIT_ID}=    Read State    EMERGENCY_ADMIT_ID
    ${EMERGENCY_ADMIT_DATE}=    Read State    EMERGENCY_ADMIT_DATE
    ${EMERGENCY_FILEFORMATION_ID}=    Read State    EMERGENCY_FILEFORMATION_ID
    ${EMERGENCY_TITLE_TYPE}=    Read State    EMERGENCY_TITLE_TYPE
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${Login_Person_Id}=    Read State    Login_Person_Id
    ${Login_Display_Name}=    Read State    Login_Display_Name
    ${Login_User_Name}=     Read State    Login_User_Name
    ${EMERGENCY_WARD_ID}=    Read State    EMERGENCY_WARD_ID
    ${Diagnosis_Name}=    Read State    Diagnosis-Name
    ${lastInsurance_ID}=    Read State    lastInsurance_ID
    ${lastInsurance_ExpDate}=    Read State    lastInsurance_ExpDate
    ${EMERGEMCY_BED_ID}=      Read State    EMERGEMCY_BED_ID
    ${INPATIONT_BED_ID}=    Read State    INPATIONT_BED_ID
    ${INPATIONT_WARD_ID}=    Read State    INPATIONT_WARD_ID
    

    ${query}=    Catenate 
    ...    SELECT     dbo.Admit_HIS.ID_Admit, dbo.Admit_HIS.FileFormationID, dbo.Admit_HIS.AdmitDate, dbo.Admit_HIS.DischargeStep,
    ...     dbo.Admit_HIS.WardIdIn, dbo.Admit_HIS.PatientClass, dbo.Admit_HIS.Priority, dbo.Admit_HIS.Diagnosis,
    ...     dbo.Admit_HIS.InsuranceID, dbo.Admit_HIS.InsuranceExpDate, 
    ...    dbo.Admit_HIS.Status_AdmitHIS, dbo.Admit_HIS.EmergencyNo, dbo.Patient_Movement.PreBedID, dbo.Patient_Movement.BedID, 
    ...    dbo.Tbl_Bed.ID_Bed, dbo.Tbl_Bed.BedStatus, dbo.Tbl_Bed.WardID, dbo.ICD_Madarek.ICDCode, 
    ...    dbo.TotalCash.ClinicTitleType, dbo.TotalCash.CashType
    ...    FROM        dbo.Admit_HIS INNER JOIN
    ...    dbo.Patient_Movement ON dbo.Admit_HIS.ID_Admit = dbo.Patient_Movement.AdmitID INNER JOIN
    ...    dbo.Tbl_Bed ON dbo.Patient_Movement.AdmitID = dbo.Tbl_Bed.AdmitID INNER JOIN
    ...    dbo.ICD_Madarek ON dbo.Tbl_Bed.AdmitID = dbo.ICD_Madarek.AdmitID INNER JOIN
    ...    dbo.TotalCash ON dbo.ICD_Madarek.AdmitID = dbo.TotalCash.AdmitID
    ...    WHERE     dbo.Admit_HIS.ID_Admit = ${EMERGENCY_ADMIT_ID} ORDER BY dbo.Patient_Movement.ID_PatientMovement DESC

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${EMERGENCY_ADMIT_ID}           msg= EMERGENCY_ADMIT_ID is Null
    Should Be Equal As Integers    ${row[1]}    ${EMERGENCY_FILEFORMATION_ID}   msg= FileFormationID != ${EMERGENCY_FILEFORMATION_ID}
    Should Contain                 ${row[2]}    ${EMERGENCY_ADMIT_DATE}         msg= EMERGENCY ADMIT DATE != ${EMERGENCY_ADMIT_DATE}
    Should Be Equal As Integers    ${row[3]}    0                               msg= DischargeStep != 0 
    Should Be Equal As Integers    ${row[4]}    ${EMERGENCY_WARD_ID}            msg= WARD In != ${EMERGENCY_WARD_ID}
    Should Be Equal As Integers    ${row[5]}    2                               msg= PatientClass != 2
    Should Be Equal As Integers    ${row[6]}    2                               msg= Priority !=2
    Should Contain                 ${row[7]}    ${Diagnosis_Name}               msg= Diagnosis Name != ${Diagnosis_Name}
    Should Be Equal As Integers    ${row[8]}    ${lastInsurance_ID}             msg= lastInsurance_ID Not Mach
    Should Contain                 ${row[9]}    ${lastInsurance_ExpDate}        msg= lastInsurance ExpDate Not Mach 
    Should Be Equal As Integers    ${row[10]}   0                               msg= Status_AdmitHIS != 0
    Should Be True                 ${row[11]}                                   msg= EmergencyNo Is Null
    Should Be Equal As Integers    ${row[12]}   ${EMERGEMCY_BED_ID}             msg= Patient_Movement.PreBedID Not Mach
    Should Be Equal As Integers    ${row[13]}   ${INPATIONT_BED_ID}             msg= Patient_Movement.BedID Not Mach 
    Should Be Equal As Integers    ${row[14]}   ${INPATIONT_BED_ID}             msg= Tbl_Bed.ID_Bed Not Mach 
    Should Be Equal As Integers    ${row[15]}   1                               msg= BedStatus != 1 
    Should Be Equal As Integers    ${row[16]}   ${INPATIONT_WARD_ID}            msg= Tbl_Bed.WardID != ${EMERGENCY_WARD_ID}
    Should Not Be Empty            ${row[17]}                                   msg= ICDCode Is Null 
    Should Be Equal As Integers    ${row[18]}   249                             msg= ClinicTitleType != 249   