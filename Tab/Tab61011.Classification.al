table 61011 "Classification"
{
    CaptionML = ENU = 'Classification', DEU = 'Klassifikation';
    DataClassification = ToBeClassified;
    LookupPageId = Classification;

    fields
    {
        field(1; Typ; Option)
        {
            Caption = 'Typ';
            DataClassification = ToBeClassified;
            OptionMembers = CompSize,Industry,Product,Origin,Status,"Job Task Detail Category";

        }
        field(2; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(3; Beschreibung; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Typ)
        {
            Clustered = true;
        }
    }

}
