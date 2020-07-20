pageextension 58101 "XPE Demand Forecast" extends "Demand Forecast Matrix"
{
    layout
    {
        addafter(Description)
        {
            field("Item Category"; "Item Category Code")
            {
                ApplicationArea = All;
                Caption = 'Item Category Code';
                Editable = false;
            }

            field("Replenishment System"; "Replenishment System")
            {
                ApplicationArea = All;
                Caption = 'Replenishment System';
                Editable = false;
            }

            field("Low-Level Code"; "Low-Level Code")
            {
                ApplicationArea = All;
                Caption = 'Low-Level Code';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        ItemCategoryFilter: Code[20];
        ReplenishmentFilter: Enum "Replenishment System";
}