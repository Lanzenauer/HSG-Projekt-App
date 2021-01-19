page 61015 "Job Task Description List Part"
{
    // version HSG

    CaptionML = DEU = 'Projektaufgaben Beschreibung',
                ENU = 'Job Task Description List Part';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Job Task Description";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

