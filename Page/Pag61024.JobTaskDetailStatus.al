/// <summary>
/// Page Job Task Detail Status (ID 61024).
/// </summary>
page 61024 "Job Task Detail Status"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 280917  HSG_01  FC  Created

    PageType = List;
    SourceTable = "Job Task Detail Status";
    SourceTableView = SORTING(Sorting);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                    Visible = false;
                }
                field(Sorting; Rec.Sorting)
                {
                    Visible = false;
                }
                field("Status Option"; Rec."Status Option")
                {
                    Visible = false;
                }
                field("Status Extended"; Rec."Status Extended")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

