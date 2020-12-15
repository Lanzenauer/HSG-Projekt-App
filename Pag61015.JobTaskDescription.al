/// <summary>
/// Page Job Task Description (ID 61015).
/// </summary>
page 61015 "Job Task Description"
{

    CaptionML = ENU = 'Job Task Description', DEU = 'Projektaufgabe Beschreibung';
    PageType = List;
    SourceTable = "Job Task Description";
    SourceTableView = SORTING("Job No.", "Job Task No.", "Line No.") ORDER(Ascending);
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Internal; Rec.Internal)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
