codeunit 61099 "Editor page Handling"
{
    // version T8.0,HSG

    // //Declare the Editpage a variable
    // //functions:
    // //SetText(Text_par) - will append a text to the texteditor.
    // 
    // //GetFullText() : Text_ret  - this function will return the full text in on call
    // 
    // //GetText(Index_par) : Text_ret - The will return a text from the wrapped text by index position.
    // //If headline length is set - Index 1 will apply to that size.
    // 
    // //TextUpdated() - if true the user did change the text
    // 
    // //SetHeadlineLength(Length_par) - Sets the max size of the first string to return - the counter will split the text
    // //according to the size. This is used mainly for header/line situations.
    // //This parameter is not mandatory and if blank the Body size parameter is used.
    // 
    // //SetBodyLength(Length_par) - Sets the max size of stings to return - the counter will split the text
    // //according to the size.
    // 
    // //Count() : NoOfIndex_ret - returns the number of lines when split by the WrapLength set.
    // 
    // //LineBreak() : linebreak_ret - this function will return a linebreak can be used to insert linebreaks
    // //to the SetText function eg.
    // 
    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 080115  HSG_00  JS  Copied from TRIMIT
    // 150115  HSG_01  JS  corrected Job No and Job task no insert


    trigger OnRun();
    begin
    end;

    var
        TRIM001: TextConst DEU = 'Es können keine weiteren Zeilen eingefügt werden.', ENU = 'You cannot insert more lines.';

    procedure CallFromCommentLine(var commentLine_par: Record "Job Task Description"; new_par: Boolean);
    var
        i_loc: Integer;
        count_loc: Integer;
        fromLine_loc: Integer;
        toLine_loc: Integer;
        splitValue_loc: Decimal;
        commentLine_loc: Record "Job Task Description";
        commentLine2_loc: Record "Job Task Description";
        EditPage_loc: Page "TRIMIT Text editor";
    begin
        commentLine_loc.COPY(commentLine_par);
        if new_par then begin
            if commentLine_loc.FINDLAST then
                fromLine_loc := commentLine_loc."Line No.";
            fromLine_loc := fromLine_loc + 10000;
        end else begin
            fromLine_loc := commentLine_loc."Line No.";
            repeat
                toLine_loc := commentLine_loc."Line No.";
            until (commentLine_loc.NEXT = 0);
            if commentLine_loc."Line No." = toLine_loc then
                toLine_loc := 0
            else
                if fromLine_loc = toLine_loc then
                    toLine_loc := commentLine_loc."Line No." - 1;
        end;

        CLEAR(EditPage_loc);
        if toLine_loc <> 0 then
            commentLine_loc.SETRANGE("Line No.", fromLine_loc, toLine_loc)
        else
            commentLine_loc.SETFILTER("Line No.", '%1..', fromLine_loc);
        if commentLine_loc.FINDFIRST then
            repeat
                EditPage_loc.SetText(commentLine_loc.Description);
            until commentLine_loc.NEXT = 0;

        if EditPage_loc.RUNMODAL = ACTION::OK then begin
            EditPage_loc.SetHeadlineLength(80);
            EditPage_loc.SetBodyLength(50);
            if EditPage_loc.TextUpdated then begin
                count_loc := EditPage_loc.Count;
                if toLine_loc > 0 then
                    splitValue_loc := ROUND(((toLine_loc - fromLine_loc) / count_loc), 1, '<')
                else
                    splitValue_loc := 10000;
                if splitValue_loc = 0 then
                    ERROR(TRIM001);
                commentLine_loc.DELETEALL;
                for i_loc := 1 to count_loc do begin
                    commentLine_loc."Line No." := commentLine_par."Line No.";
                    commentLine_loc."Job No." := commentLine_par."Job No.";
                    commentLine_loc."Job Task No." := commentLine_par."Job Task No.";
                    commentLine_loc."Line No." := fromLine_loc + ((i_loc - 1) * splitValue_loc);
                    commentLine_loc.Description := EditPage_loc.GetText(i_loc);
                    commentLine_loc.INSERT;
                end;
            end;
        end;
    end;
}

