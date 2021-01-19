table 61050 "Job Task Detail Chart Setup"
{
    // version JOB

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 190917  HSG_01  FC  Created: Copied from Table 760

    CaptionML = DEU = 'Einrichtung flexibel anpassbarer Aufträge',
                ENU = 'Trailing Sales Orders Setup';

    fields
    {
        field(1; "User ID"; Text[132])
        {
            CaptionML = DEU = 'Benutzer-ID',
                        ENU = 'User ID';
        }
        field(2; "Period Length"; Option)
        {
            CaptionML = DEU = 'Periodenlänge',
                        ENU = 'Period Length';
            OptionCaptionML = DEU = 'Tag,Woche,Monat,Quartal,Jahr',
                              ENU = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Show Orders"; Option)
        {
            CaptionML = DEU = 'Aufträge anzeigen',
                        ENU = 'Show Orders';
            OptionCaptionML = DEU = 'Alle Aufträge,Aufträge bis heute,Verzögerte Aufträge',
                              ENU = 'All Orders,Orders Until Today,Delayed Orders';
            OptionMembers = "All Orders","Orders Until Today","Delayed Orders";
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            CaptionML = DEU = 'Arbeitsdatum als Basis verwenden',
                        ENU = 'Use Work Date as Base';
        }
        field(5; "Value to Calculate"; Option)
        {
            CaptionML = DEU = 'Zu berechnender Wert',
                        ENU = 'Value to Calculate';
            OptionCaptionML = DEU = 'Restmenge,Anzahl Aufgaben',
                              ENU = 'Remaining Qty.,No. of Job Task Details';
            OptionMembers = "Remaining Qty.","No. of Job Task Details";
        }
        field(6; "Chart Type"; Option)
        {
            CaptionML = DEU = 'Diagrammart',
                        ENU = 'Chart Type';
            OptionCaptionML = DEU = 'Gestapelte Fläche,Gestapelte Fläche (%),Gestapelte Säule,Gestapelte Säule (%)',
                              ENU = 'Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = "Stacked Area","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }
        field(7; "Latest Order Document Date"; Date)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Max("Sales Header"."Document Date" WHERE("Document Type" = CONST(Order)));
            CaptionML = DEU = 'Neuestes Auftragsbelegdatum',
                        ENU = 'Latest Order Document Date';
            FieldClass = FlowField;
        }
        field(10; Startdate; Date)
        {
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: TextConst DEU = 'Aktualisiert um %1.', ENU = 'Updated at %1.';

    procedure GetCurrentSelectionText(): Text[100];
    begin
        exit(FORMAT("Show Orders") + '|' +
          FORMAT("Period Length") + '|' +
          FORMAT("Value to Calculate") + '|. (' +
          STRSUBSTNO(Text001, TIME) + ')');
    end;

    procedure GetStartDate(): Date;
    var
        StartDate: Date;
    begin
        if "Use Work Date as Base" then
            StartDate := WORKDATE
        else
            StartDate := TODAY;
        if "Show Orders" = "Show Orders"::"All Orders" then begin
            CALCFIELDS("Latest Order Document Date");
            StartDate := "Latest Order Document Date";
        end;

        exit(StartDate);
    end;

    procedure GetChartType(): Integer;
    var
        BusinessChartBuf: Record "Business Chart Buffer";
    begin
        case "Chart Type" of
            "Chart Type"::"Stacked Area":
                exit(BusinessChartBuf."Chart Type"::StackedArea);
            "Chart Type"::"Stacked Area (%)":
                exit(BusinessChartBuf."Chart Type"::StackedArea100);
            "Chart Type"::"Stacked Column":
                exit(BusinessChartBuf."Chart Type"::StackedColumn);
            "Chart Type"::"Stacked Column (%)":
                exit(BusinessChartBuf."Chart Type"::StackedColumn100);
        end;
    end;

    procedure SetPeriodLength(PeriodLength: Option);
    begin
        "Period Length" := PeriodLength;
        MODIFY;
    end;

    procedure SetShowOrders(ShowOrders: Integer);
    begin
        "Show Orders" := ShowOrders;
        MODIFY;
    end;

    procedure SetValueToCalcuate(ValueToCalc: Integer);
    begin
        "Value to Calculate" := ValueToCalc;
        MODIFY;
    end;

    procedure SetChartType(ChartType: Integer);
    begin
        "Chart Type" := ChartType;
        MODIFY;
    end;
}

