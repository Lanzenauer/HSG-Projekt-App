table 61009 "Classification"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 070917  HSG_01  FC  New Type option "Job Task Detail Category"

    Caption = 'Klassifikation';
    LookupPageID = Classification;

    fields
    {
        field(1; Typ; Option)
        {
            OptionMembers = CompSize,Industry,Product,Origin,Status,"Job Task Detail Category";
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Beschreibung; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; Typ, "Code")
        {
        }
        key(Key2; Typ, Beschreibung)
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }
}

