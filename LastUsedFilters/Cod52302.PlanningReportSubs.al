codeunit 52302 "Report Options Data"
{
    procedure GetOptionData(var ObjectOptions: Record "Object Options") Result: Text
    var
        InStream: InStream;
    begin
        if ObjectOptions."Option Data".HasValue() then begin
            ObjectOptions.CalcFields("Option Data");
            ObjectOptions."Option Data".CreateInStream(InStream, TEXTENCODING::UTF8);
            InStream.ReadText(Result);
        end;
    end;

    procedure ParseXml2(XmlText: Text; RunByUser: Code[50]; LastRunDate: DateTime) Result: Text
    var
        XmlDoc: XmlDocument;
        OptionsNode: XmlNodeList;
        DataItemsNode: XmlNodeList;
        FieldNodes: XmlNodeList;
        Node: XmlNode;
        Root: XmlElement;
        XmlElement: XmlElement;
        FieldNode: XmlNode;
        TextList: List of [Text];
        FieldName: Text;
        FieldValue: Text;
        DataItemName: Text;
        FieldFilters: List of [Text];
        FieldFilter: Text;
        FieldTextValue: Text;
        XmlAttribute: XmlAttribute;
        FinalText: Text;
        Text1: Text;
        Text2: Text;
        Text1Length: Integer;
        Text2Length: Integer;
        CRLF: Text[2];
    begin
        XmlDocument.ReadFrom(XmlText, XmlDoc);
        XmlDoc.GetRoot(Root);
        OptionsNode := Root.GetChildElements('Options');
        CRLF[1] := 13;
        CRLF[2] := 10;

        TextList.Add('Options:');
        Text1 += 'Run By User: ' + RunByUser + CRLF;
        Text1 += 'Last Run Date: ' + Format(LastRunDate) + CRLF;
        Text1 += 'Options: ';


        foreach Node in OptionsNode do begin
            XmlElement := Node.AsXmlElement();
            FieldNodes := XmlElement.GetChildElements();
            foreach FieldNode in FieldNodes do begin
                If FieldNode.AsXmlElement().Attributes().Get(1, XmlAttribute) then
                    FieldName := XmlAttribute.Value();
                FieldValue := FieldNode.AsXmlElement().InnerText();
                Text1 += FieldName + '=' + FieldValue + ', ';
                TextList.Add('  ' + FieldName + '=' + FieldValue);
            end;
        end;

        TextList.Add('');
        TextList.Add('Data Item Filters:');
        Text2 += 'Data Item Filters: ';
        DataItemsNode := Root.GetChildElements('DataItems');
        foreach Node in DataItemsNode do begin
            XmlElement := Node.AsXmlElement();
            FieldNodes := XmlElement.GetChildElements();
            foreach FieldNode in FieldNodes do begin
                If FieldNode.AsXmlElement().Attributes().Get(1, XmlAttribute) then
                    DataItemName := XmlAttribute.Value();
                TextList.Add(' name=' + DataItemName + ':');
                Text2 += ' name=' + DataItemName + ': ';
                FieldFilter := FieldNode.AsXmlElement().InnerText();
                FieldFilters := ExtractFields(FieldFilter, DataItemName);
                foreach FieldTextValue in FieldFilters do
                    Text2 += FieldTextValue + ', ';
            end;
        end;
        If Text1.EndsWith(', ') or Text2.EndsWith(', ') then begin
            Text1Length := StrLen(Text1);
            Text2Length := StrLen(Text2);
            FinalText := Text1.Substring(1, Text1Length - 2) + CRLF + CRLF + Text2.Substring(1, Text2Length - 2);
        end;
        exit(FinalText);
    end;

    procedure GetUserNameFromSecurityId(UserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        User.Get(UserSecurityID);
        exit(User."User Name");
    end;

    procedure ExtractFields(Text: Text; TableName: Text): List of [Text]
    var
        Regex: Codeunit Regex;
        WhereIndex: Integer;
        WhereText: Text;
        FieldList: List of [Text];
        FieldText: Text;
        FieldCaption: Text;
        FieldNumber: Integer;
        Filter: Text;
        FilterTrim1: Text;
        FilterTrim2: Text;
        RegexMatches: Record Matches;
    begin
        WhereIndex := Text.IndexOf('WHERE(');
        if WhereIndex = -1 then
            exit(FieldList);

        WhereText := Text.Substring(WhereIndex + 5);
        foreach FieldText in WhereText.Split(',') do begin
            Regex.Match(FieldText, '\d+', 1, RegexMatches);
            if RegexMatches.FindFirst() then
                Evaluate(FieldNumber, RegexMatches.ReadValue(), 9);
            FieldCaption := GetFieldCaption(GetTableNo(TableName), FieldNumber);
            CLear(RegexMatches);
            Regex.Match(FieldText, '\((.*?)\)', 1, RegexMatches);
            if RegexMatches.FindFirst() then
                Filter := RegexMatches.ReadValue();
            FilterTrim1 := Filter.Replace('(', '');
            FilterTrim2 := FilterTrim1.Replace(')', '');
            FieldList.Add(FieldCaption + '=' + FilterTrim2);
        end;
        exit(FieldList);
    end;

    local procedure GetTableNo(TableName: Text): Integer
    var
        Table: Record "Field";
    begin
        Table.SetRange(TableName, TableName);
        If Table.FindFirst() then
            exit(Table.TableNo);
    end;

    local procedure GetFieldCaption(TableNo: Integer; FieldNo: Integer): Text
    var
        Field: Record "Field";
    begin
        Field.Get(TableNo, FieldNo);
        exit(Field."Field Caption");
    end;
}
