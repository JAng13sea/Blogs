table 51119 "Endpoint Field Confg."
{
    Caption = 'Endpoint Field Confg.';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            DataClassification = CustomerContent;
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));
            NotBlank = true;
        }
        field(3; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            DataClassification = CustomerContent;
        }
        field(4; "Include Field"; Boolean)
        {
            Caption = 'Include Field';
            DataClassification = CustomerContent;
        }
        field(5; "Primary Key"; Boolean)
        {
            Caption = 'Primary Key Field';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Table ID","Field ID")
        {
            Clustered = true;
        }
    }
}
