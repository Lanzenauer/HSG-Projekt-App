table 61047 "Job Task Detail Blob"
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

    CaptionML = DEU = 'Unteraufgabe Blob',
                ENU = 'Job Task Detail Blob';

    fields
    {
        field(1; "Job Task Detail ID"; Integer)
        {
            CaptionML = DEU = 'Projektunteraufgabe ID',
                        ENU = 'Job Task Detail ID';
        }
        field(2; "Job No."; Code[20])
        {
            CalcFormula = Lookup("Job Task Detail"."Job No." WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Projek Nr.',
                        ENU = 'Job No.';
            FieldClass = FlowField;
            TableRelation = Job."No.";
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
        field(7; "Short Description"; Text[100])
        {
            CaptionML = DEU = 'Kurzbeschreibung',
                        ENU = 'Short Description';
        }
        field(8; Type; Option)
        {
            CaptionML = DEU = 'Art',
                        ENU = 'Type';
            OptionCaptionML = DEU = ' ,Text,Bild,Sonstige',
                              ENU = ' ,Text,Image,Other';
            OptionMembers = " ",Text,Image,Other;
        }
        field(10; "Description Blob"; BLOB)
        {
            CaptionML = DEU = 'Bild',
                        ENU = 'Picture';
            SubType = Memo;
        }
        field(11; "Solution Blob"; BLOB)
        {
        }
        field(15; "Description Text"; Text[250])
        {
        }
        field(16; "Solution Text"; Text[250])
        {
        }
        field(20; "Import Datetime"; DateTime)
        {
        }
        field(21; "Create By"; Code[50])
        {
            CaptionML = DEU = 'Reporter',
                        ENU = 'Arranger';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "Job Task Detail ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Type := Type::Text;
    end;
}

