page 51123 "Endpoint Field Filters"
{
    ApplicationArea = All;
    Caption = 'Endpoint Field Filters';
    PageType = List;
    SourceTable = "Endpoint Field Filters";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the field on which you want to filter records in the configuration table.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        ConfigPackageMgt: Codeunit "Config. Package Management";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        ConfigPackageMgt.SetFieldFilter(Field, Rec."Table ID", 0);
                        if FieldSelection.Open(Field) then begin
                            Rec.Validate("Field ID", Field."No.");
                            CurrPage.Update(true);
                        end;
                    end;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the value of the Field Caption field.';
                }
                field("Field Filter"; Rec."Field Filter")
                {
                    ToolTip = 'Specifies the value of the Field Filter field.';
                }
            }
        }
    }
}
