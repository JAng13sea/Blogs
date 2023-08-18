table 50101 "Email Delivery"
{
    Caption = 'Email Delivery';
    DataClassification = ToBeClassified;

    fields
    {
        field(50100; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(50101; "To Address"; Text[1000])
        {
            Caption = 'To Address';
            DataClassification = SystemMetadata;
        }
        field(50102; "From Address"; Text[1000])
        {
            Caption = 'From Address';
            DataClassification = SystemMetadata;
        }
        field(50103; "CC Address"; Text[1000])
        {
            Caption = 'CC Address';
            DataClassification = SystemMetadata;
        }
        field(50104; "BCC Address"; Text[1000])
        {
            Caption = 'BCC Address';
            DataClassification = SystemMetadata;
        }
        field(50105; Subject; Text[1000])
        {
            Caption = 'Subject';
            DataClassification = SystemMetadata;
        }
        field(50106; Body; Text[1000])
        {
            Caption = 'Body';
            DataClassification = SystemMetadata;
        }
        field(50107; Content; Blob)
        {
            DataClassification = SystemMetadata;
            Subtype = Bitmap;
        }
        field(50108; "Attachment Name"; Text[1000])
        {
            Caption = 'Attachment Name';
            DataClassification = SystemMetadata;
        }
        field(50109; "Attachment Type"; Text[1000])
        {
            Caption = 'Attachment Type';
            DataClassification = SystemMetadata;
        }
        field(50110; "Media Content"; MediaSet)
        {
            Caption = 'Media Content';
            DataClassification = SystemMetadata;
        }
        field(50111; "No. of Attachments"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := GetNextEntryNo();
        SendEmail(Rec);
    end;

    
    procedure GetNextEntryNo(): Integer
    var
        EmailDelivery: Record "Email Delivery";
    begin
        if EmailDelivery.FindLast() then
            exit(EmailDelivery."Entry No." + 1)
        else
            exit(1);
    end;

    procedure SaveToAttachment()
    var
        Ins: InStream;
        EmailDelivery: Record "Email Delivery";
        AttachNumber: Integer;
        AttachNameList: List of [Text];
    begin
        if EmailDelivery.Get(Rec."Entry No.") then begin
            Rec.CalcFields(Content);
            Rec.Content.CreateInStream(Ins);
            //The file won't be saved yet so the count is one less that the actual number of attachments until it is saved. Adding 1 will result in the correct file name
            AttachNumber := EmailDelivery."Media Content".Count+1;
            AttachNameList := EmailDelivery."Attachment Name".Split(',');
            if Rec."Attachment Name" = '' then
                Rec."Attachment Name" := StrSubstNo('%1_%2', EmailDelivery."Attachment Name", Format(EmailDelivery."Media Content".Count + 1));
            Rec."Media Content".ImportStream(Ins, AttachNameList.Get(AttachNumber), Rec."Attachment Type");
            Clear(Rec.Content);
            Rec.Modify();
        end;
    end;

    [InternalEvent(false, false)]
    local procedure SendEmail(var EmailDelivery: Record "Email Delivery")
    begin

    end;
}
