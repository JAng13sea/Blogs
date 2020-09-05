page 50102 "GLAccount Entity"
{
    PageType = Card;
    Caption = 'GLAccounts';
    UsageCategory = Lists;
    ApplicationArea = All;
    ModifyAllowed = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    SourceTable = "G/l Account";
    AccessByPermission = page "GLAccount Entity" = x;


    layout
    {
        area(Content)
        {
            field(id; Id)
            {
                Caption = 'Id', Locked = true;
                ApplicationArea = All;
                Editable = false;
            }
            field(Number; "No.")
            {
                Caption = 'Number';
                ApplicationArea = All;
            }
            field(name; Name)
            {
                Caption = 'name';
                ApplicationArea = All;
            }
            field(Acctype; "Account Type")
            {
                Caption = 'acctype';
                ApplicationArea = All;
            }
            field(subCategory; "Account Subcategory Descript.")
            {
                ApplicationArea = All;
                Caption = 'SubCategory', Locked = true;
            }
            field(blocked; Blocked)
            {
                ApplicationArea = All;
                Caption = 'Blocked', Locked = true;
                ToolTip = 'Specifies the status of the account.';
            }
            field(lastModifiedDateTime; "Last Modified Date Time")
            {
                ApplicationArea = All;
                Caption = 'LastModifiedDateTime', Locked = true;
            }

            field(Number2; "No. 2")
            {
                ApplicationArea = All;
                Caption = 'Number2', Locked = true;
            }

            field(DirectPosting; "Direct Posting")
            {
                ApplicationArea = All;
                Caption = 'DirectPosting', Locked = true;
            }

            field(GBPG; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'GBPG', Locked = true;
            }

            field(GPPG; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'GPPG', Locked = true;
            }

            field(VBPG; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'VBPG', Locked = true;
            }

            field(VPPG; "VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'VPPG', Locked = true;
            }

            field(PostingType; "Gen. Posting Type")
            {
                ApplicationArea = All;
                Caption = 'PostingType', Locked = true;
            }
            field(Balance; "Balance")
            {
                ApplicationArea = All;
                Caption = 'Balance', Locked = true;
            }
        }
    }
}