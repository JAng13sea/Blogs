page 51120 "Endpoint Table Config. Card"
{
    ApplicationArea = All;
    Caption = 'Endpoint Table Config. Card';
    PageType = ListPlus;
    SourceTable = "Endpoint Table Config.";
    DataCaptionFields = "Table ID","Table Name";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the value of the Table ID field.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.';
                    Editable = false;
                }
            }
            part("Endpoint Fields subform"; "Endpoint Fields subform")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = FIELD("Table ID");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(FieldFilters)
            {
                Caption = 'Field Filters';
                Image = FilterLines;
                trigger OnAction()
                var
                    EndpointMgt: Codeunit "Endpoint Mgt.";
                begin
                    EndpointMgt.ShowFilters(Rec);
                end;
            }
        }
    }
}
