page 50199 "Sales Items by Attribute"
{
    ApplicationArea = All;
    Caption = 'Filter Items by Attribute';
    PageType = ListPlus;
    SourceTable = "Filter Item Attributes Buffer";
    UsageCategory = None;
    SourceTableTemporary = true;
    DeleteAllowed = true;
    SaveValues = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field(Attribute; Rec.Attribute)
                {
                    ApplicationArea = Basic, Suite;
                    TableRelation = "Item Attribute".Name;
                    ToolTip = 'Specifies the name of the attribute to filter on.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the filter. You can use single values or filter expressions, such as >,<,>=,<=,|,&, and 1..100.';

                    trigger OnAssistEdit()
                    begin
                        Rec.ValueAssistEdit();
                    end;

                    // trigger OnValidate()
                    // begin
                    //     CurrPage.SalesIemsbyAttribute.Page.LoadItems(Rec);
                    // end;
                }
            }
            part(SalesIemsbyAttribute; "Sales Items by Attribute Part")
            {
                ApplicationArea = All;
            }
            part("Added Sales Lines Subform"; "Added Sales Lines Subform")
            {
                ApplicationArea = All;
                Visible = SalesLineVisible;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Find)
            {
                ApplicationArea = All;
                Caption = 'Find';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    CurrPage.SalesIemsbyAttribute.Page.FindItems(Rec);
                end;
            }
            action(DeleteAll)
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = DeleteRow;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.DeleteAll();
                    CurrPage.SalesIemsbyAttribute.Page.RemoveItems();
                end;
            }
            action(RemoveLastEntry)
            {
                ApplicationArea = All;
                Caption = 'Undo Last Attribute Entry';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    If Rec.FindLast() then begin
                        Rec.Delete();
                        CurrPage.SalesIemsbyAttribute.Page.FindItems(Rec);
                    end;
                end;
            }
            action(ViewAddedSalesLines)
            {
                ApplicationArea = All;
                Caption = 'Show Added Sales Lines';
                Visible = not SalesLineVisible;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    SalesLineVisible := true;
                    CurrPage.Update(false);
                end;
            }
            action(HideAddedSalesLines)
            {
                ApplicationArea = All;
                Caption = 'Hide Added Sales Lines';
                Visible = SalesLineVisible;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    SalesLineVisible := false;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SalesLineVisible := false;
        CaptionVisible := ShowCaption;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.SetRange(Value, '');
        Rec.DeleteAll();
    end;

    procedure SetVars(_RecRef: RecordRef; _LocationCode: Code[10]; _SONumber: Code[10]; _LastSalesLineNo: Integer)
    begin
        BaseRecRef := _RecRef;
        LocationCode := _LocationCode;
        LastSalesLineNo := _LastSalesLineNo;
        SONumber := _SONumber;
        CurrPage.SalesIemsbyAttribute.Page.SetVars(_RecRef, _LocationCode);
        CurrPage."Added Sales Lines Subform".Page.SetFilters(_SONumber,_LastSalesLineNo);
    end;

    var
        BaseRecRef: RecordRef;
        LocationCode: Code[10];
        LastSalesLineNo: Integer;
        SONumber: Code[10];
        SalesLineVisible: Boolean;
        CaptionVisible: Text;
        HideCaption: Label 'Hide Added Sales Lines';
        ShowCaption: Label 'Show Added Sales Lines';
}
