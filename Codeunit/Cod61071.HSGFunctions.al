codeunit 61071 "HSG Functions"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 120115  HSG_01  CH  Created
    // 110315  HSG_02  CH  Correction
    // 290818  JOB_01  CH  Send E-Mail From Interaction Log Entry
    // 231018  JOB_02  CH  shortcuts for e-mail identification cahnged from ## to ~~
    // 231018  JOB_03  NM  Validate Job Task Detail ID for notification
    // 040219  JOB_04  CH  Code change
    // 170120  JOB_05  NM  Set Status BEARB if new mail for closed job


    trigger OnRun();
    begin
    end;

    procedure CopyJobJnlLineFromT113_gFnc(DestSalesLine_iRec: Record "Sales Line"; SrcSalesInvLine_iRec: Record "Sales Invoice Line");
    var
        JobJournalLine_lRec: Record "Job Journal Line";
        JobJedgerEntry_lRec: Record "Job Ledger Entry";
        LineNo_lInt: Integer;
    begin
        // HSG_01
        if (DestSalesLine_iRec."Job No." = '') or (SrcSalesInvLine_iRec."Job No." = '') or
           (DestSalesLine_iRec."Job No." <> SrcSalesInvLine_iRec."Job No.") or
           // (DestSalesLine_iRec."Job Task No." = '') OR (SrcSalesInvLine_iRec."Job Task No." = '') // HSG_02
           (DestSalesLine_iRec."Job Task No." <> SrcSalesInvLine_iRec."Job Task No.")
        then
            exit;

        CLEAR(JobJournalLine_lRec);
        JobJournalLine_lRec.SETRANGE("Journal Template Name", '');
        JobJournalLine_lRec.SETRANGE("Journal Batch Name", '');
        if JobJournalLine_lRec.FINDLAST then
            LineNo_lInt := JobJournalLine_lRec."Line No."
        else
            LineNo_lInt := 0;

        CLEAR(JobJedgerEntry_lRec);
        JobJedgerEntry_lRec.SETRANGE("Document No.", SrcSalesInvLine_iRec."Document No.");
        JobJedgerEntry_lRec.SETRANGE("Document Line No.", SrcSalesInvLine_iRec."Line No.");
        JobJedgerEntry_lRec.SETRANGE("Job Task No.", SrcSalesInvLine_iRec."Job Task No.");
        JobJedgerEntry_lRec.SETRANGE("Job No.", SrcSalesInvLine_iRec."Job No.");
        JobJedgerEntry_lRec.SETRANGE("Entry Type", JobJedgerEntry_lRec."Entry Type"::Sale);
        if JobJedgerEntry_lRec.FINDSET then
            repeat

                LineNo_lInt += 10000;
                CLEAR(JobJournalLine_lRec);
                JobJournalLine_lRec."Line No." := LineNo_lInt;
                JobJournalLine_lRec.VALIDATE("Job No.", JobJedgerEntry_lRec."Job No.");
                JobJournalLine_lRec.VALIDATE("Job Task No.", JobJedgerEntry_lRec."Job Task No.");
                JobJournalLine_lRec.VALIDATE("Posting Date", JobJedgerEntry_lRec."Posting Date");
                JobJournalLine_lRec."Document Date" := JobJedgerEntry_lRec."Document Date";
                JobJournalLine_lRec."Document No." := DestSalesLine_iRec."Document No.";
                JobJournalLine_lRec.VALIDATE(Type, JobJedgerEntry_lRec.Type);
                JobJournalLine_lRec.VALIDATE("No.", JobJedgerEntry_lRec."No.");
                if JobJournalLine_lRec.Type = JobJournalLine_lRec.Type::Resource then
                    JobJournalLine_lRec.VALIDATE("Work Type Code", JobJedgerEntry_lRec."Work Type Code");
                JobJournalLine_lRec.Description := JobJedgerEntry_lRec.Description;
                JobJournalLine_lRec.VALIDATE(Quantity, JobJedgerEntry_lRec.Quantity);
                JobJournalLine_lRec.VALIDATE("Unit Price", JobJedgerEntry_lRec."Unit Price");
                JobJournalLine_lRec.VALIDATE("Unit Price (LCY)", JobJedgerEntry_lRec."Unit Price");
                JobJedgerEntry_lRec.CALCFIELDS(Chargeable);
                JobJournalLine_lRec.Chargeable := JobJedgerEntry_lRec.Chargeable;
                JobJournalLine_lRec."Document Line No." := DestSalesLine_iRec."Line No.";
                JobJournalLine_lRec."Entry Type" := JobJournalLine_lRec."Entry Type"::Sale;
                JobJournalLine_lRec."Job Posting Only" := false;
                JobJournalLine_lRec."Dimension Set ID" := JobJedgerEntry_lRec."Dimension Set ID";
                if not (DestSalesLine_iRec."Document Type" in [DestSalesLine_iRec."Document Type"::"Credit Memo", DestSalesLine_iRec."Document Type"::"Return Order"]) then begin
                    JobJournalLine_lRec.VALIDATE(Quantity, -JobJournalLine_lRec.Quantity);
                end;

                JobJournalLine_lRec.INSERT;

            until JobJedgerEntry_lRec.NEXT = 0;
    end;

    procedure SendEMailFromInteractionLogEntry_gFnc(var InteractionLogEntry_vRec: Record "Interaction Log Entry");
    var
        Contact_lRec: Record Contact;
        Mail_lCdu: Codeunit Mail;
        AttachFilename_lTxt: Text;
        SubjectText_lTxt: Text;
        //    OutlookHelper_lDot: DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Outlook.OutlookHelper" RUNONCLIENT;
        //  Status_lDot: DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Outlook.OutlookStatusCode" RUNONCLIENT;
        //  OutlookMessager_lDot: DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Outlook.OutlookMessage" RUNONCLIENT;
        BodyText_lTxt: Text;
        TMP_lTxt: Text;
        InStr_lIsr: InStream;
        SendToAdress_lTxt: Text;
        CR: Char;
        LF: Char;
        AddSetup_lRec: Record "HSG Add. Setup";
        CC_Adresses_lTxt: Text;
    begin
        // JOB_01
        CR := 13;
        LF := 10;

        AddSetup_lRec.GET;

        InteractionLogEntry_vRec.TESTFIELD("Job Task Detail ID");
        if InteractionLogEntry_vRec."From Mail Address" <> '' then
            SendToAdress_lTxt := InteractionLogEntry_vRec."From Mail Address"
        else begin
            Contact_lRec.GET(InteractionLogEntry_vRec."Contact No.");
            Contact_lRec.TESTFIELD("E-Mail");
            SendToAdress_lTxt := Contact_lRec."E-Mail";
        end;

        if InteractionLogEntry_vRec."Mail Subject Long Text" <> '' then
            SubjectText_lTxt := InteractionLogEntry_vRec."Mail Subject Long Text"
        else
            SubjectText_lTxt := InteractionLogEntry_vRec.Subject;

        if STRPOS(SubjectText_lTxt, HSG_EMailMarker_gFnc(InteractionLogEntry_vRec."Job Task Detail ID")) = 0 then
            SubjectText_lTxt := HSG_EMailMarker_gFnc(InteractionLogEntry_vRec."Job Task Detail ID") + ' ' + SubjectText_lTxt;

        SubjectText_lTxt := 'AW: ' + SubjectText_lTxt;

        CC_Adresses_lTxt := InteractionLogEntry_vRec."CC Mail Address";
        if AddSetup_lRec."Default E-Mail CC Address" <> '' then
            if CC_Adresses_lTxt = '' then
                CC_Adresses_lTxt := AddSetup_lRec."Default E-Mail CC Address"
            else
                CC_Adresses_lTxt := CC_Adresses_lTxt + ';' + AddSetup_lRec."Default E-Mail CC Address";

        InteractionLogEntry_vRec.CALCFIELDS("E-Mail Body Text");
        CLEAR(BodyText_lTxt);
        BodyText_lTxt := FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := '___________________________________________________________________________________________________________________' + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + 'Von: ' + InteractionLogEntry_vRec."From Mail Address" + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + 'Gesendet: ' + FORMAT(InteractionLogEntry_vRec.Date) + ' ' + FORMAT(InteractionLogEntry_vRec."Time of Interaction" + 7200000, 0, '<Hours24,2>:<Minutes,2>') + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + 'An: ' + InteractionLogEntry_vRec."To Mail Address" + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + 'Cc: ' + InteractionLogEntry_vRec."CC Mail Address" + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + 'Betreff: ' + InteractionLogEntry_vRec.Description + FORMAT(CR) + FORMAT(LF);
        BodyText_lTxt := BodyText_lTxt + FORMAT(CR) + FORMAT(LF);

        if InteractionLogEntry_vRec."E-Mail Body Text".HASVALUE then begin
            CLEAR(InStr_lIsr);
            InteractionLogEntry_vRec."E-Mail Body Text".CREATEINSTREAM(InStr_lIsr);
            while InStr_lIsr.READTEXT(TMP_lTxt) <> 0 do begin
                BodyText_lTxt := BodyText_lTxt + TMP_lTxt;
            end;
        end;

        CLEAR(Mail_lCdu);

        Mail_lCdu.NewMessage(SendToAdress_lTxt, CC_Adresses_lTxt, '', SubjectText_lTxt, BodyText_lTxt, AttachFilename_lTxt, true);
    end;

    procedure EmailFile_gFnc(AttachmentFilePath_iTxt: Text[250]; Subject_iTxt: Text[50]; AttachmentFileName_iTxt: Text[250]; SendToEMail_lTxt: Text[100]);
    var
        TempEmailItem: Record "Email Item" temporary;
        AttachmentFileName: Text[250];
    begin
        // JOB_01
        with TempEmailItem do begin
            "Send to" := SendToEMail_lTxt;
            Subject := Subject_iTxt;
            "Attachment File Path" := AttachmentFilePath_iTxt;
            "Attachment Name" := AttachmentFileName_iTxt;
            Send(false);
        end;
    end;

    procedure HSG_EMailMarker_gFnc(JobNo_lInt: Integer): Text;
    begin
        // JOB_01
        // EXIT('##HSG' + DELCHR(FORMAT(JobNo_lInt),'=','.,') + '##'); // JOB_02
        exit('~~HSG' + DELCHR(FORMAT(JobNo_lInt), '=', '.,') + '~~'); // JOB_02
    end;

    procedure HSG_EMailFilter_gFnc(): Text;
    begin
        // JOB_01
        // EXIT('*##HSG*'); // JOB_02
        exit('*~~HSG*'); // JOB_02
    end;

    procedure HSG_GetJobTaskDetailfromEMailMarker_gFnc(Input_lTxt: Text) JobTaskDetailNo_rInt: Integer;
    begin
        // JOB_01
        // -JOB_02
        // IF STRPOS(Input_lTxt,'##HSG') = 0 THEN
        if STRPOS(Input_lTxt, '~~HSG') = 0 then
            // +JOB_02
            exit(0);

        // Input_lTxt := COPYSTR(Input_lTxt,STRPOS(Input_lTxt,'##HSG') + 5); // JOB_02
        Input_lTxt := COPYSTR(Input_lTxt, STRPOS(Input_lTxt, '~~HSG') + 5);  // JOB_02

        // IF STRPOS(Input_lTxt,'##') = 0 THEN // JOB_02
        if STRPOS(Input_lTxt, '~~') = 0 then // JOB_02
            exit(0);

        // Input_lTxt := COPYSTR(Input_lTxt,1,STRPOS(Input_lTxt,'##') - 1); // JOB_02
        Input_lTxt := COPYSTR(Input_lTxt, 1, STRPOS(Input_lTxt, '~~') - 1); // JOB_02

        if not EVALUATE(JobTaskDetailNo_rInt, Input_lTxt) then
            exit(0);

        exit(JobTaskDetailNo_rInt);
    end;

    procedure AssignJobDetailToInteractionLogEntry_gFnc();
    var
        CheckInteractionLogEntry_lRec: Record "Interaction Log Entry";
        ModInteractionLogEntry_lRec: Record "Interaction Log Entry";
    begin
        // JOB_01
        CLEAR(CheckInteractionLogEntry_lRec);
        CheckInteractionLogEntry_lRec.SETRANGE("Job Task Detail ID", 0);
        CheckInteractionLogEntry_lRec.SETFILTER(Description, HSG_EMailFilter_gFnc());
        if CheckInteractionLogEntry_lRec.FIND('-') then
            repeat
                ModInteractionLogEntry_lRec := CheckInteractionLogEntry_lRec;
                //-JOB_03
                //ModInteractionLogEntry_lRec."Job Task Detail ID" := HSG_GetJobTaskDetailfromEMailMarker_gFnc(ModInteractionLogEntry_lRec.Description);
                // ModInteractionLogEntry_lRec.VALIDATE("Job Task Detail ID",HSG_GetJobTaskDetailfromEMailMarker_gFnc(ModInteractionLogEntry_lRec.Description));
                ModInteractionLogEntry_lRec.VALIDATE("Job Task Detail ID", HSG_GetJobTaskDetailfromEMailMarker_gFnc(ModInteractionLogEntry_lRec."Mail Subject Long Text")); // JOB_04
                                                                                                                                                                            //+JOB_03
                if ModInteractionLogEntry_lRec."Job Task Detail ID" <> 0 then
                    CheckJobStatus_gFnc(ModInteractionLogEntry_lRec."Job Task Detail ID");      //JOB_05
                ModInteractionLogEntry_lRec.MODIFY;
            until CheckInteractionLogEntry_lRec.NEXT = 0;
    end;

    procedure HSG_EmailPrefix_gFnc(): Text;
    begin
        exit('~~HSG'); // JOB_02
    end;

    procedure HSG_EmailPostfix_gFnc(): Text;
    begin
        exit('~~'); // JOB_02
    end;

    local procedure CheckJobStatus_gFnc(JobId_iInt: Integer);
    var
        JobTaskDetail_lRec: Record "Job Task Detail";
    begin
        //-JOB_05
        if JobTaskDetail_lRec.GET(JobId_iInt) then begin
            if JobTaskDetail_lRec.Status = 'ABGESCHL' then begin
                JobTaskDetail_lRec.Status := 'BEARB';
                JobTaskDetail_lRec.MODIFY;
            end;
        end;
        //+JOB_05
    end;
}

