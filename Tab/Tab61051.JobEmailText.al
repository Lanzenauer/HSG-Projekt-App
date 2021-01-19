/// <summary>
/// Table Job Email Text (ID 61051).
/// </summary>
table 61051 "Job Email Text"
{
    // version CSS

    // HSG Hanse Solution GmbH
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 210918  JOB_01  NM  Created


    fields
    {
        field(1; "Code"; Option)
        {
            CaptionML = DEU = 'Code',
                        ENU = 'Code';
            OptionCaptionML = DEU = 'neue Aufgabe,neue E-Mail',
                              ENU = 'new Job,new Mail';
            OptionMembers = "new Job","new Mail";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Text; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        // -JOB_01
        if FINDLAST then
            "Line No." := "Line No." + 10000
        else
            "Line No." := 10000;
        // +JOB_01
    end;
}

