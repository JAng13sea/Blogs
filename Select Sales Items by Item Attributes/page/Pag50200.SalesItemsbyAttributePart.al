page 50200 "Sales Items by Attribute Part"
{
    ApplicationArea = All;
    Caption = 'Matched Items';
    PageType = ListPart;
    SourceTable = "Sales Items by Attribute";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(variantcode; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the value of the Variantcode field.';
                    ShowMandatory = ShowMandatory;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    trigger OnValidate()
                    begin
                        ValidateQuantity(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SalesMgt: Codeunit "Sales Mgt.";
    begin
        ShowMandatory := SalesMgt.VaraintMandatory(Rec);
    end;

    procedure FindItems(var FilterItemAttributesBuffer: Record "Filter Item Attributes Buffer")
    var
        SalesMgt: Codeunit "Sales Mgt.";
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        Item: Record "Item" temporary;
    begin
        SalesMgt.LoadItems(FilterItemAttributesBuffer, Rec);
    end;

    procedure RemoveItems()
    begin
        If not Rec.IsEmpty then
            Rec.DELETEALL;
    end;

    local procedure ValidateQuantity(Rec: Record "Sales Items by Attribute")
    var
    begin
        OnValidateQuantity(Rec, LocationCode, BaseRecRef);
    end;

    [IntegrationEvent(false, false)]
    procedure OnValidateQuantity(var SalesItemAttribute: record "Sales Items by Attribute"; LocationCode: Code[10]; var RecRef: RecordRef)
    begin
    end;

    procedure SetVars(var _BaseRecRef: RecordRef; var _LocationCode: Code[10])
    begin
        BaseRecRef := _BaseRecRef;
        LocationCode := _LocationCode;
    end;

    var
        BaseRecRef: RecordRef;
        LocationCode: Code[10];
        ShowMandatory: Boolean;
}
