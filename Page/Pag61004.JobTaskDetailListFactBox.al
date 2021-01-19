/// <summary>
/// Page Job Task Detail List FactBox (ID 61004).
/// </summary>
page 61004 "Job Task Detail List FactBox"
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

    CaptionML = DEU = 'Projekt Task Fact Box',
                ENU = 'Job Task List FactBox';
    PageType = CardPart;
    SourceTable = "Job Task";

    layout
    {
        area(content)
        {
            field("Job No."; Rec."Job No.")
            {

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(PAGE::"Job Card", Job_gRec);
                end;
            }
            field("Job_gRec.Description"; Job_gRec.Description)
            {
                CaptionML = DEU = 'Projektaufgabe Beschreibung',
                            ENU = 'Job Task Description';
            }
            field("Job_gRec.Status"; Job_gRec.Status)
            {
                CaptionML = DEU = 'Projektaufgabe Status',
                            ENU = 'Job Task Status';
            }
            field("Job_gRec.""Person Responsible"""; Job_gRec."Person Responsible")
            {
                CaptionML = DEU = 'Projekt Verantwortlich',
                            ENU = 'Job Responsible';
                Visible = false;
            }
            field(PersonResponsible_gTxt; PersonResponsible_gTxt)
            {
                CaptionML = DEU = 'Projekt Verantwortlich',
                            ENU = 'Job Responsible';
            }
            field(ProjectManager_gTxt; ProjectManager_gTxt)
            {
                CaptionML = DEU = 'Projektleiter',
                            ENU = 'Project Manager';
            }
            field("Job_gRec.""Starting Date"""; Job_gRec."Starting Date")
            {
                CaptionML = DEU = 'Projektaufgabe Startdatum',
                            ENU = 'Job Task Start Date';
                Visible = false;
            }
            field("Job Task No."; Rec."Job Task No.")
            {

                trigger OnLookup(var Text: Text): Boolean;
                begin
                    PAGE.RUN(50035, Rec);
                end;
            }
            field(Description; Rec.Description)
            {
            }
            field("Schedule (Total Price)"; Rec."Schedule (Total Price)")
            {
            }
            field("Schedule (Total Quantity)"; Rec."Schedule (Total Quantity)")
            {
            }
            field("Usage (Total Price)"; Rec."Usage (Total Price)")
            {
            }
            field("Invoiced Amount (Price)"; Rec."Invoiced Amount (Price)")
            {
                Visible = false;
            }
            field("Planned Con. Job Jrnl. (Price)"; Rec."Planned Con. Job Jrnl. (Price)")
            {
            }
            field(RemAmount_gCtr; Rec."Schedule (Total Price)" - Rec."Invoiced Amount (Price)" - Rec."Planned Con. Job Jrnl. (Price)")
            {
                Caption = 'Restbetrag';
                Style = Unfavorable;
                StyleExpr = ShowAttentionRemainder_gBln;
            }
            field("No Of Description Lines"; Rec."No Of Description Lines")
            {
                LookupPageID = "Job Task Description";
                Visible = false;
            }
            field("No Overcharge"; Rec."No Overcharge")
            {
            }
            field(Status; Rec.Status)
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("Document No."; Rec."Document No.")
            {
                Visible = false;
            }
            field("Person Responsible"; Rec."Person Responsible")
            {
            }
            field("Due Date"; Rec."Due Date")
            {
            }
            field("Invoice Type"; Rec."Invoice Type")
            {
                Visible = false;
            }
            field("Invoice Release"; Rec."Invoice Release")
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    var
        Resource_lRec: Record Resource;
    begin
        ProjectManager_gTxt := '';
        PersonResponsible_gTxt := '';
        CLEAR(Job_gRec);
        if Job_gRec.GET(Rec."Job No.") then begin
            if Job_gRec."Project Manager" > '' then begin
                ProjectManager_gTxt := JobTaskDetailMgnt_gCdu.GetUser_gFnc(Job_gRec."Project Manager");
            end;
            if Resource_lRec.GET(Job_gRec."Person Responsible") then begin
                PersonResponsible_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
            end;
        end;


        ShowAttentionRemainder_gBln := (Rec."Schedule (Total Price)" - Rec."Invoiced Amount (Price)" - Rec."Planned Con. Job Jrnl. (Price)") < 0;
    end;

    var
        Job_gRec: Record Job;
        ShowAttentionRemainder_gBln: Boolean;
        ProjectManager_gTxt: Text;
        JobTaskDetailMgnt_gCdu: Codeunit "Job Task Detail Mgnt.";
        PersonResponsible_gTxt: Text;
}

