page 61009 "Job Task Detail Search"
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
    PageType = List;
    SourceTable = "Job Task Detail";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control1000000008)
            {
                field(JobFilter_gCod; JobFilter_gCod)
                {
                    CaptionML = DEU = 'Projekt Nr.',
                                ENU = 'Job No.';

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        Job_lRec: Record Job;
                    begin
                        if Job_lRec.GET(JobFilter_gCod) then;
                        if PAGE.RUNMODAL(0, Job_lRec) = ACTION::LookupOK then begin
                            JobFilter_gCod := Job_lRec."No.";
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Job_lRec: Record Job;
                    begin
                        if JobFilter_gCod > '' then begin
                            if not Job_lRec.GET(JobFilter_gCod) then begin
                                Job_lRec.SETFILTER("Search Description", '%1', '@*' + JobFilter_gCod + '*');
                                if Job_lRec.COUNT = 1 then begin
                                    Job_lRec.FINDFIRST;
                                    JobFilter_gCod := Job_lRec."No.";
                                end else begin
                                    if not Job_lRec.FINDFIRST then
                                        Job_lRec.SETRANGE("Search Description");
                                    if PAGE.RUNMODAL(0, Job_lRec) = ACTION::LookupOK then begin
                                        JobFilter_gCod := Job_lRec."No.";
                                    end;
                                end;
                            end;
                        end;
                    end;
                }
                // field(Search_Ctl; Search_gTxt)
                // {
                //     CaptionML = DEU = 'Suchbegriffe',
                //                 ENU = 'Search Terms';
                //     ColumnSpan = 4;

                //     trigger OnValidate();
                //     begin
                //         Search_lFnc;
                //     end;
                // }
            }
            repeater(Group)
            {
                Editable = false;
                field("Job Task Detail ID"; "Job Task Detail ID")
                {
                }
                field("Job No."; "Job No.")
                {
                }
                field("Job Task No."; "Job Task No.")
                {
                }
                field("Job Task Description"; "Job Task Description")
                {
                }
                field(Arranger; Arranger)
                {
                }
                field("Processing by"; "Processing by")
                {
                }
                field("Short Description"; "Short Description")
                {
                }
                field(Status; Status)
                {
                }
                field("Planned Date"; "Planned Date")
                {
                }
                field("Fixed Date"; "Fixed Date")
                {
                }
                field(Priority; Priority)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = DEU = 'F&unktion',
                            ENU = 'F&unctions';
                Image = "Action";
                action(Card)
                {
                    CaptionML = DEU = 'Karte',
                                ENU = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Item: Record Item;
                        JobTaskDetail_lRec: Record "Job Task Detail";
                    begin
                        //Item.SETRANGE("No.","No.");
                        //REPORT.RUNMODAL(REPORT::"Create Stockkeeping Unit",TRUE,FALSE,Item);
                        JobTaskDetail_lRec.GET("Job Task Detail ID");
                        PAGE.RUN(50041, JobTaskDetail_lRec);
                    end;
                }
            }
            group("Variant & Dimensions")
            {
                CaptionML = DEU = 'Variante& Dimensions ',
                            ENU = 'Variant & Dimensions';
                Image = BankAccountRec;
                action("Show Variants")
                {
                    CaptionML = DEU = 'Variante anzeigen',
                                ENU = 'Show Variants';
                    Image = ViewPage;
                    Visible = false;
                }
            }
            // action(Search_Btn)
            // {
            //     CaptionML = DEU = 'Suche',
            //                 ENU = 'Search';
            //     Image = "Filter";
            //     Promoted = true;
            //     PromotedCategory = New;
            //     PromotedIsBig = true;

            //     trigger OnAction();
            //     begin
            //         Search_lFnc;
            //     end;
            // }
        }
    }

    var
        Search_gTxt: Text;
        JobFilter_gCod: Code[20];
        ShowVar: Boolean;
        VarDimText: Text;

    // procedure Search_lFnc() Result_rBln: Boolean;
    // var
    //     SQL_lCdu: Codeunit "SQL Helper";
    //     V_lTxt: Text;
    //     V1_lTxt: Text;
    //     V2_lTxt: Text;
    //     ItemTmp_lRec: Record Item temporary;
    //     Item_lRec: Record Item;
    //     Fields_lTxt: Text;
    //     Where_lTxt: Text;
    //     JobTaskDetail_lRec: Record "Job Task Detail";
    //     Company_lTxt: Text;
    //     Database_lTxt: Text;
    //     Server_lTxt: Text;
    //     JobTaskDetailBlob_lRec: Record "Job Task Detail Blob";
    // begin
    //     DELETEALL;
    //     if Search_gTxt = '' then begin
    //         CurrPage.UPDATE(false);
    //         exit(false);
    //     end;
    //     //Server_lTxt:= 'LAPTOP1118\NAVDEMO';
    //     Server_lTxt := 'NAVSQL';
    //     //Database_lTxt:= 'Demo Database NAV (10-0)';
    //     Database_lTxt := '110_HanseSolutionLive';
    //     Company_lTxt := COMPANYNAME;

    //     //SQL_lCdu.Init_gFnc('LAPTOP1118\NAVDEMO','Demo Database NAV (10-0)','CRONUS AG','','',FALSE);
    //     SQL_lCdu.Init_gFnc(Server_lTxt, Database_lTxt, Company_lTxt, '', '', false);
    //     //SQL_lCdu.Init_gFnc('','','','','',FALSE);
    //     Fields_lTxt := 'Job Task Detail ID,Job No.,Job Task No.';
    //     //Where_lTxt:= '[Job No.] = ''todo''';
    //     V_lTxt := UPPERCASE(Search_gTxt);
    //     //Where_lTxt:= 'UPPER([Description Text]) like ''%'+V_lTxt+'%''';
    //     Where_lTxt := '( (UPPER([Description Text]) like ''%' + V_lTxt + '%'')';
    //     Where_lTxt += ' or (UPPER([Solution Text]) like ''%' + V_lTxt + '%'')';
    //     Where_lTxt += ' or (UPPER([Short Description]) like ''%' + V_lTxt + '%''))';
    //     if JobFilter_gCod > '' then begin
    //         Where_lTxt += ' and ([Job No_] = ''' + JobFilter_gCod + ''')';
    //     end;
    //     if SQL_lCdu.Findset_gFnc('Job Task Detail Blob', Fields_lTxt, Where_lTxt, 0, '') then
    //         repeat
    //             "Job Task Detail ID" := SQL_lCdu.FieldDec_gFnc('0');
    //             "Job No." := SQL_lCdu.Field_gFnc('1');
    //             "Job Task No." := SQL_lCdu.Field_gFnc('2');
    //             if JobTaskDetail_lRec.GET("Job Task Detail ID") then begin
    //                 Arranger := JobTaskDetail_lRec.Arranger;
    //                 "Processing by" := JobTaskDetail_lRec."Processing by";
    //                 "Contact No." := JobTaskDetail_lRec."Contact No.";
    //                 "Short Description" := JobTaskDetail_lRec."Short Description";
    //                 Status := JobTaskDetail_lRec.Status;
    //                 "Planned Date" := JobTaskDetail_lRec."Planned Date";
    //                 "Fixed Date" := JobTaskDetail_lRec."Fixed Date";
    //                 Priority := JobTaskDetail_lRec.Priority;
    //             end;
    //             INSERT;
    //         /*
    //         ItemTmp_lRec.INIT;
    //         //Access via Id from select string

    //         ItemTmp_lRec."No.":= SQL_lCdu.Field_gFnc('0');
    //         ItemTmp_lRec.Description:= SQL_lCdu.Field_gFnc('1');

    //         ItemTmp_lRec."No.":= Field_gFnc('No.');
    //         ItemTmp_lRec.Description:= Field_gFnc('Description');
    //         ItemTmp_lRec."Description 2":= Field_gFnc('"Description 2"');
    //         ItemTmp_lRec."Product Group Code":= Field_gFnc('[Product Group Code]');
    //         ItemTmp_lRec.INSERT;
    //         */
    //         until not SQL_lCdu.Next_gFnc;



    //     /*
    //     SQLHelper2.Init_gFnc('LAPTOP1118\NAVDEMO','TRIM2016_DE','CRONUS TRIMIT W1 Ltd.','','',FALSE);
    //     IF SQLHelper2.Findset_SP_gFnc('SelectVarDimSearchItem',Search_gTxt,0) THEN REPEAT
    //       INIT;
    //       "No.":= SQLHelper2.Field_gFnc('0');
    //       //Description:= SQLHelper2.Field_gFnc('1');
    //       //"Description 2":= SQLHelper2.Field_gFnc('2');
    //       Item_lRec.GET("No.");
    //       Description:= Item_lRec.Description;
    //       "Description 2":= Item_lRec."Description 2";
    //       "Master No.":= Item_lRec."Master No.";
    //       INSERT;
    //     UNTIL NOT SQLHelper2.Next_gFnc;
    //     */


    //     CurrPage.UPDATE(false);

    // end;
}

