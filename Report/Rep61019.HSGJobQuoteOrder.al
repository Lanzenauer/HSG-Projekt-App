report 61019 "HSG Job - Quote_Order"
{
    // version NAVW18.00.00,HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    //                      Number
    //                     of changes
    // Date        Module  in Object    User  Description
    // ========================================================================================
    // 11.07.2006                       SG    New general manager added
    // 03.05.2011  HSG_01               JN    allow manual page breaks
    // 04.05.2011  HSG_02               CH    Corrections
    // 08.01.2015  HSG_03               JS    updated and layout created for nav2015
    // 22.01.2015  HSG_04               CH    Optionally Print External Doc No.
    // 23.01.2015  HSG_05               JS    - Print Job Task Description
    //                                        - Footer changed
    // 23.01.2015  HSG_06               JS    corrected showing of job task description
    // 18.03.2015  HSG_07               CH    Layout redesigned - original layout in rep. 50069
    // 05.01.2017  HSG_08               JS    Added Layout footer and indication added
    DefaultLayout = RDLC;
    RDLCLayout = './HSG Job - Quote_Order.rdlc';

    CaptionML = DEU = 'Projekt- Angebot / Auftragsbestätigung',
                ENU = 'Job - Quote';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            column(Job_No_; "No.")
            {
            }
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(indication_gCtx; indication_gCtx)
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(Total_gCtx; Total_gCtx)
                {
                }
                column(CustAddr_1_; CustAddr[1])
                {
                }
                column(CompanyAddr_1_; CompanyAddr[1])
                {
                }
                column(CustAddr_2_; CustAddr[2])
                {
                }
                column(CompanyAddr_2_; CompanyAddr[2])
                {
                }
                column(CustAddr_3_; CustAddr[3])
                {
                }
                column(CompanyAddr_3_; CompanyAddr[3])
                {
                }
                column(CustAddr_4_; CustAddr[4])
                {
                }
                column(CompanyAddr_4_; CompanyAddr[4])
                {
                }
                column(CustAddr_5_; CustAddr[5])
                {
                }
                column(CustAddr_6_; CustAddr[6])
                {
                }
                column(Job__Bill_to_Customer_No__; Job."Bill-to Customer No.")
                {
                }
                column(SalesPersonText; SalesPersonText)
                {
                }
                column(RespResource_gRec_Name; RespResource_gRec.Name)
                {
                }
                column(CustAddr_7_; CustAddr[7])
                {
                }
                column(CustAddr_8_; CustAddr[8])
                {
                }
                column(WORKDATE; FORMAT(WORKDATE, 0, '<Day,2>.<Month,2>.<YEAR>'))
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(CompanyInfo_Name_______CompanyInfo_Address_______CompanyInfo__Post_Code______CompanyInfo_City; CompanyInfo.Name + ' - ' + CompanyInfo.Address + ' - ' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City)
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(STRSUBSTNO_Text004_CopyText_; DocTypeText_gTxt)
                {
                }
                column(Job__No__; Job."No.")
                {
                }
                column(CompanyInfo_Picture_Control140; CompanyInfo.Picture)
                {
                }
                column(STRSUBSTNO_Text004_CopyText__Control1; DocTypeText_gTxt)
                {
                }
                column(Job__No___Control36; Job."No.")
                {
                }
                column(WORKDATE_Control1000000073; WORKDATE)
                {
                }
                column(CurrReport_PAGENO_Control1000000074; CurrReport.PAGENO)
                {
                }
                column(CompanyInfo_Name; CompanyInfo.Name)
                {
                }
                column(CompanyInfo_Address; CompanyInfo.Address)
                {
                }
                column(CompanyInfo__Post_Code_________CompanyInfo_City; CompanyInfo."Post Code" + ' ' + CompanyInfo.City)
                {
                }
                column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo__Home_Page_; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                {
                }
                column(CompanyInfo__Bank_Branch_No__; CompanyInfo."Bank Branch No.")
                {
                }
                column(CompanyInfo_IBAN; CompanyInfo.IBAN)
                {
                }
                column(CompanyInfo__SWIFT_Code_; CompanyInfo."SWIFT Code")
                {
                }
                /*            column(CompanyInfo_Picture2; CompanyInfo.Picture2)
                           {
                           } */
                column(CompanyInfo__Registration_No__; CompanyInfo."Registration No.")
                {
                }
                column(Job__Bill_to_Customer_No__Caption; Job__Bill_to_Customer_No__CaptionLbl)
                {
                }
                column(WORKDATECaption; WORKDATECaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_Task__Job_Task_No__Caption; Job_Task__Job_Task_No__CaptionLbl)
                {
                }
                column(Job_Task_DescriptionCaption; "Job Task".FIELDCAPTION(Description))
                {
                }
                column(Job_Task__Schedule__Total_Price___Control1000000045Caption; Job_Task__Schedule__Total_Price___Control1000000045CaptionLbl)
                {
                }
                column(WORKDATE_Control1000000073Caption; WORKDATE_Control1000000073CaptionLbl)
                {
                }
                column(CurrReport_PAGENO_Control1000000074Caption; CurrReport_PAGENO_Control1000000074CaptionLbl)
                {
                }
                column(Projekt__aufgabe_Nr_Caption; Projekt__aufgabe_Nr_CaptionLbl)
                {
                }
                column(Job_Task_DescriptionCaption_Control1000000050; "Job Task".FIELDCAPTION(Description))
                {
                }
                column(Job_Task__Schedule__Total_Price___Control1000000045Caption_Control1000000051; Job_Task__Schedule__Total_Price___Control1000000045Caption_Control1000000051Lbl)
                {
                }
                column(Tel__Caption; Tel__CaptionLbl)
                {
                }
                column(Fax_Caption; Fax_CaptionLbl)
                {
                }
                column(WebCaption; WebCaptionLbl)
                {
                }
                column(MailCaption; MailCaptionLbl)
                {
                }
                column(VAT_IDCaption; VAT_IDCaptionLbl)
                {
                }
                column(Directors_Caption; Directors_CaptionLbl)
                {
                }
                column("Christopher_Hähne__Sven_GrageCaption"; Christopher_Hähne__Sven_GrageCaptionLbl)
                {
                }
                column(Commercial_court_HamburgCaption; Commercial_court_HamburgCaptionLbl)
                {
                }
                column(HRB_91246Caption; HRB_91246CaptionLbl)
                {
                }
                column(BankCaption; BankCaptionLbl)
                {
                }
                column(Branch_CodeCaption; Branch_CodeCaptionLbl)
                {
                }
                column(Account_Caption; Account_CaptionLbl)
                {
                }
                column(IBAN_Caption; IBAN_CaptionLbl)
                {
                }
                column(SWIFTCaption; SWIFTCaptionLbl)
                {
                }
                column(Tax_No_Caption; Tax_No_CaptionLbl)
                {
                }
                column(In_addition_our_general_terms_of_business_are_valid__see_http___www_hansesolution_com_index_php_contentID_8__Caption; In_addition_our_general_terms_of_business_are_valid__see_http___www_hansesolution_com_index_php_contentID_8__CaptionLbl)
                {
                }
                column(PageLoop_Number; Number)
                {
                }
                column(Text000; Text000)
                {
                }
                column(LineCaptJobTask_bl; LineCaptJobTask_bl)
                {
                }
                column(LineCaptDescript_bl; LineCaptDescript_bl)
                {
                }
                column(LineCaptAmnt_bl; LineCaptAmnt_bl)
                {
                }
                dataitem("Job Task"; "Job Task")
                {
                    CalcFields = "Schedule (Total Price)";
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "Job Task No.");
                    RequestFilterFields = "Job Task No.";
                    column(Job_Task__Schedule__Total_Price__; "Schedule (Total Price)")
                    {
                    }
                    column(Job_Task__Job_Task_No__; JobTaskNo_gCod)
                    {
                    }
                    column(Job_Task_Description; Description)
                    {
                    }
                    column(Job_Task__Schedule__Total_Price___Control1000000045; "Schedule (Total Price)")
                    {
                    }
                    column(Job_Task__Schedule__Total_Price___Control1000000059; "Schedule (Total Price)")
                    {
                    }
                    column(Job_Task__Schedule__Total_Price___Control1000000054; "Schedule (Total Price)")
                    {
                    }
                    column(ContinueCaption; ContinueCaptionLbl)
                    {
                    }
                    column(ContinueCaption_Control1000000058; ContinueCaption_Control1000000058Lbl)
                    {
                    }
                    column(Total_Amount_excl__VAT__EUR_Caption; Total_Amount_excl__VAT__EUR_CaptionLbl)
                    {
                    }
                    column(Job_Task_Job_No_; "Job No.")
                    {
                    }
                    column(JobTaskDesc_gTxt; JobTaskDesc_gTxt)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        // -HSG_04
                        JobTaskNo_gCod := "Job Task No.";
                        if "External Document No." <> '' then
                            JobTaskNo_gCod := JobTaskNo_gCod + '/' + "External Document No.";
                        // +HSG_04

                        //-HSG_06
                        //-HSG_05
                        CLEAR(JobTaskDesc_gRec);
                        CLEAR(JobTaskDesc_gTxt);

                        JobTaskDesc_gRec.SETRANGE("Job No.", "Job No.");
                        JobTaskDesc_gRec.SETRANGE("Job Task No.", "Job Task No.");
                        JobTaskDesc_gRec.SETRANGE(Internal, false);
                        if JobTaskDesc_gRec.FINDSET then
                            repeat
                                JobTaskDesc_gTxt += JobTaskDesc_gRec.Description;
                            until JobTaskDesc_gRec.NEXT = 0;
                        //+HSG_05
                        //+HSG_06
                    end;
                }
                dataitem(Signature; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(Quote_accepted__Date__Signature_Caption; Quote_accepted__Date__Signature_CaptionLbl)
                    {
                    }
                    column(Signature_Number; Number)
                    {
                    }

                    trigger OnPreDataItem();
                    begin
                        if not ShowCustomerSign then
                            CurrReport.BREAK;
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    CurrReport.PAGENO := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                "Sell-to Country": Text[50];
                JobSetup_lRec: Record "Jobs Setup";
                JobTask_lRec: Record "Job Task";
                DocNo_lCod: Code[20];
                NoSeriesMgt_lCdu: Codeunit NoSeriesManagement;
            begin
                Customer_gRec.GET("Bill-to Customer No.");
                if "Bill-to Contact" <> '' then
                    Customer_gRec.Contact := "Bill-to Contact";

                if RespResource_gRec.GET(Job."Person Responsible") then
                    SalesPersonText := Text000
                else
                    SalesPersonText := '';

                FormatAddr.Customer(CustAddr, Customer_gRec);

                // if ShowBank2 and (CompanyInfo."Bank Branch No. 2" <> '') then begin
                //     CompanyInfo."Bank Name" := CompanyInfo."Bank Branch No. 2";
                //     CompanyInfo."Bank Branch No." := CompanyInfo."Bank Account No. 2";
                //     CompanyInfo."Bank Account No." := CompanyInfo."IBAN 2";
                //     CompanyInfo.IBAN := CompanyInfo."SWIFT Code 2";
                //     CompanyInfo."SWIFT Code" := CompanyInfo."SWIFT Code 2";
                // end;

                // -HSG_04

                DocNo_lCod := '';

                if DocType_gOpt = DocType_gOpt::Order then begin
                    CLEAR(JobTask_lRec);
                    JobTask_lRec.COPYFILTERS("Job Task");
                    JobTask_lRec.SETRANGE("Job No.", "No.");
                    JobTask_lRec.SETFILTER("Document No.", '<>%1', '');
                    if JobTask_lRec.ISEMPTY then begin
                        if CONFIRM(WannaCreateNewDocNo_gCtx, true) then begin
                            JobSetup_lRec.GET;
                            JobSetup_lRec.TESTFIELD("Job Order No. Series");
                            DocNo_lCod := NoSeriesMgt_lCdu.GetNextNo(JobSetup_lRec."Job Order No. Series", WORKDATE, true);
                            JobTask_lRec.SETRANGE("Document No.");
                            JobTask_lRec.MODIFYALL("Document No.", DocNo_lCod);
                        end;
                    end else begin

                        JobTask_lRec.SETRANGE("Document No.");
                        if JobTask_lRec.FINDSET then begin
                            DocNo_lCod := JobTask_lRec."Document No.";
                            repeat
                                if JobTask_lRec."Document No." <> DocNo_lCod then
                                    ERROR(ErrDocNos_gCtx);
                                DocNo_lCod := JobTask_lRec."Document No.";
                            until JobTask_lRec.NEXT = 0;
                        end;
                    end;
                end;

                case DocType_gOpt of
                    DocType_gOpt::Order:
                        DocTypeText_gTxt := STRSUBSTNO(Text004, DocNo_lCod);
                    DocType_gOpt::Quote:
                        DocTypeText_gTxt := STRSUBSTNO(Text004_1, DocNo_lCod);
                end;

                // +HSG_04
            end;

            trigger OnPostDataItem();
            var
                ToDo: Record "To-do";
            begin
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(DocType_gOpt; DocType_gOpt)
                {
                    CaptionML = DEU = 'Belegart',
                                ENU = 'Options';
                    OptionCaptionML = DEU = 'Angebot,Auftrag',
                                      ENU = 'Quote,Order';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;

        FormatAddr.Company(CompanyAddr, CompanyInfo);

        //   CompanyInfo.CALCFIELDS(Picture2);
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        Text000: TextConst DEU = 'Kontakt', ENU = 'Contact';
        Text001: TextConst DEU = 'Total %1', ENU = 'Total %1';
        Text002: TextConst DEU = 'Total %1 inkl. MwSt.', ENU = 'Total %1 Incl. VAT';
        Text003: TextConst DEU = 'KOPIE', ENU = 'COPY';
        Text004: TextConst DEU = 'Auftragsbestätigung %1', ENU = 'Order Confirmation';
        Text004_1: TextConst DEU = 'Angebot %1', ENU = 'Quote %1';
        Text005: TextConst DEU = 'Seite %1', ENU = 'Page %1';
        Text006: TextConst DEU = 'Total %1 ohne MwSt.', ENU = 'Total %1 Excl. VAT';
        Customer_gRec: Record Customer;
        RespResource_gRec: Record Resource;
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        Language: Record Language;
        Country: Record "Country/Region";
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        NoOfLoops: Integer;
        CopyText: Text[30];
        i: Integer;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        "-----": Integer;
        ShowCustomerSign: Boolean;
        ShowBank2: Boolean;
        SumUpAmount_gDec: Decimal;
        Job__Bill_to_Customer_No__CaptionLbl: TextConst DEU = 'Kundennr.', ENU = 'Customer No.';
        WORKDATECaptionLbl: TextConst DEU = 'Datum', ENU = 'Date';
        CurrReport_PAGENOCaptionLbl: TextConst DEU = 'Seite', ENU = 'Page';
        Job_Task__Job_Task_No__CaptionLbl: TextConst DEU = 'Projektaufgabe', ENU = 'Job Task No.';
        Job_Task__Schedule__Total_Price___Control1000000045CaptionLbl: TextConst DEU = 'Betrag [EUR]', ENU = 'Amount [EUR)';
        WORKDATE_Control1000000073CaptionLbl: TextConst DEU = 'Datum', ENU = 'Date';
        CurrReport_PAGENO_Control1000000074CaptionLbl: TextConst DEU = 'Seite', ENU = 'Page';
        Projekt__aufgabe_Nr_CaptionLbl: Label 'Projekt- aufgabe Nr.';
        Job_Task__Schedule__Total_Price___Control1000000045Caption_Control1000000051Lbl: TextConst DEU = 'Betrag [EUR]', ENU = 'Amount [EUR)';
        Tel__CaptionLbl: Label 'Tel.:';
        Fax_CaptionLbl: Label 'Fax:';
        WebCaptionLbl: Label 'Web';
        MailCaptionLbl: Label 'Mail';
        VAT_IDCaptionLbl: TextConst DEU = 'USt-IdNr.', ENU = 'VAT-ID';
        Directors_CaptionLbl: TextConst DEU = 'Geschäftsführer', ENU = 'Directors:';
        "Christopher_Hähne__Sven_GrageCaptionLbl": TextConst DEU = 'Christopher Hähne, Sven Grage', ENU = 'Christopher Hähne, Sven Grage';
        Commercial_court_HamburgCaptionLbl: TextConst DEU = 'Registergericht Hamburg', ENU = 'Commercial court Hamburg';
        HRB_91246CaptionLbl: Label 'HRB 91246';
        BankCaptionLbl: TextConst DEU = 'Bankverbindung', ENU = 'Bank';
        Branch_CodeCaptionLbl: TextConst DEU = 'BLZ', ENU = 'Branch Code';
        Account_CaptionLbl: TextConst DEU = 'Konto:', ENU = 'Account:';
        IBAN_CaptionLbl: Label 'IBAN:';
        SWIFTCaptionLbl: Label 'SWIFT';
        Tax_No_CaptionLbl: TextConst DEU = 'Steuernr.', ENU = 'Tax No.';
        In_addition_our_general_terms_of_business_are_valid__see_http___www_hansesolution_com_index_php_contentID_8__CaptionLbl: TextConst DEU = 'Es gelten unsere AGBs (siehe auch http://www.hansesolution.com/impressum).', ENU = 'In addition our general terms of business are valid (see http://www.hansesolution.com/index.php?contentID=8).';
        ContinueCaptionLbl: TextConst DEU = 'Fortsetzung', ENU = 'Continue';
        ContinueCaption_Control1000000058Lbl: TextConst DEU = 'Fortsetzung', ENU = 'Continue';
        Total_Amount_excl__VAT__EUR_CaptionLbl: TextConst DEU = 'Gesamtbetrag exkl. MwSt [EUR]', ENU = 'Total Amount excl. VAT [EUR]';
        Quote_accepted__Date__Signature_CaptionLbl: TextConst DEU = '(Auftrag erteilt: Datum, Unterschrift)', ENU = '(Quote accepted: Date, Signature)';
        Total_gCtx: TextConst DEU = 'Gesamtbetrag exkl. MwSt [EUR]', ENU = 'Total amount excl. VAT [EUR]';
        JobTaskNo_gCod: Code[100];
        DocTypeText_gTxt: Text;
        DocType_gOpt: Option Quote,"Order";
        WannaCreateNewDocNo_gCtx: Label 'Wollen Sie eine neue Belegnr. vergeben?';
        ErrDocNos_gCtx: Label 'Unterschiedliche Belegnummern bereits vorhanden - bitte korrigieren Sie diese.';
        JobTaskDesc_gRec: Record "Job Task Description";
        JobTaskDesc_gTxt: Text;
        LineCaptJobTask_bl: TextConst DEU = 'Aufgabe', ENU = 'Task';
        LineCaptDescript_bl: TextConst DEU = 'Beschreibung', ENU = 'Description';
        LineCaptAmnt_bl: TextConst DEU = 'Betrag [EUR]', ENU = 'Amount [EUR]';
        indication_gCtx: TextConst DEU = 'Aus technischen Gründen sind Abweichungen beim tatsächlichen Rechnungsbetrag in Höhe von +- 20% möglich.', ENU = 'For technical reasons, deviations from the actual invoice amount of + - 20% are possible.';
}

