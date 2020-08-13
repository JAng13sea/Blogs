page 92500 "WS Item Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    ODataKeyFields = "No.";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(SystemId; Id)
                {
                    ApplicationArea = All;

                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    [ServiceEnabled]
    procedure AddItemURL(ItemCode: Code[20]; WebURL: Text; Description: Text)
    var
        AddLinkMgt: Codeunit "Item Add-Link";
        actionContext: WebServiceActionContext;

    begin
        actionContext.SetObjectType(ObjectType::page);
        actionContext.SetObjectId(page::"WS Item Card");
        actionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        AddLinkMgt.addlink(Rec."No.", WebURL, Description);
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}