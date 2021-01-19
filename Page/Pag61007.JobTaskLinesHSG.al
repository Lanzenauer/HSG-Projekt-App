page 61007 "Job Task Lines HSG"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 130115  HSG_01  CH  Created
    // 150115  HSG_02  JS  Page Action for Job Task Descriptions
    // 220115  HSG_03  CH  Show new fields "External Document No."+"Document No."
    // 220615  HSG_04  CH  Show New field #50009
    // 250615  HSG_05  CH  Show new field "Schedule (Total Quantity)"
    // 040117  HSG_06  CH  Show new fields "Invoice Type" and "Invoice Release"
    // 230819  HSG_07  CH  Show new field #50015 Invoice Up To %

    CaptionML = DEU = 'Projektaufgabenzeilen Status',
                ENU = 'Job Task Lines';
    CardPageID = "Job Task Card";
    DataCaptionFields = "Job No.";
    PageType = List;
    SourceTable = "Job Task";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    Visible = false;
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
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                }
                field("Invoice Release"; Rec."Invoice Release")
                {
                }
                field("Invoice Up To %"; Rec."Invoice Up To %")
                {
                }
                field(Support; Rec.Support)
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000027; "Job Task Description List Part")
            {
                SubPageLink = "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
                Visible = true;
            }
            systempart(Control1000000032; Links)
            {
                Visible = true;
            }
            systempart(Control1000000031; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Pro&jektaufgabe")
            {
                Caption = 'Pro&jektaufgabe';
                action(Projektaufgabenposten)
                {
                    Caption = 'Projektaufgabenposten';
                    Image = TaskList;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date")
                                  ORDER(Ascending);
                }
                action("Projektaufgaben-Planzeilen")
                {
                    Caption = 'Projektaufgaben-Planzeilen';
                    Image = TaskList;
                    RunObject = Page "Job Planning Lines";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Line No.")
                                  ORDER(Ascending);
                }
                action(Projektaufgabenstatistik)
                {
                    Caption = 'Projektaufgabenstatistik';
                    Image = TaskList;
                    RunObject = Page "Job Task Statistics";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    RunPageView = SORTING("Job No.", "Job Task No.")
                                  ORDER(Ascending);
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
            }
        }
        area(reporting)
        {
            action("Druck Projektangebot/Projekt AB")
            {
                Caption = 'Druck Projektangebot/Projekt AB';
                Image = PrintVoucher;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    PrintJOBOrderQuote_lRep: Report "HSG Job - Quote_Order";
                    Job_lRec: Record Job;
                begin
                    // HSG_02
                    CLEAR(Job_lRec);
                    Job_lRec.SETRANGE("No.", Rec."Job No.");

                    CLEAR(PrintJOBOrderQuote_lRep);
                    PrintJOBOrderQuote_lRep.SETTABLEVIEW(Job_lRec);
                    PrintJOBOrderQuote_lRep.RUNMODAL;
                end;
            }
        }
        area(processing)
        {
            action("Projektplanzeile anlegen")
            {
                Caption = 'Projektplanzeile anlegen';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JobPlanLines_lPag: Page "Job Planning Lines";
                    JobPlanLine_lRec: Record "Job Planning Line";
                    JobsSetup_lRec: Record "Jobs Setup";
                begin
                    // -HSG_03
                    CLEAR(JobPlanLine_lRec);
                    JobPlanLine_lRec.SETRANGE("Job No.", Rec."Job No.");
                    JobPlanLine_lRec.SETRANGE("Job Task No.", Rec."Job Task No.");
                    if JobPlanLine_lRec.ISEMPTY then begin
                        JobsSetup_lRec.GET;
                        JobsSetup_lRec.TESTFIELD("Standard Resource");

                        CLEAR(JobPlanLine_lRec);
                        JobPlanLine_lRec.VALIDATE("Job No.", Rec."Job No.");
                        JobPlanLine_lRec.VALIDATE("Job Task No.", Rec."Job Task No.");
                        JobPlanLine_lRec."Line No." := 10000;
                        JobPlanLine_lRec.VALIDATE(Type, JobPlanLine_lRec.Type::Resource);
                        JobPlanLine_lRec.VALIDATE("No.", JobsSetup_lRec."Standard Resource");
                        JobPlanLine_lRec.INSERT(true);
                        COMMIT;

                        CLEAR(JobPlanLine_lRec);
                        JobPlanLine_lRec.SETRANGE("Job No.", Rec."Job No.");
                        JobPlanLine_lRec.SETRANGE("Job Task No.", Rec."Job Task No.");
                    end;

                    CLEAR(JobPlanLines_lPag);
                    JobPlanLines_lPag.SETTABLEVIEW(JobPlanLine_lRec);
                    JobPlanLines_lPag.EDITABLE(true);
                    JobPlanLines_lPag.RUNMODAL;
                    // +HSG_03
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin

        ShowAttentionRemainder_gBln := (Rec."Schedule (Total Price)" - Rec."Invoiced Amount (Price)" - Rec."Planned Con. Job Jrnl. (Price)") < 0;
    end;

    var
        Job: Record Job;
        ShowAttentionRemainder_gBln: Boolean;
}

