/// <summary>
/// TableExtension JobsSetupExtension (ID 61005) extends Record Jobs Setup //315.
/// </summary>
tableextension 61005 "JobsSetupExtension" extends "Jobs Setup" //315
{
    fields
    {
        field(61000; "Standard Resource"; Code[20])
        {
            CaptionML = ENU = 'Standard Resource', DEU = 'Standard Ressource';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(61001; "Job Order No. Series"; Code[20])
        {
            CaptionML = ENU = 'Job Order No. Series', DEU = 'Projekt Auftrag Nummernserien';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }
}
