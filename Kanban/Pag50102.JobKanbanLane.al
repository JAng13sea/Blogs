page 56602 "Job Kanban Lane"
{
    ApplicationArea = All;
    Caption = ' ';
    PageType = ListPart;
    SourceTable = "Job";
    ShowFilter = false;
    Editable = false;
    CardPageId = "Job Card";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MultiFieldRecordValue; MultiFieldRecord(Rec))
                {
                    Caption = 'Job';
                    MultiLine = true;
                    DrillDown = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Previous)
            {
                Image = PreviousSet;
                Scope = Repeater;
                trigger OnAction()
                var
                    Error01: Label 'A Job of Status Planning cannot be moved to a previous status';
                    Job: Record Job;
                begin
                    Job.Copy(Rec);
                    CurrPage.SetSelectionFilter(Job);
                    if Job.FindSet() then
                        repeat
                            case Job.Status of
                                Job.Status::Planning:
                                    Error(Error01);
                                Job.Status::Quote:
                                    Job.Status := Job.Status::Planning;
                                Job.Status::Open:
                                    Job.Status := Job.Status::Quote;
                                Job.Status::Completed:
                                    Job.Status := Job.Status::Open;
                            end;
                            Job.Modify(true);
                        until Job.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            action(Next)
            {
                Image = NextSet;
                Scope = Repeater;
                trigger OnAction()
                var
                    Error02: Label 'A Job of Status Completed cannot be moved to a next status';
                    Job: Record Job;
                begin
                    Job.Copy(Rec);
                    CurrPage.SetSelectionFilter(Job);
                    if Job.FindSet() then
                        repeat
                            case Job.Status of
                                Job.Status::Planning:
                                    Job.Status := Job.Status::Quote;
                                Job.Status::Quote:
                                    Job.Status := Job.Status::Open;
                                Job.Status::Open:
                                    Job.Status := Job.Status::Completed;
                                Job.Status::Completed:
                                    Error(Error02);
                            end;
                            Job.Modify(true);
                        until Job.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }
    local procedure MultiFieldRecord(pJob: Record Job): Text
    var
        RecTxt: Text;
        TxtBuilder: TextBuilder;
        i: Integer;
    Begin
        if (pJob."No." <> '') and (pjob.Description <> '') then begin
            TxtBuilder.AppendLine('No.: ' + pJob."No.");
            TxtBuilder.AppendLine();
            TxtBuilder.AppendLine('Description: ' + pJob.Description);
            TxtBuilder.AppendLine('Customer: ' + pJob."Sell-to Customer Name");
            exit(TxtBuilder.ToText());
        end else
            exit('');
    End;
}
