page 61026 "Job Task Detail Jnl. Batch cre"
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
    // 191018  HSG_02  NM  Add Job Task Detail ID in description
    // 231018  HSG_03  CH  E-Mail prefix and posfix from HSG Function

    CaptionML = DEU = 'Projekt Buch.-Blatt erstellen',
                ENU = 'Create Job Journal Line';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field("JobJournalBatch_gRec.Name"; JobJournalBatch_gRec.Name)
                {
                    Caption = 'Buch.-Blattname';
                    TableRelation = "Job Journal Batch".Name WHERE("Journal Template Name" = CONST('PROJEKT'));
                }
            }
            group(Control1000000006)
            {
                field(Description_gTxt; Description_gTxt)
                {
                    Caption = 'Beschreibung';
                }
                field(Quantity_gDec; Quantity_gDec)
                {
                    Caption = 'Menge';
                }
                field(Chargeable_gBln; Chargeable_gBln)
                {
                    Caption = 'Fakturierbar';
                }
                field(Date_gDat; Date_gDat)
                {
                    Caption = 'Datum';
                }
            }
        }
    }

    actions
    {
    }

    var
        "--- HSG ---": Boolean;
        JobJournalBatch_gRec: Record "Job Journal Batch";
        Resource_gRec: Record Resource;
        JournalBatchName_gCod: Code[10];
        Description_gTxt: Text[250];
        Quantity_gDec: Decimal;
        Chargeable_gBln: Boolean;
        Date_gDat: Date;
        HSG_Funcs_gCdu: Codeunit "HSG Functions";

    local procedure "--- HSG Functions ---"();
    begin
    end;

    procedure GetValues_gFnc(var BatchName_vCod: Code[10]; var Description_vTxt: Text[250]; var Quantity_vDec: Decimal; var Chargeable_vBln: Boolean; var Date_vDat: Date);
    begin
        BatchName_vCod := JobJournalBatch_gRec.Name;
        Description_vTxt := Description_gTxt;
        Quantity_vDec := Quantity_gDec;
        Chargeable_vBln := Chargeable_gBln;
        Date_vDat := Date_gDat;
    end;

    procedure SetValues_gFnc(Resource_iRec: Record Resource);
    begin
        //Ressource übergeben
        Resource_gRec := Resource_iRec;
        JobJournalBatch_gRec.SETRANGE("Journal Template Name", 'PROJEKT');
        JobJournalBatch_gRec.SETRANGE(Description, Resource_iRec.Name);
        if JobJournalBatch_gRec.FINDSET then;
        Chargeable_gBln := true;
        Date_gDat := WORKDATE;
    end;

    procedure SetJournalDesc_gFnc(JobTaskDetail_vRec: Record "Job Task Detail");
    begin
        //-HSG_02
        // Description_gTxt := '##' + FORMAT(JobTaskDetail_vRec."Job Task Detail ID") + '##' + JobTaskDetail_vRec."Short Description"; // HSG_03
        Description_gTxt := HSG_Funcs_gCdu.HSG_EmailPrefix_gFnc + FORMAT(JobTaskDetail_vRec."Job Task Detail ID") + HSG_Funcs_gCdu.HSG_EmailPostfix_gFnc + JobTaskDetail_vRec."Short Description"; // HSG_03
        //+HSG_02
    end;
}

