tableextension 61001 "To-DoTableExtension" extends "To-do"
{
    fields
    {
    }
    procedure CreateToDoFromInteractLogEntry(InteractionLogEntry: Record "Interaction Log Entry");
    begin
        INIT;
        VALIDATE("Contact No.", InteractionLogEntry."Contact No.");
        "Salesperson Code" := InteractionLogEntry."Salesperson Code";
        "Campaign No." := InteractionLogEntry."Campaign No.";

        StartWizard;
    end;

}
