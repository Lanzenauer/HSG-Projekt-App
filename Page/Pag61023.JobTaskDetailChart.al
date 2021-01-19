page 61023 "Job Task Detail Chart"
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

    CaptionML = DEU = 'Unteraufgaben Diagramm',
                ENU = 'Job Task Detail Chart';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText; StatusText)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DEU = 'Filter',
                            ENU = 'Filter';
                Editable = false;
                ShowCaption = false;
                ToolTipML = DEU = 'Gibt den Filter des Diagramms an.',
                            ENU = 'Specifies the Filter of the chart.';
            }
            field(BusinessChart; '')
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DEU = 'Geschäftsdiagramm',
                            ENU = 'Business Chart';
                //The property ControlAddIn is not yet supported. Please convert manually.
                //ControlAddIn = 'Microsoft.Dynamics.Nav.Client.BusinessChart;PublicKeyToken=31bf3856ad364e35';
                ToolTipML = DEU = 'Gibt an, ob das Diagramm ein Geschäftsdiagramm ist.',
                            ENU = 'Specifies if the chart is of type Business Chart.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                CaptionML = DEU = 'Anzeigen',
                            ENU = 'Show';
                Image = View;
                Visible = false;
                action(AllOrders)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Alle Aufgaben',
                                ENU = 'All Tasks';
                    Enabled = AllOrdersEnabled;
                    ToolTipML = DEU = 'Zeigt alle nicht vollständig gebuchten Verkaufsaufträge an, einschließlich Verkaufsaufträge, deren Belegdatum aufgrund langer Lieferzeiten, Verzögerungen oder aus anderen Gründen in der Zukunft liegt.',
                                ENU = 'View all not fully posted sales orders, including sales orders with document dates in the future because of long delivery times, delays, or other reasons.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetShowOrders(TrailingSalesOrdersSetup."Show Orders"::"All Orders");
                        UpdateStatus;
                    end;
                }
                action(OrdersUntilToday)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Aufgaben bis heute',
                                ENU = 'Tasks Until Today';
                    Enabled = OrdersUntilTodayEnabled;
                    ToolTipML = DEU = 'Zeigt nicht vollständig gebuchte Verkaufsaufträge mit einem Belegdatum bis einschließlich des aktuellen Datums an.',
                                ENU = 'View not fully posted sales orders with document dates up until today''sŠ¢ date.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetShowOrders(TrailingSalesOrdersSetup."Show Orders"::"Orders Until Today");
                        UpdateStatus;
                    end;
                }
                action(DelayedOrders)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Verspätete Aufgaben',
                                ENU = 'Delayed Tasks';
                    Enabled = DelayedOrdersEnabled;
                    ToolTipML = DEU = 'Zeigt nicht vollständig gebuchte Verkaufsaufträge mit einem Warenausgangsdatum vor dem aktuellen Datum an.',
                                ENU = 'View not fully posted sales orders with shipment dates that are before today''sŠ¢ date.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetShowOrders(TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders");
                        UpdateStatus;
                    end;
                }
            }
            group("Move time period")
            {
                CaptionML = DEU = 'Periode verschieben',
                            ENU = 'Move time period';
                action(PrevPeriod_Ctl)
                {
                    CaptionML = DEU = 'Periode zurück',
                                ENU = 'Previous Period';
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersMgt.NextPeriod_gFnc(false);
                        NeedsUpdate := true;
                        UpdateChart
                    end;
                }
                action(NextPeriod_Ctl)
                {
                    CaptionML = DEU = 'Periode vor',
                                ENU = 'Next Period';
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersMgt.NextPeriod_gFnc(true);
                        NeedsUpdate := true;
                        UpdateChart
                    end;
                }
            }
            group(PeriodLength)
            {
                CaptionML = DEU = 'Periodenlänge',
                            ENU = 'Period Length';
                Image = Period;
                action(Day)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Tag',
                                ENU = 'Day';
                    Enabled = DayEnabled;
                    Image = Timeline;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTipML = DEU = 'Jeder Stapel deckt einen Tag ab.',
                                ENU = 'Each stack covers one day.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetPeriodLength(TrailingSalesOrdersSetup."Period Length"::Day);
                        UpdateStatus;
                    end;
                }
                action(Week)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Woche',
                                ENU = 'Week';
                    Enabled = WeekEnabled;
                    Image = Timeline;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTipML = DEU = 'Jeder Stapel mit Ausnahme des letzten deckt eine Woche ab. Der letzte Stapel enthält Daten vom Wochenanfang bis zu dem mit der Option "Anzeigen" festgelegten Datum.',
                                ENU = 'Each stack except for the last stack covers one week. The last stack contains data from the start of the week until the date that is defined by the Show option.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetPeriodLength(TrailingSalesOrdersSetup."Period Length"::Week);
                        UpdateStatus;
                    end;
                }
                action(Month)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Monat',
                                ENU = 'Month';
                    Enabled = MonthEnabled;
                    Image = Timeline;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTipML = DEU = 'Jeder Stapel mit Ausnahme des letzten deckt einen Monat ab. Der letzte Stapel enthält Daten vom Monatsanfang bis zu dem mit der Option "Anzeigen" festgelegten Datum.',
                                ENU = 'Each stack except for the last stack covers one month. The last stack contains data from the start of the month until the date that is defined by the Show option.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetPeriodLength(TrailingSalesOrdersSetup."Period Length"::Month);
                        UpdateStatus;
                    end;
                }
                action(Quarter)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Quartal',
                                ENU = 'Quarter';
                    Enabled = QuarterEnabled;
                    Image = Timeline;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTipML = DEU = 'Jeder Stapel mit Ausnahme des letzten deckt ein Quartal ab. Der letzte Stapel enthält Daten vom Quartalsanfang bis zu dem mit der Option "Anzeigen" festgelegten Datum.',
                                ENU = 'Each stack except for the last stack covers one quarter. The last stack contains data from the start of the quarter until the date that is defined by the Show option.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetPeriodLength(TrailingSalesOrdersSetup."Period Length"::Quarter);
                        UpdateStatus;
                    end;
                }
                action(Year)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = DEU = 'Jahr',
                                ENU = 'Year';
                    Enabled = YearEnabled;
                    Image = Timeline;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    ToolTipML = DEU = 'Jeder Stapel mit Ausnahme des letzten deckt ein Jahr ab. Der letzte Stapel enthält Daten vom Jahresanfang bis zu dem mit der Option "Anzeigen" festgelegten Datum.',
                                ENU = 'Each stack except for the last stack covers one year. The last stack contains data from the start of the year until the date that is defined by the Show option.';

                    trigger OnAction();
                    begin
                        TrailingSalesOrdersSetup.SetPeriodLength(TrailingSalesOrdersSetup."Period Length"::Year);
                        UpdateStatus;
                    end;
                }
            }
            group(Options)
            {
                CaptionML = DEU = 'Optionen',
                            ENU = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    CaptionML = DEU = 'Zu berechnender Wert',
                                ENU = 'Value to Calculate';
                    Image = Calculate;
                    action(Amount)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Restmenge',
                                    ENU = 'Remaining Amount';
                        Enabled = AmountEnabled;
                        ToolTipML = DEU = 'Die y-Achse zeigt den summierten Betrag der Bestellungen/Aufträge in MW.',
                                    ENU = 'The Y-axis shows the totaled LCY amount of the orders.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetValueToCalcuate(TrailingSalesOrdersSetup."Value to Calculate"::"Remaining Qty.");
                            UpdateStatus;
                        end;
                    }
                    action(NoofOrders)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Anzahl Unteraufgaben',
                                    ENU = 'No. of Sub Tasks';
                        Enabled = NoOfOrdersEnabled;
                        ToolTipML = DEU = 'Die y-Achse zeigt die Anzahl von Bestellungen/Aufträgen.',
                                    ENU = 'The Y-axis shows the number of orders.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetValueToCalcuate(TrailingSalesOrdersSetup."Value to Calculate"::"No. of Job Task Details");
                            UpdateStatus;
                        end;
                    }
                }
                group("Chart Type")
                {
                    CaptionML = DEU = 'Diagrammart',
                                ENU = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Gestapelte Fläche',
                                    ENU = 'Stacked Area';
                        Enabled = StackedAreaEnabled;
                        ToolTipML = DEU = 'Zeigt die Daten im Bereichslayout an.',
                                    ENU = 'View the data in area layout.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetChartType(TrailingSalesOrdersSetup."Chart Type"::"Stacked Area");
                            UpdateStatus;
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Gestapelte Fläche (%)',
                                    ENU = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;
                        ToolTipML = DEU = 'Zeigt die prozentuale Verteilung der vier Auftragsstatus im Bereichslayout an.',
                                    ENU = 'view the percentage distribution of the four order statuses in area layout.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetChartType(TrailingSalesOrdersSetup."Chart Type"::"Stacked Area (%)");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumn)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Gestapelte Säule',
                                    ENU = 'Stacked Column';
                        Enabled = StackedColumnEnabled;
                        ToolTipML = DEU = 'Zeigt die Daten im Spaltenlayout an.',
                                    ENU = 'view the data in column layout.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetChartType(TrailingSalesOrdersSetup."Chart Type"::"Stacked Column");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionML = DEU = 'Gestapelte Säule (%)',
                                    ENU = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;
                        ToolTipML = DEU = 'Zeigt die prozentuale Verteilung der vier Auftragsstatus im Spaltenlayout an.',
                                    ENU = 'view the percentage distribution of the four order statuses in column layout.';

                        trigger OnAction();
                        begin
                            TrailingSalesOrdersSetup.SetChartType(TrailingSalesOrdersSetup."Chart Type"::"Stacked Column (%)");
                            UpdateStatus;
                        end;
                    }
                }
            }
            separator(Separator25)
            {
            }
            action(Setup)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DEU = 'Einrichtung',
                            ENU = 'Setup';
                Image = Setup;
                ToolTipML = DEU = 'Gibt an, ob das Diagramm auf einem anderen Arbeitsdatum als dem aktuellen Datum basiert. Diese Angabe ist in erster Linie bei Demodatenbanken mit fiktiven Verkaufsaufträgen relevant.',
                            ENU = 'Specify if the chart will be based on a work date other than today''s date. This is mainly relevant in demonstration databases with fictitious sales orders.';

                trigger OnAction();
                begin
                    RunSetup;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean;
    begin
        UpdateChart;
        IsChartDataReady := true;

        if not IsChartAddInReady then
            SetActionsEnabled;
    end;

    trigger OnOpenPage();
    begin
        SetActionsEnabled;
    end;

    var
        TrailingSalesOrdersSetup: Record "Job Task Detail Chart Setup";
        OldTrailingSalesOrdersSetup: Record "Job Task Detail Chart Setup";
        TrailingSalesOrdersMgt: Codeunit "Job Task Detail Chart Mgnt";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllOrdersEnabled: Boolean;
        [InDataSet]
        OrdersUntilTodayEnabled: Boolean;
        [InDataSet]
        DelayedOrdersEnabled: Boolean;
        [InDataSet]
        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        NoOfOrdersEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;
        JobTaskDetail_gRec: Record "Job Task Detail";
        Text001_gCtx: TextConst DEU = 'Abgeschlossene Unteraufgaben auch anzeigen?', ENU = 'Show ''Closed'' Tasks too?';

    local procedure UpdateChart();
    begin
        if not NeedsUpdate then
            exit;
        if not IsChartAddInReady then
            exit;

        TrailingSalesOrdersMgt.SetFilter_gFnc(JobTaskDetail_gRec);
        TrailingSalesOrdersMgt.UpdateData(Rec);
        //Rec.Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := false;
        StatusText := TrailingSalesOrdersMgt.GetStatusInfo_gFnc;
    end;

    local procedure UpdateStatus();
    begin
        NeedsUpdate :=
          NeedsUpdate or
          (OldTrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length") or
          (OldTrailingSalesOrdersSetup."Show Orders" <> TrailingSalesOrdersSetup."Show Orders") or
          (OldTrailingSalesOrdersSetup."Use Work Date as Base" <> TrailingSalesOrdersSetup."Use Work Date as Base") or
          (OldTrailingSalesOrdersSetup."Value to Calculate" <> TrailingSalesOrdersSetup."Value to Calculate") or
          (OldTrailingSalesOrdersSetup."Chart Type" <> TrailingSalesOrdersSetup."Chart Type");

        OldTrailingSalesOrdersSetup := TrailingSalesOrdersSetup;

        //IF NeedsUpdate THEN
        //  StatusText := TrailingSalesOrdersSetup.GetCurrentSelectionText;

        SetActionsEnabled;
    end;

    local procedure RunSetup();
    begin
        //PAGE.RUNMODAL(PAGE::"Trailing Sales Orders Setup",TrailingSalesOrdersSetup);
        //TrailingSalesOrdersSetup.GET(USERID);
        //UpdateStatus;
        TrailingSalesOrdersSetup.GET(USERID);
        if CONFIRM(Text001_gCtx, true) then begin
            TrailingSalesOrdersSetup."Use Work Date as Base" := true;
        end else begin
            TrailingSalesOrdersSetup."Use Work Date as Base" := false;
        end;
        TrailingSalesOrdersSetup.MODIFY;
        UpdateStatus;
    end;

    procedure SetActionsEnabled();
    begin
        AllOrdersEnabled := (TrailingSalesOrdersSetup."Show Orders" <> TrailingSalesOrdersSetup."Show Orders"::"All Orders") and
          IsChartAddInReady;
        OrdersUntilTodayEnabled :=
          (TrailingSalesOrdersSetup."Show Orders" <> TrailingSalesOrdersSetup."Show Orders"::"Orders Until Today") and
          IsChartAddInReady;
        DelayedOrdersEnabled := (TrailingSalesOrdersSetup."Show Orders" <> TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders") and
          IsChartAddInReady;
        DayEnabled := (TrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length"::Day) and
          IsChartAddInReady;
        WeekEnabled := (TrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length"::Week) and
          IsChartAddInReady;
        MonthEnabled := (TrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length"::Month) and
          IsChartAddInReady;
        QuarterEnabled := (TrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length"::Quarter) and
          IsChartAddInReady;
        YearEnabled := (TrailingSalesOrdersSetup."Period Length" <> TrailingSalesOrdersSetup."Period Length"::Year) and
          IsChartAddInReady;
        AmountEnabled :=
          (TrailingSalesOrdersSetup."Value to Calculate" <> TrailingSalesOrdersSetup."Value to Calculate"::"Remaining Qty.") and
          IsChartAddInReady;
        NoOfOrdersEnabled :=
          (TrailingSalesOrdersSetup."Value to Calculate" <> TrailingSalesOrdersSetup."Value to Calculate"::"No. of Job Task Details") and
          IsChartAddInReady;
        StackedAreaEnabled := (TrailingSalesOrdersSetup."Chart Type" <> TrailingSalesOrdersSetup."Chart Type"::"Stacked Area") and
          IsChartAddInReady;
        StackedAreaPctEnabled := (TrailingSalesOrdersSetup."Chart Type" <> TrailingSalesOrdersSetup."Chart Type"::"Stacked Area (%)") and
          IsChartAddInReady;
        StackedColumnEnabled := (TrailingSalesOrdersSetup."Chart Type" <> TrailingSalesOrdersSetup."Chart Type"::"Stacked Column") and
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (TrailingSalesOrdersSetup."Chart Type" <> TrailingSalesOrdersSetup."Chart Type"::"Stacked Column (%)") and
          IsChartAddInReady;
    end;

    procedure SetFilter_gFnc(var JobTD_vRec: Record "Job Task Detail");
    begin
        JobTaskDetail_gRec.COPYFILTERS(JobTD_vRec);
    end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
    /*
    SetDrillDownIndexes(point);
    TrailingSalesOrdersMgt.DrillDown(Rec);
    */
    //end;

    //event BusinessChart(point : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=10.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint");
    //begin
    /*
    */
    //end;

    //event BusinessChart();
    //begin
    /*
    IsChartAddInReady := true;
    TrailingSalesOrdersMgt.OnOpenPage(TrailingSalesOrdersSetup);
    UpdateStatus;
    if IsChartDataReady then
      UpdateChart;
    */
    //end;

    //event BusinessChart();
    //begin
    /*
    if IsChartAddInReady and IsChartDataReady then begin
      NeedsUpdate := true;
      UpdateChart
    end;
    */
    //end;
}

