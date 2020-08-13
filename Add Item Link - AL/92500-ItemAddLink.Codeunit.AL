codeunit 92500 "Item Add-Link"
{
    trigger OnRun()
    begin

    end;

    procedure addlink(ItemNo: Code[50]; LinkUrl: Text; Desc: Text)
    var
        item: Record Item;
    begin
        Item.Get(ItemNo);
        item.AddLink(LinkUrl, Desc)
    end;

}