query 50750 "Purch. Order Data Query"
{

    elements
    {
        dataitem(Purchase_Header; "Purchase Header")
        {
            DataItemTableFilter = "Document Type" = CONST(Order),
"Expected Receipt Date" = FILTER(<> '');
            column(Buy_from_Vendor_No; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {
            }
            column(No; "No.")
            {
            }
            column(Expected_Receipt_Date; "Expected Receipt Date")
            {
            }
            column(Ship_to_Post_Code; "Ship-to Post Code")
            {
            }
            dataitem(Purchase_Line; "Purchase Line")
            {
                DataItemLink = "Document Type" = Purchase_Header."Document Type",
"Document No." = Purchase_Header."No.";
                DataItemTableFilter = "Document Type" = CONST(Order);
                column(ItemNo; "No.")
                {
                    Caption = 'ItemNo';
                }
                column(Description; Description)
                {
                }
                column(Outstanding_Quantity; "Outstanding Quantity")
                {
                }
                dataitem(Contact; Contact)
                {
                    DataItemLink = "No." = Purchase_Header."Buy-from Contact No.";
                    column(E_Mail; "E-Mail")
                    {
                    }
                    column(ContactName; Name)
                    {
                    }
                }
            }
        }
    }
}

