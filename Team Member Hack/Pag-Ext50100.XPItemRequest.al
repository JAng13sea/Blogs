pageextension 50105 "XP Item Request" extends "Purchase Quote"
{
    actions
    {
        addfirst("&Quote")
        {
            action(ItemRequest)
            {
                ApplicationArea = All;
                Caption = 'Item Request', comment = 'ENG="Item Request"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateInventoryPick;
                trigger OnAction()
                begin
                    Page.Run(50100);
                end;
            }
        }
    }
}
