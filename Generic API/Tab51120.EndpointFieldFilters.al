table 51120 "Endpoint Field Filters"
{
    Caption = 'Endpoint Field Filters';
    DataClassification = ToBeClassified;
    ReplicateData = false;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(5; "Field ID"; Integer)
        {
            Caption = 'Field ID';

            trigger OnValidate()
            var
                "Field": Record "Field";
                TypeHelper: Codeunit "Type Helper";
            begin
                Field.Get("Table ID", "Field ID");
                TypeHelper.TestFieldIsNotObsolete(Field);
                CalcFields("Field Name", "Field Caption");
            end;
        }
        field(6; "Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field.FieldName WHERE(TableNo = FIELD("Table ID"),
                                                        "No." = FIELD("Field ID")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Field Caption"; Text[250])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = FIELD("Table ID"),
                                                              "No." = FIELD("Field ID")));
            Caption = 'Field Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Field Filter"; Text[250])
        {
            Caption = 'Field Filter';

            trigger OnValidate()
            begin
                ValidateFieldFilter;
            end;
        }
    }
    keys
    {
        key(PK; "Table ID", "Field ID")
        {
            Clustered = true;
        }
    }

    local procedure ValidateFieldFilter()
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open("Table ID");
        if "Field Filter" <> '' then begin
            FieldRef := RecRef.Field("Field ID");
            FieldRef.SetFilter("Field Filter");
        end;
    end;
}
