/// <summary>
/// Page Job Task Detail History (ID 61019).
/// </summary>
page 61020 "Job Task Detail History"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 240216  HSG_00  SL  Created Job Task Detail History Page

    CaptionML = DEU = 'Projektjob Historie',
                ENU = 'Job Task Detail History';
    Editable = false;
    PageType = List;
    SourceTable = "Job Task Detail History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task Detail ID"; "Job Task Detail ID")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Job Task No."; "Job Task No.")
                {
                    Visible = false;
                }
                field(LastDate; LastDate)
                {
                }
                field(User; User)
                {
                }
                field("Field"; Field)
                {
                }
                field(Change; Change)
                {
                }
                field("Short Note"; "Short Note")
                {
                }
                field("User Note Date"; "User Note Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

