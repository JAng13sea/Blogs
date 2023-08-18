page 50101 "Email Delivery API"
{
    APIGroup = 'email';
    APIPublisher = 'jangle';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'emailDeliveryAPI';
    DelayedInsert = true;
    EntityName = 'sendEmail';
    EntitySetName = 'sendEmails';
    PageType = API;
    SourceTable = "Email Delivery";
    ODataKeyFields = SystemId;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(toAddress; Rec."To Address")
                {
                    Caption = 'To Address';
                }
                field(fromAddress; Rec."From Address")
                {
                    Caption = 'From Address';
                }
                field(ccAddress; Rec."CC Address")
                {
                    Caption = 'CC Address';
                }
                field(bccAddress; Rec."BCC Address")
                {
                    Caption = 'BCC Address';
                }
                field(subject; Rec.Subject)
                {
                    Caption = 'Subject';
                }
                field(body; Rec.Body)
                {
                    Caption = 'Body';
                }
                field(attachmentName; Rec."Attachment Name")
                {
                    Caption = 'Attachment Name';
                }
                field(attachmentType; Rec."Attachment Type")
                {
                    Caption = 'Attachment Type';
                }
                field(noOfAttachments; Rec."No. of Attachments")
                {
                    Caption = 'No. of Attachments';
                }
                field(attachment; Rec.Content)
                {
                    Caption = 'Content';
                }
                field(mediaContent; Rec."Media Content")
                {
                    Caption = 'Media Content';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SendEmailWithBC: Codeunit "Send Email with BC";
        InS: InStream;
        base64: Codeunit "Base64 Convert";
    begin
        If Rec."No. of Attachments" = 0 then
            SendEmailWithBC.SendEmail(Rec."To Address", Rec."From Address", Rec.Subject, Rec.Body)
    end;

    trigger OnModifyRecord(): Boolean
    var
        SendEmailWithBC: Codeunit "Send Email with BC";
        InS: InStream;
        base64: Codeunit "Base64 Convert";
    begin
        Rec.SaveToAttachment();
        If Rec."Media Content".Count = Rec."No. of Attachments" then
            SendEmailWithBC.SendEmailWithAttachment(Rec)
    end;

    trigger OnDeleteRecord(): Boolean
    var
        SendEmailWithBC: Codeunit "Send Email with BC";
    begin
        SendEmailWithBC.RemoveOldMediaContent(Rec);
    end;
}
