/// <summary>
/// Page Interact. Log. Entry Listpart (ID 61001).
/// </summary>
page 61001 "Interact. Log. Entry Listpart"
{
    // version HSG

    CaptionML = DEU = 'Akt. Prot. Posten',
                ENU = 'Interact. Log. Entry';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Interaction Log Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Subject; Rec.Subject)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Time of Interaction"; Rec."Time of Interaction")
                {
                }
                field("From Mail Address"; Rec."From Mail Address")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                CaptionML = DEU = 'F&unktion',
                            ENU = 'F&unctions';
                Image = "Action";
            }
            action(Show)
            {
                CaptionML = DEU = 'E-Mail An&zeigen',
                            ENU = '&Show E-Mail';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Rec."Attachment No." <> 0 then
                        OpenAttachment
                    else
                        Rec.ShowDocument;
                end;
            }
            action("E-Mail")
            {
                CaptionML = DEU = 'Antwort E-Mail Senden',
                            ENU = 'Send Answer E-Mail';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    HSGFunctions_gCdu.SendEMailFromInteractionLogEntry_gFnc(Rec); // JOB_01
                end;
            }
        }
    }

    var
        HSGFunctions_gCdu: Codeunit "HSG Functions";
}

