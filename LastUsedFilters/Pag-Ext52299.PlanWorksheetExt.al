pageextension 52299 "Plan. Worksheet Ext." extends "Planning Worksheet"
{
    layout
    {
        addlast(Control56)
        {
            group("Last Used Filter")
            {
                Caption = 'Last Used Filter';
                Visible = RecIsNotEmpty;
                field(LastUsedFilter; LastUsedFilter)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("GetLastUsedFilter")
            {
                ApplicationArea = All;
                Caption = 'Last Used Filter';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                trigger OnAction()
                var
                    ReqWorksheetName: Record "Requisition Wksh. Name";
                    ObjectOptions: Record "Object Options";
                    GetOptionData: Codeunit "Report Options Data";
                    XMLText: Text;
                    Params: Text;
                begin
                    if Rec.IsEmpty then
                        exit
                    else begin
                        ObjectOptions.SetRange("Parameter Name", 'Last used options and filters');
                        ObjectOptions.SetRange("Object ID", 99001017);
                        ObjectOptions.SetRange("Object Type", ObjectOptions."Object Type"::Report);
                        ObjectOptions.SetRange("Created By", GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy));
                        ObjectOptions.SetRange("Company Name", CompanyName);
                        if ObjectOptions.FindLast then begin
                            XMLText := GetOptionData.GetOptionData(ObjectOptions);
                            Params := Report.RunRequestPage(99001017, XMLText);
                        end;
                    end;
                end;
            }
            action("ShowLastUsedFilter")
            {
                ApplicationArea = All;
                Caption = 'Last Used Filter';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = RecIsNotEmpty;
                trigger OnAction()
                var
                    ReqWorksheetName: Record "Requisition Wksh. Name";
                    ObjectOptions: Record "Object Options";
                    GetOptionData: Codeunit "Report Options Data";
                    XMLText: Text;
                    Params: Text;
                begin
                    if Rec.IsEmpty then
                        exit
                    else begin
                        ObjectOptions.SetRange("Parameter Name", 'Last used options and filters');
                        ObjectOptions.SetRange("Object ID", 99001017);
                        ObjectOptions.SetRange("Object Type", ObjectOptions."Object Type"::Report);
                        ObjectOptions.SetRange("Created By", GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy));
                        ObjectOptions.SetRange("Company Name", CompanyName);
                        if ObjectOptions.FindLast then begin
                            XMLText := GetOptionData.GetOptionData(ObjectOptions);
                            Params := GetOptionData.ParseXml2(XMLText, ObjectOptions."User Name", ObjectOptions.SystemModifiedAt);
                            Message(Params);
                        end;
                    end;
                end;
            }

            action(RunReportWithLastUsedFilters)
            {
                ApplicationArea = All;
                Caption = 'Run Report With Last Used Filters';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = RecIsNotEmpty and DifferentUser;
                trigger OnAction()
                var
                    ReqWorksheetName: Record "Requisition Wksh. Name";
                    ObjectOptions: Record "Object Options";
                    GetOptionData: Codeunit "Report Options Data";
                    XMLText: Text;
                    Params: Text;
                    CalcPlan: Report "Calculate Plan - Plan. Wksh.";
                begin
                    if Rec.IsEmpty then
                        exit
                    else begin
                        ObjectOptions.SetRange("Parameter Name", 'Last used options and filters');
                        ObjectOptions.SetRange("Object ID", 99001017);
                        ObjectOptions.SetRange("Object Type", ObjectOptions."Object Type"::Report);
                        ObjectOptions.SetRange("Created By", GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy));
                        ObjectOptions.SetRange("Company Name", CompanyName);
                        if ObjectOptions.FindLast then begin
                            XMLText := GetOptionData.GetOptionData(ObjectOptions);
                            Params := CalcPlan.RunRequestPage(XMLText);
                            Clear(CalcPlan);
                            CalcPlan.SetTemplAndWorksheet(Rec."Worksheet Template Name", Rec."Journal Batch Name", true);
                            CalcPlan.UseRequestPage(false);
                            CalcPlan.Execute(Params);
                        
                            if not Rec.Find('-') then
                                Rec.SetUpNewLine(Rec);
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord();
    var
        ReqWorksheetName: Record "Requisition Wksh. Name";
        ObjectOptions: Record "Object Options";
        GetOptionData: Codeunit "Report Options Data";
        XMLText: Text;
    begin
        // ReqWorksheetName.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
        // ReqWorksheetName.SetRange(Name, rec."Journal Batch Name");
        // If ReqWorksheetName."Last Used Filters".HasValue then
        //     LastUsedFilter := ReqWorksheetName.GetUsedFilter();
        LastUsedFilter := '';
        RecIsNotEmpty := false;
        DifferentUser := false;
        //CurrPage."LastUsedFilter FB".Page.SetLastUsedFilter('');
        if Rec.IsEmpty then
            exit
        else begin
            ObjectOptions.SetRange("Parameter Name", 'Last used options and filters');
            ObjectOptions.SetRange("Object ID", 99001017);
            ObjectOptions.SetRange("Object Type", ObjectOptions."Object Type"::Report);
            ObjectOptions.SetRange("Created By", GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy));
            ObjectOptions.SetRange("Company Name", CompanyName);
            if ObjectOptions.FindLast then begin
                XMLText := GetOptionData.GetOptionData(ObjectOptions);
                LastUsedFilter := GetOptionData.ParseXml2(XMLText, ObjectOptions."User Name", ObjectOptions.SystemModifiedAt);
                //LastUsedFilter := StrSubstNo('Data Produced By: %1, Data Produced On: %2', GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy), ObjectOptions.SystemModifiedAt);
            end;
            if LastUsedFilter = '' then
                RecIsNotEmpty := false
            else
                RecIsNotEmpty := true;

            if GetOptionData.GetUserNameFromSecurityId(Rec.SystemCreatedBy) = UserId then
                DifferentUser := false
            else
                DifferentUser := true;
        end;
        //CurrPage."LastUsedFilter FB".Page.SetLastUsedFilter(LastUsedFilter);
        //CurrPage.Update(false);
    end;

    var
        LastUsedFilter: Text;
        RecIsNotEmpty: Boolean;
        DifferentUser: Boolean;
}
