table 50200 "Sales Items by Attribute"
{
    Caption = 'Sales Items by Attribute';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(4; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where ("Item No." = field("No."));
        }
        field(5; "Variant Mandatory if Exists"; Option)
        {
            Caption = 'Variant Mandatory if Exists';
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(6; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
