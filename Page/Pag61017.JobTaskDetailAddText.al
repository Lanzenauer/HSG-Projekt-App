page 61017 "Job Task Detail Add. Text"
{
    // version JOB

    // ACMT8.00.01 17.12.15/ACMT/OSH - Previous (direct I/O) code replaced by call to the function from Text Mgmt
    // 
    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 130917  HSG_01  FC  Get plain text

    CaptionML = DEU = 'Extension Zusatztext',
                ENU = 'Extension Additional Text';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Integer";
    SourceTableView = SORTING(Number)
                      WHERE(Number = CONST(1));

    layout
    {
        area(content)
        {
            group(Control1000000000)
            {
                field(HTMLText; AddText)
                {
                    //The property ControlAddIn is not yet supported. Please convert manually.
                    //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.Acommit.Extension.TextEditor;PublicKeyToken=b225e09643a54969';
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
    }

    // trigger OnAfterGetCurrRecord();
    // begin
    //     if LastRecID <> RecID then
    //         LoadHTMLText();
    //     LastRecID := RecID;
    // end;

    // trigger OnAfterGetRecord();
    // begin
    //     LoadHTMLText;
    // end;

    // trigger OnInit();
    // begin
    //     HSGSetup_gRec.GET;
    //     editable_gBol := true;
    // end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    // begin
    //     CurrPage.HTMLText.BodyHtml('');
    // end;

    // trigger OnNewRecord(BelowxRec: Boolean);
    // begin
    //     CurrPage.HTMLText.BodyHtml('');
    // end;

    var
        RecID: RecordID;
        AddText: Text;
        TextNo_gInt: Integer;
        DocNo_gInt: Integer;
        LastRecID: RecordID;
        Job_gCod: Code[20];
        JobTask_gCod: Code[20];
        ShortDesc_gTxt: Text[100];
        HSGSetup_gRec: Record "HSG Add. Setup";
        JobDetail_gRec: Record "Job Task Detail";
        editable_gBol: Boolean;

    // local procedure LoadHTMLText();
    // begin
    //     AddText := '';

    //     //ACMT8.00.01 17.12.15/ACMT/OSH
    //     //ExtTextMgmt_gCdu.GetBLOBText(RecID,TextNo,DocNo,ExtTextMgmt_gCdu.HTML,AddText);
    //     GetBLOBText_lFnc(AddText);

    //     CurrPage.HTMLText.BodyHtml(AddText);
    //     //CurrPage.UPDATE(FALSE);
    //     //MESSAGE('ja');
    // end;

    // local procedure SaveHTMLText();
    // var
    //     lc_OutStr: OutStream;
    //     Regex_lDot: DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
    //     V_lTxt: Text;
    //     test1: DotNet "'System.Web.RegularExpressions, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.RegularExpressions.RunatServerRegex";
    //     RegExOptions_lDot: DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.RegexOptions";
    //     test2: DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
    // begin
    //     AddText := CurrPage.HTMLText.BodyHtml();

    //     //ACMT8.00.01 17.12.15/ACMT/OSH
    //     // -HSG_01
    //     //ExtTextMgmt_gCdu.InsertBLOBText(RecID,TextNo,DocNo,ExtTextMgmt_gCdu.HTML,AddText);
    //     //V_lTxt:= Regex_lDot.Replace(AddText,'[^A-Za-z0-9]','');
    //     V_lTxt := Regex_lDot.Replace(AddText, '<[^>]*>', '');
    //     V_lTxt := Regex_lDot.Replace(V_lTxt, '\s+', ' ');
    //     //V_lTxt:= Regex_lDot.Replace(V_lTxt,'&lt;(.*?)&lt;','');
    //     //V_lTxt:= Regex_lDot.Replace(V_lTxt,'<\\S[^><]*>','');
    //     V_lTxt := Regex_lDot.Replace(V_lTxt, '&lt;', '<');
    //     V_lTxt := Regex_lDot.Replace(V_lTxt, '&gt;', '>');

    //     InsertBLOBText_lFnc(AddText, V_lTxt);
    //     // +HSG_01
    // end;

    procedure SetRecordInformation_gFnc(_TableID: Integer; _Position: Text; _TextNo: Integer; _DocNo: Integer; Job_iCod: Code[20]; JobTask_iCod: Code[20]; ShortDesc_iTxt: Text[100]);
    var
        lc_RecRef: RecordRef;
    begin
        CLEAR(lc_RecRef);
        lc_RecRef.OPEN(_TableID);
        lc_RecRef.SETPOSITION(_Position);

        CLEAR(LastRecID);
        RecID := lc_RecRef.RECORDID;
        TextNo_gInt := _TextNo;
        DocNo_gInt := _DocNo;
        Job_gCod := Job_iCod;
        JobTask_gCod := JobTask_iCod;
        ShortDesc_gTxt := ShortDesc_iTxt;
        CurrPage.UPDATE(false);
    end;

    // procedure UpdatePage_gFnc();
    // begin
    //     LoadHTMLText;
    //     //CurrPage.UPDATE();
    // end;

    procedure FindSet_gFnc();
    begin
        FINDSET;
        CurrPage.UPDATE(false);
    end;

    procedure GetBLOBText_lFnc(var Text_vTxt: Text): Boolean;
    var
        JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
        lc_InStream: InStream;
        lc_Text: Text;
    begin
        Text_vTxt := '';
        if DocNo_gInt = 0 then
            exit(false);
        if JobTaskDetailBlob_lRec.GET(DocNo_gInt) then begin
            if TextNo_gInt = 0 then begin
                if not JobTaskDetailBlob_lRec."Description Blob".HASVALUE then begin
                    exit(false);
                end;
                JobTaskDetailBlob_lRec.CALCFIELDS("Description Blob");
                JobTaskDetailBlob_lRec."Description Blob".CREATEINSTREAM(lc_InStream);
                while not lc_InStream.EOS do begin
                    lc_InStream.READTEXT(lc_Text);
                    Text_vTxt += lc_Text;
                end;
            end else begin
                if not JobTaskDetailBlob_lRec."Solution Blob".HASVALUE then begin
                    exit(false);
                end;
                JobTaskDetailBlob_lRec.CALCFIELDS("Solution Blob");
                JobTaskDetailBlob_lRec."Solution Blob".CREATEINSTREAM(lc_InStream);
                while not lc_InStream.EOS do begin
                    lc_InStream.READTEXT(lc_Text);
                    Text_vTxt += lc_Text;
                end;
            end;
        end;
    end;

    procedure InsertBLOBText_lFnc(Blob_iTxt: Text; Text_iTxt: Text): Boolean;
    var
        JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
        lc_OutStream: OutStream;
    begin
        //ACMT8.00.01 17.12.15/ACMT/OSH
        //IF _Text = '' THEN
        //  EXIT;
        if DocNo_gInt = 0 then
            exit(false);
        if not JobTaskDetailBlob_lRec.GET(DocNo_gInt) then begin
            if Blob_iTxt = '' then
                exit(false);
            //IF TextNo_gInt = 0 THEN BEGIN
            JobTaskDetailBlob_lRec.INIT;
            JobTaskDetailBlob_lRec."Job Task Detail ID" := DocNo_gInt;
            JobTaskDetailBlob_lRec."Job No." := Job_gCod;
            JobTaskDetailBlob_lRec."Job Task No." := JobTask_gCod;
            JobTaskDetailBlob_lRec.INSERT;
        end;

        if TextNo_gInt = 0 then begin
            CLEAR(JobTaskDetailBlob_lRec."Description Blob");
            JobTaskDetailBlob_lRec."Description Blob".CREATEOUTSTREAM(lc_OutStream);
            JobTaskDetailBlob_lRec."Description Text" := COPYSTR(Text_iTxt, 1, 250);
        end else begin
            CLEAR(JobTaskDetailBlob_lRec."Solution Blob");
            JobTaskDetailBlob_lRec."Solution Blob".CREATEOUTSTREAM(lc_OutStream);
            JobTaskDetailBlob_lRec."Solution Text" := COPYSTR(Text_iTxt, 1, 250);
        end;
        lc_OutStream.WRITETEXT(Blob_iTxt);
        JobTaskDetailBlob_lRec."Import Datetime" := CURRENTDATETIME;
        JobTaskDetailBlob_lRec."Short Description" := ShortDesc_gTxt;
        JobTaskDetailBlob_lRec.MODIFY;
    end;

    //event HTMLText();
    //begin
    /*
    LoadHTMLText();
    */
    //end;

    //event HTMLText();
    //begin
    /*

    SaveHTMLText();
    */
    //end;
}

