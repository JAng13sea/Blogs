table 50100 "Deleted Master Data"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }

        field(3; ID; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'ID';
        }
        field(4; "Data Type"; Enum "Data Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Data Type';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        NextEntryNo: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}