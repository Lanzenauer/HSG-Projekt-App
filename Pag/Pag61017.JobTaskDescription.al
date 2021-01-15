page 61017 "Job Task Description"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // D - 22549 Hamburg
    // 
    // Date    Module  ID  Description
    // ========================================================================================
    // 050115  HSG_00  JS  created
    // 070215  HSG_01  CH Property AutoSplitKey set to Yes

    AutoSplitKey = true;
    Caption = 'Projektaufgabe Beschreibung';
    PageType = List;
    SourceTable = "Job Task Description";
    SourceTableView = SORTING("Job No.", "Job Task No.", "Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
                field(Internal; Rec.Internal)
                {
                }
                field(Description; Rec.Description)
                {
                    CaptionML = DEU = 'Beschreibungs Text',
                                ENU = 'Description Text';
                }
                field("Line No."; Rec."Line No.")
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
            action("New by Editor")
            {
                CaptionML = DEU = 'Neu mit Editor',
                            ENU = 'New by Editor';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+I';

                // trigger OnAction();
                // var
                //     EditorPageHandling_loc: Codeunit "Editor page Handling";
                // begin
                //     EditorPageHandling_loc.CallFromCommentLine(Rec, true);
                // end;
            }
            action(Editor)
            {
                CaptionML = DEU = 'Editor',
                            ENU = 'Editor';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+E';

                // trigger OnAction();
                // var
                //     EditorPageHandling_loc: Codeunit "Editor page Handling";
                // begin
                //     EditorPageHandling_loc.CallFromCommentLine(Rec, false);
                // end;
            }
        }
    }
}

