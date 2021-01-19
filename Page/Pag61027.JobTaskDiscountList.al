page 61027 "Job Task Discount List"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 300415  HSG_00  CH  Created

    CaptionML = DEU = 'Projekt Aufgabe Rabatt',
                ENU = 'Job Task Discount';
    PageType = List;
    SourceTable = "Job Task Discount";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                }
                field(Quantity; Rec.Quantity)
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

