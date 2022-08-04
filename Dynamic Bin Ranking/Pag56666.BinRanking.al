page 56666 "Bin Ranking"
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    Caption = 'binRanking';
    DelayedInsert = true;
    EntityName = 'binRanking';
    EntitySetName = 'binRankings';
    EntityCaption = 'Bin_Content';
    EntitySetCaption = 'Bin_Contents';
    PageType = API;
    SourceTable = "Bin Content";
    ODataKeyFields = SystemId;
    Editable = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }
                field(zoneCode; Rec."Zone Code")
                {
                    Caption = 'Zone Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(binCode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(variantCode; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(binRanking; Rec."Bin Ranking")
                {
                    Caption = 'Bin Ranking';
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Bin Ranking"));
                    end;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    var
        BinContents: Record "Bin Content";
    begin
        BinContents.GetBySystemId(rec.SystemId);

        if Rec.SystemId = BinContents.SystemId then
            Rec.Modify(true);
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::"Bin Content", FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::"Bin Content";
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;

    var
        TempFieldSet: Record 2000000041 temporary;
}
