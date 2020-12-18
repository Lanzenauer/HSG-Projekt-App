/// <summary>
/// TableExtension "ResourceExtension" (ID 61000) extends Record Resource.
/// </summary>
tableextension 61000 ResourceExtension extends Resource //156
{
    fields
    {
        field(61000; "Sales (Price Job Journal)"; Decimal)
        {
            CaptionML = ENU = 'Sales (Price Job Journal)', DEU = 'Verkauf Betrag (Buch Blatt)';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Journal Line"."Total Price (LCY)"
            WHERE("Entry Type" = CONST(Usage), Type = CONST(Resource), "No." = FIELD("No."),
            "Posting Date" = FIELD("Date Filter"), Chargeable = FIELD("Chargeable Filter")));
            Editable = false;
        }
        field(61001; "Usage (Qty Job Journal)"; Decimal)
        {
            CaptionML = ENU = 'Usage (Qty Job Journal)', DEU = 'Verkauf Menge (Buch Blatt)';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Journal Line"."Quantity (Base)"
            WHERE("Entry Type" = CONST(Usage), Type = CONST(Resource), "No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), Chargeable = FIELD("Chargeable Filter")));
            Editable = false;
        }
        field(61002; "General Resource"; Boolean)
        {
            CaptionML = ENU = 'General Resource', DEU = 'Allgemeine Ressource';
            DataClassification = ToBeClassified;
        }
        field(61003; "Show in Statistics"; Boolean)
        {
            CaptionML = ENU = 'Show in Statistics', DEU = 'Zeige in Statistik';
            DataClassification = ToBeClassified;
        }
    }
}
