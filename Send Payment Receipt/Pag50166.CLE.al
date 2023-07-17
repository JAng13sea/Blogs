page 50166 CLE
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'cle';
    DelayedInsert = true;
    EntityName = 'cle';
    EntitySetName = 'cles';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
            }
        }
    }
}
