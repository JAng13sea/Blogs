page 59240 "Calc. ServCon Lines API"
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    Caption = 'servConLinesAPI';
    DelayedInsert = true;
    EntityName = 'calcServConLine';
    EntitySetName = 'calcServConLines';
    PageType = API;
    SourceTable = "Service Contract Line";
    SourceTableTemporary = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(contractNo; Rec."Contract No.")
                {
                    Caption = 'Contract No.';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(serviceItemNo; Rec."Service Item No.")
                {
                    Caption = 'Service Item No.';
                }
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
                }
                field(nextPlannedServiceDate; Rec."Next Planned Service Date")
                {
                    Caption = 'Next Planned Service Date';
                }
                field(lastPlannedServiceDate; Rec."Last Planned Service Date")
                {
                    Caption = 'Last Planned Service Date';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(contractExpirationDate; Rec."Contract Expiration Date")
                {
                    Caption = 'Contract Expiration Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
    trigger OnFindRecord(Which: Text): Boolean
    begin
        if not LinesLoaded then begin
            LoadLines.LoadServiceConLines(Rec);
            if not Rec.FindFirst() then
                exit(false);
            LinesLoaded := true;
        end;
        exit(true);
    end;

    var
        LinesLoaded: Boolean;
        LoadLines: Codeunit "API Line Loader";
}
