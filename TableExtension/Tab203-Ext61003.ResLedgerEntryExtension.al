/// <summary>
/// TableExtension ResLedgerEntryExtension (ID 61003) extends Record Res. Ledger Entry //203.
/// </summary>
tableextension 61003 "ResLedgerEntryExtension" extends "Res. Ledger Entry" //203
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
