page 56600 "Job Kanban Board"
{
    ApplicationArea = All;
    Caption = 'Jobs Kanban Board';
    UsageCategory = Lists;
    PageType = ListPlus;
    SourceTable = Job;
    SourceTableTemporary = true;
    SaveValues = false;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            Group(Lane1)
            {
                ShowCaption = false;
                part(Planning; "Job Kanban Lane")
                {
                    ApplicationArea = All;
                    SubPageView = where(Status = const(Planning));
                    Caption = '✏️ Planning';
                    ShowFilter = false;
                }
                part(Quote; "Job Kanban Lane")
                {
                    ApplicationArea = All;
                    SubPageView = where(Status = const(Quote));
                    Caption = '📄 Quote';
                    ShowFilter = false;
                }


            }
            group(Lane2)
            {
                ShowCaption = false;
                part(Open; "Job Kanban Lane")
                {
                    ApplicationArea = All;
                    SubPageView = where(Status = const(Open));
                    Caption = '🔨 Open';
                    ShowFilter = false;
                }
                part(Completed; "Job Kanban Lane")
                {
                    ApplicationArea = All;
                    SubPageView = where(Status = const(Completed));
                    Caption = '🏁 Completed';
                    ShowFilter = false;
                }
            }
        }
    }
}


