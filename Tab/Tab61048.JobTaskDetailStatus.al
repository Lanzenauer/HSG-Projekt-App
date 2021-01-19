/// <summary>
/// Table Job Task Detail Status (ID 61048).
/// </summary>
table 61048 "Job Task Detail Status"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 280917  HSG_01  FC  Created

    DrillDownPageID = "Job Task Detail Status";
    LookupPageID = "Job Task Detail Status";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
            CaptionML = DEU = 'Beschreibung',
                        ENU = 'Description';
        }
        field(5; Blocked; Boolean)
        {
            CaptionML = DEU = 'Gesperrt',
                        ENU = 'Blocked';
        }
        field(10; Sorting; Integer)
        {
            CaptionML = DEU = 'Sortierung',
                        ENU = 'Sorting';
        }
        field(11; "Status Option"; Option)
        {
            CaptionML = DEU = 'Status Option',
                        ENU = 'Status Option';
            OptionCaptionML = DEU = 'Offen,Aufwandschätzung,Angebot,in Bearbeitung,Test,Abnahme Kunde,Rückmeldung,Geschlossen,Gelöscht',
                              ENU = 'Open,Cost estimation,Quote,Processing,Test,Sign off Customer,Feedback,Closed,Deleted';
            OptionMembers = Open,"Cost estimation",Quote,Processing,Test,"Sign off Customer",Feedback,Closed,Deleted;
        }
        field(50; "Status Extended"; Option)
        {
            OptionCaptionML = DEU = 'Aktiv,Warte,Geschlossen,Gelöscht',
                              ENU = 'Active,Wait,Closed,Deleted';
            OptionMembers = Active,Wait,Closed,Deleted;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; Sorting)
        {
        }
    }

    fieldgroups
    {
    }
}

