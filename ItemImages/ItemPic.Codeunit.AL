codeunit 50196 "JA Get Item Pic"
{
    procedure "Pic as JSON"(ItemNo: Code[20]) : Text;
    var
        Item: Record Item;
        TenantMedia: Record "Tenant Media";
        PicText: Text;
        PicInstr: InStream;
        JObject: JsonObject;
        JToken: JsonToken;
        TempBlob: Codeunit "Temp Blob";
        PicOStr: OutStream;
        Base64: Codeunit "Base64 Convert";
    begin
        Item.Get(ItemNo);
        If Item.Picture.Count = 0 then
            exit('');
        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);
        if TenantMedia.Content.HasValue then begin
            Clear(PicText);
            Clear(PicInstr);
            TenantMedia.Content.CreateInStream(PicInstr);
            PicText := Base64.ToBase64(PicInstr);
            JObject.Add('picture',PicText);
            JObject.SelectToken('picture',JToken);
        end;
        exit(JToken.AsValue().AsText());
    end;
}