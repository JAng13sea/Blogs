page 50201 "Added Sales Lines Subform"
{
    ApplicationArea = All;
    Caption = 'Added Sales Lines Subform';
    PageType = ListPart;
    SourceTable = "Sales Line";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                    Style = Favorable;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item or service on the line.';
                    Style = Favorable;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity of the sales order line.';
                    Style = Favorable;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the sales unit of measure for this product or service.';
                    Style = Favorable;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price for one unit on the sales line.';
                    Style = Favorable;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(9);
        Rec.SetRange("Document Type", Rec."Document Type"::Order);
        Rec.SetRange("Document No.", SalesOrderNumber);
        Rec.SetRange("Line No.", LastLineNo+1, 9999999);
        Rec.FilterGroup(0);
    end;

    procedure SetFilters(_SONumber: Code[10]; _lastLineNo: Integer)
    begin
        SalesOrderNumber := _SONumber;
        LastLineNo := _lastLineNo;
    end;

    var
        SalesOrderNumber: Code[10];
        LastLineNo: Integer;
}
