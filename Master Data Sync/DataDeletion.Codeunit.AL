codeunit 50100 "Customer Deletion"
{
    trigger OnRun()
    begin

    end;

    var
        DeletedData: Record "Deleted Master Data";

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddCusttoDeletionTable(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec."No.";
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::Customer;
        DeletedData.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddVendtoDeletionTable(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec."No.";
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::Vendor;
        DeletedData.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddGLtoDeletionTable(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec."No.";
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::GLAccount;
        DeletedData.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddItemtoDeletionTable(var Rec: Record Item; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec."No.";
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::Item;
        DeletedData.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::Dimension, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddDimtoDeletionTable(var Rec: Record Dimension; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec."Code";
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::Dimension;
        DeletedData.Insert(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure AddDimValtoDeletionTable(var Rec: Record "Dimension Value"; RunTrigger: Boolean)
    begin
        DeletedData.Init();
        DeletedData."Entry No." := NextNumber();
        DeletedData."No." := Rec.Code;
        DeletedData.ID := Rec.SystemId;
        DeletedData."Data Type" := DeletedData."Data Type"::DimensionValue;
        DeletedData.Insert(true);
    end;

    local procedure NextNumber(): Integer
    var
        NextEntryNo: Integer;
    begin
        if DeletedData.FindLast then
            NextEntryNo := DeletedData."Entry No." + 1
        else
            NextEntryNo := 1;

        exit(NextEntryNo);
    end;
}