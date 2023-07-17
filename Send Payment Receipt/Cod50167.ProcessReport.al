codeunit 50167 ProcessReport
{
    Access = Public;
    // A public function which always returns the string 'Pong'
    procedure Ping(): Text
    begin
        exit('Pong');
    end;

    // Function to generate a PDF report of a sales order.
    // The input is a JSON text containing the document number, document type, and report ID.
    // It returns the PDF report in base64 format.
    procedure GetSalesOrderReportPDF(jsonText: Text) ReportBase64: Text
    var
        SalesHeader: Record "Sales Header";
        JSONManagement: Codeunit "JSON Management";
        SalesDocumentType: enum "Sales Document Type";
        ValueText: Text;
        DocumentNo: Code[20];
        ReportID: Integer;
    begin
        // Initialize JSON object from the given string
        JSONManagement.InitializeObject(jsonText);

        // Parse document number from the JSON
        JSONManagement.GetStringPropertyValueByName('Document No', ValueText);
        DocumentNo := CopyStr(ValueText.ToUpper(), 1, MaxStrLen(SalesHeader."No."));

        // Parse document type from the JSON
        JSONManagement.GetStringPropertyValueByName('Document Type', ValueText);
        Evaluate(SalesDocumentType, ValueText);

        // Parse report ID from the JSON
        JSONManagement.GetStringPropertyValueByName('Report ID', ValueText);
        Evaluate(ReportID, ValueText);

        // Generate the report and return it in base64 format
        ReportBase64 := GetSalesReportBase64(SalesHeader, SalesDocumentType, DocumentNo, ReportID);
    end;
    procedure GetCustomerPaymentReportPDF(jsonText: Text) ReportBase64: Text
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        JSONManagement: Codeunit "JSON Management";
        SalesDocumentType: enum "Sales Document Type";
        ValueText: Text;
        CustomerNo: Code[20];
        DocumentNo: Code[20];
        ReportID: Integer;
    begin
        // Initialize JSON object from the given string
        JSONManagement.InitializeObject(jsonText);

        // Parse document number from the JSON
        JSONManagement.GetStringPropertyValueByName('Customer No', ValueText);
        CustomerNo := CopyStr(ValueText.ToUpper(), 1, MaxStrLen(CustLedgEntry."Customer No."));

        // Parse document type from the JSON
        JSONManagement.GetStringPropertyValueByName('Document No', ValueText);
        DocumentNo := CopyStr(ValueText.ToUpper(), 1, MaxStrLen(CustLedgEntry."Customer No."));
        //Evaluate(SalesDocumentType, ValueText);

        // Parse report ID from the JSON
        JSONManagement.GetStringPropertyValueByName('Report ID', ValueText);
        Evaluate(ReportID, ValueText);

        // Generate the report and return it in base64 format
        ReportBase64 := GetCustomerPaymentReportBase64(CustLedgEntry, CustomerNo, DocumentNo, ReportID);
    end;

    // Function to generate the sales report in base64 format.
    // It takes as input the sales header record, document type, document number, and report ID.
    // It returns the report in base64 format.
    local procedure GetSalesReportBase64(
        var SalesHeader: Record "Sales Header";
        var SalesDocumentType: enum "Sales Document Type";
        var DocumentNo: Code[20];
        var ReportID: Integer) Base64Text: Text;
    var
        Base64: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        JsonObject: JsonObject;
    begin
        // Prepare the recordset based on the given document number and type
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", DocumentNo);
        SalesHeader.SetRange("Document Type", SalesDocumentType);

        // If no matching record is found, throw an error
        if not SalesHeader.FindLast() then
            Error('Sales Header %1 not found.', DocumentNo);

        // Generate the report and save it in a temporary blob
        TempBlob.CreateOutStream(OutStream);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, GetRecRef(SalesHeader));

        // Read the blob into a stream
        TempBlob.CreateInStream(InStream, TextEncoding::WINDOWS);

        // Convert the stream to base64
        Base64Text := Base64.ToBase64(InStream);

        // Store the base64 string into a JSON object
        JsonObject.Add('Base64Pdf', Base64Text);
        JsonObject.WriteTo(Base64Text);

        // Return the base64 string
        exit(Base64Text);
    end;
    local procedure GetCustomerPaymentReportBase64(
        var CustLedgEntry: Record "Cust. Ledger Entry";
        var CustomerNo: Code[20];
        var DocumentNo: Code[20];
        var ReportID: Integer) Base64Text: Text;
    var
        Base64: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        JsonObject: JsonObject;
    begin
        // Prepare the recordset based on the given document number and type
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange("Document No.", DocumentNo);
        //CustLedgEntry.SetRange("Document Type", SalesDocumentType);

        // If no matching record is found, throw an error
        if not CustLedgEntry.FindLast() then
            Error('Sales Header %1 not found.', DocumentNo);

        // Generate the report and save it in a temporary blob
        TempBlob.CreateOutStream(OutStream);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, GetRecRef(CustLedgEntry));

        // Read the blob into a stream
        TempBlob.CreateInStream(InStream, TextEncoding::WINDOWS);

        // Convert the stream to base64
        Base64Text := Base64.ToBase64(InStream);

        // Store the base64 string into a JSON object
        JsonObject.Add('Base64Pdf', Base64Text);
        JsonObject.WriteTo(Base64Text);

        // Return the base64 string
        exit(Base64Text);
    end;

    // This function returns a record reference from a variant.
    // The variant can be either a record or a record reference.
    local procedure GetRecRef(RecVariant: Variant) RecRef: RecordRef
    begin
        if RecVariant.IsRecordRef() then
            exit(RecVariant);
        if RecVariant.IsRecord() then
            RecRef.GetTable(RecVariant);
    end;
}
