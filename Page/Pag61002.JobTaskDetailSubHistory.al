/// <summary>
/// Page Job Task Detail Sub History (ID 50044).
/// </summary>
page 61002 "Job Task Detail Sub History"
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

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Job Task Detail History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LastDate; Rec.LastDate)
                {
                    Editable = false;
                }
                field(User; Rec.User)
                {
                    Editable = false;
                }
                field("Field"; Rec.Field)
                {
                    Editable = false;
                }
                field(Change; Rec.Change)
                {
                    Editable = false;
                }
                field("Short Note"; Rec."Short Note")
                {

                    /*  trigger OnAssistEdit();
                     begin
                         Open_ShortNote_lFnc;
                     end; */

                    trigger OnValidate();
                    begin
                        //IF User <> USERID THEN
                        //  ERROR(Text001_gCtx);
                    end;
                }
                field("User Note Date"; Rec."User Note Date")
                {
                    Visible = false;
                }
                field("Processing by changed"; Rec."Processing by changed")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001_gCtx: TextConst DEU = 'Dieser Kommentar kann nur durch den User der Zeile geändert werden.', ENU = 'User Note can only be changed by the user of this line.';
        TRIM001: TextConst DEU = 'Es können keine weiteren Zeilen eingefügt werden.', ENU = 'You cannot insert more lines.';

    /*     local procedure Open_ShortNote_lFnc();
        var
            EditPage_lPag: Page "TRIMIT Text editor";
            V_lTxt: Text;
            Text001_gCtx: TextConst DEU = 'Dieser Kommentar kann nur durch den User der Zeile geändert werden.', ENU = 'User Note can only be changed by the user of this line.';
            JobTaskDetail_lRec: Record "Job Task Detail";
        begin
            V_lTxt := GetBLOBText_gFnc(Rec);
            EditPage_lPag.SetText(V_lTxt);
            if EditPage_lPag.RUNMODAL = ACTION::OK then begin
                if EditPage_lPag.TextUpdated then begin
                    if (Rec.User <> USERID)
                    and (Rec.User <> JobTaskDetail_lRec.GetUser_gFnc('')) then begin
                        ERROR(Text001_gCtx);
                    end;
                    V_lTxt := EditPage_lPag.GetFullText;
                    //EditPage_lPag.GetFullText_gFnc(V_lTxt);
                    InsertBLOBText_gFnc(Rec, V_lTxt);
                end;
            end;
        end; */

    /// <summary>
    /// GetBLOBText_gFnc.
    /// </summary>
    /// <param name="JobTaskDetailHistory_vRec">VAR Record "Job Task Detail History".</param>
    /// <returns>Return variable Text_rTxt of type Text.</returns>
    procedure GetBLOBText_gFnc(var JobTaskDetailHistory_vRec: Record "Job Task Detail History") Text_rTxt: Text;
    var
        JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
        lc_InStream: InStream;
        lc_Text: Text;
        chr10_lChr: Char;
        chr13_lChr: Char;
        chr32_lChr: Char;
        LB_lTxt: Text;
    begin
        Text_rTxt := '';
        if not JobTaskDetailHistory_vRec."Long Note".HASVALUE then begin
            exit('');
        end;
        chr10_lChr := 10;
        chr13_lChr := 13;
        LB_lTxt := FORMAT(chr13_lChr) + FORMAT(chr10_lChr);
        JobTaskDetailHistory_vRec.CALCFIELDS("Long Note");
        JobTaskDetailHistory_vRec."Long Note".CREATEINSTREAM(lc_InStream);
        while not lc_InStream.EOS do begin
            lc_InStream.READTEXT(lc_Text);
            if Text_rTxt > '' then begin
                Text_rTxt += LB_lTxt;
            end;
            Text_rTxt += lc_Text;
        end;
    end;

    /// <summary>
    /// InsertBLOBText_gFnc.
    /// </summary>
    /// <param name="JobTaskDetailHistory_vRec">VAR Record "Job Task Detail History".</param>
    /// <param name="Text_iTxt">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure InsertBLOBText_gFnc(var JobTaskDetailHistory_vRec: Record "Job Task Detail History"; Text_iTxt: Text): Boolean;
    var
        lc_OutStream: OutStream;
        V_lTxt: Text;
        CR_lChr: Char;
        LF_lChr: Char;
    begin
        CLEAR(JobTaskDetailHistory_vRec."Long Note");
        JobTaskDetailHistory_vRec."Long Note".CREATEOUTSTREAM(lc_OutStream);
        //JobTaskDetailHistory_vRec."Short Note":= COPYSTR(Text_iTxt,1,100);
        CR_lChr := 13;
        LF_lChr := 10;
        V_lTxt := CONVERTSTR(Text_iTxt, FORMAT(CR_lChr), ' ');
        V_lTxt := CONVERTSTR(Text_iTxt, FORMAT(LF_lChr), ' ');
        JobTaskDetailHistory_vRec."Short Note" := COPYSTR(V_lTxt, 1, 100);

        lc_OutStream.WRITETEXT(Text_iTxt);
        JobTaskDetailHistory_vRec."User Note Date" := CURRENTDATETIME;
        JobTaskDetailHistory_vRec."Has Note" := true;
        JobTaskDetailHistory_vRec.MODIFY;
    end;
}

