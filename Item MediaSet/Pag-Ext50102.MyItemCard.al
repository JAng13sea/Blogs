pageextension 50102 "My Item Card" extends "Item Card"
{
    layout
    {
        addafter(ItemPicture)
        {
            part(MyItemPictureFB; "My Item FB2")
            {
                ApplicationArea = All;
                Visible = PicFBVisible;
                //SubPageLink = "Item Code" = FIELD("No.");
            }
        }
    }

    trigger OnOpenPage()
    var
        TenantMedia: Record "Tenant Media";
    begin
        If (Rec.Picture.Count > 1) then begin
            PicFBVisible := true;
            // If Rec."Current Picture No." = 0 then
            //     CurrPage.MyItemPictureFB.Page.LoadImage(Rec.Picture.Item(1), Rec)
            // else
            //     CurrPage.MyItemPictureFB.Page.LoadImage(Rec.Picture.Item(Rec."Current Picture No."), Rec);
            CurrPage.MyItemPictureFB.Page.ImportImagesForItem(Rec);
        end;
    end;

    var
        PicFBVisible: Boolean;
}
