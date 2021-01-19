codeunit 61070 "E-Mail Logging Dispatcher_"
{
    // version NAVW18.00,JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 290818  JOB_01  CH  Copied from 5064 + code changes
    // 110918  JOB_02  CH  Additional func to call directly
    // 291118  JOB_03  CH  Do not check attachments

    TableNo = "Job Queue Entry";

    trigger OnRun();
    var
        MarketingSetup: Record "Marketing Setup";
        StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
        QueueFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
    begin
        if ISNULLGUID(ID) then
            exit;

        // -JOB_01
        AddSetup_gRec.GET;
        AddSetup_gRec.TESTFIELD("E-Mail Log  Def. Sales Person");
        AddSetup_gRec.TESTFIELD("E-Mail Log Def. Contact");
        // +JOB_01

        SetErrorContext(Text101);
        CheckSetup(MarketingSetup);

        SetErrorContext(Text102);
        if not ExchangeWebServicesServer.Initialize(MarketingSetup."Autodiscovery E-Mail Address", true) then
            ERROR(Text001);

        SetErrorContext(Text103);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetQueueFolderUID, QueueFolder) then
            ERROR(Text002, MarketingSetup."Queue Folder Path");

        SetErrorContext(Text104);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetStorageFolderUID, StorageFolder) then
            ERROR(Text002, MarketingSetup."Storage Folder Path");

        RunEMailBatch(MarketingSetup."Email Batch Size", QueueFolder, StorageFolder);
    end;

    var
        ExchangeWebServicesServer: Codeunit "Exchange Web Services Server";
        Text001: TextConst DEU = 'Fehler beim automatischen Erkennen des Exchange-Diensts.', ENU = 'Autodiscovery of exchange service failed.';
        Text002: TextConst DEU = 'Der Ordner ''%1'' ist nicht vorhanden. Überprüfen Sie den Ordnerpfad im Fenster ''Marketing && Vertrieb Einr.''.', ENU = 'The %1 folder does not exist. Verify that the path to the folder is correct in the Marketing Setup window.';
        Text003: TextConst DEU = 'Der Warteschlangen- oder Speicherordner wurde nicht initialisiert. Geben Sie den Ordnerpfad im Fenster ''Marketing & Vertrieb Einr.'' ein.', ENU = 'The queue or storage folder has not been initialized. Enter the folder path in the Marketing Setup window.';
        Text101: TextConst DEU = 'Einrichtung wird überprüft...', ENU = 'Validating setup';
        Text102: TextConst DEU = 'Initialisierung und automatische Erkennung des Exchange-Webdiensts werden ausgeführt...', ENU = 'Initialization and autodiscovery of Exchange web service is in progress';
        Text103: TextConst DEU = 'Ablageordner wird geöffnet...', ENU = 'Opening queue folder';
        Text104: TextConst DEU = 'Speicherordner wird geöffnet...', ENU = 'Opening storage folder';
        Text105: TextConst DEU = 'E-Mails werden gelesen...', ENU = 'Reading email messages';
        Text106: TextConst DEU = 'Nächste E-Mail wird geprüft...', ENU = 'Checking next email message';
        Text107: TextConst DEU = 'E-Mails werden protokolliert...', ENU = 'Logging email messages';
        Text108: TextConst DEU = 'E-Mail wird aus der Warteschlange gelöscht...', ENU = 'Deleting email message from queue';
        ErrorContext: Text;
        Text109: TextConst DEU = 'Die Aktivitätenvorlage für E-Mail-Nachrichten wurde im Fenster ''Aktivitätenvorlage Einrichtung'' nicht angegeben.', ENU = 'The interaction template for email messages has not been specified in the Interaction Template Setup window.';
        Text110: TextConst DEU = 'Im Fenster ''Aktivitätenvorlage Einrichtung'' wurde eine Aktivitätenvorlage für E-Mail-Nachrichten angegeben, aber die Vorlage ist nicht vorhanden.', ENU = 'An interaction template for email messages has been specified in the Interaction Template Setup window, but the template does not exist.';
        "-----": Integer;
        AddSetup_gRec: Record "HSG Add. Setup";

    procedure CheckSetup(var MarketingSetup: Record "Marketing Setup");
    var
        ErrorMsg: Text;
    begin
        if not CheckInteractionTemplateSetup(ErrorMsg) then
            ERROR(ErrorMsg);

        MarketingSetup.GET;
        if not (MarketingSetup."Queue Folder UID".HASVALUE and MarketingSetup."Storage Folder UID".HASVALUE) then
            ERROR(Text003);

        MarketingSetup.TESTFIELD("Autodiscovery E-Mail Address");
    end;

    procedure RunEMailBatch(BatchSize: Integer; var QueueFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder"; var StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder");
    var
        QueueFindResults: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IFindEmailsResults";
        QueueEnumerator: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
        QueueMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
        EmailsLeftInBatch: Integer;
        PageSize: Integer;
    begin
        EmailsLeftInBatch := BatchSize;
        repeat
            SetErrorContext(Text105);

            PageSize := 50;
            if (BatchSize <> 0) and (EmailsLeftInBatch < PageSize) then
                PageSize := EmailsLeftInBatch;

            // Keep using zero offset, since all processed messages are deleted from the queue folder
            QueueFindResults := QueueFolder.FindEmailMessages(PageSize, 0);
            QueueEnumerator := QueueFindResults.GetEnumerator;
            while QueueEnumerator.MoveNext do begin
                QueueMessage := QueueEnumerator.Current;
                ProcessMessage(QueueMessage, StorageFolder);
                SetErrorContext(Text108);
                QueueMessage.Delete;
            end;

            EmailsLeftInBatch := EmailsLeftInBatch - PageSize;
        until (not QueueFindResults.MoreAvailable) or ((BatchSize <> 0) and (EmailsLeftInBatch <= 0));
    end;

    procedure GetErrorContext(): Text;
    begin
        exit(ErrorContext);
    end;

    procedure SetErrorContext(NewContext: Text);
    begin
        ErrorContext := NewContext;
    end;

    procedure ItemLinkedFromAttachment(MessageId: Text; var Attachment: Record Attachment): Boolean;
    begin
        Attachment.SETRANGE("Email Message Checksum", Attachment.Checksum(MessageId));

        if not Attachment.FINDSET then
            exit(false);
        repeat
            if Attachment.GetMessageID = MessageId then
                exit(true);
        until (Attachment.NEXT = 0);
        exit(false);
    end;

    procedure AttachmentRecordAlreadyExists(AttachmentNo: Text; var Attachment: Record Attachment): Boolean;
    var
        No: Integer;
    begin
        if EVALUATE(No, AttachmentNo) then
            exit(Attachment.GET(No));
        exit(false);
    end;

    local procedure SalespersonRecipients(Message: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage"; var SegLine: Record "Segment Line"): Boolean;
    var
        RecepientEnumerator: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
        Recepient: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
        RecepientAddress: Text;
    begin
        RecepientEnumerator := Message.Recipients.GetEnumerator;
        while RecepientEnumerator.MoveNext do begin
            Recepient := RecepientEnumerator.Current;
            RecepientAddress := Recepient.Address;
            if IsSalesperson(RecepientAddress, SegLine."Salesperson Code") then begin
                SegLine.INSERT;
                SegLine."Line No." := SegLine."Line No." + 1;
            end;
        end;
        exit(not SegLine.ISEMPTY);
    end;

    local procedure ContactRecipients(Message: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage"; var SegLine: Record "Segment Line"): Boolean;
    var
        RecepientEnumerator: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
        RecepientAddress: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
    begin
        RecepientEnumerator := Message.Recipients.GetEnumerator;
        while RecepientEnumerator.MoveNext do begin
            RecepientAddress := RecepientEnumerator.Current;
            if IsContact(RecepientAddress.Address, SegLine) then begin
                SegLine.INSERT;
                SegLine."Line No." := SegLine."Line No." + 1;
            end;
        end;
        exit(not SegLine.ISEMPTY);
    end;

    local procedure IsMessageToLog(QueueMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage"; StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder"; var SegLine: Record "Segment Line"; var Attachment: Record Attachment): Boolean;
    var
        StorageMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
        Sender: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
        SenderAddress: Text;
        MessageId: Text;
    begin
        if QueueMessage.IsSensitive then
            exit(false);

        Sender := QueueMessage.SenderAddress;
        if Sender.IsEmpty or (QueueMessage.RecipientsCount = 0) then
            exit(false);

        if ExchangeWebServicesServer.IdenticalMailExists(QueueMessage, StorageFolder, StorageMessage) then begin
            MessageId := StorageMessage.Id;
            StorageMessage.Delete;
            if ItemLinkedFromAttachment(MessageId, Attachment) then
                exit(true);
        end;

        // -JOB_03
        // IF AttachmentRecordAlreadyExists(QueueMessage.NavAttachmentNo,Attachment) THEN
        //   EXIT(TRUE);
        // +JOB_03

        // Check if in- or out-bound and store sender and recipients in segment line(s)
        SenderAddress := Sender.Address;
        if IsSalesperson(SenderAddress, SegLine."Salesperson Code") then begin
            SegLine."Information Flow" := SegLine."Information Flow"::Outbound;
            if not ContactRecipients(QueueMessage, SegLine) then
                exit(false);
        end else begin
            if IsContact(SenderAddress, SegLine) then begin
                SegLine."Information Flow" := SegLine."Information Flow"::Inbound;
                if not SalespersonRecipients(QueueMessage, SegLine) then
                    exit(false);
            end else
                exit(false);
        end;

        exit(not SegLine.ISEMPTY);
    end;

    procedure UpdateSegLine(var SegLine: Record "Segment Line"; Emails: Code[10]; Subject: Text; DateSent: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime"; DateReceived: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime"; AttachmentNo: Integer);
    var
        LineDate: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
        DateTimeKind: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeKind";
        InformationFlow: Integer;
    begin
        InformationFlow := SegLine."Information Flow";
        SegLine.VALIDATE("Interaction Template Code", Emails);
        SegLine."Information Flow" := InformationFlow;
        SegLine."Correspondence Type" := SegLine."Correspondence Type"::"E-Mail";
        SegLine.Description := COPYSTR(Subject, 1, MAXSTRLEN(SegLine.Description));

        if SegLine."Information Flow" = SegLine."Information Flow"::Outbound then begin
            LineDate := DateSent;
            SegLine."Initiated By" := SegLine."Initiated By"::Us;
        end else begin
            LineDate := DateReceived;
            SegLine."Initiated By" := SegLine."Initiated By"::Them;
        end;

        // The date received from Exchange is UTC and to record the UTC date and time
        // using the AL functions requires datetime to be of the local date time kind.
        LineDate := LineDate.DateTime(LineDate.Ticks, DateTimeKind.Local);
        SegLine.Date := DT2DATE(LineDate);
        SegLine."Time of Interaction" := DT2TIME(LineDate);

        SegLine.Subject := COPYSTR(Subject, 1, MAXSTRLEN(SegLine.Subject));
        SegLine."Attachment No." := AttachmentNo;
        SegLine.MODIFY;
    end;

    local procedure LogMessageAsInteraction(QueueMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage"; StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder"; var SegLine: Record "Segment Line"; var Attachment: Record Attachment);
    var
        InteractLogEntry: Record "Interaction Log Entry";
        InteractionTemplateSetup: Record "Interaction Template Setup";
        StorageMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
        Subject: Text;
        AttachmentNo: Integer;
        NextInteractLogEntryNo: Integer;
        "----": Integer;
        MailBody_lTxt: Text;
        FromMail_lTxt: Text;
        CCMail_lTxt: Text;
        RecepientEnumerator_lDot: DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
        RecepientAddress_lDot: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
        Sender_lDot: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
        ToMail_lTxt: Text;
    begin
        if not SegLine.ISEMPTY then begin
            Subject := QueueMessage.Subject;

            Attachment.RESET;
            Attachment.LOCKTABLE;
            if Attachment.FINDLAST then
                AttachmentNo := Attachment."No." + 1
            else
                AttachmentNo := 1;

            Attachment.INIT;
            Attachment."No." := AttachmentNo;
            Attachment.INSERT;

            InteractionTemplateSetup.GET;
            SegLine.RESET;
            SegLine.FINDSET(true);
            repeat
                UpdateSegLine(
                  SegLine, InteractionTemplateSetup."E-Mails", Subject, QueueMessage.DateTimeSent, QueueMessage.DateTimeReceived,
                  Attachment."No.");
            until SegLine.NEXT = 0;

            // -JOB_01
            MailBody_lTxt := QueueMessage.Body;
            Sender_lDot := QueueMessage.SenderAddress;
            FromMail_lTxt := Sender_lDot.Address;
            RecepientEnumerator_lDot := QueueMessage.CcRecipients.GetEnumerator;
            while RecepientEnumerator_lDot.MoveNext do begin
                RecepientAddress_lDot := RecepientEnumerator_lDot.Current;
                if CCMail_lTxt = '' then
                    CCMail_lTxt := RecepientAddress_lDot.Address
                else
                    CCMail_lTxt := CCMail_lTxt + ';' + RecepientAddress_lDot.Address;
            end;

            RecepientEnumerator_lDot := QueueMessage.Recipients.GetEnumerator;
            while RecepientEnumerator_lDot.MoveNext do begin
                RecepientAddress_lDot := RecepientEnumerator_lDot.Current;
                if ToMail_lTxt = '' then
                    ToMail_lTxt := RecepientAddress_lDot.Address
                else
                    ToMail_lTxt := ToMail_lTxt + ';' + RecepientAddress_lDot.Address;
            end;

            // +JOB_01
            InteractLogEntry.LOCKTABLE;
            if InteractLogEntry.FINDLAST then
                NextInteractLogEntryNo := InteractLogEntry."Entry No.";
            if SegLine.FINDSET then
                repeat
                    NextInteractLogEntryNo := NextInteractLogEntryNo + 1;
                    // -JOB_01
                    // InsertInteractionLogEntry(SegLine,NextInteractLogEntryNo);
                    InsertInteractionLogEntry(SegLine, NextInteractLogEntryNo, MailBody_lTxt, FromMail_lTxt, CCMail_lTxt, ToMail_lTxt, Subject);
                // +JOB_01
                until SegLine.NEXT = 0;
        end;

        if Attachment."No." <> 0 then begin
            StorageMessage := QueueMessage.CopyToFolder(StorageFolder);
            Attachment.LinkToMessage(StorageMessage.Id, StorageMessage.EntryId, true);

            StorageMessage.NavAttachmentNo := FORMAT(Attachment."No.");
            StorageMessage.Update;

            COMMIT;
        end;
    end;

    procedure InsertInteractionLogEntry(SegLine: Record "Segment Line"; EntryNo: Integer; Body_iTxt: Text; FromMailAddress_iTxt: Text; CC_iTxt: Text; ToMail_iTxt: Text; Subject_iTxt: Text);
    var
        InteractLogEntry: Record "Interaction Log Entry";
        SegManagement: Codeunit SegManagement;
        OutStr_lOst: OutStream;
    begin
        // New parameter Body_iTxt, FromMailAddress_iTxt, CC_ITxt, ToMail_iTxt, Subject_iTxt
        InteractLogEntry.INIT;
        InteractLogEntry."Entry No." := EntryNo;
        InteractLogEntry."Correspondence Type" := InteractLogEntry."Correspondence Type"::"E-Mail";
        SegManagement.CopyFieldsToInteractLogEntry(InteractLogEntry, SegLine);
        InteractLogEntry."E-Mail Logged" := true;
        // -JOB_01
        CLEAR(OutStr_lOst);
        InteractLogEntry."E-Mail Body Text".CREATEOUTSTREAM(OutStr_lOst);
        OutStr_lOst.WRITETEXT(Body_iTxt);
        InteractLogEntry."From Mail Address" := COPYSTR(FromMailAddress_iTxt, 1, MAXSTRLEN(InteractLogEntry."From Mail Address"));
        InteractLogEntry."CC Mail Address" := COPYSTR(CC_iTxt, 1, MAXSTRLEN(InteractLogEntry."CC Mail Address"));
        InteractLogEntry."To Mail Address" := COPYSTR(ToMail_iTxt, 1, MAXSTRLEN(InteractLogEntry."To Mail Address"));
        InteractLogEntry."Mail Subject Long Text" := COPYSTR(Subject_iTxt, 1, MAXSTRLEN(InteractLogEntry."Mail Subject Long Text"));
        // +JOB_01
        InteractLogEntry.INSERT;
    end;

    procedure IsSalesperson(Email: Text; var SalespersonCode: Code[10]): Boolean;
    var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if Email = '' then
            exit(false);

        with Salesperson do begin
            if STRLEN(Email) > MAXSTRLEN("Search E-Mail") then
                exit(false);

            SETCURRENTKEY("Search E-Mail");
            SETRANGE("Search E-Mail", Email);
            if FINDFIRST then begin
                SalespersonCode := Code;
                exit(true);
            end;
            // -JOB_01
            SalespersonCode := AddSetup_gRec."E-Mail Log  Def. Sales Person";
            exit(true);
            // +JOB_01
            exit(false);
        end;
    end;

    procedure IsContact(EMail: Text; var SegLine: Record "Segment Line"): Boolean;
    var
        Cont: Record Contact;
        ContAltAddress: Record "Contact Alt. Address";
    begin
        if EMail = '' then
            exit(false);

        with Cont do begin
            if STRLEN(EMail) > MAXSTRLEN("Search E-Mail") then
                exit(false);

            SETCURRENTKEY("Search E-Mail");
            SETRANGE("Search E-Mail", EMail);
            if FINDFIRST then begin
                SegLine."Contact No." := "No.";
                SegLine."Contact Company No." := "Company No.";
                SegLine."Contact Alt. Address Code" := '';
                exit(true);
            end;
            // -JOB_01
            SegLine."Contact No." := AddSetup_gRec."E-Mail Log Def. Contact";
            SegLine."Contact Company No." := '';
            SegLine."Contact Alt. Address Code" := '';
            exit(true);
            // +JOB_01
        end;

        with ContAltAddress do begin
            if STRLEN(EMail) > MAXSTRLEN("Search E-Mail") then
                exit(false);

            SETCURRENTKEY("Search E-Mail");
            SETRANGE("Search E-Mail", EMail);
            if FINDFIRST then begin
                SegLine."Contact No." := "Contact No.";
                Cont.GET("Contact No.");
                SegLine."Contact Company No." := Cont."Company No.";
                SegLine."Contact Alt. Address Code" := Code;
                exit(true);
            end;
        end;

        exit(false);
    end;

    procedure ProcessMessage(QueueMessage: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage"; StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder");
    var
        TempSegLine: Record "Segment Line" temporary;
        Attachment: Record Attachment;
    begin
        TempSegLine.DELETEALL;
        TempSegLine.INIT;

        Attachment.INIT;
        Attachment.RESET;

        SetErrorContext(Text106);
        if IsMessageToLog(QueueMessage, StorageFolder, TempSegLine, Attachment) then begin
            SetErrorContext(Text107);
            LogMessageAsInteraction(QueueMessage, StorageFolder, TempSegLine, Attachment);
        end;
    end;

    procedure CheckInteractionTemplateSetup(var ErrorMsg: Text): Boolean;
    var
        InteractionTemplateSetup: Record "Interaction Template Setup";
        InteractionTemplate: Record "Interaction Template";
    begin
        // E-Mails cannot be automatically logged unless the field E-Mails on Interaction Template Setup is set.
        InteractionTemplateSetup.GET;
        if InteractionTemplateSetup."E-Mails" = '' then begin
            ErrorMsg := Text109;
            exit(false);
        end;

        // Since we have no guarantees that the Interaction Template for E-Mails exists, we check for it here.
        InteractionTemplate.SETFILTER(Code, '=%1', InteractionTemplateSetup."E-Mails");
        if not InteractionTemplate.FINDFIRST then begin
            ErrorMsg := Text110;
            exit(false);
        end;

        exit(true);
    end;

    local procedure "-"();
    begin
    end;

    procedure RunEMailBatch_gFnc();
    var
        MarketingSetup: Record "Marketing Setup";
        StorageFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
        QueueFolder: DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
    begin
        // JOB_02
        AddSetup_gRec.GET;
        AddSetup_gRec.TESTFIELD("E-Mail Log  Def. Sales Person");
        AddSetup_gRec.TESTFIELD("E-Mail Log Def. Contact");

        SetErrorContext(Text101);
        CheckSetup(MarketingSetup);

        SetErrorContext(Text102);
        if not ExchangeWebServicesServer.Initialize(MarketingSetup."Autodiscovery E-Mail Address", true) then
            ERROR(Text001);

        SetErrorContext(Text103);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetQueueFolderUID, QueueFolder) then
            ERROR(Text002, MarketingSetup."Queue Folder Path");

        SetErrorContext(Text104);
        if not ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetStorageFolderUID, StorageFolder) then
            ERROR(Text002, MarketingSetup."Storage Folder Path");

        RunEMailBatch(MarketingSetup."Email Batch Size", QueueFolder, StorageFolder);
    end;
}

