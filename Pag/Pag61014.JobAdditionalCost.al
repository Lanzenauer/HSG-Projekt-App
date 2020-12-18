page 61014 "Job Additional Cost"
{
    // version HSG

    CaptionML = DEU = 'Projekt Zusatzkosten',
                ENU = 'Job Additional Cost';
    PageType = List;
    SourceTable = "Job Additional Costs";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field("Job Task No"; Rec."Job Task No")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
            }
        }
    }

    actions
    {
    }
}

