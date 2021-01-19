table 61045 "Job Task Detail History"
{
    // version JOB

    // Documentation()
    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 240216  JOB_00  SL  Created Job Task Detail History Table
    // 110917  HSG_01  FC  New fields "User Note", "User Note Date"
    // 290818  JOB_01  CH  Field Group DropDown added
    // 030918  JOB_02  NM  Field Change 50 -> 200

    CaptionML = DEU = 'Projektunteraufgabe History',
                ENU = 'Job Task Detail History';

    fields
    {
        field(1; "Job Task Detail ID"; Integer)
        {
            CaptionML = DEU = ' Projektunteraufgabe ID',
                        ENU = 'Job Task Detail ID';
        }
        field(2; LastDate; DateTime)
        {
            CaptionML = DEU = 'Änderung Datum',
                        ENU = 'Last Date';
        }
        field(10; User; Code[50])
        {
            CaptionML = DEU = 'Benutzer',
                        ENU = 'User';
            TableRelation = Resource;
        }
        field(11; "Field"; Text[50])
        {
            CaptionML = DEU = 'Feld',
                        ENU = 'Field';
        }
        field(12; Change; Text[200])
        {
            CaptionML = DEU = 'Änderung',
                        ENU = 'Change';
        }
        field(13; "Processing by changed"; Boolean)
        {
            CaptionML = DEU = 'Bearbeitung durch geändert',
                        ENU = 'Processing by changed';
            TableRelation = Resource;
        }
        field(15; "Short Note"; Text[100])
        {
            CaptionML = DEU = 'Kurzbemerkung',
                        ENU = 'Short Note';

            trigger OnValidate();
            var
                JobTaskDetailMgnt_lCdu: Codeunit "Job Task Detail Mgnt.";
            begin
                if (User <> USERID)
                and (User <> JobTaskDetailMgnt_lCdu.GetUser_gFnc('')) then
                    ERROR(Text001_gCtx);
                "User Note Date" := CURRENTDATETIME;
            end;
        }
        field(16; "User Note Date"; DateTime)
        {
        }
        field(17; "Long Note"; BLOB)
        {
            SubType = Memo;
        }
        field(18; "Has Note"; Boolean)
        {
        }
        field(1000; "Job No."; Code[20])
        {
            CalcFormula = Lookup("Job Task Detail"."Job No." WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Projek Nr.',
                        ENU = 'Job No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001; "Job Task No."; Code[20])
        {
            CalcFormula = Lookup("Job Task Detail"."Job Task No." WHERE("Job Task Detail ID" = FIELD("Job Task Detail ID")));
            CaptionML = DEU = 'Projektaufgabe Nr. ',
                        ENU = 'Job Task No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Job Task Detail ID", LastDate)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job Task Detail ID", "Short Note")
        {
        }
    }

    trigger OnInsert();
    begin
        "User Note Date" := CURRENTDATETIME;
    end;

    var
        Text001_gCtx: TextConst DEU = 'Dieser Kommentar kann nur durch den User der Zeile geändert werden.', ENU = 'User Note can only be changed by the user of this line.';
}

