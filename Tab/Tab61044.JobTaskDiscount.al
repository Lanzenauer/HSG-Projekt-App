/// <summary>
/// Table Job Task Discount (ID 61044).
/// </summary>
table 61044 "Job Task Discount"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 300415  HSG_00  CH  Created

    CaptionML = DEU = 'Projekt Aufgabe Rabatt',
                ENU = 'Job Task Discount';
    DrillDownPageID = "Job Task Discount List";
    LookupPageID = "Job Task Discount List";

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
        field(3; Description; Text[50])
        {
            CaptionML = DEU = 'Beschreibung',
                        ENU = 'Description';
        }
        field(4; "Minimum Amount"; Decimal)
        {
            CaptionML = DEU = 'Minimal Betrag',
                        ENU = 'Minimum Amount';
        }
        field(5; Quantity; Decimal)
        {
            CaptionML = DEU = 'Menge',
                        ENU = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(6; "Unit Price"; Decimal)
        {
            CaptionML = DEU = 'Verkaufspreis',
                        ENU = 'Unit Price';
        }
    }

    keys
    {
        key(Key1; "Job No.", "Job Task No.")
        {
        }
    }

    fieldgroups
    {
    }
}

