table 61010 "HSG Add. Setup"
{
    // version HSG,JOB

    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 290818  JOB_00  CH  Created
    // 030918  JOB_01  NM  new field Job Details Closed
    // 060918  JOB_02  NM  new field 201 Job Details Reopen
    // 180918  JOB_03  NM  new field 202 Job Details Wait


    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = DEU = 'Code',
                        ENU = 'Code';
            DataClassification = ToBeClassified;
        }
        field(100; "E-Mail Log  Def. Sales Person"; Code[20])
        {
            CaptionML = DEU = 'E-Mail Log Std. Verkäufer',
                        ENU = 'E-Mail Log  Def.  Sales Person';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(101; "E-Mail Log Def. Contact"; Code[20])
        {
            CaptionML = DEU = 'E-Mail Log Std. Kontakt',
                        ENU = 'E-Mail Log Def. Contact';
            DataClassification = ToBeClassified;
            TableRelation = Contact."No.";
        }
        field(102; "Default E-Mail CC Address"; Text[100])
        {
            CaptionML = DEU = 'Standard E-Mail CC Adresse',
                        ENU = 'Default E-Mail CC Address';
            DataClassification = ToBeClassified;
        }
        field(103; "TEMP File Folder"; Text[200])
        {
            Caption = 'TEMP File Folder';
            DataClassification = ToBeClassified;
        }
        field(200; "Job Details Closed"; Code[20])
        {
            CaptionML = DEU = 'Aufgabe Geschlossen',
                        ENU = 'Job Details Closed';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task Detail Status".Code;
        }
        field(201; "Job Details Reopen"; Code[20])
        {
            Caption = 'Aufgabe in Bearbeitung';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task Detail Status".Code;
        }
        field(202; "Job Details Wait"; Code[20])
        {
            Caption = 'Aufgabe Warte auf Kunde';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task Detail Status".Code;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

