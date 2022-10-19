page 50101 "My Item Picture FB"
{
    Caption = '';
    PageType = Cardpart;
    SourceTable = "Item";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies the picture that has been inserted for the item.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(NextImage)
            {
                ApplicationArea = All;
                Image = NextSet;
                Caption = 'Next Image';
                trigger OnAction()
                var
                    Item: Record Item;
                    i: Integer;
                begin
                    Item.Get(Rec."No.");
                    i := Item.Picture.Count;
                    if Item."Current Picture No." < i then begin
                        Item."Current Picture No." += 1;
                        Item.Modify(false);
                        LoadImage(Rec.Picture.Item(Item."Current Picture No."), Rec);
                    end;
                end;
            }
            action(PreviousImage)
            {
                ApplicationArea = All;
                Image = PreviousSet;
                Caption = 'Previous Image';
                trigger OnAction()
                var
                    vItem: Record Item;
                begin
                    CurrPage.Close();
                    vItem.Get(Rec."No.");
                    if vItem."Current Picture No." >= 0 then begin
                        vItem.Get(Rec."No.");
                        vItem."Current Picture No." -= 1;
                        vItem.Modify(false);
                        LoadImage(Rec.Picture.Item(vItem."Current Picture No."), vItem);
                    end;
                end;
            }
        }
    }
    procedure LoadImage(id: Guid; Item: Record Item)
    var
        TenantMedia: Record "Tenant Media";
        InS: InStream;
    begin
        //Clear(Rec);
        If TenantMedia.Get(id) then begin
            TenantMedia.SetLoadFields(Content);
            TenantMedia.CalcFields(Content);
            TenantMedia.Content.CreateInStream(InS);
            Rec.Init();
            Rec."No." := Item."No.";
            Rec.Description := Item.Description;
            if Item."Current Picture No." = 0 then
                Rec."Current Picture No." := 1
            else
            Rec."Current Picture No." := Item."Current Picture No.";
            Rec.Insert();
            Rec.Picture.ImportStream(InS, Item.Description);
            Rec.Modify();
        end;
    end;

    var
    PicArray: array[10] of Record "Tenant Media";  
}
