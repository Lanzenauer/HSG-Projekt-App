/// <summary>
/// PageExtension "JobTaskLinesExtensionn" (ID 61023) extends Record Job Task Lines //1002.
/// </summary>
pageextension 61023 JobTaskLinesExtensionn extends "Job Task Lines" //1002
{
    layout
    {
        modify("Job No.")
        {
            Visible = false;
        }
        modify("EAC (Total Cost)")
        {
            CaptionML = ENU = 'EAC (Total Cost)', DEU = 'BK (Einstandsbetrag)';
        }

    }
}
