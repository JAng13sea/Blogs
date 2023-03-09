table 51118 "Endpoint Table Config."
{
    Caption = 'Endpoint Table Config.';
    DataClassification = ToBeClassified;
    ReplicateData = false;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
            trigger OnValidate()
            var
                EndpointMgt: Codeunit "Endpoint Mgt.";
            begin
                Rec.Validate("Table Name", EndpointMgt.GetTableCaption(Rec."Table ID"));
                AddFieldConfig(Rec);
            end;
        }
        field(2; "Table Name"; Text[100])
        {
            Caption = 'Table Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Table ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        FieldConfig: Record "Endpoint Field Confg.";
    begin
        FieldConfig.SetRange("Table ID", Rec."Table ID");
        FieldConfig.DeleteAll();
    end;

    local procedure AddFieldConfig(TblRec: Record "Endpoint Table Config.")
    var
        FieldConfig: Record "Endpoint Field Confg.";
        FieldList: Record Field;
        ConfigValidateMgt: Codeunit "Config. Validate Management";
        EndpointMgt: Codeunit "Endpoint Mgt.";
    begin
        FieldList.SetRange(TableNo, TblRec."Table ID");
        FieldList.SetFilter(ObsoleteState, '<>%1', FieldList.ObsoleteState::Removed);
        If FieldList.FindSet() then begin
            repeat
                FieldConfig.Init();
                FieldConfig.Validate("Table ID", TblRec."Table ID");
                FieldConfig.Validate("Field ID", FieldList."No.");
                FieldConfig.Validate("Field Name", EndpointMgt.GetFieldCaption(Rec."Table ID", FieldConfig."Field ID"));
                //FieldConfig.Validate("Include Field",true);
                FieldConfig."Primary Key" := ConfigValidateMgt.IsKeyField(TblRec."Table ID", FieldList."No.");
                FieldConfig.Insert();
                if FieldConfig."Primary Key" then
                    FieldConfig.Validate("Include Field", true);
                FieldConfig.Modify();
            until FieldList.Next() = 0;
        end;
    end;
}
