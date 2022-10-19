pageextension 50101 "Item Pic Ext" extends "Item Picture"
{
    layout
    {
        addlast(content)
        {
            field(PicCount; PicCount())
            {
                ApplicationArea = All;
                Caption = 'Picture Count';

                trigger OnDrillDown()
                begin
                    ViewAssignedImages();
                end;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(ImportAnotherPicture)
            {
                ApplicationArea = All;
                Caption = 'Import Additional';
                Image = Import;
                ToolTip = 'Import another picture file.';

                trigger OnAction()
                begin
                    ImportFromDevice2;
                end;
            }
            action(DeleteImage)
            {
                ApplicationArea = All;
                Caption = 'Delete a picture';
                Image = "Invoicing-Delete";
                ToolTip = 'Delete a picture if there is more than 1';

                trigger OnAction()
                var
                    DeleteImage: Report "Delete Item Picture";
                begin
                    DeleteImage.SetItemNumberFilter(Rec);
                    DeleteImage.Run();
                end;
            }
            
            action(Toggle)
            {
                ApplicationArea = All;
                Caption = 'All Images';
                Image = NextRecord;
                ToolTip = 'Import another picture file.';

                trigger OnAction()
                begin
                    ViewAssignedImages();
                end;
            }
        }
    }

    procedure ImportFromDevice2()
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
        InS: InStream;
        PicCounter: Integer;
    begin
        Rec.Find;
        Rec.TestField("No.");
        ClientFileName := '';
        PicCounter := Rec.Picture.Count + 1;
        FileName := StrSubstNo('%1-%2', Rec."No.", PicCounter);
        if UploadIntoStream('Additional Item Picture', '', '', FileName, InS) then begin
            Rec.Picture.ImportStream(InS, FileName);
            Rec.modify(true);
        end;
    end;

    local procedure ViewAssignedImages()
    var
        PicCounter: Integer;
        i: Integer;
        TenantMedia: Record "Tenant Media";
        TempTenantMedia: Record "Tenant Media" temporary;
        TempItem: Record Item temporary;
        InS: InStream;
    begin
        If Rec.Picture.Count > 1 then
            for i := 1 to Rec.Picture.Count do begin
                if TenantMedia.get(Rec.Picture.Item(i)) then begin
                    TenantMedia.CalcFields(Content);
                    TenantMedia.Content.CreateInStream(InS);
                    TempItem.Init();
                    TempItem."No." := Format(i);
                    TempItem.Description := Rec.Description;
                    TempItem.Insert();
                    TempItem.Picture.ImportStream(InS, Rec.Description);
                    TempItem.Modify();
                end;
            end;
        page.Run(0, TempItem);
    end;

    local procedure PicCount() CountResult: Integer
    var
        IsHandled: Boolean;
    begin
        CountResult := Rec.Picture.Count;
    end;
}
