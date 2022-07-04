codeunit 86800 "Copy Office Email Body"
{
    procedure GenerateEmailBody(var HeaderRecRef: RecordRef)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        TempOfficeSuggestedLineItem: Record "Office Suggested Line Item" temporary;
        InstructionMgt: Codeunit "Instruction Mgt.";
        OfficeMgt: Codeunit "Office Management";
        EmailBody: Text;
        tempBlob: Codeunit "Temp Blob";
        InStrm: InStream;
        OutStrm: OutStream;
        DocumentAttachment: Record "Document Attachment";
        FileMgt: Codeunit "File Management";
    begin
        if InstructionMgt.IsEnabled(InstructionMgt.AutomaticLineItemsDialogCode) then begin
            OfficeMgt.GetContext(TempOfficeAddinContext);
            EmailBody := OfficeMgt.GetEmailBody(TempOfficeAddinContext);
            Commit;
            tempBlob.CreateOutStream(OutStrm);
            OutStrm.WriteText(EmailBody);
            tempBlob.CreateInStream(InStrm);
            DocumentAttachment.Init();
            DocumentAttachment.SaveAttachmentFromStream(InStrm, HeaderRecRef, TempOfficeAddinContext.Subject + Format(CurrentDateTime(),0,'<Day,2><Month,2><Year,2><Hours24><Minutes,2><Seconds,2>') + '.html');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Office Host Management", 'OnGetEmailBody', '', false, false)]
    local procedure GetEmailBody(var EmailBody: Text)
    begin
    end;

    procedure PreviewHTMLContent(DocAttachment: Record "Document Attachment")
    var
        ContentPreview: Page "Content Preview";
    begin
        ContentPreview.SetContent(GetHTMLTextValue(DocAttachment));
        ContentPreview.RunModal();
    end;

    procedure NiceHTML(DocAttachment: Record "Document Attachment")
    var
        HTMLViewer: Page "HTML Viewer";
    begin
        HTMLViewer.Load((GetHTMLTextValue(DocAttachment)));
        HTMLViewer.RunModal();
    end;

    procedure WordHTML(DocAttachment: Record "Document Attachment")
    var
        ContentPreview: Page "Content Preview";
        HTMLDisplay: Report "HTML Display";
        OutS: OutStream;
        Ins: InStream;
        TempBlob: Codeunit "Temp Blob";
        HTMLTxt: Text;
    begin
        HTMLDisplay.SetText(GetHTMLTextValue(DocAttachment));
        TempBlob.CreateOutStream(OutS);
        HTMLDisplay.SaveAs('',ReportFormat::Html,OutS);
        TempBlob.CreateInStream(Ins);
        Ins.Read(HTMLTxt);
        ContentPreview.SetContent(HTMLTxt);
        ContentPreview.RunModal();
    end;
    local procedure GetHTMLTextValue(DocAttachment: Record "Document Attachment") Result: Text
    var
        TempBlob: Codeunit "Temp Blob";
        InStrm: InStream;
        DocumentStream: OutStream;
    begin
        if DocAttachment."Document Reference ID".HasValue() then begin
            clear(TempBlob);
            TempBlob.CreateOutStream(DocumentStream);
            DocAttachment."Document Reference ID".ExportStream(DocumentStream);
            TempBlob.CreateInStream(InStrm);
            InStrm.Read(Result);
            exit(Result);
        end;
    end;
}
