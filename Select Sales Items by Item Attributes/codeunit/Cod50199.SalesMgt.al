codeunit 50199 "Sales Mgt."
{
    procedure LoadItems(var FilterItemAttributesBuffer: Record "Filter Item Attributes Buffer"; var Rec: Record "Sales Items by Attribute" temporary)
    var
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        Item: Record "Item" temporary;
    begin
        if not Rec.IsEmpty then
            Rec.DELETEALL;
        Item.SetLoadFields("No.", Description, "Variant Mandatory if Exists", "Sales Unit of Measure", "Sales Blocked", Blocked);
        ItemAttributeManagement.FindItemsByAttributes(FilterItemAttributesBuffer, Item);

        Item.SetRange(Blocked, false);
        Item.SetRange("Sales Blocked", false);
        if Item.FindSet then
            repeat
                Rec."No." := Item."No.";
                Rec.Description := Item.Description;
                Rec.Quantity := 0;
                Rec."Variant Mandatory if Exists" := Item."Variant Mandatory if Exists";
                Rec."Sales Unit of Measure" := Item."Sales Unit of Measure";
                Rec.Insert();
            until Item.Next = 0;
    end;

    procedure ShowItemsByAttributesPage(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        ItemAttributeFilter: Page "Sales Items by Attribute";
        RecRef: RecordRef;
        LastLineNo: Integer;
    begin
        SalesHeader.get(Rec."Document Type", Rec."Document No.");
        clear(ItemAttributeFilter);
        RecRef.GetTable(Rec);
        If Rec.FindLast() then
            LastLineNo := Rec."Line No."
        else
            LastLineNo := 0;
        ItemAttributeFilter.SetVars(RecRef, SalesHeader."Location Code", SalesHeader."No.", LastLineNo);
        ItemAttributeFilter.Run();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Items by Attribute Part", 'OnValidateQuantity', '', false, false)]
    local procedure OnValidateQuantity(var SalesItemAttribute: record "Sales Items by Attribute"; LocationCode: Code[10]; var RecRef: RecordRef)
    var
    begin
        if RecRef.Number() <> Database::"Sales Line" then
            exit;
        AddModifySalesLine(SalesItemAttribute, LocationCode, RecRef);
    end;

    local procedure AddModifySalesLine(var SalesItemAttribute: record "Sales Items by Attribute"; LocationCode: Code[10]; var RecRef: RecordRef)
    var
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
    begin
        RecRef.SetTable(SalesLine);
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetRange("No.", SalesItemAttribute."No.");
        SalesLine2.SetRange("Variant Code", SalesItemAttribute."Variant Code");
        SalesLine2.SetRange("Unit of Measure Code", SalesItemAttribute."Sales Unit of Measure");
        SalesLine2.SetRange("Location Code", LocationCode);
        if SalesLine2.findfirst() then begin
            if SalesItemAttribute.Quantity = 0 then
                SalesLine2.Delete(true)
            else begin
                SalesLine2.Validate(Quantity, SalesItemAttribute.Quantity);
                SalesLine2.Modify(true);
            end;
        end else begin
            if SalesItemAttribute.Quantity <> 0 then
                CreateSalesLine(SalesItemAttribute, LocationCode, SalesLine);
        end;
    end;

    local procedure CreateSalesLine(var SalesItemAttribute: record "Sales Items by Attribute" temporary; LocationCode: Code[10]; SalesLine: Record "Sales Line")
    var
        SalesLine2: Record "Sales Line";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        LineNo: Integer;
    begin
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        if SalesLine2.FindLast() then
            LineNo := SalesLine2."Line No." + 10000
        else
            LineNo := 10000;

        clear(SalesLine2);
        SalesLine2."Document Type" := SalesLine."Document Type";
        SalesLine2.Validate("Document No.", SalesLine."Document No.");
        SalesLine2."Line No." := LineNo;
        SalesLine2.Insert(true);

        SalesLine2.Type := SalesLine2.Type::Item;
        SalesLine2.Validate("No.", SalesItemAttribute."No.");
        SalesLine2.Validate("Variant Code", SalesItemAttribute."Variant Code");
        SalesLine2.Validate("Unit of Measure Code", SalesItemAttribute."Sales Unit of Measure");
        SalesLine2.Validate("Location Code", LocationCode);
        SalesLine2.validate(Quantity, SalesItemAttribute.Quantity);
        SalesLine2.modify(true);
        if ItemCheckAvail.SalesLineCheck(SalesLine2) then
            ItemCheckAvail.RaiseUpdateInterruptedError();
    end;

    procedure LoadItemAttributesFactBoxData(KeyValue: Code[20]): Text
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
        TextBuilder: TextBuilder;
    begin
        if KeyValue = '' then
            exit('');
        Clear(TextBuilder);
        ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
        ItemAttributeValueMapping.SetRange("No.", KeyValue);
        if ItemAttributeValueMapping.FindSet() then
            repeat
                if ItemAttributeValue.Get(ItemAttributeValueMapping."Item Attribute ID", ItemAttributeValueMapping."Item Attribute Value ID") then begin
                    ItemAttributeValue.CalcFields("Attribute Name");
                    TextBuilder.AppendLine(StrSubstNo('%1: %2', ItemAttributeValue."Attribute Name", ItemAttributeValue."Value"));
                end
            until ItemAttributeValueMapping.Next() = 0;
        exit(TextBuilder.ToText());
    end;

    procedure VaraintMandatory(var Rec: Record "Sales Items by Attribute"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
    begin
        //Sales Line uses a different method to determine if the variant is mandatory from the item table
        InventorySetup.Get();
        case Rec."Variant Mandatory if Exists" of
            Rec."Variant Mandatory if Exists"::No:
                exit(false);
            Rec."Variant Mandatory if Exists"::Yes:
                exit(true);
            Rec."Variant Mandatory if Exists"::Default:
                exit(InventorySetup."Variant Mandatory if Exists");
        end;
    end;
}
