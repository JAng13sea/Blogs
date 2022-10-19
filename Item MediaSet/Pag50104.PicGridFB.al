page 50104 "Pic Grid FB"
{
    Caption = 'Item Pictures';
    PageType = CardPart;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                grid(MyGrid1)
                {
                    fixed(MyFixed1)
                    {
                        group(Wash)
                        {
                            Caption = 'Picture 1';

                            field(WashPicture; ItemPictureValue[1].Picture)
                            {
                                Caption = '';
                                ApplicationArea = All;
                            }
                        }
                        group(Bleach)
                        {
                            Caption = 'Picture 2';
                            field(BleachPicture; ItemPictureValue[2].Picture)
                            {
                                Caption = '';
                                ApplicationArea = All;
                            }
                        }
                        group(Iron)
                        {
                            Caption = 'Picture 3';
                            field(IronPicture; ItemPictureValue[3].Picture)
                            {
                                Caption = '';
                                ApplicationArea = All;
                            }
                        }
                    }
                }
                grid(MyGrid2)
                {
                    fixed(MyFixed2)
                    {
                        group(Dry)
                        {
                            Caption = 'Picture 4';
                            field(DryPicture; ItemPictureValue[4].Picture)
                            {
                                Caption = '';
                                ApplicationArea = All;
                            }
                        }
                        group(DryClean)
                        {
                            Caption = 'Picture 5';
                            field(DryCleanPicture; ItemPictureValue[5].Picture)
                            {
                                ApplicationArea = All;
                            }
                        }
                        group(Empty)
                        {
                            Caption = 'Picture 6';
                            field(EmptyPicture; ItemPictureValue[6].Picture)
                            {
                                ApplicationArea = All;
                            }
                        }
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        ItemPicValues: Record "Item Picture Values";
        ArrayLoop: Integer;
    begin
        ArrayLoop := 1;
        if ItemPicValues.FindSet() then
            repeat
                ItemPictureValue[ArrayLoop] := ItemPicValues;
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
    var
        ItemPictureValue: array[10] of Record "Item Picture Values";
}
