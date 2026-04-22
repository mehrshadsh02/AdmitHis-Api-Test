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

Validate DateBase After Change Preadmit To Admit
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


Validate DB After Cancel Preadmit Reserve
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE

    ${query}=    Catenate     
    ...    SELECT ID_Admit, DischargeStep, CancelReasonID, Pishpardaght, Status_AdmitHIS 
    ...    FROM Admit_HIS 
    ...    WHERE ID_Admit=${PREADMIT_ADMIT_ID}

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be Equal As Integers    ${row[0]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Be Equal As Integers    ${row[1]}    54                              msg= DischargeStep != 54
    Should Be Equal As Integers    ${row[2]}    12                              msg= CancelReasonID != 12
    Should Be Equal As Integers    ${row[3]}    0                               msg= Pishpardaght != 0 
    Should Be Equal As Integers    ${row[4]}    2                               msg= Status_AdmitHIS != 2


Validate DB After Cancel Preadmit Admit
    [Arguments]    ${fileFormationId}

    Connect To HIS Database

    ${PREADMIT_ADMIT_ID}=    Read State    PREADMIT_ADMIT_ID
    ${PREADMIT_iD_FileFormation}=    Read State    PREADMIT_FILEFORMATION_ID
    ${NATIONALCODE}=    Read State    NATIONALCODE
    ${HOSPITALFILEID}=    Read State    HOSPITALFILEID
    ${PREADMIT_ADMIT_DATE}=    Read State    PREADMIT_ADMIT_DATE

    ${query}=    Catenate 
    ...    SELECT TotalCash.ID_TotalCash, TotalCash.FileFormationID, TotalCash.AdmitID, TotalCash.ClinicTitleType, TotalCash.Credit, 
    ...    TotalCash.OperatorID, TotalCash.OperatorName, TotalCash.Note, TotalCash.CashType, Admit_HIS.DischargeStep, 
    ...    Admit_HIS.CancelReasonID,Admit_HIS.PishPardaght, Admit_HIS.DischargeDebt, Admit_HIS.Status_AdmitHIS
    ...    FROM        TotalCash INNER JOIN Admit_HIS ON TotalCash.AdmitID = Admit_HIS.ID_Admit
    ...    WHERE     TotalCash.AdmitID = ${PREADMIT_ADMIT_ID}

    ${rows}=    Query    ${query}
    Should Not Be Empty    ${rows}
    ${row}=    Set Variable    ${rows[0]}
    
   
    Should Be True                 ${row[0]}                                    msg= ID_TotalCash is Null
    Should Be Equal As Integers    ${row[1]}    ${PREADMIT_iD_FileFormation}    msg= FileFormationID != ${PREADMIT_iD_FileFormation}
    Should Be Equal As Integers    ${row[2]}    ${PREADMIT_ADMIT_DATE}          msg= PREADMIT ADMIT DATE != ${PREADMIT_ADMIT_DATE}
    Should Be Equal As Integers    ${row[3]}    0                               msg= Pishpardaght != 0 
    Should Be Equal As Integers    ${row[4]}    -${pishPardaght}                msg= DischargeDebt != -${pishPardaght}
    Should Be Equal As Integers    ${row[5]}    2                               msg= Status_AdmitHIS != 2
    Should Be Equal As Integers    ${row[6]}    ${PREADMIT_ADMIT_ID}            msg= Admit ID Not Mach
    Should Be Equal As Integers    ${row[7]}    55                              msg= DischargeStep != 54
    Should Be Equal As Integers    ${row[8]}    12                              msg= CancelReasonID != 12
    Should Be Equal As Integers    ${row[9]}    0                               msg= Pishpardaght != 0 
    Should Be Equal As Integers    ${row[10]}    -${pishPardaght}               msg= DischargeDebt != -${pishPardaght}
    Should Be Equal As Integers    ${row[11]}    2                              msg= Status_AdmitHIS != 2
        