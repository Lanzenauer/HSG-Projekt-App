/// <summary>
/// TableExtension "InteractionLogEntryExtension" (ID 61008) extends Record Interaction Log Entry // 5065.
/// </summary>
tableextension 61060 InteractionLogEntryExtension extends "Interaction Log Entry" // 5065
{
    /*     
        version NAVW18.00,NAVDACH8.00,HSG,JOB

        HSG Hanse Solution GmbH
        D - 22607 Hamburg

        Date    Module  ID  Description
        ==========================================================================================
        290818  JOB_01  CH  New fields #50000..#50005
        190918  JOB_02  NM  Create Notification by validate on Job Task Detail ID on Validate
        051218  JOB_03  CH  New field "E-Mail read" 
    */
    fields
    {
        field(61000; "Job Task Detail ID"; Integer)
        {
            CaptionML = DEU = 'Projektunteraufgabe ID',
                        ENU = 'Job Task Detail ID';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task Detail"."Job Task Detail ID";

            trigger OnValidate();
            begin
                JobTaskDetMgnt_gCdu.SetNotificationByJobTaskDetID_gFnc("Job Task Detail ID", 2);
            end;
        }
        field(61001; "E-Mail Body Text"; BLOB)
        {
            CaptionML = DEU = 'E-Mail Body Text',
                        ENU = 'E-Mail Body Text';
            DataClassification = ToBeClassified;
        }
        field(61002; "From Mail Address"; Text[50])
        {
            CaptionML = DEU = 'Von E-Mail Adresse',
                        ENU = 'From E-Mail Address';
            DataClassification = ToBeClassified;
        }
        field(61003; "CC Mail Address"; Text[200])
        {
            CaptionML = DEU = 'CC E-Mail Adresse',
                        ENU = 'CC Mail Address';
            DataClassification = ToBeClassified;
        }
        field(61004; "To Mail Address"; Text[120])
        {
            CaptionML = DEU = 'An E-Mail Adresse',
                        ENU = 'To E-Mail Address';
            DataClassification = ToBeClassified;
        }
        field(61005; "Mail Subject Long Text"; Text[150])
        {
            CaptionML = DEU = 'Mail Betreff Langtext',
                        ENU = 'Mail Subject Long Text';
            DataClassification = ToBeClassified;
        }
        field(61006; "E-Mail Read"; Boolean)
        {
            CaptionML = DEU = 'E-Mail gelesen',
                        ENU = 'E-Mail Read';
            DataClassification = ToBeClassified;
        }
    }
    var
        JobTaskDetMgnt_gCdu: Codeunit "Job Task Detail Mgnt.";

}
