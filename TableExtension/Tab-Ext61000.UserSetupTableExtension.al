tableextension 61000 UserSetupTableExtension extends "User Setup"
{
    fields
    {
        field(61000; "Resource No."; Code[20])
        {
            CaptionML = DEU = 'Ressource Nr.',
                        ENU = 'Resource No.';
            DataClassification = ToBeClassified;
            Description = 'JOB_01';
            TableRelation = Resource."No.";
        }
        field(61001; "Send E-Mail on new Mail"; Boolean)
        {
            CaptionML = DEU = 'Sende E-Mail wenn neue Mail',
                        ENU = 'Send E-Mail by new Mail';
            DataClassification = ToBeClassified;
            Description = 'JOB_02';
        }

    }
}
