/// <summary>
/// TableExtension ResJournalLineExtension (ID 61004) extends Record Res. Journal Line //207.
/// </summary>
tableextension 61004 "ResJournalLineExtension" extends "Res. Journal Line" //207
{
    fields
    {
        field(61000; "Job Task No."; Code[20])
        {
            CaptionML = ENU = 'Job Task No.', DEU = 'Projektaufgabennr.';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." where("Job No." = FIELD("Job No."));
        }
        field(61001; LongDescription; Text[250])
        {
            CaptionML = ENU = 'LongDescription', DEU = 'Beschreibungf';
            DataClassification = ToBeClassified;
        }
    }
}
