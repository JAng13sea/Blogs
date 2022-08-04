page 56667 "Bins API"
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    Caption = 'binsAPI';
    DelayedInsert = true;
    EntityName = 'bin';
    EntitySetName = 'bins';
    PageType = API;
    SourceTable = Bin;
    ODataKeyFields = Code;
    Editable = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(binRanking; Rec."Bin Ranking")
                {
                    Caption = 'Bin Ranking';
                }
                field(id;Rec.SystemId)
                {
                    Caption = 'id';
                    Editable = false;
                }
            }
        }
    }
}
