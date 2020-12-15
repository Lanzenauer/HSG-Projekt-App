page 61021 "Job Journal All Jobs"
{
    //TODO: Add ShortCuts; buttom Part
    CaptionML = ENU = 'Job Journal All Jobs', DEU = 'Projekt Buch.-Blatt Alle Projekte';
    PageType = List;
    SourceTable = "Job Journal Line";
    SourceTableView = SORTING("Job No.", "No.", "Posting Date") WHERE("Journal Template Name" = FILTER(<> ''));
    InsertAllowed = false;
    DeleteAllowed = false;
    SaveValues = true;
    AutoSplitKey = true;
    DataCaptionFields = "Journal Batch Name";
    layout
    {
        area(content)
        {


            repeater(General)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    LookupPageId = "Job Task Lines HSG";
                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);

                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("ShortcutDimCode3"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,3';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode4"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,4';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode5"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,5';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode6"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,6';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode7"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,7';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode8"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    Visible = false;
                    CaptionClass = '1,2,8';

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = All;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = All;
                }
                field("Applies-from Entry"; Rec."Applies-from Entry")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ApplicationArea = All;
                }
                field("Time Sheet Line No."; Rec."Time Sheet Line No.")
                {
                    ApplicationArea = All;
                }
                field("Time Sheet Date"; Rec."Time Sheet Date")
                {
                    ApplicationArea = All;
                }
            }
            //ToDo: Is that correct
            group("Fixed Layout")
            {
                group("Job Description")
                {
                    field(JobDescription; JobDescription)
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
                group("AccountName")
                {
                    field("Account Name"; AccName)
                    {
                        CaptionML = ENU = 'Account Name', DEU = 'Kontoname';
                        Editable = false;
                        ApplicationArea = All;
                    }
                }

            }

        }
        area(FactBoxes)
        {
            part(""; recor)
            {
                Visible = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        COMMIT;
        IF NOT ReserveJobJnlLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
    end;

    var
        JobJnlReconcile: Page "Job Journal Reconcile";
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[50];
        AccName: Text[50];
        ShortcutDimCode: Array[8] of Code[20];
        OpenedFromBatch: Boolean;
        CurrentUser_gTxt: Text;
        OrgJobJnlLine_gRec: Record "Job Journal Line";
}
