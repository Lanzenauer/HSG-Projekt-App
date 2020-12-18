codeunit 61018 "Job Journal Get Add. Costs"
{
    // version HSG

    TableNo = "Job Journal Line";

    trigger OnRun();
    var
        AdditionalCost_lRec: Record "Job Additional Costs";
        JobJnlLine_lRec: Record "Job Journal Line";
        NextLineNo_lInt: Integer;
        NoOfLines_lInt: Integer;
        i: Integer;
    begin

        // HSG01
        Rec.TESTFIELD("Job No.");

        AdditionalCost_lRec.RESET;
        AdditionalCost_lRec.SETRANGE("Job No.", Rec."Job No.");

        if not AdditionalCost_lRec.FINDFIRST then
            exit;

        CLEAR(JobJnlLine_lRec);
        JobJnlLine_lRec := Rec;
        JobJnlLine_lRec.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        JobJnlLine_lRec.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        if JobJnlLine_lRec.NEXT <> 0 then
            NextLineNo_lInt := JobJnlLine_lRec."Line No."
        else
            NextLineNo_lInt := Rec."Line No." + 10000;

        NoOfLines_lInt := AdditionalCost_lRec.COUNT;
        i := 0;

        repeat
            i := i + 1;
            JobJnlLine_lRec := Rec;
            JobJnlLine_lRec."Line No." := Rec."Line No." + ROUND((NextLineNo_lInt - Rec."Line No.") / (NoOfLines_lInt + 1) * i, 1);
            case AdditionalCost_lRec.Type of
                AdditionalCost_lRec.Type::Item:
                    JobJnlLine_lRec.VALIDATE(Type, JobJnlLine_lRec.Type::Item);
                AdditionalCost_lRec.Type::Resource:
                    JobJnlLine_lRec.VALIDATE(Type, JobJnlLine_lRec.Type::Resource);
                AdditionalCost_lRec.Type::"G/L":
                    JobJnlLine_lRec.VALIDATE(Type, JobJnlLine_lRec.Type::"G/L Account");
            end;
            JobJnlLine_lRec.VALIDATE("No.", AdditionalCost_lRec."No.");
            if AdditionalCost_lRec."Unit of Measure" <> '' then
                JobJnlLine_lRec.VALIDATE("Unit of Measure Code", AdditionalCost_lRec."Unit of Measure");
            JobJnlLine_lRec.Description := AdditionalCost_lRec.Description;
            JobJnlLine_lRec.Chargeable := true;
            JobJnlLine_lRec.VALIDATE(Quantity, AdditionalCost_lRec.Quantity);
            JobJnlLine_lRec.VALIDATE("Unit Price", AdditionalCost_lRec."Unit Price");
            JobJnlLine_lRec."Unit Price (LCY)" := AdditionalCost_lRec."Unit Price";
            if AdditionalCost_lRec."Job Task No" <> '' then
                JobJnlLine_lRec."Job Task No." := AdditionalCost_lRec."Job Task No";
            JobJnlLine_lRec.INSERT;
        until AdditionalCost_lRec.NEXT = 0;
    end;
}

