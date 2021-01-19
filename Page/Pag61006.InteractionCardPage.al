page 61006 "Interaction Card Page"
{
    // version HSG

    // 310720  HSG_01  CH  Code correction due to file access issues

    CaptionML = DEU = 'Aktivität Mail Info Box',
                ENU = 'Ineraction Mail Info Box';
    PageType = CardPart;
    SourceTable = "Interaction Log Entry";

    layout
    {
        area(content)
        {
            field(URL_Browser; URL_gTxt)
            {
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'BrowserAddIn;PublicKeyToken=e44e2ec27e697fcb';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Update)
            {
                CaptionML = DEU = '&Aktualisieren',
                            ENU = 'F&unctions';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Update_lFnc;
                end;
            }
        }
    }

    trigger OnInit();
    begin
        URL_gTxt := 'https://www.hansesolution.com';

        AddSetup_gRec.GET;
    end;

    var
        Mail_Body_gTxt: Text;
        URL_gTxt: Text;
        AddSetup_gRec: Record "HSG Add. Setup";

    local procedure Update_lFnc();
    var
        InStr_lIsr: InStream;
        OutStr_lOsr: OutStream;
        TMP_lTxt: Text;
        TMP_FILE_lFil: File;
        FilePathName_lTxt: Text;
        LocalPath_lTxt: Text;
        FileMgt_lCdu: Codeunit "File Management";
    begin
        CLEAR(Mail_Body_gTxt);
        CALCFIELDS("E-Mail Body Text");
        if "E-Mail Body Text".HASVALUE then begin
            AddSetup_gRec.TESTFIELD("TEMP File Folder");
            ;
            CLEAR(InStr_lIsr);
            "E-Mail Body Text".CREATEINSTREAM(InStr_lIsr);
            LocalPath_lTxt := AddSetup_gRec."TEMP File Folder"; // Temp files need to be deleted
                                                                // -HSG_01
            if not FileMgt_lCdu.ClientDirectoryExists(LocalPath_lTxt) then
                FileMgt_lCdu.CreateClientDirectory(LocalPath_lTxt);
            // +HSG_01
            FilePathName_lTxt := LocalPath_lTxt + DELCHR(FORMAT(CREATEGUID), '=', '{}') + '.html';
            TMP_FILE_lFil.CREATE(FilePathName_lTxt);
            TMP_FILE_lFil.CREATEOUTSTREAM(OutStr_lOsr);
            COPYSTREAM(OutStr_lOsr, InStr_lIsr);
            TMP_FILE_lFil.CLOSE;
            FileMgt_lCdu.DownloadToFile(FilePathName_lTxt, FilePathName_lTxt); // HSG_01
            URL_gTxt := 'file:///' + FilePathName_lTxt;
            CurrPage.UPDATE;
        end;
    end;
}

