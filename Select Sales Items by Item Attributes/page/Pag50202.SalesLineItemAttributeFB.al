page 50202 "Sales Line Item Attribute FB"
{
    ApplicationArea = All;
    Caption = 'Sales Line Item Attributes';
    PageType = CardPart;
    SourceTable = "Sales Line";
    Editable = false;

    layout
    {
        area(content)
        {
            field(AttributeText; AttributeText)
            {
                ApplicationArea = Basic, Suite;
                Caption = '';
                ToolTip = 'Specifies the attribute of the item.';
                MultiLine = true;
                Editable = false;
            }
            // repeater(r1)
            // {
            //     field(AttributeText2; AttributeText)
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = '';
            //         ToolTip = 'Specifies the attribute of the item.';
            //         MultiLine = true;
            //         Editable = false;
            //     }
            // }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.ClearSalesHeader;
        Clear(AttributeText);
        AttributeText := SalesMgt.LoadItemAttributesFactBoxData(ShowNo());
    end;

    trigger OnAfterGetRecord()
    begin
        SalesInfoPaneMgt.ResetItemNo;
    end;

    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesMgt: Codeunit "Sales Mgt.";
        AttributeText: Text;

    local procedure ShowNo(): Code[20]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec."No.");
    end;
}
