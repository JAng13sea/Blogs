pageextension 58720 "XP Gen. Jrnl" extends "General Journal"
{
    actions
    {
        addafter("Renumber Document Numbers")
        {
            action(FillGlobalDim)
            {
                ApplicationArea = All;
                Caption = 'Dimension Selector';
                Promoted = true;
                Image = SuggestField;
                trigger OnAction()
                var
                    ExistingDimSetEntry: Record "Dimension Set Entry" temporary;
                    DimsSelected: Record "Dimension Set Entry" temporary;
                    EditDimSetEntries: Page "Dimension Selector";
                    NewDimSetID: Integer;
                    CopyGenJnl: Record "Gen. Journal Line";
                    DimMgt: Codeunit DimensionManagement;
                begin
                    EditDimSetEntries.RunModal();
                    NewDimSetID := EditDimSetEntries.GetDimensionID();
                    CopyGenJnl.Copy(Rec);
                    CurrPage.SetSelectionFilter(CopyGenJnl);
                    if CopyGenJnl.FindSet() then
                        repeat
                            DimMgt.GetDimensionSet(ExistingDimSetEntry, CopyGenJnl."Dimension Set ID");
                            DimMgt.GetDimensionSet(DimsSelected, NewDimSetID);
                            if DimsSelected.FindSet() then
                                repeat
                                    if ExistingDimSetEntry.Get(CopyGenJnl."Dimension Set ID", DimsSelected."Dimension Code") then begin
                                        ExistingDimSetEntry.Validate("Dimension Value Code", DimsSelected."Dimension Value Code");
                                        ExistingDimSetEntry.Modify();
                                    end else begin
                                        ExistingDimSetEntry := DimsSelected;
                                        ExistingDimSetEntry."Dimension Set ID" := CopyGenJnl."Dimension Set ID";
                                        ExistingDimSetEntry.Insert();
                                    end;
                                until DimsSelected.Next() = 0;
                            UpdateDimSetIDJnlLine(CopyGenJnl, DimMgt.GetDimensionSetID(ExistingDimSetEntry));
                        until CopyGenJnl.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    procedure UpdateDimSetIDJnlLine(var JnlLine: Record "Gen. Journal Line"; DimSetID: Integer)
    begin
        JnlLine.Validate("Dimension Set ID", DimSetID);
        JnlLine.Modify();
    end;
}
