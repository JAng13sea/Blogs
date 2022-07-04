report 86800 "HTML Display"
{
    Caption = 'HTML Display';
    DefaultLayout = Word;
    WordLayout = 'HTMLDisplay.docx';
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            column(TextValue; TextValue) { }
        }
    }

    procedure SetText(TextVal: Text)
    begin
        TextValue := TextVal;
    end;

    var
        TextValue: Text;
}
