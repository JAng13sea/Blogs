page 50102 "My Item FB2"
{
    Caption = '';
    PageType = Cardpart;
    RefreshOnActivate = true;
    //SourceTable = "Item Picture Values";
    //SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                grid(G1)
                {
                    GridLayout = Columns;
                        field(PreviousArrow; '<     ')
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            trigger OnDrillDown()
                            begin
                                If (i > 1) and (i <= ArrayLen(PicArray)) then
                                    i -= 1;
                                CurrPage.Update(false);
                            end;
                        }

                        field(NextArrow; '>                                                 ')
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            trigger OnDrillDown()
                            begin
                                if i < ArrayLen(PicArray) then
                                    i += 1;
                                CurrPage.Update(false);
                            end;
                    }
                }
                field(Picture; PicArray[i].Picture)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies the picture that has been inserted for the item.';
                }
                field(PictureNumber; WhichPicNumber())
                {
                    ApplicationArea = All;
                    ShowCaption = false;
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
                begin
                    if i < ArrayLen(PicArray) then
                        i += 1;
                    CurrPage.Update(false);
                end;
            }
            action(PreviousImage)
            {
                ApplicationArea = All;
                Image = PreviousSet;
                Caption = 'Previous Image';
                trigger OnAction()
                begin
                    If (i > 1) and (i <= ArrayLen(PicArray)) then
                        i -= 1;
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        ItemPicValues: Record "Item Picture Values";
        ArrayLoop: Integer;
    begin
        i := 1;
        ArrayLoop := 1;
        if ItemPicValues.FindSet() then
            repeat
                PicArray[ArrayLoop] := ItemPicValues;
                ArrayLoop += 1;
            until ItemPicValues.Next() = 0;
    end;

    procedure ImportImagesForItem(pItem: Record Item)
    var
        TenantMedia: Record "Tenant Media";
        InS: InStream;
        i: Integer;
        ItemPics: Record "Item Picture Values";
    begin
        ItemPics.DeleteAll();
        If pItem.Picture.Count > 1 then
            for i := 1 to pItem.Picture.Count do begin
                if TenantMedia.get(pItem.Picture.Item(i)) then begin
                    TenantMedia.CalcFields(Content);
                    TenantMedia.Content.CreateInStream(InS);
                    ItemPics.Init();
                    ItemPics."Entry No." := i;
                    ItemPics."Item Code" := pItem."No.";
                    ItemPics.Description := pItem.Description;
                    ItemPics.Insert();
                    ItemPics.Picture.ImportStream(InS, ItemPics.Description);
                    ItemPics.Modify();
                end;
            end;
    end;

    local procedure WhichPicNumber(): Text[10]
    var
    Text001: Label 'Picture %1';
    begin
        exit(StrSubstNo(Text001,i));
    end;

    // procedure LoadImage(id: Guid; Item: Record Item)
    // var
    //     TenantMedia: Record "Tenant Media";
    //     InS: InStream;
    // begin
    //     //Clear(Rec);
    //     If TenantMedia.Get(id) then begin
    //         TenantMedia.SetLoadFields(Content);
    //         TenantMedia.CalcFields(Content);
    //         TenantMedia.Content.CreateInStream(InS);
    //         Rec.Init();
    //         Rec."No." := Item."No.";
    //         Rec.Description := Item.Description;
    //         if Item."Current Picture No." = 0 then
    //             Rec."Current Picture No." := 1
    //         else
    //             Rec."Current Picture No." := Item."Current Picture No.";
    //         Rec.Insert();
    //         Rec.Picture.ImportStream(InS, Item.Description);
    //         Rec.Modify();
    //     end;
    // end;

    var
        PicArray: array[10] of Record "Item Picture Values";
        i: Integer;
}

