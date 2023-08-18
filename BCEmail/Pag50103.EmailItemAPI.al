page 50103 EmailItem_API
{
    APIGroup = 'email';
    APIPublisher = 'jangle';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'emailItemAPI';
    DelayedInsert = true;
    EntityName = 'emailItem';
    EntitySetName = 'emailItems';
    PageType = API;
    SourceTable = "Email Item";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(sendTo; Rec."Send to")
                {
                    Caption = 'Send to';
                }
                field(fromAddress; Rec."From Address")
                {
                    Caption = 'From Address';
                }
                field(subject; Rec.Subject)
                {
                    Caption = 'Subject';
                }
                field(sendAsHTML; Rec."Send as HTML")
                {
                    Caption = 'Send as HTML';
                }
                field(body; BodyText)
                {
                    Caption = 'Body';
                }
                field(emailContent; Rec.Body)
                {
                    Caption = 'Content';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Contact: Record "Contact";
        EmailScenario: Enum "Email Scenario";
    begin
        Contact.SetRange("E-Mail", Rec."Send to");
        if Contact.FindFirst then
            Rec.AddSourceDocument(Database::Contact, Contact.SystemId);
        Rec.SetBodyText(BodyText);
        Rec.Send(true, EmailScenario::Default);
    end;

    var
        BodyText: Text;
}
