/// <summary>
/// Page Job Task Detail List (ID 610025).
/// </summary>
page 61025 "Job Task Detail List"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 240216  HSG_00  SL  Created Job Task Detail Page
    // 290818  HSG_01  CH  Show field "No Of E-Mails"
    // 070918  HSG_02  NM  delete some factbox which are not need
    // 180918  JOB_01  NM  change on action create job journal line
    // 231018  JOB_02  NM  add external document no.
    // 221118  JOB_03  CH  Additional Fact Box Interaction Log Entries P 50012
    // 051218  JOB_04  CH  Show new field "No Of E-Mails not Read"

    CaptionML = DEU = 'Projektunteraufgabe Liste',
                ENU = 'Job Task Detail List';
    CardPageID = "Job Task Detail Card";
    DataCaptionExpression = FORMAT(Rec."Job Task Detail ID") + ' - ' + Rec."Job Task Description" + ' - ' + Rec."Short Description";
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Job Task Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task Detail ID"; Rec."Job Task Detail ID")
                {
                    Editable = false;
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Job Task Description"; Rec."Job Task Description")
                {
                }
                field("Processing by Name"; Rec."Processing by Name")
                {
                }
                field("Short Description"; Rec."Short Description")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("No Of E-Mails"; Rec."No Of E-Mails")
                {
                    DrillDownPageID = "Interaction Log Entries Mail";
                }
                field("No Of E-Mails not Read"; Rec."No Of E-Mails not Read")
                {
                    DrillDownPageID = "Interaction Log Entries Mail";
                }
                field(Status; Rec.Status)
                {
                }
                field("Planned Date"; Rec."Planned Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                    Importance = Promoted;
                }
                field("Fixed Date"; Rec."Fixed Date")
                {
                    Visible = false;
                }
                field("Waiting on Customer"; Rec."Waiting on Customer")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field(Effect; Rec.Effect)
                {
                    Visible = false;
                }
                field(Reproducible; Rec.Reproducible)
                {
                    Visible = false;
                }
                field(Category; Rec.Category)
                {
                }
                field(Visibility; Rec.Visibility)
                {
                    Visible = false;
                }
                field("Message Date"; Rec."Message Date")
                {
                    Visible = false;

                    trigger OnControlAddIn(Index: Integer; Data: Text);
                    begin
                        Rec."Message Date" := TODAY;
                        Rec.MODIFY;
                    end;
                }
                field("Last update"; Rec."Last update")
                {
                    Visible = false;
                }
                field("Estimated Quantity_Ctl"; Rec."Estimated Quantity")
                {
                    Importance = Promoted;
                }
                field("Quote Quantity"; Rec."Quote Quantity")
                {
                    Visible = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Visible = false;
                }
                field("Project Manager"; Rec."Project Manager")
                {
                }
                field("Job Person Responsible"; Rec."Job Person Responsible")
                {
                }
                field("Contact No."; Rec."Contact No.")
                {
                    Visible = false;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                }
                field(Arranger; Rec.Arranger)
                {
                }
                field("Job Task Status"; Rec."Job Task Status")
                {
                    Visible = false;
                }
                field("Job Task External Document No."; Rec."Job Task External Document No.")
                {
                    Visible = false;
                }
                field("Job Task Document No."; Rec."Job Task Document No.")
                {
                    Visible = false;
                }
                field("Job Task Person Responsible"; Rec."Job Task Person Responsible")
                {
                    Visible = false;
                }
                field("Job Task Due Date"; Rec."Job Task Due Date")
                {
                    Visible = false;
                }
            }
            group(Control1000000024)
            {
                part(Control1000000048; "Job Task Detail Sub History")
                {
                    SubPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID");
                    SubPageView = SORTING("Job Task Detail ID", LastDate)
                                  ORDER(Descending);
                }
            }
        }
        area(factboxes)
        {
            CaptionML = DEU='Factbox',
                        ENU='Factbox';
            part(Control1000000028; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Job No.");
                Visible = false;
            }
            part(Control1000000027; "Job Task Detail History FactBox")
            {
                SubPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID");
                Visible = false;
            }
            part(Control1000000036; "Job Task Description List Part")
            {
                SubPageLink = "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
                Visible = true;
            }
            part(Control1000000056; "Interact. Log. Entry Listpart")
            {
                SubPageLink = "Job Task Detail ID" = FIELD("Job Task Detail ID");
            }
            systempart(Control1000000038; MyNotes)
            {
                Visible = false;
            }
            systempart(Control1000000026; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                CaptionML = DEU = 'Notizen',
                            ENU = 'Notes';
                Visible = true;
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
                    JobTaskDetailCard_lPag: Page "Job Task Detail Card";
                begin
                    // -HSG_01
                    JobDetMgt_gCdu.CreateProjectTask_gFnc(Rec);
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
                    JobTaskDetailCard_lPag: Page "Job Task Detail Card";
                begin
                    // -HSG_02
                    JobDetMgt_gCdu.CreateJobJournalLine_gFnc(Rec);
                end;
            }
            action("The Job Task Description")
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
                var
                    JobTaskDetailCard_lPag: Page "Job Task Detail Card";
                begin
                    JobTaskDetailCard_lPag.CreateNote_gFnc(Rec);
                end;
            }
        }
        area(processing)
        {
            action(FilterMenu_Ctl)
            {
                Caption = 'Filter Menü';
                Image = FiledOverview;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    SetFilterDlg_lFnc;
                end;
            }
            action(Closed_Ctl)
            {
                Caption = 'Abgeschlossene';
                Image = "Filter";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";

                trigger OnAction();
                begin
                    //SETRANGE(Status,Status::"7");
                    //SETRANGE("Status Extended Calc.","Status Extended Calc."::Active);
                    //SETRANGE("Status Extended Calc.","Status Extended Calc."::Active,"Status Extended Calc."::Closed);
                    Rec.SETRANGE(Status, HSGAddSetup_gRec."Job Details Closed");
                end;
            }
            action(Search_Ctl)
            {
                CaptionML = DEU = 'Suche',
                            ENU = 'Search';
                Image = Find;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "Job Task Detail Search";
            }
            action(Chart_Ctl)
            {
                CaptionML = DEU = 'Statistik',
                            ENU = 'Chart';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JobSubTaskChart_lPag: Page "Job Task Detail Chart";
                begin
                    JobSubTaskChart_lPag.SetFilter_gFnc(Rec);
                    JobSubTaskChart_lPag.RUN;
                end;
            }
            action(History)
            {
                CaptionML = DEU = 'Projektjob Historie',
                            ENU = 'Job Task Detail History';
                Image = History;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
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
                var
                    JobTaskDetailCard_lPag: Page "Job Task Detail Card";
                begin
                    JobTaskDetailCard_lPag.ShowDescriptionSolution_gFnc(Rec, true);
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
                var
                    JobTaskDetailCard_lPag: Page "Job Task Detail Card";
                begin
                    JobTaskDetailCard_lPag.ShowDescriptionSolution_gFnc(Rec, false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //CALCFIELDS("Resource Name");
    end;

    trigger OnInit();
    begin
        /*
        IF FIND ('+') THEN BEGIN
          "Job Task Detail ID" := "Job Task Detail ID" + 1;
          END
          ELSE BEGIN
          "Job Task Detail ID" := 1;
          END;
        */
        HSGAddSetup_gRec.GET();

    end;

    trigger OnOpenPage();
    begin
        //IF GETFILTERS = '' THEN BEGIN
        //SETRANGE(Status,0,Status::"6");
        //SETRANGE("Status Extended Calc.","Status Extended Calc."::Active);
        //END;
    end;

    var
        JobDetMgt_gCdu: Codeunit "Job Task Detail Mgnt.";
        HSGAddSetup_gRec: Record "HSG Add. Setup";

    local procedure SetFilterDlg_lFnc();
    var
        Options_lTxt: Text;
        Option_lInt: Integer;
        User_lTxt: Text;
        Date_lDat: Date;
        UserSetup_lRec: Record "User Setup";
    begin
        //User_lTxt:= GetUser_gFnc('');
        UserSetup_lRec.GET(USERID);
        User_lTxt := UserSetup_lRec."Resource No.";
        Options_lTxt := 'Zuständig,Zuständig bis heute,Zuständig bis diese Woche,Zuständig und abgelaufen,';
        //Options_lTxt+= 'Projektmanager,Von mir erstellt,Warte auf Kunde';
        Options_lTxt += 'Projektmanager,Von mir erstellt,Warte auf Kunde,Meine Aktivitäten diese Woche';
        Option_lInt := STRMENU(Options_lTxt);

        Rec.SETRANGE("Waiting on Customer");
        Rec.MARKEDONLY(false);
        Rec.CLEARMARKS;

        if Option_lInt = 0 then
            exit;
        case Option_lInt of
            1:
                begin    //Aktuell zuständig
                    Rec.SETRANGE("Fixed Date");
                    Rec.SETRANGE("Due Date");
                    Rec.SETRANGE("Planned Date");
                    Rec.SETRANGE(Arranger);
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE("Processing by", User_lTxt);
                end;
            2:
                begin// ktuell zuständig bis heute
                    Rec.SETFILTER("Due Date", '%1|..%2', 0D, TODAY);
                    Rec.SETFILTER("Planned Date", '%1|..%2', 0D, TODAY);
                    Rec.SETRANGE(Arranger);
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE("Processing by", User_lTxt);
                end;
            3:
                begin//Aktuell zuständig bis diese Woche
                    Date_lDat := CALCDATE('+1W', TODAY);
                    Rec.SETFILTER("Due Date", '%1|..%2', 0D, Date_lDat);
                    Rec.SETFILTER("Planned Date", '%1|..%2', 0D, Date_lDat);
                    Rec.SETRANGE(Arranger);
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE("Processing by", User_lTxt);
                end;
            4:
                begin// Aktuell zuständig und abgelaufen
                    Date_lDat := CALCDATE('-1T', TODAY);
                    Rec.SETFILTER("Due Date", '%1|..%2', 0D, Date_lDat);
                    Rec.SETFILTER("Planned Date", '%1|..%2', 0D, Date_lDat);
                    Rec.SETRANGE(Arranger);
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE("Processing by", User_lTxt);
                end;
            5:
                begin// Projektmanager
                    Rec.SETRANGE("Due Date");
                    Rec.SETRANGE("Planned Date");
                    Rec.SETRANGE("Processing by");
                    Rec.SETRANGE(Arranger);
                    //SETRANGE("Project Manager",User_lTxt);
                    Rec.SETFILTER("Project Manager", '*' + Rec.GetUser_gFnc(''));
                end;
            6:
                begin//Von mir erstellt
                    Rec.SETRANGE("Due Date");
                    Rec.SETRANGE("Planned Date");
                    Rec.SETRANGE("Processing by");
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE(Arranger, Rec.GetUser_gFnc(''));
                end;
            7:
                begin//Warte auf Kunde
                    Rec.SETRANGE("Due Date");
                    Rec.SETRANGE("Planned Date");
                    Rec.SETRANGE("Processing by");
                    Rec.SETRANGE("Project Manager");
                    Rec.SETRANGE(Arranger, Rec.GetUser_gFnc(''));
                    Rec.SETRANGE("Waiting on Customer", true);
                end;
            8:
                begin// not defined
                    SetFilterMyActivities_lFnc();
                end;
            9:
                begin// not defined

                end;

        end;
    end;

    local procedure SetFilterMyActivities_lFnc();
    var
        Options_lTxt: Text;
        Option_lInt: Integer;
        User_lTxt: Text;
        Date_lDat: Date;
        UserSetup_lRec: Record "User Setup";
        JobTaskDetailTmp_lRec: Record "Job Task Detail" temporary;
        JobTaskDetailHistory_lRec: Record "Job Task Detail History";
        JobJournalLine_lRec: Record "Job Journal Line";
        Date1_lDat: Date;
        Date2_lDat: Date;
        Date1_lDtm: DateTime;
        Date2_lDtm: DateTime;
        BatchName_lCod: Code[20];
        Resource_lRec: Record Resource;
    begin
        //User_lTxt:= GetUser_gFnc('');
        UserSetup_lRec.GET(USERID);
        User_lTxt := UserSetup_lRec."Resource No.";
        Resource_lRec.GET(UserSetup_lRec."Resource No.");
        BatchName_lCod := UserSetup_lRec."Resource No.";

        Date2_lDat := TODAY;
        Date1_lDat := CALCDATE('<-1W>', Date2_lDat);
        Date1_lDtm := CREATEDATETIME(Date1_lDat, 000000T);
        //Date2_lDtm:= CREATEDATETIME(Date2_lDat,0T);
        Date2_lDtm := CURRENTDATETIME;

        Rec.SETRANGE("Waiting on Customer");
        Rec.SETRANGE("Fixed Date");
        Rec.SETRANGE("Planned Date");
        Rec.SETRANGE(Arranger);
        Rec.SETRANGE("Project Manager");
        Rec.SETRANGE("Processing by");
        Rec.MARKEDONLY(false);
        Rec.CLEARMARKS;

        /*
        JobJournalLine_lRec.RESET;
        JobJournalLine_lRec.SETRANGE("Journal Template Name", 'PROJEKT');
        JobJournalLine_lRec.SETRANGE("Journal Batch Name", BatchName_lCod);
        JobJournalLine_lRec.SETRANGE(Type, JobJournalLine_lRec.Type::Resource);
        JobJournalLine_lRec.SETRANGE("No.", Resource_lRec."No.");
        JobJournalLine_lRec.SETRANGE("Posting Date",Date_lDat);
        IF JobJournalLine_lRec.FINDset THEN REPEAT
        UNTIL JobJournalLine_lRec.NEXT = 0;
        */

        JobTaskDetailHistory_lRec.SETRANGE(User, Rec.GetUser_gFnc(''));
        JobTaskDetailHistory_lRec.SETRANGE(LastDate, Date1_lDtm, Date2_lDtm);
        if JobTaskDetailHistory_lRec.FINDSET then
            repeat
                JobTaskDetailTmp_lRec."Job Task Detail ID" := JobTaskDetailHistory_lRec."Job Task Detail ID";
                JobTaskDetailTmp_lRec."Job No." := JobTaskDetailHistory_lRec."Job No.";
                JobTaskDetailTmp_lRec."Job Task No." := JobTaskDetailHistory_lRec."Job Task No.";
                if JobTaskDetailTmp_lRec.INSERT then;
            until JobTaskDetailHistory_lRec.NEXT = 0;
        if JobTaskDetailTmp_lRec.FINDSET then
            repeat
                if Rec.GET(JobTaskDetailTmp_lRec."Job Task Detail ID") then begin
                    Rec.MARK(true);
                end;
            until JobTaskDetailTmp_lRec.NEXT = 0;

        Rec.MARKEDONLY(true);

    end;
}

