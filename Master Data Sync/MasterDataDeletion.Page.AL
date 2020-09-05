page 50100 "Master Data Deletion Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Deleted Master Data";
    SourceTableView = sorting("Entry No.") order(descending);
    DeleteAllowed = true;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Data Type"; "Data Type")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(ID; ID)
                {
                    ApplicationArea = All;
                }
            }
        }

    }
}