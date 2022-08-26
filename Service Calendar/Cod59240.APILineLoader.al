codeunit 59240 "API Line Loader"
{
    procedure LoadServiceConLines(var ServConLines: Record "Service Contract Line")
    var
        ServiceConLines: Record "Service Contract Line";
        ServConType: Enum "Service Contract Type";
        ServiceDate: Date;
        StartDate: Date;
        EndDate: Date;
        LineNo: Integer;
        DF: DateFormula;
        ServItem: Record "Service Item";
        ServCon: Record "Service Contract Header";
    begin
        LineNo := 0;
        ServiceConLines.SetRange("Contract Type", ServConType::Contract);
        if ServiceConLines.FindSet() then
            Repeat
                StartDate := ServiceConLines."Starting Date";
                EndDate := ServiceConLines."Contract Expiration Date";
                ServiceDate := ServiceConLines."Next Planned Service Date";
                ServItem.Get(ServiceConLines."Service Item No.");
                ServCon.Get(ServConType::Contract, ServiceConLines."Contract No.");
                repeat
                    LineNo += 10000;
                    ServConLines := ServiceConLines;
                    ServConLines."Next Planned Service Date" := ServiceDate;
                    ServConLines."Line No." := LineNo;
                    ServConLines.Insert;
                    ServiceDate := CalcDate(ServConLines."Service Period", ServiceDate);
                until ServiceDate > EndDate;

                ServiceDate := ServiceConLines."Next Planned Service Date";
                Evaluate(DF, '-' + Format(ServConLines."Service Period"));
                ServiceDate := CalcDate(DF, ServiceDate);
                if ServiceDate > StartDate then
                    repeat
                        LineNo += 10000;
                        ServConLines := ServiceConLines;
                        ServConLines."Next Planned Service Date" := ServiceDate;
                        ServConLines."Line No." := LineNo;
                        ServConLines.Insert;
                        ServiceDate := CalcDate(DF, ServiceDate);
                    until ServiceDate < StartDate;
            Until ServiceConLines.Next = 0
    end;
}
