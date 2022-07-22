page 59980 "Saved Demand Forecast Filters"
{
    Caption = 'Saved Demand Forecast Filters';
    PageType = List;
    SourceTable = "Prod. Forecast Saved Filters";
    CardPageId = "Saved Demand Filters Card";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Filter Name"; Rec."Filter Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Filter Name field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(FilterCreator; GetFilterCreatorUserID(Format(Rec.SystemCreatedBy)))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    Caption = 'Created By';
                }
            }
        }
    }
    local procedure GetFilterCreatorUserID(text1: Text): Text
    var
    Users: Record User;
    begin
        if Users.Get(text1) then
            exit(Users."User Name");
    end;
}
