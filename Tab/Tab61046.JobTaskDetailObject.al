table 61046 "Job Task Detail Object"
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

    CaptionML = DEU = 'Unteraufgabe Objekt',
                ENU = 'Job Task Detail Object';

    fields
    {
        field(1; "Job Task Detail ID"; Integer)
        {
            CaptionML = DEU = 'Projektunteraufgabe ID',
                        ENU = 'Job Sub Task ID';
        }
        field(2; "Job No."; Code[20])
        {
            CalcFormula = Lookup("Job Task Detail"."Job No." WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Projek Nr.',
                        ENU = 'Job No.';
            FieldClass = FlowField;
        }
        field(3; "Job Task No."; Code[20])
        {
            CalcFormula = Lookup("Job Task Detail"."Job Task No." WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Projektaufgabe Nr. ',
                        ENU = 'Job Task No.';
            FieldClass = FlowField;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnLookup();
            var
                JobTask_lRec: Record "Job Task";
            begin
            end;
        }
        field(10; "Object Type"; Text[30])
        {

            trigger OnValidate();
            begin
                if EVALUATE("Object Type calc.", "Object Type") then;
            end;
        }
        field(11; "Object ID"; Text[30])
        {
        }
        field(12; "Object Name"; Text[50])
        {
        }
        field(13; "Object Modified"; Text[30])
        {
        }
        field(14; "Version List"; Text[100])
        {
        }
        field(15; "Object Date"; Text[30])
        {
        }
        field(16; "Object Time"; Text[30])
        {
        }
        field(20; "Object Type calc."; Option)
        {
            OptionMembers = " ","Table",Form,"Report",Empty,"Codeunit","XMLport",MenuSuite,"Page","Query";
        }
    }

    keys
    {
        key(Key1; "Job Task Detail ID", "Object Type", "Object ID")
        {
        }
    }

    fieldgroups
    {
    }
}

