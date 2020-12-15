table 61012 "Job Additional Costs"
{
    CaptionML = ENU = 'Job Additional Costs', DEU = 'Projekt Zusatzkosten';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            CaptionML = ENU = 'Job No.', DEU = 'Projektnr.';
            TableRelation = Job."No.";
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.', DEU = 'Zeilennr.';
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            CaptionML = ENU = 'Type', DEU = 'Typ';
            OptionMembers = "G/L",Item,Resource;
            OptionCaptionML = DEU = 'Sachkonto,Artikel,Ressource', ENU = 'G/L,Item,Resource';
            DataClassification = ToBeClassified;
        }
        field(4; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', DEU = 'Nr.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("G/L")) "G/L Account"."No." ELSE
            IF (Type = CONST(Item)) Item."No." ELSE
            IF (Type = CONST(Resource)) Resource."No.";
        }
        field(5; Description; Text[50])
        {
            CaptionML = ENU = 'Description', DEU = 'Beschreibung';
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            CaptionML = ENU = 'Quantity', DEU = 'Menge';
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Price"; Decimal)
        {
            CaptionML = ENU = 'Unit Price', DEU = 'VK-Preis';
            DataClassification = ToBeClassified;
        }
        field(8; "Unit of Measure"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure', DEU = 'Einheitencode';
            TableRelation = IF (Type = CONST(Resource)) "Resource Unit of Measure".Code
                WHERE("Resource No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Item)) "Item Unit of Measure".Code
                WHERE("Item No." = FIELD("No."));
            DataClassification = ToBeClassified;
        }
        field(9; "Job Task No"; Code[20])
        {
            CaptionML = ENU = 'Job Task No', DEU = 'Projektaufgabe';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Job No.")
        {
            Clustered = true;
        }
    }

}
