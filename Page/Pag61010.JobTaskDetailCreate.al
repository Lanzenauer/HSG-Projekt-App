page 61010 "Job Task Detail Create"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 130918  JOB_01  NM  Created
    // 170918  JOB_02  NM  Add Filter "not in statistic"

    CaptionML = DEU = 'Aufgabe erstellen',
                ENU = 'Create Job Journal Line';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Allgemein)
            {
                field(JobNo_gCod; JobNo_gCod)
                {
                    CaptionML = DEU = 'Projektnummer',
                                ENU = 'Job No.';
                    Lookup = true;
                    LookupPageID = "Job List";
                    TableRelation = Job."No.";

                    trigger OnValidate();
                    begin
                        JobTaskNo_gCod := JobTaskDetailMgnt_gCu.SetSupportTask_gFnc(JobNo_gCod);
                    end;
                }
                field(JobTaskNo_gCod; JobTaskNo_gCod)
                {
                    CaptionML = DEU = 'Projekt Aufgabe',
                                ENU = 'Job Task';
                    TableRelation = "Job Task"."Job Task No.";

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        JobTaskNo_lRec: Record "Job Task";
                    begin
                        CLEAR(JobTaskNo_lRec);
                        JobTaskNo_lRec.SETRANGE("Job No.", JobNo_gCod);
                        if PAGE.RUNMODAL(0, JobTaskNo_lRec) = ACTION::LookupOK then begin
                            JobTaskNo_gCod := JobTaskNo_lRec."Job Task No.";
                            Text := JobTaskNo_gCod;
                            exit(true);
                        end;
                    end;

                    trigger OnValidate();
                    var
                        JobTaskNo_lRec: Record "Job Task";
                    begin
                        if JobTaskNo_gCod <> '' then
                            JobTaskNo_lRec.GET(JobNo_gCod, JobTaskNo_gCod);
                    end;
                }
                field(Description_gTxt; Description_gTxt)
                {
                    Caption = 'Beschreibung';
                }
                field(RessourceID_gCod; RessourceID_gCod)
                {
                    Caption = 'Bearbeitung durch';
                    Lookup = true;
                    LookupPageID = "Resource List";
                    TableRelation = Resource."No." WHERE("Show in Statistics" = CONST(true));
                }
            }
        }
    }

    actions
    {
    }

    var
        "--- HSG ---": Boolean;
        Resource_gRec: Record Resource;
        Description_gTxt: Text[250];
        Job_gRec: Record Job;
        JobNo_gCod: Code[20];
        RessourceID_gCod: Code[20];
        JobTaskNo_gCod: Code[20];
        JobTaskDetailMgnt_gCu: Codeunit "Job Task Detail Mgnt.";

    local procedure "--- HSG Functions ---"();
    begin
    end;

    procedure GetValues_gFnc(var JobNo_vCod: Code[20]; var Description_vTxt: Text[250]; var RessourceID_vCod: Code[20]; var JobTaskNo_vCod: Code[20]);
    begin
        JobNo_vCod := JobNo_gCod;
        Description_vTxt := Description_gTxt;
        RessourceID_vCod := RessourceID_gCod;
        JobTaskNo_vCod := JobTaskNo_gCod;
    end;

    procedure SetValues_gFnc(InteractionLogEntry_iRec: Record "Interaction Log Entry");
    begin
        Description_gTxt := InteractionLogEntry_iRec.Description;
        RessourceID_gCod := JobTaskDetailMgnt_gCu.SetRessourceID_gFnc();
    end;
}

