/// <summary>
/// PageExtension "JobListExtension" (ID 61000) extends Record Job List // 89.
/// </summary>
pageextension 61000 JobListExtension extends "Job List" // 89
{
    actions
    {
        addlast(navigation)
        {
            action("Additional Costs")
            {
                Caption = 'Zusatzkosten';
                Image = Costs;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Additional Cost";
                RunPageLink = "Job No." = FIELD("No.");
            }
            action(JobTasLinesHSG)
            {
                Caption = 'Projekaufgaben Status';
                Image = TaskPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Task Lines HSG";
                RunPageLink = "Job No." = FIELD("No.");
            }

            action("Job Details")
            {
                CaptionML = DEU = 'Projekaufgaben Details',
                                ENU = 'Job Task Details';
                RunObject = Page "Job Task Detail List";
                RunPageLink = "Job No." = FIELD("No.");
            }
        }
        addlast(Prices)
        {
            action("Job Discounts")
            {
                CaptionML = DEU = 'Projekt Rabatte',
                                ENU = 'Job Discounts';
                Image = Discount;
                RunObject = Page "Job Task Discount List";
                RunPageLink = "Job No." = FIELD("No.");
            }

        }
    }
}
