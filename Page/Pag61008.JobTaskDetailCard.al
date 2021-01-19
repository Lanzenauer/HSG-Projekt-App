page 61008 "Job Task Detail Card"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 240216  HSG_00  SL  Created Job Task Detail Card
    // 010217  HSG_01  SL  Created Page Action "Create Project Task"
    // 020217  HSG_02  SL  Created Page Action "Create Job Journal Line"
    // 150317  HSG_03  SL  Created Page Action "Description"
    // 160317  HSG_04  SL  Created Page Action "Solution"
    // 060917  HSG_05  FC  JobTask_lRec.Status does not exist anymore
    // 290818  HSG_01  CH  Show field "No Of E-Mails"
    // 060918  HSG_06  NM  Set not editable on Status "closed"
    // 291018  HSG_07  NM  New Function "--ACMT"AssignEMailsJobTask_lFnc
    // 021118  HSG_08  SG  SET right filter

    CaptionML = DEU = 'Projektunteraufgabe Karte',
                ENU = 'Job Task Detail Card';
    DataCaptionExpression = FORMAT(Rec."Job Task Detail ID") + ' - ' + Rec."Job Task Description" + ' - ' + Rec."Short Description";
    DataCaptionFields = "Job No.", "Job Task No.", "Job Task Detail ID";
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Job Task Detail";

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                CaptionML = DEU = 'Allgemein',
                            ENU = 'General';
                field("Job Task Detail ID"; Rec."Job Task Detail ID")
                {
                    Editable = false;
                    Enabled = false;
                    Importance = Additional;
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = editable_gBol;

                    trigger OnValidate();
                    var
                        Cont_lRec: Record Contact;
                        ContBusinessRelation_lRec: Record "Contact Business Relation";
                        Job_lRec: Record Job;
                        Count_lInt: Integer;
                    begin
                        UpdateDescriptionSolution_lFnc(true);

                        if Rec."Job No." > '' then begin
                            Rec."Contact No." := '';
                            ContactName_gTxt := '';
                            Job_lRec.GET(Rec."Job No.");
                            ContBusinessRelation_lRec.RESET;
                            ContBusinessRelation_lRec.SETCURRENTKEY("Link to Table", "No.");
                            ContBusinessRelation_lRec.SETRANGE("Link to Table", ContBusinessRelation_lRec."Link to Table"::Customer);
                            ContBusinessRelation_lRec.SETRANGE("No.", Job_lRec."Bill-to Customer No.");
                            if ContBusinessRelation_lRec.FINDFIRST then begin
                                Cont_lRec.SETRANGE("Company No.", ContBusinessRelation_lRec."Contact No.");
                                Cont_lRec.SETRANGE(Type, Cont_lRec.Type::Person);
                                if Cont_lRec.COUNT = 1 then begin
                                    Cont_lRec.FINDFIRST;
                                    Rec.VALIDATE("Contact No.", Cont_lRec."No.");
                                    ContactName_gTxt := Cont_lRec.Name;
                                end;
                            end;
                        end;
                    end;
                }
                field(JobTaskName_gTxt; JobTaskName_gTxt)
                {
                    CaptionML = DEU = 'Projektaufgabe',
                                ENU = 'Job Task';
                    Editable = editable_gBol;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Position_lTxt: Text;
                        JobTask_lRec: Record "Job Task";
                    begin
                        JobTask_lRec.SETRANGE("Job No.", Rec."Job No.");
                        if JobTask_lRec.GET(Rec."Job No.", Rec."Job Task No.") then;
                        if PAGE.RUNMODAL(50035, JobTask_lRec) = ACTION::LookupOK then begin
                            JobTaskName_gTxt := JobTask_lRec.Description;
                            if Rec."Job Task No." <> JobTask_lRec."Job Task No." then begin
                                Rec.VALIDATE("Job Task No.", JobTask_lRec."Job Task No.");
                            end;
                        end;

                        //Position_lTxt := GETPOSITION(FALSE);
                        //CurrPage.Description_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 0, "Job Task Detail ID" ,"Job No.","Job Task No.","Short Description");
                        //CurrPage.Solution_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 1, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
                        //CurrPage.UPDATE(TRUE);
                        UpdateDescriptionSolution_lFnc(true);
                    end;

                    trigger OnValidate();
                    var
                        Position_lTxt: Text;
                        JobTask_lRec: Record "Job Task";
                    begin
                        if JobTaskName_gTxt = '' then begin
                            exit;
                        end;
                        JobTask_lRec.SETRANGE("Job No.", Rec."Job No.");
                        if not JobTask_lRec.GET(Rec."Job No.", JobTaskName_gTxt) then begin
                            JobTask_lRec.SETFILTER(Description, '%1', '@*' + JobTaskName_gTxt + '*');
                            if JobTask_lRec.COUNT = 1 then begin
                                JobTask_lRec.FINDFIRST;
                                //JobTaskName_gTxt:= JobTask_lRec.Description;
                                JobTaskName_gTxt := '[' + Rec."Job Task No." + '] ' + JobTask_lRec.Description;
                                if Rec."Job Task No." <> JobTask_lRec."Job Task No." then begin
                                    Rec.VALIDATE("Job Task No.", JobTask_lRec."Job Task No.");
                                end;
                            end else begin
                                if not JobTask_lRec.FINDFIRST then begin
                                    JobTask_lRec.SETRANGE(Description);
                                end;
                                if PAGE.RUNMODAL(50035, JobTask_lRec) = ACTION::LookupOK then begin
                                    //JobTaskName_gTxt:= JobTask_lRec.Description;
                                    JobTaskName_gTxt := '[' + Rec."Job Task No." + '] ' + JobTask_lRec.Description;
                                    if Rec."Job Task No." <> JobTask_lRec."Job Task No." then begin
                                        Rec.VALIDATE("Job Task No.", JobTask_lRec."Job Task No.");
                                    end;
                                end;
                            end;
                        end else begin
                            //JobTaskName_gTxt:= JobTask_lRec.Description;
                            JobTaskName_gTxt := '[' + Rec."Job Task No." + '] ' + JobTask_lRec.Description;
                            if Rec."Job Task No." <> JobTask_lRec."Job Task No." then begin
                                Rec.VALIDATE("Job Task No.", JobTask_lRec."Job Task No.");
                            end;
                        end;
                        UpdateDescriptionSolution_lFnc(true);
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Editable = editable_gBol;
                    Visible = false;

                    trigger OnValidate();
                    var
                        Position_lTxt: Text;
                        JobTask_lRec: Record "Job Task";
                    begin
                    end;
                }
                field("Job Task Description"; Rec."Job Task Description")
                {
                    Editable = editable_gBol;
                    Enabled = (Rec."Job Task No." = '');
                    Importance = Additional;
                }
                field(Arranger; Rec.Arranger)
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field(Reproducible; Rec.Reproducible)
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field("Last update"; Rec."Last update")
                {
                    Importance = Additional;
                }
                field(ContactName_gTxt; ContactName_gTxt)
                {
                    CaptionML = DEU = 'Ansprechpartner',
                                ENU = 'Contact Suchname';
                    Editable = editable_gBol;

                    trigger OnAssistEdit();
                    var
                        Cont_lRec: Record Contact;
                        ContBusinessRelation_lRec: Record "Contact Business Relation";
                        Job_lRec: Record Job;
                        Count_lInt: Integer;
                    begin
                        if Rec."Contact No." > '' then begin
                            Cont_lRec.GET(Rec."Contact No.");
                            PAGE.RUNMODAL(5050, Cont_lRec);
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Cont_lRec: Record Contact;
                        ContBusinessRelation_lRec: Record "Contact Business Relation";
                        Job_lRec: Record Job;
                        Count_lInt: Integer;
                    begin
                        Job_lRec.GET(Rec."Job No.");
                        ContBusinessRelation_lRec.RESET;
                        ContBusinessRelation_lRec.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation_lRec.SETRANGE("Link to Table", ContBusinessRelation_lRec."Link to Table"::Customer);
                        ContBusinessRelation_lRec.SETRANGE("No.", Job_lRec."Bill-to Customer No.");
                        if ContBusinessRelation_lRec.FINDFIRST then begin
                            Cont_lRec.SETRANGE("Company No.", ContBusinessRelation_lRec."Contact No.");
                            Cont_lRec.SETRANGE(Type, Cont_lRec.Type::Person);
                            if PAGE.RUNMODAL(0, Cont_lRec) = ACTION::LookupOK then begin
                                Rec.VALIDATE("Contact No.", Cont_lRec."No.");
                                ContactName_gTxt := Cont_lRec.Name;
                            end;
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Cont_lRec: Record Contact;
                        ContBusinessRelation_lRec: Record "Contact Business Relation";
                        Job_lRec: Record Job;
                        Count_lInt: Integer;
                    begin
                        if ContactName_gTxt > '' then begin
                            Job_lRec.GET(Rec."Job No.");
                            ContBusinessRelation_lRec.RESET;
                            ContBusinessRelation_lRec.SETCURRENTKEY("Link to Table", "No.");
                            ContBusinessRelation_lRec.SETRANGE("Link to Table", ContBusinessRelation_lRec."Link to Table"::Customer);
                            ContBusinessRelation_lRec.SETRANGE("No.", Job_lRec."Bill-to Customer No.");
                            if ContBusinessRelation_lRec.FINDFIRST then begin
                                Cont_lRec.SETRANGE("Company No.", ContBusinessRelation_lRec."Contact No.");
                                Cont_lRec.SETFILTER("Search Name", '%1', '*' + ContactName_gTxt + '*');
                                Cont_lRec.SETRANGE(Type, Cont_lRec.Type::Person);
                                Count_lInt := Cont_lRec.COUNT;
                                if Count_lInt = 1 then begin
                                    Cont_lRec.FINDFIRST;
                                    Rec.VALIDATE("Contact No.", Cont_lRec."No.");
                                    ContactName_gTxt := Cont_lRec.Name;
                                end else begin
                                    if Count_lInt > 1 then begin
                                        if PAGE.RUNMODAL(0, Cont_lRec) = ACTION::LookupOK then begin
                                            Rec.VALIDATE("Contact No.", Cont_lRec."No.");
                                            ContactName_gTxt := Cont_lRec.Name;
                                        end;
                                    end else begin
                                        if Count_lInt = 0 then begin// Create Contact
                                            if CONFIRM('Kontakt anlegen?\"' + ContactName_gTxt + '"', false) then begin
                                                CurrPage.UPDATE(true);
                                                Cont_lRec.INIT;
                                                Cont_lRec."No." := '';
                                                Cont_lRec.VALIDATE(Name, ContactName_gTxt);
                                                //Cont_lRec."Company No.":= ContBusinessRelation_lRec."Contact No.";
                                                Cont_lRec.INSERT(true);
                                                Cont_lRec.VALIDATE(Name, ContactName_gTxt);
                                                Cont_lRec.VALIDATE(Type, Cont_lRec.Type::Person);
                                                Cont_lRec.VALIDATE("Company No.", ContBusinessRelation_lRec."Contact No.");
                                                Cont_lRec.MODIFY;
                                                COMMIT;
                                                Cont_lRec.RESET;
                                                PAGE.RUNMODAL(5050, Cont_lRec);
                                                Cont_lRec.GET(Cont_lRec."No.");
                                                Rec.VALIDATE("Contact No.", Cont_lRec."No.");
                                                ContactName_gTxt := Cont_lRec.Name;
                                                CurrPage.UPDATE(true);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                }
                field("Short Description"; Rec."Short Description")
                {
                    Editable = editable_gBol;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field(Category; Rec.Category)
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field(Priority_Ctl; Rec.Priority)
                {
                    Editable = editable_gBol;
                }
                field(Status; Rec.Status)
                {
                    Editable = editable_gBol;
                    Importance = Promoted;

                    trigger OnValidate();
                    begin
                        //-HSG_06
                        if Rec.Status = HSGSetup_gRec."Job Details Closed" then
                            editable_gBol := false
                        else
                            editable_gBol := true;
                        if Rec.Status = HSGSetup_gRec."Job Details Wait" then
                            Rec."Waiting on Customer" := true;
                        CurrPage.UPDATE;
                        //+HSG_06
                    end;
                }
                field(WaitingonCustomer_Ctl; Rec."Waiting on Customer")
                {
                    Editable = editable_gBol;
                    Visible = false;
                }
                field("Message Date"; Rec."Message Date")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Planned Date_Ctl"; Rec."Planned Date")
                {
                    Editable = editable_gBol;
                    Importance = Standard;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = editable_gBol;
                    Importance = Promoted;
                }
                field("Fixed Date_Ctl"; Rec."Fixed Date")
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field("Estimated Quantity_Ctl"; Rec."Estimated Quantity")
                {
                    Editable = editable_gBol;
                    Importance = Promoted;
                }
                field("Quote Quantity"; Rec."Quote Quantity")
                {
                    CaptionML = DEU = 'Menge Angebot',
                                ENU = 'quantity quote';
                    Editable = editable_gBol;
                }
                field(RemainingQuantity_Ctl; Rec."Remaining Quantity")
                {
                    Editable = editable_gBol;
                    Importance = Additional;
                }
                field(ProcessingBy_Ctl; ProcessingBy_gTxt)
                {
                    CaptionML = DEU = 'Bearbeitung durch',
                                ENU = 'Processing by';
                    Editable = editable_gBol;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Resource_lRec: Record Resource;
                    begin
                        if Resource_lRec.GET(Rec."Processing by") then;
                        // -HSG_08
                        Resource_lRec.SETRANGE("Show in Statistics", true);
                        // +HSG_08
                        Resource_lRec.SETRANGE(Blocked, false);
                        if PAGE.RUNMODAL(0, Resource_lRec) = ACTION::LookupOK then begin
                            if CurrPage.EDITABLE = true then begin
                                ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                                if Rec."Processing by" <> Resource_lRec."No." then
                                    Rec.VALIDATE("Processing by", Resource_lRec."No.");
                            end;
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Resource_lRec: Record Resource;
                        ResourceList_lPag: Page "Resource List";
                    begin
                        if not Resource_lRec.GET(ProcessingBy_gTxt) then begin
                            Resource_lRec.SETRANGE(Blocked, false);
                            // -HSG_08
                            Resource_lRec.SETRANGE("Show in Statistics", true);
                            // +HSG_08
                            Resource_lRec.SETFILTER(Name, '*' + ProcessingBy_gTxt + '*');
                            if not Resource_lRec.FINDFIRST then begin
                                Resource_lRec.SETFILTER("Search Name", '*' + ProcessingBy_gTxt + '*');
                            end;
                            if Resource_lRec.COUNT = 1 then begin
                                Resource_lRec.FINDFIRST;
                                ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                            end else begin
                                if not Resource_lRec.FINDFIRST then begin
                                    Resource_lRec.SETRANGE("Search Name");
                                end;
                                if PAGE.RUNMODAL(0, Resource_lRec) = ACTION::LookupOK then begin
                                    if CurrPage.EDITABLE = true then begin
                                        ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                                        if Rec."Processing by" <> Resource_lRec."No." then
                                            Rec.VALIDATE("Processing by", Resource_lRec."No.");
                                    end;
                                end;
                            end;
                        end else begin
                            ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                        end;
                        if Rec."Processing by" <> Resource_lRec."No." then
                            Rec.VALIDATE("Processing by", Resource_lRec."No.");
                    end;
                }
                field("No Of E-Mails"; Rec."No Of E-Mails")
                {
                    DrillDownPageID = "Interaction Log Entries Mail";
                }
            }
            part(Description_Ctl; Rec."Job Task Detail Add. Text")
            {
                CaptionML = DEU = 'Beschreibung',
                            ENU = 'Description';
                Editable = editable_gBol;
                ShowFilter = false;
            }
            part(Solution_Ctl; "Job Task Detail Add. Text")
            {
                CaptionML = DEU = 'Lösung',
                            ENU = 'Description';
                Editable = editable_gBol;
                ShowFilter = false;
            }
            part(Control1000000020; "Job Task Detail Sub History")
            {
                SubPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID");
                SubPageView = SORTING("Job Task Detail ID", LastDate)
                              ORDER(Descending);
            }
        }
        area(factboxes)
        {
            Caption = 'FactBox';
            part(Control1000000038; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Job No.");
            }
            part(Control1000000021; "Job Task Detail History FactBo")
            {
                SubPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID");
            }
            part(Control1000000045; "Job Task Description List Part")
            {
                Editable = false;
                SubPageLink = "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
                Visible = true;
            }
            systempart(Control1000000043; MyNotes)
            {
                Visible = false;
            }
            systempart("<Notes>"; Notes)
            {
                CaptionML = DEU = 'Notitzen',
                            ENU = 'Notes';
            }
            systempart(Links; Links)
            {
                CaptionML = DEU = 'Links',
                            ENU = 'Links';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Create Project Task")
            {
                CaptionML = DEU = 'Projektaufgabe anlegen',
                            ENU = 'Create Project Task';
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    "--- HSG locals ---": Boolean;
                    Job_lRec: Record Job;
                    JobTask_lRec: Record "Job Task";
                    NoSeries_lRec: Record "No. Series";
                    NoSeriesManagement_lCdu: Codeunit NoSeriesManagement;
                    JobTaskDescription_lTxt: Text[50];
                begin
                    // -HSG_01
                    JobDetMgt_gCdu.CreateProjectTask_gFnc(Rec);
                end;
            }
            action("Close Job")
            {
                CaptionML = DEU = 'Aufgabe abschließen',
                            ENU = 'Close Job';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //-HSG_07
                    JobDetMgt_gCdu.CreateJobJournalLine_gFnc(Rec);
                    JobDetMgt_gCdu.SetStatusClosed_gFnc(Rec);
                    //+HSG_07
                end;
            }
            action("Create Job Journal Line")
            {
                CaptionML = DEU = 'Projekt Buch.-Blatt Zeile erstellen',
                            ENU = 'Create Job Journal Line';
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    "--- HSG locals ---": Boolean;
                    Job_lRec: Record Job;
                    JobTask_lRec: Record "Job Task";
                    JobJournalBatch_lRec: Record "Job Journal Batch";
                    JobJournalLine_lRec: Record "Job Journal Line";
                    BatchName_lCod: Code[10];
                    DocumentNo_lCod: Code[10];
                    Description_lTxt: Text[250];
                    Quantity_lDec: Decimal;
                    NextLineNo_lInt: Integer;
                    Chargeable_lBln: Boolean;
                    Date_lDat: Date;
                begin
                    // -HSG_02
                    JobDetMgt_gCdu.CreateJobJournalLine_gFnc(Rec);
                end;
            }
            action("Job Task Description")
            {
                CaptionML = DEU = 'Projektaufgaben Beschreibung',
                            ENU = 'Job Task Description';
                Image = Description;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Task Description";
                                RunPageLink = "Table Name" = CONST("Job Task Description"),
                              "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
            }
            action("Set Status Work")
            {
                CaptionML = DEU = 'Status auf Bearbeitung zurücksetzen',
                            ENU = 'Set Status Work';

                trigger OnAction();
                begin
                    Rec.SetStatus_gFnc("Job Task Document No.");
                    editable_gBol := true;
                    CurrPage.UPDATE;
                end;
            }
            action(ObjectList_Ctl)
            {
                CaptionML = DEU = 'Objektliste',
                            ENU = 'Object List';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Task Detail Objects";
                                RunPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID"),
                              "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
            }
            action(CreateNote_Ctl)
            {
                Caption = 'Notiz erstellen';
                Image = Note;
                Promoted = true;

                trigger OnAction();
                begin
                    CreateNote_gFnc(Rec);
                end;
            }
            action(History)
            {
                CaptionML = DEU = 'Projektjob Historie',
                            ENU = 'Job Task Detail History';
                Image = History;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Job Task Detail History";
                                RunPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID"),
                              "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
            }
            action(ShowDescription_Ctl)
            {
                CaptionML = DEU = 'Beschreibung anzeigen',
                            ENU = 'Show Description';
                Image = Description;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ShortCutKey = 'Ctrl+B';

                trigger OnAction();
                begin
                    ShowDescriptionSolution_gFnc(Rec, true);
                end;
            }
            action(ShowSolution_Ctl)
            {
                CaptionML = DEU = 'Lösung anzeigen',
                            ENU = 'Show Solution';
                Image = Description;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ShortCutKey = 'Ctrl+Ö';

                trigger OnAction();
                begin
                    ShowDescriptionSolution_gFnc(Rec, false);
                end;
            }
            action("Assign Emails to Job Task")
            {
                Caption = 'E-Mails zuordnen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    AssignEMailsJobTask_lFnc;  //HSG_06
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        Position_lTxt: Text;
    begin
        //Position_lTxt := GETPOSITION(FALSE);
        //CurrPage.Description_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 0, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
        //CurrPage.Solution_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 1, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
        //UpdateDescriptionSolution_lFnc(FALSE);
    end;

    trigger OnAfterGetRecord();
    var
        Position_lTxt: Text;
        JobTask_lRec: Record "Job Task";
        Resource_lRec: Record Resource;
    begin
        //Position_lTxt := GETPOSITION(FALSE);
        //CurrPage.Description_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 0, "Job Task Detail ID" ,"Job No.","Job Task No.","Short Description");
        //CurrPage.Solution_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 1, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
        //CALCFIELDS("Resource Name");
        //ContactName_gTxt:= '';
        //-HSG_06
        if Status = HSGSetup_gRec."Job Details Closed" then
            editable_gBol := false
        else
            editable_gBol := true;
        //+HSG_06

        CALCFIELDS("Contact Name");
        ContactName_gTxt := "Contact Name";
        JobTaskName_gTxt := '';
        if JobTask_lRec.GET("Job No.", "Job Task No.") then begin
            JobTaskName_gTxt := '[' + "Job Task No." + '] ' + JobTask_lRec.Description;
        end;

        ProcessingBy_gTxt := '';
        if Resource_lRec.GET("Processing by") then begin
            ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
        end;

        PageEditable_gBln := CurrPage.EDITABLE;

        UpdateDescriptionSolution_lFnc(false);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        JobTaskDetailStatus_lRec: Record "Job Task Detail Status";
    begin
        //VALIDATE("Status Extended","Status Extended"::"3");
        JobTaskDetailStatus_lRec.SETRANGE("Status Extended", JobTaskDetailStatus_lRec."Status Extended"::Deleted);
        JobTaskDetailStatus_lRec.FINDFIRST;
        VALIDATE(Status, JobTaskDetailStatus_lRec.Code);
        MODIFY;
        exit(false);
    end;

    trigger OnInit();
    begin
        if FIND('+') then begin
            "Job Task Detail ID" := "Job Task Detail ID" + 1;
        end
        else begin
            "Job Task Detail ID" := 1;
        end;
        //-HSG_06
        editable_gBol := true;
        HSGSetup_gRec.GET;
        //+HSG_06
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        Position_lTxt: Text;
    begin
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        Position_lTxt: Text;
    begin
        // Position_lTxt := GETPOSITION(FALSE);
        // CurrPage.Description_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 0, "Job Task Detail ID" ,"Job No.","Job Task No.","Short Description");
        // CurrPage.Solution_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 1, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
        PageEditable_gBln := CurrPage.EDITABLE;
    end;

    trigger OnOpenPage();
    var
        Position_lTxt: Text;
    begin
        Position_lTxt := GETPOSITION(false);
        //CurrPage.Description_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, ExtDefTxt.DetailText_gFnc, ExtDefTxt.DetailText_gFnc);
        //CurrPage.Solution_Ctl.PAGE.SetRecordInformation(DATABASE::"Job Task Detail", Position_lTxt, 1, 1);
    end;

    var
        "--ACMT": Integer;
        ContactName_gTxt: Text;
        JobTaskNo_gCod: Code[20];
        JobTaskName_gTxt: Text;
        PageEditable_gBln: Boolean;
        ProcessingBy_gTxt: Text;
        Text001_gCtx: TextConst DEU = '%1 %2 %3 exists already', ENU = '%1 %2 %3 gibt es schon';
        HSGSetup_gRec: Record "HSG Add. Setup";
        editable_gBol: Boolean;
        JobDetMgt_gCdu: Codeunit "Job Task Detail Mgnt.";
        ConfirmAlreadyAssigned_gCtx: TextConst DEU = 'Für Protokollposten %1 existiert bereits eine Zuordnung - trotzdem fortfahren?', ENU = 'There is an assigenment for interaction log entry %1 already - continue anyway?';
        Err_Abort_gCtx: Label 'Abbruch';

    procedure CreateNote_gFnc(var JobTaskDetail_vRec: Record "Job Task Detail"): Boolean;
    var
        JobTaskDetail_TMP_lRec: Record "Job Task Detail" temporary;
        JobSubTaskCreateNote_lPag: Page "Job Task Detail Create Note";
                                       V_lTxt: Text;
                                       Modified_lBln: Boolean;
                                       JobTaskDetailHistory_lRec: Record "Job Task Detail History";
                                       JobTaskDetailSubHistory_lPag: Page "Job Task Detail Sub History";
                                       Filter1_lDtm: DateTime;
                                       Filter2_lDtm: DateTime;
    begin
        JobTaskDetail_TMP_lRec.COPY(JobTaskDetail_vRec);
        JobTaskDetail_TMP_lRec.INSERT;
        JobSubTaskCreateNote_lPag.LOOKUPMODE(true);
        JobSubTaskCreateNote_lPag.SETRECORD(JobTaskDetail_TMP_lRec);
        //JobSubTaskCreateNote_lPag.SetTable_gFnc(JobTaskDetail_vRec);
        JobSubTaskCreateNote_lPag.SetTable_gFnc(JobTaskDetail_TMP_lRec);
        if JobSubTaskCreateNote_lPag.RUNMODAL = ACTION::LookupOK then begin
            //JobSubTaskCreateNote_lPag.GETRECORD(JobTaskDetail_TMP_lRec);
            JobSubTaskCreateNote_lPag.GetTable_gFnc(JobTaskDetail_TMP_lRec);
            if JobTaskDetail_TMP_lRec."Short Description" <> "Short Description" then begin
                //VALIDATE(JobTaskDetail_vRec."Short Description", JobTaskDetail_TMP_lRec."Short Description");
                JobTaskDetail_vRec.VALIDATE("Short Description", JobTaskDetail_TMP_lRec."Short Description");
                Modified_lBln := true;
            end;
            if Status <> JobTaskDetail_TMP_lRec.Status then begin
                JobTaskDetail_vRec.VALIDATE(Status, JobTaskDetail_TMP_lRec.Status);
                Modified_lBln := true;
            end;
            if "Planned Date" <> JobTaskDetail_TMP_lRec."Planned Date" then begin
                JobTaskDetail_vRec.VALIDATE("Planned Date", JobTaskDetail_TMP_lRec."Planned Date");
                Modified_lBln := true;
            end;
            if "Fixed Date" <> JobTaskDetail_TMP_lRec."Fixed Date" then begin
                JobTaskDetail_vRec.VALIDATE("Fixed Date", JobTaskDetail_TMP_lRec."Fixed Date");
                Modified_lBln := true;
            end;
            if "Waiting on Customer" <> JobTaskDetail_TMP_lRec."Waiting on Customer" then begin
                JobTaskDetail_vRec.VALIDATE("Waiting on Customer", JobTaskDetail_TMP_lRec."Waiting on Customer");
                Modified_lBln := true;
            end;
            if Priority <> JobTaskDetail_TMP_lRec.Priority then begin
                JobTaskDetail_vRec.VALIDATE(Priority, JobTaskDetail_TMP_lRec.Priority);
                Modified_lBln := true;
            end;
            if "Remaining Quantity" <> JobTaskDetail_TMP_lRec."Remaining Quantity" then begin
                JobTaskDetail_vRec.VALIDATE("Remaining Quantity", JobTaskDetail_TMP_lRec."Remaining Quantity");
                Modified_lBln := true;
            end;
            if "Processing by" <> JobTaskDetail_TMP_lRec."Processing by" then begin
                JobTaskDetail_vRec.VALIDATE("Processing by", JobTaskDetail_TMP_lRec."Processing by");
                Modified_lBln := true;
            end;
            if Modified_lBln then begin
                JobTaskDetail_vRec.MODIFY;
                JobTaskDetailHistory_lRec.SETRANGE("Job Task Detail ID", JobTaskDetail_vRec."Job Task Detail ID");
                JobTaskDetailHistory_lRec.SETRANGE("Job No.", JobTaskDetail_vRec."Job No.");
                JobTaskDetailHistory_lRec.SETRANGE("Job Task No.", JobTaskDetail_vRec."Job Task No.");
                Filter1_lDtm := ROUNDDATETIME(CURRENTDATETIME, 100000, '<');
                Filter2_lDtm := CURRENTDATETIME;
                JobTaskDetailHistory_lRec.SETRANGE(LastDate, Filter1_lDtm, Filter2_lDtm);
                JobTaskDetailHistory_lRec.SETRANGE(User, GetUser_gFnc(''));
                JobTaskDetailHistory_lRec.FINDLAST;
            end else begin
                JobTaskDetailHistory_lRec.INIT;
                JobTaskDetailHistory_lRec."Job Task Detail ID" := JobTaskDetail_vRec."Job Task Detail ID";
                JobTaskDetailHistory_lRec."Job No." := JobTaskDetail_vRec."Job No.";
                JobTaskDetailHistory_lRec."Job Task No." := JobTaskDetail_vRec."Job Task No.";
                JobTaskDetailHistory_lRec.LastDate := CURRENTDATETIME;
                JobTaskDetailHistory_lRec.Field := 'Notiz';
                JobTaskDetailHistory_lRec."Processing by changed" := true;
                JobTaskDetailHistory_lRec.Change := 'Notiz';
                JobTaskDetailHistory_lRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_lRec.INSERT;
            end;
            if JobSubTaskCreateNote_lPag.TextUpdated then begin
                V_lTxt := JobSubTaskCreateNote_lPag.GetFullText;
                JobTaskDetailSubHistory_lPag.InsertBLOBText_gFnc(JobTaskDetailHistory_lRec, V_lTxt);
            end;
        end;
    end;

    local procedure UpdateDescriptionSolution_lFnc(CurrPageUpdate_iBln: Boolean);
    var
        Position_lTxt: Text;
    begin
        Position_lTxt := GETPOSITION(false);
        CurrPage.Description_Ctl.PAGE.SetRecordInformation_gFnc(DATABASE::"Job Task Detail", Position_lTxt, 0, "Job Task Detail ID", "Job No.", "Job Task No.", "Short Description");
        CurrPage.Solution_Ctl.PAGE.SetRecordInformation_gFnc(DATABASE::"Job Task Detail", Position_lTxt, 1, "Job Task Detail ID", "Job No.", "Job Task No.", "Short Description");
        //CurrPage.Description_Ctl.PAGE.UpdatePage_gFnc;
        if CurrPageUpdate_iBln then begin
            CurrPage.UPDATE(true);
        end;
    end;

    procedure ShowDescriptionSolution_gFnc(JobTaskDetail_iRec: Record "Job Task Detail"; ShowDescription_iBln: Boolean);
    var
        Position_lTxt: Text;
        JobTaskDetailAddTextCard_lPag: Page "Job Task Detail Add. Text Card";
                                           TextNo_lInt: Integer;
    begin
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
    end;

    local procedure AssignEMailsJobTask_lFnc();
    var
        InteractionLogEntry_lRec: Record "Interaction Log Entry";
        interactionLog_lPag: Page "Interaction Log Entries Mail";
    begin
        //-HSG_06
        interactionLog_lPag.SETTABLEVIEW(InteractionLogEntry_lRec);
        if interactionLog_lPag.RUNMODAL <> ACTION::Cancel then begin
            interactionLog_lPag.GetInteractionLogEntries_gFnc(InteractionLogEntry_lRec);
            if InteractionLogEntry_lRec.FINDFIRST then begin
                repeat
                    if InteractionLogEntry_lRec."Job Task Detail ID" <> 0 then
                        if not CONFIRM(ConfirmAlreadyAssigned_gCtx, false, InteractionLogEntry_lRec."Entry No.") then
                            ERROR(Err_Abort_gCtx);
                    InteractionLogEntry_lRec.VALIDATE("Job Task Detail ID", Rec."Job Task Detail ID");
                    InteractionLogEntry_lRec.MODIFY;
                until InteractionLogEntry_lRec.NEXT = 0;
            end;

        end;
        //+HSG_06
    end;
}

