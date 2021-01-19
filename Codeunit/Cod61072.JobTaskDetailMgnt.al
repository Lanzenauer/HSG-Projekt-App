codeunit 61072 "Job Task Detail Mgnt."
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 190917  HSG_01  FC  Created
    // 180918  JOB_01  NM  new function SetSupportTask_gFnc
    // 190918  JOB_02  NM  new functions CreateNotification_gFnc, SetNotificationByJobTaskDetID_gFnc, SendNotificationMail_gFnc
    // 231018  JOB_03  CH  E-Mail prefix and posfix from HSG Function
    // 231018  JOB_04  NM  Validate Job Task Detail ID for sending notification
    // 241018  JOB_05  NM  New function SetStatusClosed_gFnc
    // 291018  JOB_06  NM  send only email if Processing by <> USERID
    //                     no Testfield on Job Task No.
    // 281118  JOB_07  NM  send email only if User Setup send E-Mail by new Mail
    // 171219  JOB_08  CH  Use job task ID as document no


    trigger OnRun();
    begin
    end;

    var
        newTask_gCtx: TextConst DEU = 'HSG Aufgaben-Tool: Neue Aufgabe %1 zugeordnet', ENU = 'new Task';
        newMail_gCtx: TextConst DEU = 'HSG Aufgbaben-Tool: Neue E-Mail zu Aufgabe %1 erhalten', ENU = 'HSG Tool: New Message';
        HSG_Funcs_gCdu: Codeunit "HSG Functions";

    procedure GetUser_gFnc(User_iTxt: Text) Retun_rTxt: Text;
    var
        V_lTxt: Text;
        Pos_lInt: Integer;
    begin
        if User_iTxt = '' then begin
            User_iTxt := USERID;
        end;
        Pos_lInt := STRPOS(User_iTxt, '\');
        if Pos_lInt > 0 then begin
            exit(COPYSTR(User_iTxt, Pos_lInt + 1, 100));
        end else begin
            exit(User_iTxt);
        end;
    end;

    // procedure GetSQLServerName_gFnc(): Text;
    // var
    //     ServerUserSettings_lDot: DotNet "'Microsoft.Dynamics.Nav.Types'.Microsoft.Dynamics.Nav.Types.ServerUserSettings";
    // begin
    //     ServerUserSettings_lDot := ServerUserSettings_lDot.Instance();
    //     if FORMAT(ServerUserSettings_lDot.DatabaseInstance) <> '' then
    //         exit(STRSUBSTNO('%1\%2', ServerUserSettings_lDot.DatabaseServer, ServerUserSettings_lDot.DatabaseInstance));
    //     exit(FORMAT(ServerUserSettings_lDot.DatabaseInstance));
    // end;

    // procedure GetDatabaseName_gFnc(): Text;
    // var
    //     ServerUserSettings_lDot: DotNet "'Microsoft.Dynamics.Nav.Types'.Microsoft.Dynamics.Nav.Types.ServerUserSettings";
    // begin
    //     ServerUserSettings_lDot := ServerUserSettings_lDot.Instance();
    //     exit(FORMAT(ServerUserSettings_lDot.DatabaseName));
    // end;

    procedure SetSupportTask_gFnc(Job_gCod: Code[20]) Task_vCod: Code[20];
    var
        JobTask_lRec: Record "Job Task";
    begin
        //-JOB_01
        JobTask_lRec.SETRANGE("Job No.", Job_gCod);
        JobTask_lRec.SETRANGE(Support, true);
        if JobTask_lRec.FINDFIRST then
            Task_vCod := JobTask_lRec."Job Task No."
        else
            exit('');
        //+JOB_01
    end;

    procedure SetRessourceID_gFnc() RessourceID_vCod: Code[20];
    var
        UserSetup_lRec: Record "User Setup";
    begin
        UserSetup_lRec.SETRANGE("User ID", USERID);
        if UserSetup_lRec.FINDFIRST then
            RessourceID_vCod := UserSetup_lRec."Resource No."
        else
            exit('');
    end;

    procedure CreateNewJob_gFnc(InteractionLogEntry_iRec: Record "Interaction Log Entry");
    var
        JobTaskDetail_lRec: Record "Job Task Detail";
        CreateJob_lPge: Page "Job Task Detail Create";
        jobno_lCod: Code[20];
        desc_lTxt: Text;
        JobTaskNo_lCod: Code[20];
        JobTaskDetail_lPge: Page "Job Task Detail Card";
        RessourceID_lCod: Code[20];
        lastJobTaskNo_lInt: Integer;
        HSGAddSetup_lRec: Record "HSG Add. Setup";
    begin
        //-JOB_02
        CreateJob_lPge.LOOKUPMODE(true);
        CreateJob_lPge.SetValues_gFnc(InteractionLogEntry_iRec);
        if CreateJob_lPge.RUNMODAL = ACTION::LookupOK then begin
            HSGAddSetup_lRec.GET();
            CreateJob_lPge.GetValues_gFnc(jobno_lCod, desc_lTxt, RessourceID_lCod, JobTaskNo_lCod);

            if JobTaskDetail_lRec.FIND('+') then
                lastJobTaskNo_lInt := JobTaskDetail_lRec."Job Task Detail ID" + 1
            else
                lastJobTaskNo_lInt := 1;
            JobTaskDetail_lRec.INIT;
            JobTaskDetail_lRec."Job Task Detail ID" := lastJobTaskNo_lInt;
            JobTaskDetail_lRec."Job No." := jobno_lCod;
            JobTaskDetail_lRec."Job Task No." := JobTaskNo_lCod;
            JobTaskDetail_lRec."Short Description" := desc_lTxt;
            JobTaskDetail_lRec.Arranger := USERID;
            //-JOB_04
            //JobTaskDetail_lRec."Processing by" := RessourceID_lCod;
            JobTaskDetail_lRec.VALIDATE("Processing by", RessourceID_lCod);
            if InteractionLogEntry_iRec."Contact No." <> HSGAddSetup_lRec."E-Mail Log Def. Contact" then
                JobTaskDetail_lRec.VALIDATE("Contact No.", InteractionLogEntry_iRec."Contact No.");
            JobTaskDetail_lRec."Planned Date" := TODAY + 1;
            if JobTaskDetail_lRec.INSERT(true) then begin
                InteractionLogEntry_iRec.VALIDATE("Job Task Detail ID", JobTaskDetail_lRec."Job Task Detail ID");  //JOB_04
                InteractionLogEntry_iRec.MODIFY;
                JobTaskDetail_lPge.SETRECORD(JobTaskDetail_lRec);
                JobTaskDetail_lPge.RUN;
            end else
                ERROR('Aufgabe konnte nicht angelegt werden!');
        end;

        //+JOB_02
    end;

    procedure SetDescJobJournal_gFnc(JobTaskDetails_vRec: Record "Job Task Detail") Desc_iRec: Text;
    begin
        //-JOB_02
        Desc_iRec := JobTaskDetails_vRec."Short Description";
        exit(Desc_iRec);
        //+JOB_02
    end;

    procedure ShowDescriptionSolution_gFnc(JobTaskDetail_iRec: Record "Job Task Detail"; ShowDescription_iBln: Boolean);
    var
        Position_lTxt: Text;
        JobTaskDetailAddTextCard_lPag: Page "Job Task Detail Add. Text Card";
        TextNo_lInt: Integer;
    begin
        //-JOB_02
        Position_lTxt := JobTaskDetail_iRec.GETPOSITION(false);
        if ShowDescription_iBln then begin
            TextNo_lInt := 0;
        end else begin
            TextNo_lInt := 1;
        end;
        JobTaskDetailAddTextCard_lPag.SetDescriptionSolution_gFnc(JobTaskDetail_iRec, ShowDescription_iBln);
        JobTaskDetail_iRec.SETRECFILTER;
        JobTaskDetailAddTextCard_lPag.SETRECORD(JobTaskDetail_iRec);
        JobTaskDetailAddTextCard_lPag.RUNMODAL;
        //-JOB_02
    end;

    procedure CreateJobJournalLine_gFnc(var ProjectTaskDetail_vRec: Record "Job Task Detail");
    var
        Job_lRec: Record Job;
        JobTask_lRec: Record "Job Task";
        JobJournalBatch_lRec: Record "Job Journal Batch";
        JobJournalLine_lRec: Record "Job Journal Line";
        JournalBatchLineInformation_lPge: Page "Job Task Detail Jnl. Batch cre";
        BatchName_lCod: Code[10];
        DocumentNo_lCod: Code[10];
        Description_lTxt: Text[250];
        Quantity_lDec: Decimal;
        NextLineNo_lInt: Integer;
        Chargeable_lBln: Boolean;
        Date_lDat: Date;
        Resource_lRec: Record Resource;
    begin
        //-HSG_02
        ProjectTaskDetail_vRec.TESTFIELD("Job No.");
        //ProjectTaskDetail_vRec.TESTFIELD("Job Task No.");  //JOB_06
        CLEAR(JournalBatchLineInformation_lPge);
        Resource_lRec.GET(ProjectTaskDetail_vRec."Processing by");
        JournalBatchLineInformation_lPge.SetValues_gFnc(Resource_lRec);
        JournalBatchLineInformation_lPge.SetJournalDesc_gFnc(ProjectTaskDetail_vRec);
        JournalBatchLineInformation_lPge.LOOKUPMODE(true);
        if JournalBatchLineInformation_lPge.RUNMODAL = ACTION::LookupOK then begin
            JournalBatchLineInformation_lPge.GetValues_gFnc(BatchName_lCod, Description_lTxt, Quantity_lDec, Chargeable_lBln, Date_lDat);
            JobJournalBatch_lRec.GET('PROJEKT', BatchName_lCod);
            if Description_lTxt = '' then
                ERROR('Bitte geben Sie eine Beschreibung an.');
            if Quantity_lDec = 0 then
                ERROR('Bitte geben Sie eine Menge an.');

            JobJournalLine_lRec.RESET;
            JobJournalLine_lRec.SETRANGE("Journal Template Name", 'PROJEKT');
            JobJournalLine_lRec.SETRANGE("Journal Batch Name", BatchName_lCod);
            if JobJournalLine_lRec.FINDLAST then
                NextLineNo_lInt := JobJournalLine_lRec."Line No." + 10000
            else
                NextLineNo_lInt := 10000;

            JobJournalLine_lRec.INIT;
            JobJournalLine_lRec.VALIDATE("Journal Template Name", 'PROJEKT');
            JobJournalLine_lRec.VALIDATE("Journal Batch Name", BatchName_lCod);
            JobJournalLine_lRec."Line No." := NextLineNo_lInt;
            JobJournalLine_lRec.INSERT;
            JobJournalLine_lRec.VALIDATE("Job No.", ProjectTaskDetail_vRec."Job No.");
            JobJournalLine_lRec.VALIDATE("Job Task No.", ProjectTaskDetail_vRec."Job Task No.");
            JobJournalLine_lRec.VALIDATE(Type, JobJournalLine_lRec.Type::Resource);
            JobJournalLine_lRec.VALIDATE("No.", Resource_lRec."No.");
            JobJournalLine_lRec.Description := Description_lTxt;
            JobJournalLine_lRec.VALIDATE(Quantity, Quantity_lDec);
            JobJournalLine_lRec.VALIDATE(Chargeable, Chargeable_lBln);
            JobJournalLine_lRec.VALIDATE("Posting Date", Date_lDat);
            // -JOB_08
            // JobJournalLine_lRec."Document No.":= FORMAT(Date_lDat, 0, '<Year4>-<Month,2>');
            JobJournalLine_lRec."Document No." := FORMAT(ProjectTaskDetail_vRec."Job Task Detail ID");
            // +JOB_08
            JobJournalLine_lRec.MODIFY;
            MESSAGE('Die Buch.-Blatt Zeile wurde erstellt.');
        end else begin
            MESSAGE('Es wurde keine Buch.-Blatt Zeile erstellt.');
        end;
        //+HSG_02
    end;

    procedure CreateProjectTask_gFnc(var ProjectTaskDetail_vRec: Record "Job Task Detail");
    var
        Job_lRec: Record Job;
        JobTask_lRec: Record "Job Task";
        NoSeries_lRec: Record "No. Series";
        NoSeriesManagement_lCdu: Codeunit NoSeriesManagement;
        JobTaskDescription_lTxt: Text[50];
        CurrNo_lCod: Code[20];
        Text001_lCtx: TextConst DEU = '%1 %2 %3 exists already', ENU = '%1 %2 %3 gibt es schon';
    begin
        //-HSG_01
        //IF ProjectTaskDetail_vRec."Job Task Description" = '' THEN
        //  ERROR('Bitte geben Sie zunächst eine Projektaufgaben Beschreibung an.');
        if not Job_lRec.GET(ProjectTaskDetail_vRec."Job No.") then
            if PAGE.RUNMODAL(0, Job_lRec) = ACTION::LookupOK then
                ProjectTaskDetail_vRec."Job No." := Job_lRec."No.";
        ProjectTaskDetail_vRec.TESTFIELD("Job No.");
        //MESSAGE('Bitte Projektaufgabe auswählen, unter dem der neue Eintrag erstellt werden soll.');
        JobTask_lRec.SETRANGE("Job No.", ProjectTaskDetail_vRec."Job No.");
        if PAGE.RUNMODAL(0, JobTask_lRec) = ACTION::LookupOK then begin
            CurrNo_lCod := JobTask_lRec."Job No.";
            CurrNo_lCod := INCSTR(CurrNo_lCod);
            if JobTask_lRec.GET(ProjectTaskDetail_vRec."Job No.", CurrNo_lCod) then begin
                ERROR(Text001_lCtx, JobTask_lRec.TABLECAPTION, JobTask_lRec."Job No.", JobTask_lRec."Job Task No.");
            end;
            JobTask_lRec.INIT;
            JobTask_lRec.VALIDATE("Job No.", ProjectTaskDetail_vRec."Job No.");
            JobTask_lRec.VALIDATE("Job Task No.", CurrNo_lCod);
            JobTask_lRec.Description := ProjectTaskDetail_vRec."Job Task Description";
            // -HSG_05
            //JobTask_lRec.Status := JobTask_lRec.Status::"1";
            // +HSG_05
            JobTask_lRec.INSERT(true);
        end;
    end;

    procedure CreateNotification_gFnc(JobTaskDetail_iRec: Record "Job Task Detail"; Which_iInt: Integer);
    var
        Outstream: OutStream;
        NewId: Integer;
        Text: Text[250];
        LenChar: Char;
        RecordLink: Record "Record Link";
        UserSetup_lRec: Record "User Setup";
        ServerInstance_lRec: Record "Server Instance";
    begin
        //-JOB_02
        case Which_iInt of
            1:
                begin
                    Text := STRSUBSTNO(newTask_gCtx, JobTaskDetail_iRec."Job Task Detail ID");
                end;
            2:
                begin
                    Text := STRSUBSTNO(newMail_gCtx, JobTaskDetail_iRec."Job Task Detail ID");
                end;
        end;
        LenChar := STRLEN(Text);
        ServerInstance_lRec.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        ServerInstance_lRec.FINDFIRST;


        Text := FORMAT(LenChar) + Text;

        NewId := JobTaskDetail_iRec.ADDLINK(STRSUBSTNO('DynamicsNAV://%1:%2/%3/%4/runpage?page=%5&bookmark=%6&mode=Edit',
                              ServerInstance_lRec."Server Computer Name",
                              FORMAT(ServerInstance_lRec."Server Port"),
                              ServerInstance_lRec."Service Name",
                              COMPANYNAME,
                              FORMAT(50041),
                              FORMAT(JobTaskDetail_iRec.RECORDID, 0, 10)));

        UserSetup_lRec.SETRANGE("Resource No.", JobTaskDetail_iRec."Processing by");
        if UserSetup_lRec.FINDFIRST then;


        RecordLink.GET(NewId);

        RecordLink.CALCFIELDS(Note);
        RecordLink.Note.CREATEOUTSTREAM(Outstream);
        Outstream.WRITE(Text);
        RecordLink.Description := JobTaskDetail_iRec."Job No." + ' ' + JobTaskDetail_iRec."Short Description";
        RecordLink.Type := RecordLink.Type::Note;
        RecordLink.Notify := true;
        RecordLink."To User ID" := UserSetup_lRec."User ID";

        RecordLink.MODIFY;

        SendNotificationMail_gFnc(JobTaskDetail_iRec, RecordLink.URL1, Which_iInt);
        //+JOB_02
    end;

    procedure SetNotificationByJobTaskDetID_gFnc(JobTaskDetailId_iCod: Integer; Which_iInt: Integer);
    var
        JobTaskDetail_lRec: Record "Job Task Detail";
        RessourceNo_Cod: Code[10];
        UserSetup_lRec: Record "User Setup";
    begin
        //-JOB_02
        if JobTaskDetail_lRec.GET(JobTaskDetailId_iCod) then begin
            //-JOB_06
            if UserSetup_lRec.GET(USERID) then
                RessourceNo_Cod := UserSetup_lRec."Resource No.";
            //-JOB_07
            CLEAR(UserSetup_lRec);
            UserSetup_lRec.SETRANGE("Resource No.", JobTaskDetail_lRec."Processing by");
            if UserSetup_lRec.FINDFIRST then;
            //IF JobTaskDetail_lRec."Processing by" <> RessourceNo_Cod THEN
            if (JobTaskDetail_lRec."Processing by" <> RessourceNo_Cod) and (UserSetup_lRec."Send E-Mail on new Mail") then
                //+JOB_07
                //+JOB_06
                CreateNotification_gFnc(JobTaskDetail_lRec, Which_iInt);
        end else
            ERROR('Keine Aufgabe gefunden');
        //+JOB_02
    end;

    procedure SendNotificationMail_gFnc(JobTaskDetail_iRec: Record "Job Task Detail"; RecordLinkUrl_iTxt: Text; which_iInt: Integer);
    var
        Mail_lCdu: Codeunit Mail;
        UserSetup_lRec: Record "User Setup";
        JobTaskDetail_lRec: Record "Job Task Detail";
        RecordLink_lRec: Record "Record Link";
        gotoTask_lCtx: TextConst DEU = 'Zur Aufgabe ', ENU = 'go to Task';
        EMailTxt_lRec: Record "Job Email Text";
        EMailTxt_lTxt: Text;
        CRLF: Text[2];
    begin
        //-JOB_02
        CRLF := '';
        CRLF[1] := 13;
        CRLF[2] := 10;
        UserSetup_lRec.SETRANGE("Resource No.", JobTaskDetail_iRec."Processing by");

        if UserSetup_lRec.FINDFIRST then;
        case which_iInt of
            1:
                begin  //change Proccess by
                    EMailTxt_lRec.SETRANGE(Code, EMailTxt_lRec.Code::"new Job");
                    if EMailTxt_lRec.FINDSET then begin
                        repeat
                            EMailTxt_lTxt += EMailTxt_lRec.Text + CRLF;
                        until EMailTxt_lRec.NEXT = 0;
                    end;
                    Mail_lCdu.NewMessage(UserSetup_lRec."E-Mail", '', '', STRSUBSTNO(newTask_gCtx, JobTaskDetail_iRec."Job Task Detail ID"), EMailTxt_lTxt + CRLF + '<a href="' + RecordLinkUrl_iTxt + '">' +
                                              // -JOB_03
                                              // gotoTask_lCtx + ('##' + FORMAT(JobTaskDetail_iRec."Job Task Detail ID") + '## - ' + FORMAT(JobTaskDetail_iRec."Job No." + ' - ' + FORMAT(FORMAT(JobTaskDetail_iRec."Short Description")))) + '</a>'
                                              gotoTask_lCtx + (HSG_Funcs_gCdu.HSG_EmailPrefix_gFnc + FORMAT(JobTaskDetail_iRec."Job Task Detail ID") + HSG_Funcs_gCdu.HSG_EmailPostfix_gFnc + ' - ' + FORMAT(JobTaskDetail_iRec."Job No." + ' - ' +
                                              FORMAT(FORMAT(JobTaskDetail_iRec."Short Description")))) + '</a>'
                                              // +JOB_03
                                              , '', false);
                end;
            2:
                begin  //Neue E-Mail erhalten
                    EMailTxt_lRec.SETRANGE(Code, EMailTxt_lRec.Code::"new Mail");
                    if EMailTxt_lRec.FINDSET then begin
                        repeat
                            EMailTxt_lTxt += EMailTxt_lRec.Text;
                        until EMailTxt_lRec.NEXT = 0;
                    end;
                    Mail_lCdu.NewMessage(UserSetup_lRec."E-Mail", '', '', STRSUBSTNO(newMail_gCtx, JobTaskDetail_iRec."Job Task Detail ID"), EMailTxt_lTxt + CRLF + '<a href="' + RecordLinkUrl_iTxt + '">' +
                                              // -JOB_03
                                              // gotoTask_lCtx + ('##' + FORMAT(JobTaskDetail_iRec."Job Task Detail ID") + '## - ' + FORMAT(JobTaskDetail_iRec."Job No.") + ' - ' + FORMAT(FORMAT(JobTaskDetail_iRec."Short Description"))) + '</a>'
                                              gotoTask_lCtx + (HSG_Funcs_gCdu.HSG_EmailPrefix_gFnc + FORMAT(JobTaskDetail_iRec."Job Task Detail ID") + HSG_Funcs_gCdu.HSG_EmailPostfix_gFnc + ' - ' + FORMAT(JobTaskDetail_iRec."Job No.") + ' - ' +
                                              FORMAT(FORMAT(JobTaskDetail_iRec."Short Description"))) + '</a>'
                                              // +JOB_03
                                              , '', false);
                end;
        end;
        //+JOB_02
    end;

    procedure SetStatusClosed_gFnc(var ProjectTaskDetail_vRec: Record "Job Task Detail");
    var
        HSGAddSetup_lRec: Record "HSG Add. Setup";
    begin
        //-JOB_05
        HSGAddSetup_lRec.GET();
        ProjectTaskDetail_vRec.Status := HSGAddSetup_lRec."Job Details Closed";
        ProjectTaskDetail_vRec.MODIFY(true);
        //+JOB_05
    end;
}

