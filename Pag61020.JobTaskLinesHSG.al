page 61020 "Job Task Lines HSG"
{

    CaptionML = ENU = 'Job Task Lines HSG', DEU = 'Projektaufgabenzeilen Status;';
    PageType = List;
    SourceTable = "Job Task";
    CardPageId = "Job Task Card";
    DataCaptionFields = "Job No.";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = All;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = All;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Schedule (Total Price)"; Rec."Schedule (Total Price)")
                {
                    ApplicationArea = All;
                }
                field("Schedule (Total Quantity)"; Rec."Schedule (Total Quantity)")
                {
                    ApplicationArea = All;
                }
                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Amount (Price)"; Rec."Invoiced Amount (Price)")
                {
                    ApplicationArea = All;
                }
                field("Planned Con. Job Jrnl. (Price)"; Rec."Planned Con. Job Jrnl. (Price)")
                {
                    ApplicationArea = All;
                }
                field(RemAmount_gCtr; Rec."Schedule (Total Price)" - "Invoiced Amount (Price)" - "Planned Con. Job Jrnl. (Price)")
                {
                    CaptionML = DEU = 'Restbetrag';
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = ShowAttentionRemainder_gBln;
                }
                field("No Of Description Lines"; Rec."No Of Description Lines")
                {
                    ApplicationArea = All;
                }
                field("No Overcharge"; Rec."No Overcharge")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = All;
                }
                field("Invoice Release"; Rec."Invoice Release")
                {
                    ApplicationArea = All;
                }
                field("Invoice Up To %"; Rec."Invoice Up To %")
                {
                    ApplicationArea = All;
                }
                field(Support; Rec.Support)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        ShowAttentionRemainder_gBln := (Rec."Schedule (Total Price)" - "Invoiced Amount (Price)" - "Planned Con. Job Jrnl. (Price)") < 0;
    end;

    var
        ShowAttentionRemainder_gBln: Boolean;
        Job: Record Job;
}
