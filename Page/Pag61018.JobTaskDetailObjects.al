/// <summary>
/// Page Job Task Detail Objects (ID 61003).
/// </summary>
page 61018 "Job Task Detail Objects"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 190917  HSG_01  FC  Created

    CaptionML = DEU = 'Unteraufgabe Objekte',
                ENU = 'Job Task Detail Objects';
    PageType = List;
    SourceTable = "Job Task Detail Object";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task Detail ID"; "Job Task Detail ID")
                {
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    Visible = false;
                }
                field("Object Type"; "Object Type")
                {
                }
                field("Object ID"; "Object ID")
                {
                }
                field("Object Name"; "Object Name")
                {
                }
                field("Object Modified"; "Object Modified")
                {
                }
                field("Version List"; "Version List")
                {
                }
                field("Object Date"; "Object Date")
                {
                }
                field("Object Time"; "Object Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

