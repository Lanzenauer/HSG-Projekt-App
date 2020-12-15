/// <summary>
/// Page "Classification" (ID 61018).
/// </summary>
page 61018 Classification
{

    Caption = 'Classification';
    PageType = List;
    SourceTable = Classification;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
