table 61010 "HSG Add. Setup" //50007
{
    Caption = 'HSG Add. Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "E-Mail Log  Def. Sales Person"; Code[20])
        {
            CaptionML = ENU = 'E-Mail Log  Def. Sales Person', DEU = 'E-Mail Log Std. Verkäufer';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(3; "E-Mail Log Def. Contact"; Code[20])
        {
            CaptionML = ENU = 'E-Mail Log Def. Contact', DEU = 'E-Mail Log Std. Kontakt';
            TableRelation = Contact."No.";
            DataClassification = ToBeClassified;
        }
        field(4; "Default E-Mail CC Address"; Text[100])
        {
            CaptionML = ENU = 'Default E-Mail CC Address', DEU = 'Standard E-Mail CC Adresse';
            DataClassification = ToBeClassified;
        }
        field(5; "TEMP File Folder"; Text[200])
        {
            CaptionML = ENU = 'TEMP File Folder', DEU = 'TEMP Dateiordner';
            DataClassification = ToBeClassified;
        }
        field(6; "Job Details Closed"; Code[20])
        {
            CaptionML = ENU = 'Job Details Closed', DEU = 'Aufgabe Geschlossen';
            TableRelation = "Job Task Detail Status".Code;
            DataClassification = ToBeClassified;
        }
        field(7; "Job Details Reopen"; Code[20])
        {
            CaptionML = ENU = 'Job Details Reopen', DEU = 'Aufgabe in Bearbeitung';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task Detail Status".Code;
        }
        field(8; "Job Details Wait"; Code[20])
        {
            CaptionML = ENU = 'Job Details Wait', DEU = 'Aufgabe Warte auf Kunde';
            TableRelation = "Job Task Detail Status".Code;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}
