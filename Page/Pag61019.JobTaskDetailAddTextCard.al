page 61019 "Job Task Detail Add. Text Card"
{
    // version JOB

    DataCaptionExpression = DescriptionSolution_gTxt + ': ' + FORMAT("Job Task Detail ID") + ' - ' + "Job Task Description" + ' - ' + "Short Description";
    PageType = Card;
    SourceTable = "Job Task Detail";

    layout
    {
        area(content)
        {
            part(Description_Ctl; "Job Task Detail Add. Text")
            {
                CaptionML = DEU = 'Beschreibung',
                            ENU = 'Description';
                ShowFilter = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        CALCFIELDS("Job Task Description");
        UpdateDescriptionSolution_lFnc(false);
    end;

    var
        DescriptionSolution_gTxt: Text;
        Description_gCtx: TextConst DEU = 'Beschreibung', ENU = 'Description';
        Solution_gCtx: TextConst DEU = 'Lösung', ENU = 'Solution';
        ShowDescription_gBln: Boolean;

    local procedure UpdateDescriptionSolution_lFnc(CurrPageUpdate_iBln: Boolean);
    var
        Position_lTxt: Text;
        TextNo_lInt: Integer;
    begin
        Position_lTxt := GETPOSITION(false);
        if ShowDescription_gBln then begin
            TextNo_lInt := 0;
        end else begin
            TextNo_lInt := 1;
        end;
        CurrPage.Description_Ctl.PAGE.SetRecordInformation_gFnc(DATABASE::"Job Task Detail", Position_lTxt, TextNo_lInt, "Job Task Detail ID", "Job No.", "Job Task No.", "Short Description");
        //CurrPage.Solution_Ctl.PAGE.SetRecordInformation_gFnc(DATABASE::"Job Task Detail", Position_lTxt, TextNo_lInt, "Job Task Detail ID","Job No.","Job Task No.","Short Description");
        //CurrPage.Description_Ctl.PAGE.UpdatePage_gFnc;
        if CurrPageUpdate_iBln then begin
            CurrPage.UPDATE(true);
        end;
    end;

    procedure SetDescriptionSolution_gFnc(JobTaskDetail_iRec: Record "Job Task Detail"; ShowDescription_iBln: Boolean);
    var
        Position_lTxt: Text;
        JobTaskDetailAddTextCard_lPag: Page "Job Task Detail Add. Text Card";
        TextNo_lInt: Integer;
    begin
        ShowDescription_gBln := ShowDescription_iBln;
        if ShowDescription_iBln then begin
            TextNo_lInt := 0;
            DescriptionSolution_gTxt := Description_gCtx;
        end else begin
            TextNo_lInt := 1;
            DescriptionSolution_gTxt := Solution_gCtx;
        end;
    end;
}

