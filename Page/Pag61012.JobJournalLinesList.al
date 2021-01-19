page 61012 "Job Journal Lines List"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================

    Caption = 'Projekt Buch Blatt Zeilen';
    PageType = List;
    SourceTable = "Job Journal Line";

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
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = true;
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Total Price"; Rec."Total Price")
                {
                }
                field(Chargeable; Rec.Chargeable)
                {
                }
            }
        }
    }

    actions
    {
    }
}

