page 50196 "JA ItemPic API"
{
    PageType = API;
    Caption = 'itempic';
    APIPublisher = 'ja';
    APIGroup = 'customer';
    APIVersion = 'v2.0';
    EntityName = 'itempic';
    EntitySetName = 'itempic';
    SourceTable = Item;
    DelayedInsert = true;
    
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(nummber; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(base_UOM; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field(pictureID; Rec.Picture)
                {
                    ApplicationArea = All;
                }
                field(picture; PictureAsJSON){}
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(item_Category_Code; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
var
    PictureAsJSON: Text;
    
    trigger OnAfterGetRecord();
    var
        GetItemPic: Codeunit "JA Get Item Pic";
    begin
        PictureAsJSON := GetItemPic."Pic as JSON"(Rec."No.");
    end;
}