codeunit 61098 "Job Task Detail Chart Mgnt"
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


    trigger OnRun();
    begin
    end;

    var
        TrailingSalesOrdersSetup: Record "Job Task Detail Chart Setup";
        SalesHeader: Record "Sales Header";
        JobTD_gRec: Record "Job Task Detail";
        StartDate_gDat: Date;
        Text001_gCtx: TextConst DEU = 'Kein Filter', ENU = 'No filter';
        EndDate_gDat: Date;

    procedure OnOpenPage(var TrailingSalesOrdersSetup: Record "Job Task Detail Chart Setup");
    begin
        with TrailingSalesOrdersSetup do
            if not GET(USERID) then begin
                LOCKTABLE;
                "User ID" := USERID;
                //"Use Work Date as Base" := TRUE;
                "Use Work Date as Base" := false;
                "Period Length" := "Period Length"::Month;
                "Value to Calculate" := "Value to Calculate"::"No. of Job Task Details";
                "Chart Type" := "Chart Type"::"Stacked Column";
                INSERT;
            end;
    end;

    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer");
    var
        SalesHeader: Record "Sales Header";
        DateStart_lDat: Date;
        DateTo_lDat: Date;
        Measure: Integer;
        XIndex_lInt: Integer;
    begin
        /*
        Measure := BusChartBuf."Drill-Down Measure Index";
        IF (Measure < 0) OR (Measure > 3) THEN
          EXIT;
        TrailingSalesOrdersSetup.GET(USERID);
        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        IF TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" THEN
          SalesHeader.SETFILTER("Shipment Date",'<%1',TrailingSalesOrdersSetup.GetStartDate);
        IF EVALUATE(SalesHeader.Status,BusChartBuf.GetMeasureValueString(Measure),9) THEN
          SalesHeader.SETRANGE(Status,SalesHeader.Status);
        
        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        SalesHeader.SETRANGE("Document Date",0D,ToDate);
        PAGE.RUN(PAGE::"Sales Order List",SalesHeader);
        */

        Measure := BusChartBuf."Drill-Down Measure Index";
        if (Measure < 0) or (Measure > 9) then
            exit;
        TrailingSalesOrdersSetup.GET(USERID);

        if TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" then
            JobTD_gRec.SETFILTER("Planned Date", '<%1', TrailingSalesOrdersSetup.GetStartDate);
        if EVALUATE(JobTD_gRec.Status, BusChartBuf.GetMeasureValueString(Measure), 9) then
            JobTD_gRec.SETRANGE(Status, JobTD_gRec.Status);

        XIndex_lInt := BusChartBuf."Drill-Down X Index";

        DateTo_lDat := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        if XIndex_lInt = 0 then begin
            DateStart_lDat := 0D;
        end else begin
            //DateStart_lDat:= CalcPeriodDate_lFnc(DateTo_lDat,FALSE);
            DateStart_lDat := CALCDATE(STRSUBSTNO('<-C%1>', GetPeriodLength_lFnc), DateTo_lDat);
        end;
        JobTD_gRec.SETRANGE("Planned Date", DateStart_lDat, DateTo_lDat);
        if JobTD_gRec.COUNT > 1 then begin
            PAGE.RUN(0, JobTD_gRec);
        end else begin
            JobTD_gRec.FINDFIRST;
            PAGE.RUN(PAGE::"Job Task Detail Card", JobTD_gRec);
        end;

    end;

    procedure UpdateData(var BusChartBuf_vRec: Record "Business Chart Buffer");
    var
        ChartToStatusMap_Arr_lCod: array[10] of Code[20];
        ToDate: array[9] of Date;
        FromDate: array[9] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus_lInt: Integer;
        Status_ARRAYLEN_lInt: Integer;
        JobTaskDetailStatus_lRec: Record "Job Task Detail Status";
    begin
        TrailingSalesOrdersSetup.GET(USERID);
        //WITH BusChartBuf_vRec DO BEGIN
        BusChartBuf_vRec.Initialize;
        BusChartBuf_vRec."Period Length" := TrailingSalesOrdersSetup."Period Length";
        BusChartBuf_vRec.SetPeriodXAxis;
        //TrailingSalesOrdersSetup."Use Work Date as Base"
        //Status_ARRAYLEN_lInt:= ARRAYLEN(ChartToStatusMap_Arr_lInt);
        JobTaskDetailStatus_lRec.SETRANGE("Status Extended", JobTaskDetailStatus_lRec."Status Extended"::Active, JobTaskDetailStatus_lRec."Status Extended"::Wait);
        if not TrailingSalesOrdersSetup."Use Work Date as Base" then begin//Include "Status"='finished' in Job Task Detail
            JobTaskDetailStatus_lRec.SETRANGE("Status Extended", JobTaskDetailStatus_lRec."Status Extended"::Active, JobTaskDetailStatus_lRec."Status Extended"::Closed);
        end;
        Status_ARRAYLEN_lInt := 0;
        JobTaskDetailStatus_lRec.SETCURRENTKEY(Sorting);
        JobTaskDetailStatus_lRec.SETRANGE(Blocked, false);
        if JobTaskDetailStatus_lRec.FINDSET then
            repeat
                Status_ARRAYLEN_lInt += 1;
                ChartToStatusMap_Arr_lCod[Status_ARRAYLEN_lInt] := JobTaskDetailStatus_lRec.Code;
            until JobTaskDetailStatus_lRec.NEXT = 0;

        //CreateMap(ChartToStatusMap_Arr_lCod);
        for SalesHeaderStatus_lInt := 1 to Status_ARRAYLEN_lInt do begin
            //JobTD_gRec.Status := ChartToStatusMap_Arr_lCod[SalesHeaderStatus_lInt];
            BusChartBuf_vRec.AddMeasure(ChartToStatusMap_Arr_lCod[SalesHeaderStatus_lInt], SalesHeaderStatus_lInt,
                                       BusChartBuf_vRec."Data Type"::Decimal, TrailingSalesOrdersSetup.GetChartType);
        end;
        if CalcPeriods(FromDate, ToDate, BusChartBuf_vRec) then begin
            //BusChartBuf_vRec.AddPeriods(ToDate[1],ToDate[ARRAYLEN(ToDate)]);
            BusChartBuf_vRec.AddPeriods(StartDate_gDat, ToDate[ARRAYLEN(ToDate)]);

            for SalesHeaderStatus_lInt := 1 to Status_ARRAYLEN_lInt do begin
                TotalValue := 0;
                for ColumnNo := 1 to ARRAYLEN(ToDate) do begin
                    Value := GetSalesOrderValue(ChartToStatusMap_Arr_lCod[SalesHeaderStatus_lInt], FromDate[ColumnNo], ToDate[ColumnNo]);
                    if ColumnNo = 1 then
                        TotalValue := Value
                    else
                        TotalValue += Value;
                    //BusChartBuf_vRec.SetValueByIndex(SalesHeaderStatus - 1,ColumnNo - 1,TotalValue);
                    BusChartBuf_vRec.SetValueByIndex(SalesHeaderStatus_lInt - 1, ColumnNo - 1, Value);
                end;
            end;
        end;


        //END;
        /*
        TrailingSalesOrdersSetup.GET(USERID);
        WITH BusChartBuf DO BEGIN
          Initialize;
          "Period Length" := TrailingSalesOrdersSetup."Period Length";
          SetPeriodXAxis;
        
          CreateMap(ChartToStatusMap);
          FOR SalesHeaderStatus := 1 TO ARRAYLEN(ChartToStatusMap) DO BEGIN
            SalesHeader.Status := ChartToStatusMap[SalesHeaderStatus];
            AddMeasure(FORMAT(SalesHeader.Status),SalesHeader.Status,"Data Type"::Decimal,TrailingSalesOrdersSetup.GetChartType);
          END;
        
          IF CalcPeriods(FromDate,ToDate,BusChartBuf) THEN BEGIN
            AddPeriods(ToDate[1],ToDate[ARRAYLEN(ToDate)]);
        
            FOR SalesHeaderStatus := 1 TO ARRAYLEN(ChartToStatusMap) DO BEGIN
              TotalValue := 0;
              FOR ColumnNo := 1 TO ARRAYLEN(ToDate) DO BEGIN
                Value := GetSalesOrderValue(ChartToStatusMap[SalesHeaderStatus],FromDate[ColumnNo],ToDate[ColumnNo]);
                IF ColumnNo = 1 THEN
                  TotalValue := Value
                ELSE
                  TotalValue += Value;
                SetValueByIndex(SalesHeaderStatus - 1,ColumnNo - 1,TotalValue);
              END;
            END;
          END;
        END;
        */

    end;

    local procedure GetSalesOrderValue(Status_iCod: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    begin
        if TrailingSalesOrdersSetup."Value to Calculate" = TrailingSalesOrdersSetup."Value to Calculate"::"No. of Job Task Details" then
            exit(GetSalesOrderCount(Status_iCod, FromDate, ToDate));
        exit(GetSalesOrderAmount(Status_iCod, FromDate, ToDate));
    end;

    local procedure GetSalesOrderAmount(Status_iCod: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    var
        CurrExchRate: Record "Currency Exchange Rate";
        TrailingSalesOrderQry: Query "Trailing Sales Order Qry";
        Amount: Decimal;
        TotalAmount: Decimal;
    begin
        /*
        IF TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" THEN
          TrailingSalesOrderQry.SETFILTER(ShipmentDate,'<%1',TrailingSalesOrdersSetup.GetStartDate);
        
        TrailingSalesOrderQry.SETRANGE(Status,Status);
        TrailingSalesOrderQry.SETRANGE(DocumentDate,FromDate,ToDate);
        TrailingSalesOrderQry.OPEN;
        WHILE TrailingSalesOrderQry.READ DO BEGIN
          IF TrailingSalesOrderQry.CurrencyCode = '' THEN
            Amount := TrailingSalesOrderQry.Amount
          ELSE
            Amount := ROUND(TrailingSalesOrderQry.Amount / CurrExchRate.ExchangeRate(TODAY,TrailingSalesOrderQry.CurrencyCode));
          TotalAmount := TotalAmount + Amount;
        END;
        EXIT(TotalAmount);
        */
        if TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" then
            JobTD_gRec.SETFILTER("Fixed Date", '<%1', TrailingSalesOrdersSetup.GetStartDate)
        else
            JobTD_gRec.SETRANGE("Fixed Date");
        JobTD_gRec.SETRANGE(Status, Status_iCod);
        JobTD_gRec.SETRANGE("Planned Date", FromDate, ToDate);
        //JobTD_gRec.CALCSUMS("Estimated Quantity");
        //EXIT(JobTD_gRec."Estimated Quantity");
        JobTD_gRec.CALCSUMS("Remaining Quantity");
        exit(JobTD_gRec."Remaining Quantity");

    end;

    local procedure GetSalesOrderCount(Status_iCod: Code[20]; FromDate: Date; ToDate: Date): Decimal;
    begin
        /*
        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        IF TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" THEN
          SalesHeader.SETFILTER("Shipment Date",'<%1',TrailingSalesOrdersSetup.GetStartDate)
        ELSE
          SalesHeader.SETRANGE("Shipment Date");
        SalesHeader.SETRANGE(Status,Status);
        SalesHeader.SETRANGE("Document Date",FromDate,ToDate);
        EXIT(SalesHeader.COUNT);
        */
        if TrailingSalesOrdersSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" then
            JobTD_gRec.SETFILTER("Fixed Date", '<%1', TrailingSalesOrdersSetup.GetStartDate)
        else
            JobTD_gRec.SETRANGE("Fixed Date");
        JobTD_gRec.SETRANGE(Status, Status_iCod);
        JobTD_gRec.SETRANGE("Planned Date", FromDate, ToDate);

        exit(JobTD_gRec.COUNT);

    end;

    procedure CreateMap(var Map_vCod: array[10] of Code[20]);
    var
        SalesHeader: Record "Sales Header";
        JobTaskDetailStatus_lRec: Record "Job Task Detail Status";
        i: Integer;
    begin
        /*
        Map[1] := SalesHeader.Status::Released;
        Map[2] := SalesHeader.Status::"Pending Prepayment";
        Map[3] := SalesHeader.Status::"Pending Approval";
        Map[4] := SalesHeader.Status::Open;
        */
        //Open,Cost estimation,Quote,Processing,Test,Sign off Customer,Feedback,Closed,Deleted
        /*
        Map[1] := JobTD_gRec.Status::"0";
        Map[2] := JobTD_gRec.Status::"1" ;
        Map[3] := JobTD_gRec.Status::"2" ;
        Map[4] := JobTD_gRec.Status::"3" ;
        Map[5] := JobTD_gRec.Status::"4" ;
        Map[6] := JobTD_gRec.Status::"5" ;
        Map[7] := JobTD_gRec.Status::"6" ;
        Map[8] := JobTD_gRec.Status::"7" ;
        //Map[9] := JobTD_gRec.Status::Deleted ;
        i:= 0;
        */

    end;

    procedure SetFilter_gFnc(var JobTD_vRec: Record "Job Task Detail");
    begin
        JobTD_gRec.COPYFILTERS(JobTD_vRec);
    end;

    procedure GetStatusInfo_gFnc(): Text;
    var
        JobTD_lRec: Record "Job Task Detail";
    begin
        JobTD_lRec.COPYFILTERS(JobTD_gRec);
        JobTD_lRec.SETRANGE("Status Extended Calc.");
        JobTD_lRec.SETRANGE(Status);
        JobTD_lRec.SETRANGE("Planned Date");
        if JobTD_lRec.GETFILTERS = '' then
            exit(Text001_gCtx)
        else
            exit(JobTD_lRec.GETFILTERS);
    end;

    local procedure CalcPeriods(var FromDate: array[9] of Date; var ToDate: array[9] of Date; var BusChartBuf: Record "Business Chart Buffer"): Boolean;
    var
        MaxPeriodNo: Integer;
        i: Integer;
        V_lTxt: Text;
    begin
        MaxPeriodNo := ARRAYLEN(ToDate);
        /*
        ToDate[MaxPeriodNo] := TrailingSalesOrdersSetup.GetStartDate;
        IF ToDate[MaxPeriodNo] = 0D THEN
          EXIT(FALSE);
        FOR i := MaxPeriodNo DOWNTO 1 DO BEGIN
          IF i > 1 THEN BEGIN
            FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
            ToDate[i - 1] := FromDate[i] - 1;
          END ELSE
            FromDate[i] := 0D
        END;
        EXIT(TRUE);
        */
        //ToDate[1] := WORKDATE;
        //ToDate[2] := WORKDATE;
        V_lTxt := STRSUBSTNO('<-C%1>', GetPeriodLength_lFnc);
        if StartDate_gDat = 0D then begin
            StartDate_gDat := WORKDATE;
        end;
        FromDate[1] := CALCDATE(V_lTxt, StartDate_gDat);
        StartDate_gDat := FromDate[1];
        ToDate[1] := CALCDATE(STRSUBSTNO('<+1%1>', GetPeriodLength_lFnc), FromDate[1]);

        for i := 2 to MaxPeriodNo do begin
            //FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
            //FromDate[i]:= ToDate[i - 1] + 1;
            FromDate[i] := CalcPeriodDate_lFnc(FromDate[i - 1], true);
            ToDate[i] := CALCDATE(STRSUBSTNO('<+1%1-1D>', GetPeriodLength_lFnc), FromDate[i]);
        end;
        //FromDate[1] := 0D;

        exit(true);

    end;

    local procedure CalcPeriodDate_lFnc(Date_iDat: Date; Positive_iBln: Boolean): Date;
    var
        Modificator: Text[1];
        V_lTxt: Text;
        V_lDat: Date;
    begin
        if Date_iDat = 0D then
            exit(Date_iDat);

        case TrailingSalesOrdersSetup."Period Length" of
            //TrailingSalesOrdersSetup."Period Length"::Day:
            //  EXIT(Date_iDat);
            TrailingSalesOrdersSetup."Period Length"::Day,
            TrailingSalesOrdersSetup."Period Length"::Week,
            TrailingSalesOrdersSetup."Period Length"::Month,
            TrailingSalesOrdersSetup."Period Length"::Quarter,
            TrailingSalesOrdersSetup."Period Length"::Year:
                begin
                    if Positive_iBln then
                        Modificator := '+'
                    else
                        Modificator := '-';
                    //EXIT(CALCDATE(STRSUBSTNO('<%1C%2>',Modificator,GetPeriodLength_lFnc ),Date));
                    //V_lTxt:= STRSUBSTNO('<%1%2>',Modificator,GetPeriodLength_lFnc);
                    //V_lTxt:= STRSUBSTNO('<%1C%2>',Modificator,GetPeriodLength_lFnc);
                    //V_lTxt:= STRSUBSTNO('<%11%2>',Modificator,GetPeriodLength_lFnc);
                    V_lTxt := '<' + Modificator + '1' + GetPeriodLength_lFnc + '>';
                    V_lDat := CALCDATE(V_lTxt, Date_iDat);
                    exit(CALCDATE(V_lTxt, Date_iDat));
                end;
        end;
    end;

    local procedure GetPeriodLength_lFnc(): Text[1];
    begin
        case TrailingSalesOrdersSetup."Period Length" of
            TrailingSalesOrdersSetup."Period Length"::Day:
                exit('D');
            TrailingSalesOrdersSetup."Period Length"::Week:
                exit('W');
            TrailingSalesOrdersSetup."Period Length"::Month:
                exit('M');
            TrailingSalesOrdersSetup."Period Length"::Quarter:
                exit('Q');
            TrailingSalesOrdersSetup."Period Length"::Year:
                exit('Y');
        end;
    end;

    procedure NextPeriod_gFnc(Positive_iBln: Boolean);
    var
        V_lTxt: Text;
        Modificator_lTxt: Text;
    begin
        //V_lTxt:= STRSUBSTNO('<-C%1>',GetPeriodLength_lFnc);
        if WORKDATE = 0D then
            StartDate_gDat := WORKDATE;

        if Positive_iBln then
            Modificator_lTxt := '+'
        else
            Modificator_lTxt := '-';

        V_lTxt := '<' + Modificator_lTxt + '9' + GetPeriodLength_lFnc + '>';
        StartDate_gDat := CALCDATE(V_lTxt, StartDate_gDat);
    end;
}

