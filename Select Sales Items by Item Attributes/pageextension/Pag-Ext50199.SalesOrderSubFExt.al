pageextension 50199 "Sales Order SubF Ext." extends "Sales Order Subform"
{
    actions
    {
        addlast(processing)
        {
            action(SalesItemsbyAttribute)
            {
                ApplicationArea = All;
                Caption = 'Add Items by Attributes';
                ShortCutKey = 'Shift+Ctrl+A';
                Tooltip = 'Filter items by attributes and add them to the sales document';
                Image = Category;

                trigger OnAction()
                var
                    SalesManagement: Codeunit "Sales Mgt.";
                begin
                    SalesManagement.ShowItemsByAttributesPage(Rec);
                end;
            }

        }
    }
    
}
