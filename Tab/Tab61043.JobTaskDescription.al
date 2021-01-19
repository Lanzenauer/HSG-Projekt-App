/// <summary>
/// Table Job Task Description (ID 61043).
/// </summary>
table 61043 "Job Task Description"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 080115  HSG_00  JS  Created

    CaptionML = DEU = 'Projekt Aufgabe Beschreibung',
                ENU = 'Job Task Description',
                DES = 'Projekt Aufgabe Beschreibung';
    DrillDownPageID = "Job Task Description";
    LookupPageID = "Job Task Description";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = DEU = 'Projektnr.',
                        ENU = 'Job No.';
            NotBlank = true;
            TableRelation = Job;
        }
        field(2; "Job Task No."; Code[20])
        {
            CaptionML = DEU = 'Projektaufgabennr.',
                        ENU = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate();
            var
                Job: Record Job;
                Cust: Record Customer;
            begin
            end;
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = DEU = 'Zeilennr.',
                        ENU = 'Line No.',
                        DES = 'Zeilennr.';
        }
        field(4; Description; Text[250])
        {
            CaptionML = DEU = 'Beschreibung',
                        ENU = 'Description',
                        DES = 'Description';
        }
        field(5; Internal; Boolean)
        {
            CaptionML = DEU = 'Intern',
                        ENU = 'Internal';
        }
        field(6; "Table Name"; Option)
        {
            CaptionML = DEU = 'Tabellenname',
                        ENU = 'Table Name';
            OptionCaptionML = DEU = 'Projekt Aufgabe Beschreibung',
                              ENU = 'Job Task Description';
            OptionMembers = "G/L Account",Customer,Vendor,Item,Resource,Job,,"Resource Group","Bank Account",Campaign,"Fixed Asset",Insurance,"Nonstock Item","IC Partner","Job Task Description";
        }
    }

    keys
    {
        key(Key1; "Job No.", "Job Task No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

