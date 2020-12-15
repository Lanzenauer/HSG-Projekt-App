/// <summary>
/// Page Job Task Description List Part (ID 61016).
/// </summary>
page 61016 "Job Task Description List Part"
{

    CaptionML = ENU = 'Job Task Description List Part', DEU = 'Projektaufgaben Beschreibung';
    PageType = ListPart;
    SourceTable = "Job Task Description";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
