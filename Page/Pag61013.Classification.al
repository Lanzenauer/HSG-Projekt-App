page 61013 "Classification"
{
    // version HSG

    PageType = List;
    SourceTable = Classification;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Beschreibung; Rec.Beschreibung)
                {
                }
            }
        }
    }

    actions
    {
    }
}

