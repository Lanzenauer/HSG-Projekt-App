tableextension 61002 "JobLedgerEntry" extends "Job Ledger Entry" //169
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
        }
        field(61004; "Document Line No."; Integer)
        {
            CaptionML = ENU = 'Document Line No.', DEU = 'Beleg Zeilennr.';
            DataClassification = ToBeClassified;
        }
        field(61005; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            DataClassification = ToBeClassified;
        }
    }
}