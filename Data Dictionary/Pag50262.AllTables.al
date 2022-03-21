page 50262 AllTables
{
    ApplicationArea = All;
    Caption = 'All Tables';
    PageType = List;
    SourceTable = "Key";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the value of the TableNo field.';
                    ApplicationArea = All;
                }
                field(TableName; Rec.TableName)
                {
                    ToolTip = 'Specifies the value of the TableName field.';
                    ApplicationArea = All;
                }
                field("Key"; Rec."Key")
                {
                    ToolTip = 'Specifies the value of the Key field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.';
                    ApplicationArea = All;
                }
                field(Unique; Rec.Unique)
                {
                    ToolTip = 'Specifies the value of the Unique field.';
                    ApplicationArea = All;
                }
                field(Clustered; Rec.Clustered)
                {
                    ToolTip = 'Specifies the value of the Clustered field.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
