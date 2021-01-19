/* page 61022 "TRIMIT Text editor"
{
    // version T7.0

    CaptionML = DEU = 'TRIMIT Text Editor',
                ENU = 'TRIMIT Text Editor';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;

    layout
    {
        area(content)
        {
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

    actions
    {
    }

    trigger OnInit();
    begin
        InitChars;
    end;

    var
        EditText: Text;
        TextChanged: Boolean;
        TextLength: Integer;
        TextLengthHeadline: Integer;
        ProcessLength: Integer;
        HeadLineProcessed: Boolean;
        strC: DotNet "'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.StringCollection";
        chr10: Char;
        chr13: Char;
        chr32: Char;
        t10: Text[1];
        t13: Text[1];
        t32: Text[1];
        TRIM000: TextConst DEU = 'No Text available.', ENU = 'No Text available.';
        testStringContent: Text;

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

    procedure "Count"() NoOfIndex_ret: Integer;
    var
        RemainderText_loc: Text;
        OrgLength_loc: Integer;
        RestLength_loc: Integer;
    begin
        if ISNULL(strC) then
            strC := strC.StringCollection();
        OrgLength_loc := STRLEN(EditText);
        RestLength_loc := OrgLength_loc;
        RemainderText_loc := EditText;
        if TextLengthHeadline > 0 then
            HeadLineProcessed := false
        else
            HeadLineProcessed := true;
        while (RestLength_loc > 0) do begin
            if not HeadLineProcessed then
                ProcessLength := TextLengthHeadline
            else
                ProcessLength := TextLength;
            if STRPOS(RemainderText_loc, t10) > 0 then begin
                if STRLEN(COPYSTR(RemainderText_loc, 1, STRPOS(RemainderText_loc, t10))) < ProcessLength then begin
                    strC.Add(COPYSTR(RemainderText_loc, 1, STRPOS(RemainderText_loc, t10)))
                end else begin
                    AddChunck(COPYSTR(RemainderText_loc, 1, (STRPOS(RemainderText_loc, t10))), ProcessLength);
                end;
                RemainderText_loc := COPYSTR(RemainderText_loc, STRPOS(RemainderText_loc, t10) + 1);
                RestLength_loc := STRLEN(RemainderText_loc);
            end else begin
                if STRLEN(RemainderText_loc) < ProcessLength then
                    strC.Add(RemainderText_loc)
                else begin
                    AddChunck(RemainderText_loc, ProcessLength)
                end;
                RestLength_loc := 0;
            end;
            if not HeadLineProcessed then
                HeadLineProcessed := true;
        end;
        exit(strC.Count)
    end;

    procedure GetText(Index_par: Integer) Text_ret: Text;
    begin
        if (strC.Count > 0) then
            exit(strC.Item(Index_par - 1))
        else
            ERROR(TRIM000);
    end;

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

    local procedure AddChunck(Text_par: Text; Length_par: Integer);
    var
        BreakPoint_loc: Integer;
    begin
        while STRLEN(Text_par) >= Length_par do begin
            BreakPoint_loc := BreakLine(Text_par, 1, Length_par);
            testStringContent := COPYSTR(Text_par, 1, BreakPoint_loc);
            strC.Add(COPYSTR(Text_par, 1, BreakPoint_loc));
            Text_par := COPYSTR(Text_par, BreakPoint_loc + 1);
            Length_par := TextLength;
            if STRLEN(Text_par) < Length_par then
                strC.Add(Text_par);
        end;
    end;

    local procedure InitChars();
    begin
        chr10 := 10;
        chr13 := 13;
        chr32 := 32;
        EVALUATE(t10, FORMAT(chr10));
        EVALUATE(t13, FORMAT(chr13));
        EVALUATE(t32, FORMAT(chr32));
    end;
}

 */