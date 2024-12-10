page 52265 "CP Create Contact Proposal Sub"
{
    ApplicationArea = All;
    Caption = 'Suggest Contact with Copilot';
    PageType = CardPart;
    SourceTable = "CP Create Contact Proposal";

    layout
    {
        area(Content)
        {
            field("Person Name"; Rec."Person Name")
            {
                ApplicationArea = All;
            }
            field("Person Email"; Rec."Person Email")
            {
                ToolTip = 'Specifies the value of the Person Email field.', Comment = '%';
            }
            field("Person Role"; Rec."Person Role")
            {
                ToolTip = 'Specifies the value of the Person Role field.', Comment = '%';
            }
            field("Person Phone No."; Rec."Person Phone No.")
            {
                ToolTip = 'Specifies the value of the Person Phone No. field.', Comment = '%';
            }
            field("Company Name"; Rec."Company Name")
            {
                ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
            }
            field("Company Address"; Rec."Company Address")
            {
                ToolTip = 'Specifies the value of the Company Address field.', Comment = '%';
            }
            field("Company City"; Rec."Company City")
            {
                ToolTip = 'Specifies the value of the Company City field.', Comment = '%';
            }
            field("Company County"; Rec."Company County")
            {
                ToolTip = 'Specifies the value of the Person Phone No. field.', Comment = '%';
            }
            field("Company Post Code"; Rec."Company Post Code")
            {
                ToolTip = 'Specifies the value of the Company Postal Code field.', Comment = '%';
            }
            field("Company Country Code"; Rec."Company Country Code")
            {
                ToolTip = 'Specifies the value of the Company Country field.', Comment = '%';
            }
            field("Company Phone No."; Rec."Company Phone No.")
            {
                ToolTip = 'Specifies the value of the Company Phone No. field.', Comment = '%';
            }
            field("Company Email"; Rec."Company Email")
            {
                ToolTip = 'Specifies the value of the Company Email field.', Comment = '%';
            }
            field("Company Language"; Rec."Company Language")
            {
                ToolTip = 'Specifies the value of the Company Language field.', Comment = '%';
            }
            field("Company Website"; Rec."Company Website")
            {
                ToolTip = 'Specifies the value of the Company Website field.', Comment = '%';
            }
        }
    }
    procedure Load(var TmpCPCreateContactProposal: Record "CP Create Contact Proposal" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        TmpCPCreateContactProposal.Reset();
        if TmpCPCreateContactProposal.FindFirst() then begin
            Rec.Copy(TmpCPCreateContactProposal, false);
            Rec.Insert();
        end;
        CurrPage.Update(false);
    end;

    procedure SaveNewContact()
    var
        CPContactProposal: Record "CP Create Contact Proposal" temporary;
        Contact: Record Contact;
        CompanyContactNo: Code[20];
    begin
        CPContactProposal.Copy(Rec, false);

        CompanyContactNo := CompanyContactExists();
        if CompanyContactNo = '' then
            CompanyContactNo := CreateCompanyContact();
        Contact.Init();
        Contact.Validate(Name, CPContactProposal."Person Name");
        Contact.Validate("E-Mail", CPContactProposal."Person Email");
        Contact.Validate("Phone No.", CPContactProposal."Person Phone No.");
        Contact."Job Title" := CPContactProposal."Person Role";
        Contact.Type := Contact.Type::Person;
        Contact.Address := CPContactProposal."Company Address";
        Contact.City := CPContactProposal."Company City";
        Contact.County := CPContactProposal."Company County";
        Contact."Post Code" := CPContactProposal."Company Post Code";
        Contact.Validate("Country/Region Code", CPContactProposal."Company Country Code");
        Contact.Validate("Language Code", CPContactProposal."Company Language");
        Contact.Insert(true);
        Contact.Validate("Company No.", CompanyContactNo);
        Contact.Modify(true);

        if NotLinked(Contact) then
            Page.Run(Page::"Contact Card", Contact)
        else
            Contact.ShowBusinessRelation(Enum::"Contact Business Relation Link To Table"::" ", false);
        CurrPage.Close();
    end;

    local procedure CompanyContactExists() CompanyNo: Code[20]
    var
        CPContactProposal: Record "CP Create Contact Proposal" temporary;
        Contact: Record Contact;
    begin
        CPContactProposal.Copy(Rec, false);
        Contact.SetRange("Name", CPContactProposal."Company Name");
        if Contact.IsEmpty() then
            exit('')
        else
            exit(Contact."No.");
    end;

    local procedure CreateCompanyContact() CompanyNo: Code[20]
    var
        CPContactProposal: Record "CP Create Contact Proposal" temporary;
        Contact: Record Contact;
    begin
        CPContactProposal.Copy(Rec, false);
        Contact.Init();
        Contact.Type := Contact.Type::Company;
        Contact.Validate(Name, CPContactProposal."Company Name");
        Contact.Validate("E-Mail", CPContactProposal."Company Email");
        Contact.Validate("Phone No.", CPContactProposal."Company Phone No.");
        Contact.Address := CPContactProposal."Company Address";
        Contact.City := CPContactProposal."Company City";
        Contact.County := CPContactProposal."Company County";
        Contact."Post Code" := CPContactProposal."Company Post Code";
        Contact.Validate("Country/Region Code", CPContactProposal."Company Country Code");
        Contact.Validate("Language Code", CPContactProposal."Company Language");
        Contact.Insert(true);
        exit(Contact."No.");
    end;

    local procedure NotLinked(Contact: Record Contact): Boolean
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        // Person could be linked directly or through Company No.
        ContBusRel.SetFilter("Contact No.", '%1|%2', Contact."No.", Contact."Company No.");
        ContBusRel.SetFilter("No.", '<>''''');
        exit(ContBusRel.IsEmpty);
    end;
}
