page 61005 "Job Task Detail History FactBo"
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

    Caption = 'Job Task Detail History FactBox';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Job Task Detail History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LastDate; LastDate)
                {
                    Editable = false;
                }
                field(User; User)
                {
                    Editable = false;
                }
                field("Field"; Field)
                {
                    Editable = false;
                }
                field(Change; Change)
                {
                    Editable = false;
                }
                field("Short Note"; "Short Note")
                {

                    trigger OnValidate();
                    begin
                        //IF User <> USERID THEN
                        //  ERROR(Text001_gCtx);
                    end;
                }
                field("User Note Date"; "User Note Date")
                {
                    Visible = false;
                }
                field("Processing by changed"; "Processing by changed")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Filter_ProcessingByChanged_Only_Ctl)
            {
                CaptionML = DEU = 'Filter "Processing by changed" only',
                            ENU = 'Filter "Processing by changed" only';

                trigger OnAction();
                begin
                    SETRANGE("Processing by changed", true);
                end;
            }
        }
    }

    var
        Text001_gCtx: TextConst DEU = 'Dieser Kommentar kann nur durch den User der Zeile geändert werden.', ENU = 'User Note can only be changed by the user of this line.';
}

