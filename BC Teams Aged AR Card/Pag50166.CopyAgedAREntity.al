page 50166 "Copy Aged AR Entity"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Aged Accounts Receivable';
    EntitySetCaption = 'Aged Accounts Receivables';
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    EntityName = 'copyagedAccountsReceivable';
    EntitySetName = 'copyagedAccountsReceivables';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = API;
    APIPublisher = 'ja';
    APIGroup = 'jagrp';
    SourceTable = "Aged Report Entity";
    SourceTableTemporary = true;
    Extensible = false;
    ODataKeyFields = AccountId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(customerId; Rec.AccountId)
                {
                    Caption = 'Customer Id';
                }
                field(customerNumber; Rec."No.")
                {
                    Caption = 'Customer No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(balanceDue; Rec.Balance)
                {
                    Caption = 'Balance';
                }
                field(currentAmount; Rec.Before)
                {
                    Caption = 'Before';
                }
                field(period1Amount; Rec."Period 1")
                {
                    Caption = 'Period 1';
                }
                field(period2Amount; Rec."Period 2")
                {
                    Caption = 'Period 2';
                }
                field(period3Amount; Rec."Period 3")
                {
                    Caption = 'Period 3';
                }
                field(period4Amount; Rec."Period 4")
                {
                    Caption = 'Period 4';
                }
                field(agedAsOfDate; Rec."Period Start Date")
                {
                    Caption = 'Period Start Date';
                }
                field(periodLengthFilter; Rec."Period Length")
                {
                    Caption = 'Period Length';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        GraphMgtReports: Codeunit "Copy Graph Mgt - Reports";
        RecVariant: Variant;
        ReportAPIType: Option "Balance Sheet","Income Statement","Trial Balance","CashFlow Statement","Aged Accounts Payable","Aged Accounts Receivable","Retained Earnings";
    begin
        RecVariant := Rec;
        GraphMgtReports.SetUpAgedReportAPIData(RecVariant, ReportAPIType::"Aged Accounts Receivable");
    end;
}
