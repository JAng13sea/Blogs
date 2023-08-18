codeunit 50100 "Send Email with BC"
{
    Permissions = tabledata "Tenant Media" = RIMD;
    procedure SendEmail(ToAddress: Text; FromAddress: Text; Subject: Text; Body: Text; AttachmentName: Text; Attachment: Text; AttachmentType: Text) result: Boolean
    var
        mail: Codeunit "Email Message";
        email: Codeunit Email;
        InS: InStream;
        base64: Codeunit "Base64 Convert";
        EmailConnector: Enum "Email Connector";
    begin
        mail.Create(ToAddress, Subject, Body, true);
        //'application/pdf'
        mail.AddAttachment(AttachmentName, AttachmentType, Attachment);
        if email.Send(mail, GetEmailAccount(FromAddress)) then
            exit(true);
    end;

    procedure SendEmail(ToAddress: Text; FromAddress: Text; Subject: Text; Body: Text) result: Boolean
    var
        mail: Codeunit "Email Message";
        email: Codeunit Email;
        InS: InStream;
        base64: Codeunit "Base64 Convert";
        EmailConnector: Enum "Email Connector";
    begin
        mail.Create(ToAddress, Subject, Body, true);
        //'application/pdf'
        if email.Send(mail, GetEmailAccount(FromAddress)) then
            exit(true);
    end;

    procedure SendEmailWithAttachment(EmailDelivery: Record "Email Delivery") result: Boolean
    var
        mail: Codeunit "Email Message";
        email: Codeunit Email;
        InS: InStream;
        base64: Codeunit "Base64 Convert";
        EmailConnector: Enum "Email Connector";
        i: Integer;
        TenantMedia: Record "Tenant Media";
    begin
        if EmailDelivery."Media Content".Count > 0 then begin
            mail.Create(EmailDelivery."To Address", EmailDelivery."Subject", EmailDelivery."Body", true);
            GetEmailAttachments(mail, EmailDelivery);
            if email.Send(mail, GetEmailAccount(EmailDelivery."From Address")) then
                exit(true);
        end else
            exit(false);
    end;

    local procedure GetEmailAttachments(var EmailMessage: Codeunit "Email Message"; EmailDelivery: Record "Email Delivery")
    var
        InS: InStream;
        AttIns: InStream;
        base64: Codeunit "Base64 Convert";
        EmailConnector: Enum "Email Connector";
        i: Integer;
        TenantMedia: Record "Tenant Media";
        DataCompression: Codeunit "Data Compression";
        OutS: OutStream;
        TempBlob: Codeunit "Temp Blob";
        ZipFileName: Label 'Attachments.zip';
        ZIPMimeType: Label 'application/x-zip-compressed';
        FileName: Label 'Attachment_%1.pdf';
    begin
        if EmailDelivery."Media Content".Count = EmailDelivery."No. of Attachments" then begin
            DataCompression.CreateZipArchive();
            for i := 1 to EmailDelivery."Media Content".Count do begin
                if TenantMedia.Get(EmailDelivery."Media Content".Item(i)) then begin
                    TenantMedia.CalcFields(Content);
                    if TenantMedia.Content.HasValue then begin
                        Clear(InS);
                        TenantMedia.Content.CreateInStream(InS);
                        DataCompression.AddEntry(InS, TenantMedia."Description");
                    end;
                end;
            end;
            TempBlob.CreateOutStream(OutS);
            DataCompression.SaveZipArchive(OutS);
            TempBlob.CreateInStream(AttIns);
            EmailMessage.AddAttachment(ZipFileName, ZIPMimeType, base64.ToBase64(AttIns));
        end;
    end;

    local procedure GetEmailAccount(FromAddress: Text) account: Record "Email Account"
    var
        EmailAccounts: Record "Email Account";
        EmailAccount: Codeunit "Email Account";
        EmailScenario: Codeunit "Email Scenario";
    begin
        EmailAccount.GetAllAccounts(false, EmailAccounts);
        if FromAddress = '' then begin
            EmailAccounts.FindFirst();
            exit(EmailAccounts);
        end else begin
            EmailAccounts.SetFilter(EmailAccounts."Email Address", FromAddress);
            if EmailAccounts.FindFirst() then
                exit(EmailAccounts);
        end;
    end;

    procedure RemoveOldMediaContent(EmailDelivery: Record "Email Delivery")
    var
        TenantMedia: Record "Tenant Media";
        i: Integer;
    begin
        if EmailDelivery."Media Content".count > 0 then
            for i := 1 to EmailDelivery."Media Content".count do begin
                TenantMedia.Get(EmailDelivery."Media Content".item(i));
                TenantMedia.Delete();
            end;
    end;
}