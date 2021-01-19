/// <summary>
/// TableExtension JobJournalLineExtension (ID 61000) extends Record Job Journal Line //210.
/// </summary>
tableextension 61066 "JobJournalLineExtension" extends "Job Journal Line" //210
{
    fields
    {
        field(61000; "Starting Time"; Time)
        {
            CaptionML = ENU = 'Starting Time', DEU = 'Startzeit';
            DataClassification = ToBeClassified;
        }
        field(61001; "Ending Time"; Time)
        {
            CaptionML = ENU = 'Ending Time', DEU = 'Endzeit';
            DataClassification = ToBeClassified;
        }
        field(61002; "Pos. No."; Code[10])
        {
            CaptionML = ENU = 'Pos. No.', DEU = 'Pos.-Nr.';
            DataClassification = ToBeClassified;
        }
        field(61003; "Sales Order No."; Code[20])
        {
            CaptionML = ENU = 'Sales Order No.', DEU = 'Verkauf Auftragsnr.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No."
            WHERE("Document Type" = CONST(Order));
        }
        field(61004; "Document Line No."; Integer)
        {
            CaptionML = ENU = 'Document Line No.', DEU = 'Beleg Zeilennr';
            DataClassification = ToBeClassified;
        }
    }
}
