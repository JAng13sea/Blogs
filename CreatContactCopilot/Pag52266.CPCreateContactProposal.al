page 52266 "CP Create Contact Proposal"
{
    ApplicationArea = All;
    Caption = 'CP Create Contact Proposal';
    PageType = StandardDialog;
    Extensible = false;
    layout
    {

        area(Content)
        {
            part("CP Create Contact Proposal Sub"; "CP Create Contact Proposal Sub")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        area(Processing)
        {
            action(OK)
            {
                Caption = 'Confirm';
            }
            action(Regenerate)
            {
                Caption = 'Regenerate';
                trigger OnAction()
                begin
                    RunGeneration(EmailBody);
                end;
            }
        }

    }

    trigger OnOpenPage()
    begin
        RunGeneration(EmailBody);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::Ok then begin
            CurrPage."CP Create Contact Proposal Sub".Page.SaveNewContact();
        end;
    end;

    procedure SetEmailBody(EmailContent: Text)
    begin
        EmailBody := EmailContent;
    end;

    local procedure RunGeneration(DataPrompt: Text)
    var
        InStr: InStream;
        Attempts: Integer;
    begin
        TmpCPCreateContactProposal.Reset();
        TmpCPCreateContactProposal.DeleteAll();
        Attempts := 0;
        while TmpCPCreateContactProposal.IsEmpty and (Attempts < 5) do begin
            RetrieveContactDetails.SetDataPrompt(DataPrompt);
            if RetrieveContactDetails.Run() then
                RetrieveContactDetails.GetResult(TmpCPCreateContactProposal);
            Attempts += 1;
        end;

        if (Attempts < 5) then begin
            Load(TmpCPCreateContactProposal);
        end else
            Error('Something went wrong. Please try again. ' + GetLastErrorText());
    end;

    procedure Load(var TmpCPCreateContactProposal: Record "CP Create Contact Proposal" temporary)
    begin
        CurrPage."CP Create Contact Proposal Sub".Page.Load(TmpCPCreateContactProposal);

        CurrPage.Update(false);
    end;

    var
        CPChat: Codeunit "CP Chat";
        RetrieveContactDetails: Codeunit "Retrieve Contact Details";
        TmpCPCreateContactProposal: Record "CP Create Contact Proposal" temporary;
        EmailBody: Text;
}
