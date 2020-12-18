table 61008 "Job Additional Costs"
{
    // version HSG

    CaptionML = DEU = 'Projekt Zusatzkosten',
                ENU = 'Job Additional Costs';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Projektnr.';
            NotBlank = true;
            TableRelation = Job."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
        }
        field(3; Type; Option)
        {
            Caption = 'Typ';
            OptionCaptionML = DEU = 'Sachkonto,Artikel,Ressource',
                              ENU = 'G/L,Item,Resource';
            OptionMembers = "G/L",Item,Resource;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'Nr.';
            TableRelation = IF (Type = CONST("G/L")) "G/L Account"."No."
            ELSE
            IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST(Resource)) Resource."No.";
        }
        field(5; Description; Text[50])
        {
            Caption = 'Beschreibung';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Menge';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'VK-Preis';
        }
        field(8; "Unit of Measure"; Code[10])
        {
            CaptionML = DEU = 'Einheitencode',
                        ENU = 'Unit of Measure';
            TableRelation = IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            var
                ResUnitOfMeasure: Record "Resource Unit of Measure";
                ResLedgEnty: Record "Res. Ledger Entry";
            begin
            end;
        }
        field(10; "Job Task No"; Code[20])
        {
            CaptionML = DEU = 'Projektaufgabe',
                        ENU = 'Job Task No';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
    }

    keys
    {
        key(Key1; "Job No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

