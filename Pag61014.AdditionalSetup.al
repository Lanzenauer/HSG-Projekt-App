/// <summary>
/// Page Additional Setup (ID 61014).
/// </summary>
page 61014 "Additional Setup"
{

    Caption = 'Additional Setup';
    PageType = Card;
    SourceTable = "HSG Add. Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("E-Mail Log  Def. Sales Person"; Rec."E-Mail Log  Def. Sales Person")
                {
                    ApplicationArea = All;
                }
                field("E-Mail Log Def. Contact"; Rec."E-Mail Log Def. Contact")
                {
                    ApplicationArea = All;
                }
                field("Default E-Mail CC Address"; Rec."Default E-Mail CC Address")
                {
                    ApplicationArea = All;
                }
                field("TEMP File Folder"; Rec."TEMP File Folder")
                {
                    ApplicationArea = All;
                }
                field("Job Details Closed"; Rec."Job Details Closed")
                {
                    ApplicationArea = All;
                }
                field("Job Details Reopen"; Rec."Job Details Reopen")
                {
                    ApplicationArea = All;
                }
                field("Job Details Wait"; Rec."Job Details Wait")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
