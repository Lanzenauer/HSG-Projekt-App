/// <summary>
/// Page Job Additional Cost (ID 61017).
/// </summary>
page 61017 "Job Additional Cost"
{

    CaptionML = ENU = 'Job Additional Cost', DEU = 'Projekt Zusatzkosten';
    PageType = List;
    SourceTable = "Job Additional Costs";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Job Task No"; Rec."Job Task No")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
