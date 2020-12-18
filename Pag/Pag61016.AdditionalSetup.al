page 61016 "Additional Setup"
{
    // version HSG,JOB

    // HSG Hanse Solution GmbH
    // Wichmannstraße 4 Hause 10 Mitte
    // D-22607 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 290818  JOB_00  CH  Created
    // 180918  JOB_02  FC  New fields "Job Details Closed","Job Details Reopen","Job Details Wait"

    CaptionML = DEU = 'Erweiterte Einrichtung',
                ENU = 'Additional Setup';
    PageType = Card;
    SourceTable = "HSG Add. Setup";

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("E-Mail Log  Def. Sales Person"; Rec."E-Mail Log  Def. Sales Person")
                {
                }
                field("E-Mail Log Def. Contact"; Rec."E-Mail Log Def. Contact")
                {
                }
                field("Default E-Mail CC Address"; Rec."Default E-Mail CC Address")
                {
                }
                field("TEMP File Folder"; Rec."TEMP File Folder")
                {
                }
            }
            group("Job Task Status")
            {
                CaptionML = DEU = 'Aufgabe Status',
                            ENU = 'Job Task Status';
                field("Job Details Closed"; Rec."Job Details Closed")
                {
                }
                field("Job Details Reopen"; Rec."Job Details Reopen")
                {
                }
                field("Job Details Wait"; Rec."Job Details Wait")
                {
                }
            }
        }
    }

    actions
    {
    }
}

