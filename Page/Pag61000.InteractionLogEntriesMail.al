page 61000 "Interaction Log Entries Mail"
{
    // version NAVW18.00,JOB

    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 290818  JOB_01  CH  Copied from p 5076
    // 070918  JOB_02  NM  new Action CreatenewJob
    // 191018  JOB_03  CH  Additional page action - "Assign Job Detail to Selected Records"
    // 291018  JOB_04  NM  new function GetInteractionLogEntries_gFnc
    // 051218  JOB_05  CH  Show new field "E-Mail read"

    CaptionML = DEU = 'Mail Aktivitätenprotokollposten',
                ENU = 'Mail Interaction Log Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Interaction Log Entry" = rm;
    SourceTable = "Interaction Log Entry";
    SourceTableView = SORTING("Entry No.")
                      ORDER(Descending)
                      WHERE(Postponed = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Canceled; Rec.Canceled)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Attempt Failed"; Rec."Attempt Failed")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field("Time of Interaction"; Rec."Time of Interaction")
                {
                    Editable = false;
                }
                field("Correspondence Type"; Rec."Correspondence Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Interaction Group Code"; Rec."Interaction Group Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("""Attachment No."" <> 0"; Rec."Attachment No." <> 0)
                {
                    BlankZero = true;
                    CaptionML = DEU = 'Dateianhang',
                                ENU = 'Attachment';
                    Editable = false;

                    trigger OnAssistEdit();
                    begin
                        if Rec."Attachment No." <> 0 then
                            Rec.OpenAttachment;
                    end;
                }
                field("Information Flow"; Rec."Information Flow")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Initiated By"; Rec."Initiated By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    Editable = true;
                }
                field("Contact Company No."; Rec."Contact Company No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Evaluation; Rec.Evaluation)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cost (LCY)"; Rec."Cost (LCY)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Duration (Min.)"; Rec."Duration (Min.)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Segment No."; Rec."Segment No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Campaign Entry No."; Rec."Campaign Entry No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Campaign Response"; Rec."Campaign Response")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Campaign Target"; Rec."Campaign Target")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("To-do No."; Rec."To-do No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Interaction Language Code"; Rec."Interaction Language Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Subject; Rec.Subject)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Contact Via"; Rec."Contact Via")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    Editable = false;
                }
                field("Job Task Detail ID"; Rec."Job Task Detail ID")
                {
                    Editable = true;
                }
                field("From Mail Address"; Rec."From Mail Address")
                {
                    Editable = false;
                }
                field("CC Mail Address"; Rec."CC Mail Address")
                {
                    Editable = false;
                }
                field("To Mail Address"; Rec."To Mail Address")
                {
                    Editable = false;
                }
                field("E-Mail Read"; Rec."E-Mail Read")
                {
                }
            }
            group(Control78)
            {
                field("Contact Name"; Rec."Contact Name")
                {
                    CaptionML = DEU = 'Kontaktname',
                                ENU = 'Contact Name';
                    DrillDown = false;
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    DrillDown = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000007; "Interaction Card Page")
            {
                SubPageLink = "Entry No." = FIELD("Entry No.");
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                CaptionML = DEU = '&Posten',
                            ENU = 'Ent&ry';
                Image = Entry;
                action("Co&mments")
                {
                    CaptionML = DEU = 'Be&merkungen',
                                ENU = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inter. Log Entry Comment Sheet";
                    RunPageLink = "Entry No." = FIELD("Entry No.");
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                CaptionML = DEU = 'F&unktion',
                            ENU = 'F&unctions';
                Image = "Action";
                action("Switch Check&mark in Canceled")
                {
                    CaptionML = DEU = '&Kennzeichen auf Storniert setzen',
                                ENU = 'Switch Check&mark in Canceled';
                    Image = ReopenCancelled;

                    trigger OnAction();
                    begin
                        CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                        InteractionLogEntry.ToggleCanceledCheckmark;
                    end;
                }
                action(Resend)
                {
                    CaptionML = DEU = 'Erneut senden',
                                ENU = 'Resend';
                    Image = Reuse;

                    trigger OnAction();
                    var
                        InteractLogEntry: Record "Interaction Log Entry";
                        ResendAttachments: Report "Resend Attachments";
                    begin
                        InteractLogEntry.SETRANGE("Logged Segment Entry No.", Rec."Logged Segment Entry No.");
                        InteractLogEntry.SETRANGE("Entry No.", Rec."Entry No.");
                        ResendAttachments.SETTABLEVIEW(InteractLogEntry);
                        ResendAttachments.RUNMODAL;
                    end;
                }
                action("Evaluate Interaction")
                {
                    CaptionML = DEU = 'Aktivität bewerten',
                                ENU = 'Evaluate Interaction';
                    Image = Evaluate;

                    trigger OnAction();
                    begin
                        CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                        InteractionLogEntry.EvaluateInteraction;
                    end;
                }
                action(AssignJobTaskIDAuto)
                {
                    CaptionML = DEU = 'Projekunteraufgabe ID Automatisch Zuordnen',
                                ENU = 'Assign Job Task Detail Automatically';
                    Image = JobTimeSheet;

                    trigger OnAction();
                    begin
                        HSGFunctions_gCdu.AssignJobDetailToInteractionLogEntry_gFnc;
                    end;
                }
                action(CreateNewJob)
                {
                    CaptionML = DEU = 'Neue Aufgabe Erstellen',
                                ENU = 'Create new Job';
                    Image = New;
                    Promoted = true;

                    trigger OnAction();
                    begin
                        JobDetailMgt_gCdu.CreateNewJob_gFnc(Rec); // JOB_02
                    end;
                }
                // action("E-Mails importieren")
                // {
                //     CaptionML = DEU = 'E-Mails importieren',
                //                 ENU = 'Import E-Mails';
                //     Image = ImportExport;

                //     trigger OnAction();
                //     begin
                //         EMailLoggingDispatcher_gCdu.RunEMailBatch_gFnc;
                //     end;
                // }
                action(AssignJobTaskIDManually)
                {
                    CaptionML = DEU = 'Projekunteraufgabe ID Manuell Zuordnen',
                                ENU = 'Assign Job Task Detail Manually';
                    Image = JobRegisters;

                    trigger OnAction();
                    begin
                        AssignDetailsToSelectedRecoords_lFnc; // JOB_03
                    end;
                }
                separator(Separator75)
                {
                }
                action("Create To-do")
                {
                    AccessByPermission = TableData "To-do" = R;
                    CaptionML = DEU = 'Aufgabe erstellen',
                                ENU = 'Create To-do';
                    Image = NewToDo;

                    trigger OnAction();
                    begin
                        CreateTodo();
                    end;
                }
            }
            action(Show)
            {
                CaptionML = DEU = 'E-Mail An&zeigen',
                            ENU = '&Show E-Mail';
                Enabled = ShowEnable;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Rec."Attachment No." <> 0 then
                        Rec.OpenAttachment
                    else
                        Rec.ShowDocument;
                end;
            }
            action("Create &Interact")
            {
                CaptionML = DEU = 'Aktivität &erst.',
                            ENU = 'Create &Interact';
                Image = CreateInteraction;

                trigger OnAction();
                begin
                    Rec.CreateInteraction;
                end;
            }
            action("E-Mail")
            {
                CaptionML = DEU = 'Antwort E-Mail Senden',
                            ENU = 'Send Answer E-Mail';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    HSGFunctions_gCdu.SendEMailFromInteractionLogEntry_gFnc(Rec); // JOB_01
                end;
            }
            action("Toggle E-Mail Read")
            {
                CaptionML = DEU = 'E-Mail gelesen Kennzeichen ändern',
                            ENU = 'Toggle E-Mail Read';
                Image = Confirm;

                trigger OnAction();
                begin
                    ToggleE_MailReadSelectedRecords_lFnc; // JOB_05
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        Rec.CALCFIELDS("Contact Name", "Contact Company Name");
    end;

    trigger OnFindRecord(Which: Text): Boolean;
    var
        RecordsFound: Boolean;
    begin
        RecordsFound := Rec.FIND(Which);
        FunctionsEnable := RecordsFound;
        ShowEnable := RecordsFound;
        EntryEnable := RecordsFound;
        exit(RecordsFound);
    end;

    trigger OnInit();
    begin
        EntryEnable := true;
        ShowEnable := true;
        FunctionsEnable := true;
    end;

    trigger OnOpenPage();
    begin
        SetCaption;

        // -JOB_01
        InteractionTemplate_gRec.GET;
        InteractionTemplate_gRec.TESTFIELD("E-Mails");
        Rec.SETRANGE("Interaction Template Code", InteractionTemplate_gRec."E-Mails");
        // +JOB_01
    end;

    var
        InteractionLogEntry: Record "Interaction Log Entry";
        [InDataSet]
        FunctionsEnable: Boolean;
        [InDataSet]
        ShowEnable: Boolean;
        [InDataSet]
        EntryEnable: Boolean;
        "---": Integer;
        InteractionTemplate_gRec: Record "Interaction Template Setup";
        HSGFunctions_gCdu: Codeunit "HSG Functions";
        // EMailLoggingDispatcher_gCdu: Codeunit "E-Mail Logging Dispatcher_";
        JobDetailMgt_gCdu: Codeunit "Job Task Detail Mgnt.";
        ConfirmAlreadyAssigned_gCtx: TextConst DEU = 'Für Protokollposten %1 existiert bereits eine Zuordnung - trotzdem fortfahren?', ENU = 'There is an assigenment for interaction log entry %1 already - continue anyway?';
        Err_Abort_gCtx: Label 'Abbruch';
        JobTask_gRec: Record "Job Task";

    local procedure SetCaption();
    var
        Contact: Record Contact;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ToDo: Record "To-do";
        Opportunity: Record Opportunity;
    begin
        if Contact.GET(Rec."Contact Company No.") then
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."Company No." + ' . ' + Contact."Company Name");
        if Contact.GET(Rec."Contact No.") then begin
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."No." + ' . ' + Contact.Name);
            exit;
        end;
        if Rec."Contact Company No." <> '' then
            exit;
        if SalespersonPurchaser.GET(Rec."Salesperson Code") then begin
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Rec."Salesperson Code" + ' . ' + SalespersonPurchaser.Name);
            exit;
        end;
        if Rec."Interaction Template Code" <> '' then begin
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Rec."Interaction Template Code");
            exit;
        end;
        if ToDo.GET(Rec."To-do No.") then begin
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + ToDo."No." + ' . ' + ToDo.Description);
            exit;
        end;
        if Opportunity.GET(Rec."Opportunity No.") then
            CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Opportunity."No." + ' . ' + Opportunity.Description);
    end;

    local procedure AssignDetailsToSelectedRecoords_lFnc();
    var
        InteractionLogEntry_lRec: Record "Interaction Log Entry";
        JobDetails_lRec: Record "Job Task Detail";
    begin
        // JOB_03
        CurrPage.SETSELECTIONFILTER(InteractionLogEntry_lRec);

        if PAGE.RUNMODAL(0, JobDetails_lRec) = ACTION::LookupOK then begin
            InteractionLogEntry_lRec.FINDFIRST;
            repeat
                if InteractionLogEntry_lRec."Job Task Detail ID" <> 0 then
                    if not CONFIRM(ConfirmAlreadyAssigned_gCtx, false, InteractionLogEntry_lRec."Entry No.") then
                        ERROR(Err_Abort_gCtx);
                InteractionLogEntry_lRec.VALIDATE("Job Task Detail ID", JobDetails_lRec."Job Task Detail ID");
                InteractionLogEntry_lRec.MODIFY;
            until InteractionLogEntry_lRec.NEXT = 0;
        end;
    end;

    /// <summary>
    /// GetInteractionLogEntries_gFnc.
    /// </summary>
    /// <param name="InteractionLog_iRec">VAR Record "Interaction Log Entry".</param>
    procedure GetInteractionLogEntries_gFnc(var InteractionLog_iRec: Record "Interaction Log Entry");
    begin
        //-JOB_04
        CurrPage.SETSELECTIONFILTER(Rec);
        InteractionLog_iRec.COPY(Rec);
        //+JOB_04
    end;

    local procedure ToggleE_MailReadSelectedRecords_lFnc();
    var
        InteractionLogEntry_lRec: Record "Interaction Log Entry";
        JobDetails_lRec: Record "Job Task Detail";
    begin
        // JOB_05
        CurrPage.SETSELECTIONFILTER(InteractionLogEntry_lRec);

        InteractionLogEntry_lRec.FINDFIRST;
        repeat
            InteractionLogEntry_lRec."E-Mail Read" := not InteractionLogEntry_lRec."E-Mail Read";
            InteractionLogEntry_lRec.MODIFY;
        until InteractionLogEntry_lRec.NEXT = 0;
    end;
}

