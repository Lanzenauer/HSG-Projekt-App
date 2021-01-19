tableextension 61062 "JobExtension" extends Job //167
{
    fields
    {
        field(61000; "No Posting Without Job Task"; Boolean)
        {
            CaptionML = DEU = 'Keine Buchung ohne Projektaufgabe', ENU = 'No Posting Without Job Task';
            DataClassification = ToBeClassified;
        }
        field(61001; "Sales Amount Consumed"; Decimal)
        {
            Caption = 'Sales Amount Consumed';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Price (LCY)"
            WHERE("Job No." = FIELD("No."),
            "Entry Type" = CONST(Usage),
            "Posting Date" = FIELD("Posting Date Filter")));
        }
        field(61002; "Sales Amount Invoiced"; Decimal)
        {
            Caption = 'Sales Amount Invoiced';
            FieldClass = FlowField;
            CalcFormula = - Sum("Res. Ledger Entry"."Total Price"
            WHERE("Job No." = FIELD("No."),
            "Posting Date" = FIELD("Posting Date Filter"),
            "Entry Type" = CONST(Sale)));
        }
        field(61003; "No Batch Invoicing"; Boolean)
        {
            CaptionML = ENU = 'No Batch Invoicing', DEU = 'Keine Automatische Abrechnung';
            DataClassification = ToBeClassified;
        }
        field(61004; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', DEU = 'DEU=Externe Belegnr.;';
            DataClassification = ToBeClassified;
        }
        /*         field(61005; "Project Manager"; Code[50])
                {
                    CaptionML = DEU = 'Projektleiter', ENU = 'Project Manager';
                    TableRelation = "User Setup";
                    DataClassification = ToBeClassified;
                } */
    }
}
