pageextension 50200 "Sales Order Ext." extends "Sales Order"
{
    layout
    {
        addlast(factboxes)
        {
            part("Sales Line Item Attribute FB"; "Sales Line Item Attribute FB")
            {
                ApplicationArea = All;
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
        }
    }
}
