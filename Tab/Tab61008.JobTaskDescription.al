table 61008 "Job Task Description"
{
    Caption = 'Job Task Description';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', DEU = 'Projektnr.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Job;
        }
        field(2; "Job Task No."; Code[20])
        {
            CaptionML = ENU = 'Job Task No.', DEU = 'Projektaufgabennr.';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No."
            WHERE("Job No." = FIELD("Job No."));
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', DEU = 'Zeilennr.';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[250])
        {
            CaptionML = ENU = 'Description', DEU = 'Beschreibung';
            DataClassification = ToBeClassified;
        }
        field(5; Internal; Boolean)
        {
            CaptionML = ENU = 'Internal', DEU = 'Intern';
            DataClassification = ToBeClassified;
        }
        field(6; "Table Name"; Option)
        {
            Caption = 'Table Name';
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Customer,Vendor,Item,Resource,Job,,"Resource Group","Bank Account",Campaign,"Fixed Asset",Insurance,"Nonstock Item","IC Partner","Job Task Description";
            OptionCaptionML = ENU = 'Job Task Description', DEU = 'Projekt Aufgabe Beschreibung';
        }
    }
    keys
    {
        key(PK; "Job No.", "Job Task No.", "Line No.")
        {
            Clustered = true;
        }
    }

}
