table 52265 "CP Create Contact Proposal"
{
    Caption = 'CP Create Contact Proposal';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Person Name"; Text[250])
        {
            Caption = 'Person Name';
            DataClassification = CustomerContent;
        }
        field(2; "Person Email"; Text[250])
        {
            Caption = 'Person Email';
            DataClassification = CustomerContent;
        }
        field(3; "Person Role"; Text[250])
        {
            Caption = 'Person Role';
            DataClassification = CustomerContent;
        }
        field(4; "Person Phone No."; Text[250])
        {
            Caption = 'Person Phone No.';
            DataClassification = CustomerContent;
        }
        field(5; "Company Name"; Text[250])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(6; "Company Address"; Text[250])
        {
            Caption = 'Company Address';
            DataClassification = CustomerContent;
        }
        field(7; "Company Phone No."; Text[250])
        {
            Caption = 'Company Phone No.';
            DataClassification = CustomerContent;
        }
        field(8; "Company Email"; Text[250])
        {
            Caption = 'Company Email';
            DataClassification = CustomerContent;
        }
        field(9; "Company Website"; Text[250])
        {
            Caption = 'Company Website';
            DataClassification = CustomerContent;
        }
        field(10; "Company Post Code"; Text[250])
        {
            Caption = 'Company Postal Code';
            DataClassification = CustomerContent;
        }
        field(11; "Company County"; Text[250])
        {
            Caption = 'Person Phone No.';
            DataClassification = CustomerContent;
        }
        field(12; "Company City"; Text[250])
        {
            Caption = 'Company City';
            DataClassification = CustomerContent;
        }
        field(13; "Company Country Code"; Code[20])
        {
            Caption = 'Company Country';
            DataClassification = CustomerContent;
        }
        field(14; "Company Language"; Code[20])
        {
            Caption = 'Company Language';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Person Name")
        {
            Clustered = true;
        }
    }
}
