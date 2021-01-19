/// <summary>
/// Page Job Journal All Jobs (ID 61011).
/// </summary>
page 61011 "Job Journal All Jobs"
{
    // version NAVW18.00,HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 020315  HSG_01  CH  Copied from page 201

    AutoSplitKey = true;
    CaptionML = DEU = 'Projekt Buch.-Blatt Alle Projekte',
                ENU = 'Job Journal All Jobs';
    DataCaptionFields = "Journal Batch Name";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SaveValues = true;
    SourceTable = "Job Journal Line";
    SourceTableView = SORTING("Job No.", "No.", "Posting Date")
                      WHERE("Journal Template Name" = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    Editable = false;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Editable = false;
                }
                field("Line Type"; Rec."Line Type")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    LookupPageID = "Job Task Lines HSG";
                }
                field(Type; Rec.Type)
                {

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                    end;
                }
                field("No."; Rec."No.")
                {

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        Rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;

                    trigger OnAssistEdit();
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        if ChangeExchangeRate.RUNMODAL = ACTION::OK then
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);

                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(Chargeable; Rec.Chargeable)
                {
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    Visible = false;
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    Visible = false;
                }
                field("Applies-from Entry"; Rec."Applies-from Entry")
                {
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    Visible = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Visible = false;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    Visible = false;
                }
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    Visible = false;
                }
                field("Time Sheet Line No."; Rec."Time Sheet Line No.")
                {
                    Visible = false;
                }
                field("Time Sheet Date"; Rec."Time Sheet Date")
                {
                    Visible = false;
                }
            }
            group(Control73)
            {
                fixed(Control1902114901)
                {
                    group("Job Description")
                    {
                        CaptionML = DEU = 'Projektbeschreibung',
                                    ENU = 'Job Description';
                        field(JobDescription; JobDescription)
                        {
                            Editable = false;
                        }
                    }
                    group("Account Name")
                    {
                        CaptionML = DEU = 'Kontoname',
                                    ENU = 'Account Name';
                        field(AccName; AccName)
                        {
                            CaptionML = DEU = 'Kontoname',
                                        ENU = 'Account Name';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                CaptionML = DEU = '&Zeile',
                            ENU = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    CaptionML = DEU = 'Dimensionen',
                                ENU = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(ItemTrackingLines)
                {
                    CaptionML = DEU = 'Artikel&verfolgungszeilen',
                                ENU = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        Rec.OpenItemTrackingLines(false);
                    end;
                }
            }
            group("&Job")
            {
                CaptionML = DEU = 'Pro&jekt',
                            ENU = '&Job';
                Image = Job;
                action(Card)
                {
                    CaptionML = DEU = 'Karte',
                                ENU = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("Job No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    CaptionML = DEU = '&Posten',
                                ENU = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageView = SORTING("Job No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = DEU = 'F&unktion',
                            ENU = 'F&unctions';
                Image = "Action";
                action(CalcRemainingUsage)
                {
                    CaptionML = DEU = 'Restverbrauch berechnen',
                                ENU = 'Calc. Remaining Usage';
                    Ellipsis = true;
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        JobCalcRemainingUsage: Report "Job Calc. Remaining Usage";
                    begin
                        Rec.TESTFIELD("Journal Template Name");
                        Rec.TESTFIELD("Journal Batch Name");
                        CLEAR(JobCalcRemainingUsage);
                        JobCalcRemainingUsage.SetBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                        JobCalcRemainingUsage.SetDocNo(Rec."Document No.");
                        JobCalcRemainingUsage.RUNMODAL;
                    end;
                }
                action(SuggestLinesFromTimeSheets)
                {
                    CaptionML = DEU = 'Zeilen anhand von Arbeitszeittabellen vorschlagen',
                                ENU = 'Suggest Lines from Time Sheets';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        SuggestJobJnlLines: Report "Suggest Job Jnl. Lines";
                    begin
                        SuggestJobJnlLines.SetJobJnlLine(Rec);
                        SuggestJobJnlLines.RUNMODAL;
                    end;
                }
                action(GetAddCosts)
                {
                    Caption = 'Zusatzkosten hoeln';
                    Image = GetActionMessages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Job Journal Get Add. Costs";
                }
            }
            group("P&osting")
            {
                CaptionML = DEU = 'Bu&chung',
                            ENU = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    CaptionML = DEU = 'Abstimmen',
                                ENU = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction();
                    begin
                        JobJnlReconcile.SetJobJnlLine(Rec);
                        JobJnlReconcile.RUN;
                    end;
                }
                action("Test Report")
                {
                    CaptionML = DEU = 'Testbericht',
                                ENU = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction();
                    begin
                        ReportPrint.PrintJobJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    CaptionML = DEU = 'Bu&chen',
                                ENU = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        OrgJobJnlLine_gRec.COPYFILTERS(Rec);

                        CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post", Rec);
                        // CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        Rec.FILTERGROUP(2);
                        Rec.SETRANGE("Journal Batch Name");
                        Rec.COPYFILTERS(OrgJobJnlLine_gRec);
                        Rec.FILTERGROUP(0);

                        Rec.SETCURRENTKEY("Job No.", "No.", "Posting Date");

                        CurrPage.UPDATE(false);
                    end;
                }
                action("Post and &Print")
                {
                    CaptionML = DEU = 'Buchen und d&rucken',
                                ENU = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post+Print", Rec);
                        // CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        Rec.FILTERGROUP(2);
                        Rec.SETRANGE("Journal Batch Name");
                        Rec.FILTERGROUP(0);

                        Rec.SETCURRENTKEY("Job No.", "No.", "Posting Date");

                        CurrPage.UPDATE(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
    end;

    trigger OnAfterGetRecord();
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        COMMIT;
        if not ReserveJobJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        // -HSG_01
        //OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
        //IF OpenedFromBatch THEN BEGIN
        //  CurrentJnlBatchName := "Journal Batch Name";
        //  JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        //  EXIT;
        //END;
        //JobJnlManagement.TemplateSelection(PAGE::"Job Journal",FALSE,Rec,JnlSelected);
        //IF NOT JnlSelected THEN
        //  ERROR('');
        //JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        // +HSG_01

        //-HSG_01
        //CurrentUser_gTxt := DELSTR(USERID,1,14);
        //CurrentJnlBatchName := CurrentUser_gTxt;
        //CurrentJnlBatchNameOnAfterVali;
        //+HSG_01
    end;

    var
        JobJnlReconcile: Page "Job Journal Reconcile";
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[50];
        AccName: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        CurrentUser_gTxt: Text;
        OrgJobJnlLine_gRec: Record "Job Journal Line";

    local procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        // JobJnlManagement.SetName(CurrentJnlBatchName,Rec);

        CurrPage.UPDATE(false);
    end;
}

