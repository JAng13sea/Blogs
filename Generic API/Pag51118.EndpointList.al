page 51118 "Endpoint List"
{
    ApplicationArea = All;
    Caption = 'Endpoint List';
    PageType = List;
    SourceTable = "Endpoint Table Config.";
    UsageCategory = Lists;
    CardPageId = "Endpoint Table Config. Card";
    Editable = false;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
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
        area(Processing)
        {
            action(ViewJson)
            {
                Caption = 'View JSON';
                trigger OnAction()
                var
                    Json: Codeunit "Endpoint Mgt.";
                    JsonObj: JsonObject;
                    C: Record Customer;
                begin
                    JsonObj := Json.PrepareGetDataResponse(Rec);
                    message('%1', format(JsonObj));
                end;
            }
        }
    }
}
