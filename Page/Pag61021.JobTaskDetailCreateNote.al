page 61021 "Job Task Detail Create Note"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 190917  HSG_01  FC  Created

    CaptionML = DEU = 'Notiz erstellen',
                ENU = 'Create Note';
    DataCaptionExpression = FORMAT(Rec."Job Task Detail ID") + ' - ' + ShortDescription_gTxt;
    PageType = Card;
    SourceTable = "Job Task Detail";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("Job Task Detail ID"; "Job Task Detail ID")
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field(ShortDescription_gTxt; ShortDescription_gTxt)
                {
                    CaptionML = DEU = 'Kurzbeschreibung',
                                ENU = 'Short Description';
                }
                field(Status_gCod; Status_gCod)
                {
                    Caption = 'Status';

                    // OptionCaptionML = DEU='Offen,Aufwandschätzung,Angebot,in Bearbeitung,Test,Abnahme Kunde,Rückmeldung,Geschlossen,Gelöscht',
                    //                   ENU='Open,Cost estimation,Quote,Processing,Test,Sign off Customer,Feedback,Closed,Deleted';
                    TableRelation = "Job Task Detail Status".Code;
                }
                field(PlannedDate_gDat; PlannedDate_gDat)
                {
                    CaptionML = DEU = 'Plandatum',
                                ENU = 'Planned Date';
                    Visible = false;
                }
                field(FixedDate_gDat; FixedDate_gDat)
                {
                    CaptionML = DEU = 'Fixtermin',
                                ENU = 'Fixed Termin';
                    Visible = false;
                }
                field(WaitingOnCustomer_gBln; WaitingOnCustomer_gBln)
                {
                    CaptionML = DEU = 'Warte auf Kunde',
                                ENU = 'Waiting on customer';
                }
                field(Priority_gOpt; Priority_gOpt)
                {
                    CaptionML = DEU = 'Priorität',
                                ENU = 'Priority';
                    OptionCaptionML = DEU = ' ,Niedrig,Mittel,Hoch,Sofort',
                                      ENU = ' ,Low,Medium,High,Immediately';
                }
                field(RemainingQuantity_gDec; RemainingQuantity_gDec)
                {
                    CaptionML = DEU = 'Restschätzmenge',
                                ENU = 'Remaining Quantity';
                    Visible = false;
                }
                field(Processingby_gCod; Processingby_gCod)
                {
                    CaptionML = DEU = 'Bearbeitung durch',
                                ENU = 'Processing by';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Resource_lRec: Record Resource;
                    begin
                        if Resource_lRec.GET(Processingby_gCod) then;
                        if PAGE.RUNMODAL(0, Resource_lRec) = ACTION::LookupOK then begin
                            Processingby_gCod := Resource_lRec."No.";
                            ProcessingbyName_gTxt := Resource_lRec.Name;
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Resource_lRec: Record Resource;
                    begin
                        if not Resource_lRec.GET(Processingby_gCod) then begin
                            Resource_lRec.SETFILTER("Search Name", '*' + Processingby_gCod + '*');
                            if Resource_lRec.COUNT = 1 then begin
                                Resource_lRec.FINDFIRST;
                                Processingby_gCod := Resource_lRec."No.";
                                ProcessingbyName_gTxt := Resource_lRec.Name;
                            end else begin
                                Resource_lRec.GET(Processingby_gCod);// not found
                            end;
                        end else begin
                            ProcessingbyName_gTxt := Resource_lRec.Name;
                        end;
                    end;
                }
                field(ProcessingbyName_gTxt; ProcessingbyName_gTxt)
                {
                    CaptionML = DEU = 'Bearbeitung durch Name',
                                ENU = 'Processing by Name';
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field(ProcessingBy_Ctl; ProcessingBy_gTxt)
                {
                    CaptionML = DEU = 'Bearbeitung durch',
                                ENU = 'Processing by';

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Resource_lRec: Record Resource;
                    begin
                        if Resource_lRec.GET(Processingby_gCod) then;
                        if PAGE.RUNMODAL(0, Resource_lRec) = ACTION::LookupOK then begin
                            if CurrPage.EDITABLE = true then begin
                                ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                                Processingby_gCod := Resource_lRec."No.";
                            end;
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Resource_lRec: Record Resource;
                    begin
                        if not Resource_lRec.GET(ProcessingBy_gTxt) then begin
                            Resource_lRec.SETFILTER("Search Name", '*' + ProcessingBy_gTxt + '*');
                            if Resource_lRec.COUNT = 1 then begin
                                Resource_lRec.FINDFIRST;
                                ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                                Processingby_gCod := Resource_lRec."No.";
                            end else begin
                                if not Resource_lRec.FINDFIRST then begin
                                    Resource_lRec.SETRANGE("Search Name");
                                end;
                                if PAGE.RUNMODAL(0, Resource_lRec) = ACTION::LookupOK then begin
                                    if CurrPage.EDITABLE = true then begin
                                        ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                                        Processingby_gCod := Resource_lRec."No.";
                                    end;
                                end;
                            end;
                        end else begin
                            ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
                            Processingby_gCod := Resource_lRec."No.";
                        end;
                    end;
                }
            }
            group(Notes)
            {
                CaptionML = DEU = 'Notizen',
                            ENU = 'Notes';
                field(EditText; EditText)
                {
                    MultiLine = true;

                    trigger OnValidate();
                    begin
                        TextChanged := true;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        EditText: Text;
        TextChanged: Boolean;
        TextLength: Integer;
        TextLengthHeadline: Integer;
        ProcessLength: Integer;
        HeadLineProcessed: Boolean;
        //        strC : DotNet "'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.StringCollection";
        chr10: Char;
        chr13: Char;
        chr32: Char;
        t10: Text[1];
        t13: Text[1];
        t32: Text[1];
        testStringContent: Text;
        TRIM000: TextConst DEU = 'No Text available.', ENU = 'No Text available.';
        ShortDescription_gTxt: Text;
        Status_gCod: Code[20];
        PlannedDate_gDat: Date;
        FixedDate_gDat: Date;
        WaitingOnCustomer_gBln: Boolean;
        Priority_gOpt: Option;
        RemainingQuantity_gDec: Decimal;
        Processingby_gCod: Code[20];
        ProcessingbyName_gTxt: Text;
        ProcessingBy_gTxt: Text;

    procedure SetText(Text_par: Text);
    begin
        EditText := EditText + Text_par;
    end;

    procedure LineBreak() linebreak_ret: Text[2];
    begin
        linebreak_ret := FORMAT(chr13) + FORMAT(chr10);
        exit(linebreak_ret);
    end;

    procedure TextUpdated(): Boolean;
    begin
        exit(TextChanged);
    end;

    procedure SetBodyLength(Length_par: Integer);
    begin
        TextLength := Length_par;
    end;

    procedure SetHeadlineLength(Length_par: Integer);
    begin
        TextLengthHeadline := Length_par;
    end;

    // procedure "Count"() NoOfIndex_ret : Integer;
    // var
    //     RemainderText_loc : Text;
    //     OrgLength_loc : Integer;
    //     RestLength_loc : Integer;
    // begin
    //     if ISNULL(strC) then
    //       strC := strC.StringCollection();
    //     OrgLength_loc := STRLEN(EditText);
    //     RestLength_loc := OrgLength_loc;
    //     RemainderText_loc := EditText;
    //     if TextLengthHeadline > 0 then
    //       HeadLineProcessed := false
    //     else
    //       HeadLineProcessed := true;
    //     while (RestLength_loc >0) do begin
    //       if not HeadLineProcessed then
    //         ProcessLength := TextLengthHeadline
    //       else
    //         ProcessLength := TextLength;
    //       if STRPOS(RemainderText_loc,t10) > 0 then begin
    //         if STRLEN(COPYSTR(RemainderText_loc,1,STRPOS(RemainderText_loc,t10))) < ProcessLength then begin
    //           strC.Add(COPYSTR(RemainderText_loc,1,STRPOS(RemainderText_loc,t10)))
    //         end else begin
    //           AddChunck(COPYSTR(RemainderText_loc,1,(STRPOS(RemainderText_loc,t10))),ProcessLength);
    //         end;
    //         RemainderText_loc := COPYSTR(RemainderText_loc,STRPOS(RemainderText_loc,t10)+1);
    //         RestLength_loc := STRLEN(RemainderText_loc);
    //       end else begin
    //         if STRLEN(RemainderText_loc) < ProcessLength then
    //           strC.Add(RemainderText_loc)
    //         else begin
    //           AddChunck(RemainderText_loc, ProcessLength)
    //         end;
    //         RestLength_loc := 0;
    //       end;
    //       if not HeadLineProcessed then
    //         HeadLineProcessed := true;
    //     end;
    //     exit(strC.Count)
    // end;

    // procedure GetText(Index_par : Integer) Text_ret : Text;
    // begin
    //     if (strC.Count > 0) then
    //       exit(strC.Item(Index_par-1))
    //     else
    //       ERROR(TRIM000);
    // end;

    procedure GetFullText() Text_ret: Text;
    begin
        Text_ret := EditText;
    end;

    local procedure BreakLine(text_par: Text; pos_par: Integer; max_par: Integer) newLineLength: Integer;
    var
        i_loc: Integer;
        Half50Pct_loc: Integer;
        BreakLoop_loc: Boolean;
    begin
        i_loc := max_par;
        while ((i_loc >= 0) and (not (COPYSTR(text_par, pos_par + i_loc, 1) = t32)) and (not BreakLoop_loc)) do begin
            i_loc := i_loc - 1;
            if i_loc < 0 then begin
                i_loc := 0;
                BreakLoop_loc := true;
            end;
        end;
        BreakLoop_loc := false;
        if (i_loc <= 0) then begin
            if max_par > 5 then
                exit(max_par - 3)
            else
                exit(max_par);
        end;
        while ((i_loc >= 0) and (COPYSTR(text_par, pos_par + i_loc, 1) = t32)) do begin
            i_loc := i_loc - 1;
            if i_loc < 0 then begin
                i_loc := 0;
                BreakLoop_loc := true;
            end;
        end;

        Half50Pct_loc := ROUND(max_par / 2, 1, '>');
        if i_loc + 1 < Half50Pct_loc then begin
            if (STRPOS(text_par, '-') > 0) and
               (STRPOS(text_par, '-') > Half50Pct_loc)
            then
                exit(STRPOS(text_par, '-'));
            if max_par > 5 then
                exit(max_par - 3);
        end else begin
            if i_loc + 2 > max_par then
                exit(i_loc + 1)
            else
                exit(i_loc + 2);
        end;
    end;

    // local procedure AddChunck(Text_par : Text;Length_par : Integer);
    // var
    //     BreakPoint_loc : Integer;
    // begin
    //     while STRLEN(Text_par) >= Length_par do begin
    //       BreakPoint_loc:=BreakLine(Text_par,1,Length_par);
    //       testStringContent := COPYSTR(Text_par,1,BreakPoint_loc);
    //       strC.Add(COPYSTR(Text_par,1,BreakPoint_loc));
    //       Text_par := COPYSTR(Text_par,BreakPoint_loc+1);
    //       Length_par := TextLength;
    //       if STRLEN(Text_par) < Length_par then
    //         strC.Add(Text_par);
    //     end;
    // end;

    local procedure InitChars();
    begin
        chr10 := 10;
        chr13 := 13;
        chr32 := 32;
        EVALUATE(t10, FORMAT(chr10));
        EVALUATE(t13, FORMAT(chr13));
        EVALUATE(t32, FORMAT(chr32));
    end;

    procedure SetTable_gFnc(var JobTaskDetail_vRec: Record "Job Task Detail");
    var
        Resource_lRec: Record Resource;
    begin
        INIT;
        "Job Task Detail ID" := JobTaskDetail_vRec."Job Task Detail ID";
        "Job No." := JobTaskDetail_vRec."Job No.";
        "Job Task No." := JobTaskDetail_vRec."Job Task No.";

        ShortDescription_gTxt := JobTaskDetail_vRec."Short Description";
        Status_gCod := JobTaskDetail_vRec.Status;
        PlannedDate_gDat := JobTaskDetail_vRec."Planned Date";
        FixedDate_gDat := JobTaskDetail_vRec."Fixed Date";
        WaitingOnCustomer_gBln := JobTaskDetail_vRec."Waiting on Customer";
        Priority_gOpt := JobTaskDetail_vRec.Priority;
        RemainingQuantity_gDec := JobTaskDetail_vRec."Remaining Quantity";
        Processingby_gCod := JobTaskDetail_vRec."Processing by";
        ProcessingBy_gTxt := '';
        if Resource_lRec.GET(Processingby_gCod) then begin
            ProcessingBy_gTxt := '[' + Resource_lRec."No." + '] ' + Resource_lRec.Name;
        end;

        INSERT;
    end;

    procedure GetTable_gFnc(var JobTaskDetail_TMP_vRec: Record "Job Task Detail" temporary);
    begin
        JobTaskDetail_TMP_vRec."Short Description" := ShortDescription_gTxt;
        JobTaskDetail_TMP_vRec.Status := Status_gCod;
        JobTaskDetail_TMP_vRec."Planned Date" := PlannedDate_gDat;
        JobTaskDetail_TMP_vRec."Fixed Date" := FixedDate_gDat;
        JobTaskDetail_TMP_vRec."Waiting on Customer" := WaitingOnCustomer_gBln;
        JobTaskDetail_TMP_vRec.Priority := Priority_gOpt;
        JobTaskDetail_TMP_vRec."Remaining Quantity" := RemainingQuantity_gDec;
        JobTaskDetail_TMP_vRec."Processing by" := Processingby_gCod;
    end;
}

