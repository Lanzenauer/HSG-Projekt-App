/// <summary>
/// Table Job Task Detail (ID 61049).
/// </summary>
table 61049 "Job Task Detail"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 240216  JOB_00  SL  Created Job Task Detail Table
    // 230816  JOB_01  SL  Additional code in nsert trigger
    // 060917  HSG_02  FC  Renamed to "Job Task Detail"
    // 290818  JOB_02  CH  New flow field #200
    // 030918  JOB_03  NM  field "Job Task Description" 50 -> 100
    // 070918  HSG_03  NM  some changes
    // 190918  JOB_04  NM  create notification by changing proccessing by
    // 231018  JOB_05  NM  create only notification if processing by <> Ressource ID of the actual user
    // 291018  JOB_06  NM  Error Handling
    // 051218  JOB_07  CH  New field #201

    CaptionML = DEU = 'Projektunteraufgabe',
                ENU = 'Job Task Detail';
    DrillDownPageID = "Job Task Detail List";
    LookupPageID = "Job Task Detail List";

    fields
    {
        field(1; "Job Task Detail ID"; Integer)
        {
            CaptionML = DEU = 'Projektunteraufgabe ID',
                        ENU = 'Job Task Detail ID';
        }
        field(2; "Job No."; Code[20])
        {
            CaptionML = DEU = 'Projekt Nr.',
                        ENU = 'Job No.';
            TableRelation = Job."No.";

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                JobTaskDetailHistory_gRec.Change := 'Projektnummer: ' + "Job No.";
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,'Projektnummer', "Job No.",FALSE);
            end;
        }
        field(3; "Job Task No."; Code[20])
        {
            CaptionML = DEU = 'Projektaufgabe Nr. ',
                        ENU = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate();
            begin
                if "Job Task No." <> '' then begin
                    JobTask_gRec.GET("Job No.", "Job Task No.");
                    "Job Task Description" := JobTask_gRec.Description; //Lilly

                end;
                //test JobTaskDetailHistoryInsert_gFnc(Rec,'Projektaufgabennr.',"Job Task No.",FALSE);
            end;
        }
        field(4; Arranger; Code[50])
        {
            CaptionML = DEU = 'Reporter',
                        ENU = 'Arranger';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5; "Processing by"; Code[50])
        {
            CaptionML = DEU = 'Bearbeitung durch',
                        ENU = 'Processing by';
            TableRelation = Resource."No." WHERE("Show in Statistics" = CONST(true));

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                if Resource_gRec.GET("Processing by") then;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME("Processing by");
                JobTaskDetailHistory_gRec.Change := Resource_gRec.Name;
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                if not Resource_gRec.GET("Processing by") then begin
                    CLEAR(Resource_gRec);
                end;
                //test JobTaskDetailHistoryInsert_gFnc(Rec,'Bearbeitung durch',Resource_gRec.Name,TRUE);
                CALCFIELDS("Processing by Name");

                //-JOB_04
                if (xRec."Processing by" <> "Processing by") and (xRec."Processing by" <> '') then begin
                    //-JOB_05
                    if "Processing by" <> JobTaskDetMgnt_gCdu.SetRessourceID_gFnc() then
                        //+JOB_05
                        JobTaskDetMgnt_gCdu.CreateNotification_gFnc(Rec, 1);
                end;
                //+JOB_04
            end;
        }
        field(6; "Contact No."; Code[20])
        {
            CaptionML = DEU = 'Kontaktnr.',
                        ENU = 'Contact';
            TableRelation = Contact."No.";

            trigger OnLookup();
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
                Job_lRec: Record Job;
            begin
                //Cont.GET("Bill-to Contact No.");
                Job_lRec.GET("Job No.");
                ContBusinessRelation.RESET;
                ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                ContBusinessRelation.SETRANGE("No.", Job_lRec."Bill-to Customer No.");
                if ContBusinessRelation.FINDFIRST then begin
                    Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.");
                    if PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK then begin
                        VALIDATE("Contact No.", Cont."No.");

                    end;
                end;
            end;
        }
        field(7; "Short Description"; Text[100])
        {
            CaptionML = DEU = 'Kurzbeschreibung',
                        ENU = 'Short Description';

            trigger OnValidate();
            begin

                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME("Short Description");
                JobTaskDetailHistory_gRec.Change := "Short Description";
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;


                //test JobTaskDetailHistoryInsert_gFnc(Rec,'Kurzbeschr.', "Short Description",FALSE);
                //test ShortDesciptionUpdate_gFnc(Rec);
            end;
        }
        field(8; Status; Code[20])
        {
            Caption = 'Status';
            TableRelation = "Job Task Detail Status".Code;

            trigger OnValidate();
            begin

                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME(Status);
                JobTaskDetailHistory_gRec.Change := FORMAT(Status);
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;


                //JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Status), FORMAT(Status),FALSE);
            end;
        }
        field(9; Effect; Text[100])
        {
            CaptionML = DEU = 'Auswirkung',
                        ENU = 'Effect';
        }
        field(10; Reproducible; Option)
        {
            CaptionML = DEU = 'Reproduzierbar',
                        ENU = 'Reproducible';
            OptionCaptionML = DEU = ' ,Immer,Manchmal,Zufällig',
                              ENU = ' ,Always,Sometimes,ByChance';
            OptionMembers = " ",Always,Sometimes,ByChance;

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME(Reproducible);
                JobTaskDetailHistory_gRec.Change := FORMAT(Reproducible);
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                //+HSG_03
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Reproducible), FORMAT(Reproducible),FALSE);
            end;
        }
        field(11; Solution; Text[100])
        {
            CaptionML = DEU = 'Lösung',
                        ENU = 'Solution';

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                JobTaskDetailHistory_gRec.Change := 'Lösung: ' + Solution;
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Solution), Solution,FALSE);
            end;
        }
        field(12; Category; Code[10])
        {
            CaptionML = DEU = 'Kategorie',
                        ENU = 'Category';
            TableRelation = Classification.Code WHERE(Typ = CONST("Job Task Detail Category"));

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME(Category);
                JobTaskDetailHistory_gRec.Change := Category;
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Category),Category,FALSE);
            end;
        }
        field(13; Visibility; Option)
        {
            CaptionML = DEU = 'Sichtbarkeit',
                        ENU = 'Visibility';
            OptionCaptionML = DEU = 'offen,privat',
                              ENU = 'public,private';
            OptionMembers = public,private;

            trigger OnValidate();
            begin
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Visibility), FORMAT(Visibility),FALSE);
            end;
        }
        field(14; "Message Date"; Date)
        {
            CaptionML = DEU = 'Meldungsdatum ',
                        ENU = 'Message Date';
        }
        field(15; "Last update"; DateTime)
        {
            CaptionML = DEU = 'Zuletzt aktualisiert',
                        ENU = 'Last update';
            Editable = false;
        }
        field(17; "Due Date"; Date)
        {
            CaptionML = DEU = 'Fälligkeitsdatum',
                        ENU = 'Due Date';
        }
        field(18; "Planned Date"; Date)
        {
            CaptionML = DEU = 'Plandatum',
                        ENU = 'Planned Date';

            trigger OnValidate();
            begin
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Planned Date"),FORMAT("Planned Date"),FALSE);
            end;
        }
        field(19; "Fixed Date"; Date)
        {
            CaptionML = DEU = 'Fixtermin',
                        ENU = 'Fixed Termin';

            trigger OnValidate();
            begin
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Fixed Date"),FORMAT("Fixed Date"),FALSE);
            end;
        }
        field(20; "Waiting on Customer"; Boolean)
        {
            CaptionML = DEU = 'Warte auf Kunde',
                        ENU = 'Waiting on customer';

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME("Waiting on Customer");
                JobTaskDetailHistory_gRec.Change := FORMAT("Waiting on Customer");
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Waiting on Customer"), FORMAT("Waiting on Customer"),FALSE);
            end;
        }
        field(21; Priority; Option)
        {
            CaptionML = DEU = 'Priorität',
                        ENU = 'Priority';
            InitValue = Medium;
            OptionCaptionML = DEU = ' ,Niedrig,Mittel,Hoch,Sofort',
                              ENU = ' ,Low,Medium,High,Immediately';
            OptionMembers = " ",Low,Medium,High,Immediately;

            trigger OnValidate();
            begin
                //test
                JobTaskDetailHistory_gRec.INIT;
                JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
                JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
                //-HSG_03
                JobTaskDetailHistory_gRec.Field := Rec.FIELDNAME(Priority);
                JobTaskDetailHistory_gRec.Change := FORMAT(Priority);
                //+HSG_03
                JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
                JobTaskDetailHistory_gRec.INSERT;
                //test
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION(Priority), FORMAT(Priority),FALSE);
            end;
        }
        field(23; "Estimated Quantity"; Decimal)
        {
            CaptionML = DEU = 'geschätze Menge',
                        ENU = 'Estimated Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                // -HSG_02
                "Remaining Quantity" := "Estimated Quantity";
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Estimated Quantity"), FORMAT("Estimated Quantity"),FALSE);
                // +HSG_02
            end;
        }
        field(24; "Quote Quantity"; Decimal)
        {
            CaptionML = DEU = 'Menge Angebot',
                        ENU = 'Quote Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                // -HSG_02
                if "Estimated Quantity" = 0 then
                    VALIDATE("Estimated Quantity", "Quote Quantity");
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Quote Quantity"),FORMAT("Quote Quantity"),FALSE);
                // +HSG_02
            end;
        }
        field(25; "Remaining Quantity"; Decimal)
        {
            CaptionML = DEU = 'Restschätzmenge',
                        ENU = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate();
            begin
                //test JobTaskDetailHistoryInsert_gFnc(Rec,FIELDCAPTION("Remaining Quantity"), FORMAT("Remaining Quantity"),FALSE);
            end;
        }
        field(28; "External Document No."; Code[35])
        {
            CaptionML = DEU = 'Externe Belegnummer',
                        ENU = 'External Document No.';
        }
        field(30; "Contact Name"; Text[50])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Contact No.")));
            CaptionML = DEU = 'Ansprechpartner Name',
                        ENU = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Processing by Name"; Text[50])
        {
            CalcFormula = Lookup(Resource.Name WHERE("No." = FIELD("Processing by")));
            CaptionML = DEU = 'Bearbeitung durch Name',
                        ENU = 'Processing by Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Job Task Description"; Text[100])
        {
            CalcFormula = Lookup("Job Task".Description WHERE("Job No." = FIELD("Job No."),
                                                               "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Projektaufgabe Beschreibung';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Project Manager"; Code[50])
        {
            CalcFormula = Lookup(Job."Project Manager" WHERE("No." = FIELD("Job No.")));
            CaptionML = DEU = 'Projektleiter',
                        ENU = 'Project Manager';
            FieldClass = FlowField;
            TableRelation = "User Setup";
        }
        field(38; "Job Person Responsible"; Code[20])
        {
            CalcFormula = Lookup(Job."Person Responsible" WHERE("No." = FIELD("Job No.")));
            CaptionML = DEU = 'Projekt Verantwortlich',
                        ENU = 'Job Person Responsible';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(40; "Job Task Status"; Option)
        {
            CalcFormula = Lookup("Job Task".Status WHERE("Job No." = FIELD("Job No."),
                                                          "Job Task No." = FIELD("Job Task No.")));
            CaptionML = DEU = 'Projektaufgabe Status',
                        ENU = 'Job Task Status';
            Editable = false;
            FieldClass = FlowField;
            OptionCaptionML = DEU = 'Angebot,Auftrag,,,Beendet',
                              ENU = 'Quote,Order,,,Finished';
            OptionMembers = Quote,"Order",,,Finished;
        }
        field(41; "Job Task External Document No."; Code[20])
        {
            CalcFormula = Lookup("Job Task"."External Document No." WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No.")));
            CaptionML = DEU = 'Projektaufgabe Externe Belegnr.',
                        ENU = 'Job Task External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Job Task Document No."; Code[20])
        {
            CalcFormula = Lookup("Job Task"."Document No." WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No.")));
            CaptionML = DEU = 'Projektaufgabe Belegnr.',
                        ENU = 'Job Task Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Job Task Person Responsible"; Code[20])
        {
            CalcFormula = Lookup("Job Task"."Person Responsible" WHERE("Job No." = FIELD("Job No."),
                                                                        "Job Task No." = FIELD("Job Task No.")));
            CaptionML = DEU = 'Projektaufgabe Verantwortlich',
                        ENU = 'Job Task Person Responsible';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(44; "Job Task Due Date"; Date)
        {
            CalcFormula = Lookup("Job Task"."Due Date" WHERE("Job No." = FIELD("Job No."),
                                                              "Job Task No." = FIELD("Job Task No.")));
            CaptionML = DEU = 'Projektaufgabe Fälligkeitsdatum',
                        ENU = 'Job Task Due Date';
            FieldClass = FlowField;
        }
        field(51; "Status Extended Calc."; Option)
        {
            CalcFormula = Lookup("Job Task Detail Status"."Status Extended" WHERE(Code = FIELD(Status)));
            Editable = false;
            FieldClass = FlowField;
            OptionCaptionML = DEU = 'Aktiv,Warte,Geschlossen,Gelöscht',
                              ENU = 'Active,Wait,Closed,Deleted';
            OptionMembers = Active,Wait,Closed,Deleted;
        }
        field(52; Indent; Integer)
        {
        }
        field(200; "No Of E-Mails"; Integer)
        {
            CalcFormula = Count("Interaction Log Entry" WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Anzahl E-Mails',
                        ENU = 'No Of E-Mails';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "No Of E-Mails not Read"; Integer)
        {
            CalcFormula = Count("Interaction Log Entry" WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID"),
                                                               "E-Mail Read" = CONST(false)));
            CaptionML = DEU = 'Anzahl Ungelesene E-Mails',
                        ENU = 'No Of E-Mails not Read';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Job Task Detail ID")
        {
            SumIndexFields = "Estimated Quantity";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job Task Detail ID", "Short Description")
        {
        }
    }

    trigger OnDelete();
    var
        JobTaskDetailHistory_lRec: Record "Job Task Detail History";
        JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
        JobTaskDetailObject_lRec: Record "Job Task Detail Object";
    begin
        JobTaskDetailHistory_lRec.SETRANGE("Job Task Detail ID", "Job Task Detail ID");
        JobTaskDetailHistory_lRec.DELETEALL;
        JobTaskDetailBlob_lRec.SETRANGE("Job Task Detail ID", "Job Task Detail ID");
        JobTaskDetailBlob_lRec.DELETEALL;
        JobTaskDetailObject_lRec.SETRANGE("Job Task Detail ID", "Job Task Detail ID");
        JobTaskDetailObject_lRec.DELETEALL;
    end;

    trigger OnInsert();
    var
        JobTaskDetailStatus_lRec: Record "Job Task Detail Status";
    begin
        // -JOB_01
        if Rec_gRec.FINDLAST then
            "Job Task Detail ID" := Rec_gRec."Job Task Detail ID" + 1
        else
            "Job Task Detail ID" := 1;
        // +JOB_01
        // -JOB_02
        "Message Date" := WORKDATE;
        //Arranger := USERID;
        Arranger := GetUser_gFnc('');
        // +JOB 02

        JobTaskDetailHistory_gRec.INIT;
        JobTaskDetailHistory_gRec."Job Task Detail ID" := "Job Task Detail ID";
        JobTaskDetailHistory_gRec.LastDate := CURRENTDATETIME;
        JobTaskDetailHistory_gRec.Change := 'hinzugefügt';
        JobTaskDetailHistory_gRec.User := GetUser_gFnc('');
        //-Job_06
        if not JobTaskDetailHistory_gRec.INSERT then
            JobTaskDetailHistory_gRec.MODIFY;
        //+Job_06
        /*
        JobTaskDetailStatus_lRec.SETCURRENTKEY(Sorting);
        JobTaskDetailStatus_lRec.SETRANGE(Blocked,FALSE);
        JobTaskDetailStatus_lRec.FINDFIRST;
        Status:= JobTaskDetailStatus_lRec.Code;
        */
        //JobTaskDetailHistoryInsert_gFnc(Rec,'INSERT','hinzugefügt',FALSE); //Lilly

    end;

    trigger OnModify();
    begin
        "Last update" := CURRENTDATETIME;
    end;

    var
        "--HSG--": Boolean;
        Rec_gRec: Record "Job Task Detail";
        Resource_gRec: Record Resource;
        JobTask_gRec: Record "Job Task";
        JobTaskDetailHistory_gRec: Record "Job Task Detail History";
        JobTaskDetMgnt_gCdu: Codeunit "Job Task Detail Mgnt.";

    /// <summary>
    /// GetUser_gFnc.
    /// </summary>
    /// <param name="User_iTxt">Text.</param>
    /// <returns>Return variable Retun_rTxt of type Text.</returns>
    procedure GetUser_gFnc(User_iTxt: Text) Retun_rTxt: Text;
    var
        V_lTxt: Text;
        Pos_lInt: Integer;
    begin
        if User_iTxt = '' then begin
            V_lTxt := USERID;
        end;
        Pos_lInt := STRPOS(USERID, '\');
        if Pos_lInt > 0 then begin
            exit(COPYSTR(USERID, Pos_lInt + 1, 100));
        end else begin
            exit(USERID);
        end;
    end;

    /// <summary>
    /// JobTaskDetailHistoryInsert_gFnc.
    /// </summary>
    /// <param name="JobTaskDetail_vRec">VAR Record "Job Task Detail".</param>
    /// <param name="Field_iTxt">Text.</param>
    /// <param name="Change_iTxt">Text.</param>
    /// <param name="ProcessingByChanged_iBln">Boolean.</param>
    procedure JobTaskDetailHistoryInsert_gFnc(var JobTaskDetail_vRec: Record "Job Task Detail"; Field_iTxt: Text; Change_iTxt: Text; ProcessingByChanged_iBln: Boolean);
    var
        JobTaskDetailHistory_lRec: Record "Job Task Detail History";
    begin
        JobTaskDetailHistory_lRec.INIT;
        //test
        JobTaskDetailHistory_lRec."Job Task Detail ID" := "Job Task Detail ID";
        JobTaskDetailHistory_lRec."Job Task Detail ID" := JobTaskDetail_vRec."Job Task Detail ID";
        JobTaskDetailHistory_lRec."Job No." := JobTaskDetail_vRec."Job No.";
        JobTaskDetailHistory_lRec."Job Task No." := JobTaskDetail_vRec."Job Task No.";
        JobTaskDetailHistory_lRec.LastDate := CURRENTDATETIME;
        //test
        JobTaskDetailHistory_lRec.Change := 'Projektnummer: ' + "Job No.";
        JobTaskDetailHistory_lRec.Field := Field_iTxt;
        JobTaskDetailHistory_lRec."Processing by changed" := ProcessingByChanged_iBln;
        JobTaskDetailHistory_lRec.Change := Change_iTxt;
        JobTaskDetailHistory_lRec.User := GetUser_gFnc('');

        JobTaskDetailHistory_lRec.INSERT;
    end;

    /// <summary>
    /// ShortDesciptionUpdate_gFnc.
    /// </summary>
    /// <param name="JobTaskDetail_vRec">VAR Record "Job Task Detail".</param>
    procedure ShortDesciptionUpdate_gFnc(var JobTaskDetail_vRec: Record "Job Task Detail");
    var
        JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
    begin
        if not JobTaskDetailBlob_lRec.GET(JobTaskDetail_vRec."Job Task Detail ID") then begin
            JobTaskDetailBlob_lRec.INIT;
            JobTaskDetailBlob_lRec."Job Task Detail ID" := JobTaskDetail_vRec."Job Task Detail ID";
            JobTaskDetailBlob_lRec."Job No." := JobTaskDetail_vRec."Job No.";
            JobTaskDetailBlob_lRec."Job Task No." := JobTaskDetail_vRec."Job Task No.";
            JobTaskDetailBlob_lRec.INSERT;
        end;
        JobTaskDetailBlob_lRec."Import Datetime" := CURRENTDATETIME;
        JobTaskDetailBlob_lRec."Short Description" := JobTaskDetail_vRec."Short Description";
        JobTaskDetailBlob_lRec.MODIFY;
    end;

    /// <summary>
    /// SetStatus_gFnc.
    /// </summary>
    /// <param name="JobDetailDocNo_gCod">Code[10].</param>
    procedure SetStatus_gFnc(JobDetailDocNo_gCod: Code[10]);
    var
        AddSetup_lRec: Record "HSG Add. Setup";
    begin
        AddSetup_lRec.GET();
        VALIDATE(Status, AddSetup_lRec."Job Details Reopen");
        MODIFY(true);
    end;
}

