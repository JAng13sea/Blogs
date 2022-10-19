report 50148 "Delete Item Picture"
{
    Caption = 'Delete Item Image';
    ProcessingOnly = true;
    Permissions = tabledata "Tenant Media" = RIMD;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()
            begin
                Item.SetRange("No.", ItemFilter);
            end;

            trigger OnAfterGetRecord()
            var
                TenantMedia: Record "Tenant Media";
            begin
                Item.SetLoadFields(Picture);
                if Item.Picture.Count >= 2 then begin
                    if TenantMedia.Get(Item.Picture.Item(PictureNumber)) then begin
                        TenantMedia.Delete();
                        Message('Picture number %1 has been deleted', PictureNumber);
                    end;
                end else begin
                    Message('Item record only has 1 picture. Use the standard method to delete');
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                    field(ItemFilter; ItemFilter)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        StyleExpr = 'Unfavorable';
                    }
                    field(PictureNumber; PictureNumber)
                    {
                        Caption = 'Picture Number';
                        ApplicationArea = All;
                        MinValue = 1;
                    }
                }
            }
        }
    }

    procedure SetItemNumberFilter(Item: Record Item)
    begin
        ItemFilter := Item."No.";
    end;

    var
        PictureNumber: Integer;
        ItemFilter: Code[30];
}
