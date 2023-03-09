page 51119 "Endpoint Fields subform"
{
    ApplicationArea = All;
    Caption = 'Endpoint Fields subform';
    PageType = ListPart;
    SourceTable = "Endpoint Field Confg.";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Fields)
            {
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the value of the Field ID field.';
                    Editable = false;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the value of the Field Name field.';
                    Editable = false;
                }
                field("Include Field"; Rec."Include Field")
                {
                    ToolTip = 'Specifies the value of the Include Field field.';
                    Editable = not IsPKField;
                }
            }
        }
    }
    var
        IsPKField: Boolean;

    trigger OnAfterGetRecord()
    begin
        if rec."Primary Key" then
            IsPKField := true
        else
            IsPKField := false;
    end;
}
