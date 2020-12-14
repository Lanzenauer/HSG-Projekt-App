/// <summary>
/// TableExtension "JobTaskExtension" (ID 61006) extends Record Job Task //1001.
/// </summary>
tableextension 61006 JobTaskExtension extends "Job Task" //1001
{
    fields
    {
        field(61000; "Planned Con. Job Jrnl. (Price)"; Decimal)
        {
            CaptionML = ENU = 'Planned Con. Job Jrnl. (Price)', DEU = 'Fakturierbar Buch Blatt (Verkaufspreis)';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Journal Line"."Total Price (LCY)"
            WHERE("Job No." = FIELD("Job No."),
            "Job Task No." = FIELD("Job Task No."),
            "Posting Date" = FIELD("Posting Date Filter"),
            "Chargeable" = CONST(true)));
            Editable = false;
            BlankZero = true;
        }
        field(61001; "Invoiced Amount (Price)"; Decimal)
        {
            CaptionML = ENU = 'Invoiced Amount (Price)', DEU = 'Fakturiert (Verkaufspreis)';
            FieldClass = FlowField;
            CalcFormula = - Sum("Job Ledger Entry"."Total Price (LCY)"
            WHERE("Entry Type" = CONST(Sale),
            "Job No." = FIELD("Job No."),
            "Job Task No." = FIELD("Job Task No."), "Posting Date" = FIELD("Posting Date Filter")));
            BlankZero = true;
            Editable = false;
        }
        field(61002; "Consumed Amount (Price)"; Decimal)
        {
            CaptionML = ENU = 'Consumed Amount (Price)', DEU = 'Verbrauch (Verkaufspreis)';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Total Price (LCY)"
            WHERE("Entry Type" = CONST(Usage), "Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."), "Posting Date" = FIELD("Posting Date Filter")));
            BlankZero = true;
            Editable = false;
        }
        field(61003; "Responsible Resource"; Code[10])
        {
            CaptionML = ENU = 'Responsible Resource', DEU = 'Verantwortliche Resource';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(61004; "No Of Description Lines"; Integer)
        {
            CaptionML = ENU = 'No Of Description Lines', DEU = 'Beschreibungszeilen Anzahl';
            FieldClass = FlowField;
            CalcFormula = Count("Job Task Description"
            WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No.")));
            BlankZero = true;
            Editable = false;
        }
        field(61005; "No Overcharge"; Boolean)
        {
            CaptionML = ENU = 'No Overcharge', DEU = 'Keine Überfakturierung';
            DataClassification = ToBeClassified;
        }
        field(61006; Status; Option)
        {
            CaptionML = ENU = 'Status', DEU = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = Quote,Order,,,Finished;
            OptionCaptionML = ENU = 'Quote,Order,,,Finished', DEU = 'Angebot,Auftrag,,,Beendet';

        }
        field(61007; "External Document No."; Code[20])
        {
            CaptionML = ENU = 'External Document No.', DEU = 'Externe Belegnr.';
            DataClassification = ToBeClassified;
        }
        field(61008; "Document No."; Code[20])
        {
            CaptionML = ENU = 'Document No.', DEU = 'Belegnr.';
            DataClassification = ToBeClassified;
        }
        field(61009; "Person Responsible"; Code[20])
        {
            CaptionML = ENU = 'Person Responsible', DEU = 'Verantwortlich';
            DataClassification = ToBeClassified;
            TableRelation = Resource
            Where(Type = const(Person));
        }
        field(61010; "Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', DEU = 'Fälligkeitsdatum';
            DataClassification = ToBeClassified;
        }
        field(61011; "Schedule (Total Quantity)"; Decimal)
        {
            CaptionML = ENU = 'Schedule (Total Quantity)', DEU = 'Plan (Menge)';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Planning Line".Quantity
            WHERE("Job No." = FIELD("Job No."),
            "Job Task No." = FIELD("Job Task No."),
            "Job Task No." = FIELD(FILTER(Totaling)),
            "Schedule Line" = CONST(true),
            "Planning Date" = FIELD("Planning Date Filter")));
            BlankZero = true;
            Editable = false;
        }
        field(61012; "Invoice Type"; Option)
        {
            CaptionML = ENU = 'Invoice Type', DEU = 'Abrechnungsart';
            DataClassification = ToBeClassified;
            OptionMembers = Effort,Release;
            OptionCaptionML = ENU = 'Effort,Release', DEU = 'Aufwand,Freigabe';

            trigger OnValidate()
            begin
                TESTFIELD("Invoice Release", FALSE);
            end;
        }
        field(61013; "Invoice Release"; Boolean)
        {
            CaptionML = ENU = 'Invoice Release', DEU = 'Freigabe Rechnung;';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Invoice Release" THEN
                    TESTFIELD("Invoice Type", "Invoice Type"::Release);
            end;
        }
        field(61014; Support; Boolean)
        {
            CaptionML = ENU = 'Support', DEU = 'Supportaufgabe';
            DataClassification = ToBeClassified;
        }
        field(60105; "Invoice Up To %"; Decimal)
        {
            CaptionML = ENU = 'Invoice Up To %', DEU = 'Berechnung bis %';
            DataClassification = ToBeClassified;
            InitValue = 100;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                TESTFIELD("Invoice Type", "Invoice Type"::Release);
            end;
        }
    }
}
