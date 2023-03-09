codeunit 51118 "Endpoint Mgt."
{
    procedure PrepareGetDataResponse(EndpointConfig: Record "Endpoint Table Config."): JsonObject
    var
        EndpointFields: Record "Endpoint Field Confg.";
        jsObject: JsonObject;
        ParentJSObject: JsonObject;
        jsArray: JsonArray;
        RecRef: RecordRef;
        RecId: RecordId;
        FieldList: List of [Integer];
        i: Integer;
        FRef: FieldRef;
        jsonCaption: Text[100];
    begin
        EndpointFields.SetRange("Table ID", EndpointConfig."Table ID");
        EndpointFields.SetRange("Include Field", true);
        if EndpointFields.FindSet() then begin
            repeat
                FieldList.Add(EndpointFields."Field ID");
            until EndpointFields.Next() = 0;
        end;

        RecRef.Open(EndpointConfig."Table ID");
        ApplyFieldFilters(EndpointConfig,RecRef);
        if RecRef.FindSet() then begin
            repeat
                Clear(jsObject);
                for i := 1 to FieldList.Count do begin
                    FRef := RecRef.Field(FieldList.Get(i));
                    jsonCaption := LowerCase(FRef.Caption);
                    case FRef.Class of
                        FRef.Class::Normal:
                            jsObject.Add(GetJsonFieldName(FRef), FieldRef2JsonValue(FRef));
                        FRef.Class::FlowField:
                            begin
                                FRef.CalcField();
                                jsObject.Add(GetJsonFieldName(FRef), FieldRef2JsonValue(FRef));
                            end;
                    end;
                end;
                jsArray.Add(jsObject);
            until RecRef.Next() = 0;
        end;
        ParentJSObject.Add(EndpointConfig."Table Name", jsArray);
        exit(ParentJSObject);
    end;

    local procedure GetJsonFieldName(FRef: FieldRef): Text
    var
        Name: Text;
        i: Integer;
    begin
        Name := FRef.Name();
        for i := 1 to Strlen(Name) do begin
            if Name[i] < '0' then
                Name[i] := '_';
        end;
        exit(Name.Replace('__', '_').TrimEnd('_').TrimStart('_'));
    end;

    local procedure AssignValueToFieldRef(var FR: FieldRef; JsonKeyValue: JsonValue)
    begin
        case FR.Type() of
            FieldType::Code,
            FieldType::Text:
                FR.Value := JsonKeyValue.AsText();
            FieldType::Integer:
                FR.Value := JsonKeyValue.AsInteger();
            FieldType::Date:
                FR.Value := JsonKeyValue.AsDate();
            else
                error('%1 is not a supported field type', FR.Type());
        end;
    end;

    local procedure FieldRef2JsonValue(FRef: FieldRef): JsonValue
    var
        V: JsonValue;
        D: Date;
        DT: DateTime;
        T: Time;
    begin
        case FRef.Type() of
            FieldType::Date:
                begin
                    D := FRef.Value;
                    V.SetValue(D);
                end;
            FieldType::Time:
                begin
                    T := FRef.Value;
                    V.SetValue(T);
                end;
            FieldType::DateTime:
                begin
                    DT := FRef.Value;
                    V.SetValue(DT);
                end;
            else
                V.SetValue(Format(FRef.Value, 0, 9));
        end;
        exit(v);
    end;

    procedure GetTableCaption(TableID: Integer): Text[250]
    var
        recRef: RecordRef;
    begin
        recRef.Open(TableID);
        exit(recRef.Caption);
    end;

    procedure GetFieldCaption(TableID: Integer; FieldID: Integer): Text[250]
    var
        recRef: RecordRef;
        fldRef: FieldRef;
    begin
        recRef.Open(TableID);
        fldRef := recRef.Field(FieldID);
        exit(fldRef.Caption);
    end;

    procedure GetData(TableId: Integer): JsonObject
    var
        TableConfig: Record "Endpoint Table Config.";
        JObject: JsonObject;
    begin
        JObject.ReadFrom(Format(TableId));

        TableConfig.SetRange("Table ID", TableId);
        exit(PrepareGetDataResponse(TableConfig));
    end;

    procedure ApplyFieldFilters(EndpointConfig: Record "Endpoint Table Config."; var RecRef: RecordRef)
    var
        ConfigPackageFilter: Record "Endpoint Field Filters";
        FieldRef: FieldRef;
    begin
        //ConfigPackageFilter.SetRange("Package Code", ConfigPackageTable."Package Code");
        ConfigPackageFilter.SetRange("Table ID", EndpointConfig."Table ID");
        //ConfigPackageFilter.SetRange("Processing Rule No.", 0);
        if ConfigPackageFilter.FindSet then
            repeat
                if ConfigPackageFilter."Field Filter" <> '' then begin
                    FieldRef := RecRef.Field(ConfigPackageFilter."Field ID");
                    FieldRef.SetFilter(StrSubstNo('%1', ConfigPackageFilter."Field Filter"));
                end;
            until ConfigPackageFilter.Next = 0;
    end;

    procedure ShowFilters(EndpointTable: Record "Endpoint Table Config.")
    var
        ConfigPackageFilter: Record "Endpoint Field Filters";
        ConfigPackageFilters: Page "Endpoint Field Filters";
    begin
        ConfigPackageFilter.FilterGroup(2);
        ConfigPackageFilter.SetRange("Table ID", EndpointTable."Table ID");
        ConfigPackageFilter.FilterGroup(0);
        ConfigPackageFilters.SetTableView(ConfigPackageFilter);
        ConfigPackageFilters.RunModal();
        Clear(ConfigPackageFilters);
    end;
}
