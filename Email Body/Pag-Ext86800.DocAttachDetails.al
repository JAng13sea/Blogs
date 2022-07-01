pageextension 86800 "Doc. Attach Details" extends "Document Attachment Details"
{
    actions
    {
        addlast(processing)
        {
            action(AttachEmailBody)
            {
                ApplicationArea = All;
                Caption = 'Attach email body';
                Image = Email;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Page;
                ToolTip = 'Attach body of the email as HTML';
                Visible = IsOfficeAddin;

                trigger OnAction()
                begin
                    CopyOfficeEmail.GenerateEmailBody(FromRecRef);
                end;
            }
        }

        addlast(processing)
        {
            action(OpenHTMLEmail)
            {
                ApplicationArea = All;
                Caption = 'Preview Email';
                Image = Email;
                Enabled = Rec."File Extension" = 'html';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Page;
                ToolTip = 'Preview HTML Email';
                Visible = Not IsOfficeAddin;

                trigger OnAction()
                begin
                    CopyOfficeEmail.PreviewHTMLContent(Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsOfficeAddin := OfficeMgmt.IsAvailable();
    end;

    var
        OfficeMgmt: Codeunit "Office Management";
        IsOfficeAddin: Boolean;
        CopyOfficeEmail: Codeunit "Copy Office Email Body";
}
