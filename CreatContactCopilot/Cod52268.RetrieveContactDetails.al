codeunit 52268 "Retrieve Contact Details"
{
    trigger OnRun()
    begin
        GetContactDetails();
    end;

    procedure SetDataPrompt(InputUserPrompt: Text)
    begin
        //Pass in the email body details
        UserPrompt := InputUserPrompt;
    end;

    procedure GetResult(var TmpItemSubstAIProposal2: Record "CP Create Contact Proposal"
     temporary)
    begin
        TmpItemSubstAIProposal2.Copy(TmpItemSubstAIProposal, true);
    end;

    local procedure GetContactDetails()
    var
        TmpXmlBuffer: Record "XML Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        CurrInd, LineNo : Integer;
        DateVar: Date;
        TmpText: Text;
        CPChat: Codeunit "CP Chat";
    begin
        TempBlob.CreateOutStream(OutStr);
        TmpText := CPChat.Chat(GetSystemPrompt(), GetFinalUserPrompt(UserPrompt));
        OutStr.WriteText(TmpText);
        TempBlob.CreateInStream(InStr);

        TmpXmlBuffer.DeleteAll();
        TmpXmlBuffer.LoadFromStream(InStr);
        Clear(OutStr);
        if TmpXmlBuffer.FindSet() then
            repeat
                case TmpXmlBuffer.Path of
                    '/contacts/contact':
                        TmpItemSubstAIProposal.Init();
                    '/contacts/contact/name':
                        begin
                            TmpItemSubstAIProposal."Person Name" := UpperCase(CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Person Name")));
                            TmpItemSubstAIProposal.Insert();
                        end;
                    '/contacts/contact/email':
                        begin
                            TmpItemSubstAIProposal."Person Email" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Person Email"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/role':
                        begin
                            TmpItemSubstAIProposal."Person Role" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Person Role"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/phone':
                        begin
                            TmpItemSubstAIProposal."Person Phone No." := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Person Phone No."));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/company':
                        begin
                            TmpItemSubstAIProposal."Company Name" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Name"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/address':
                        begin
                            TmpItemSubstAIProposal."Company Address" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Address"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/city':
                        begin
                            TmpItemSubstAIProposal."Company City" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company City"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/county':
                        begin
                            TmpItemSubstAIProposal."Company County" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company County"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/postalcode':
                        begin
                            TmpItemSubstAIProposal."Company Post Code" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Post Code"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/companyphone':
                        begin
                            TmpItemSubstAIProposal."Company Phone No." := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."company phone no."));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/language':
                        begin
                            TmpItemSubstAIProposal."Company Language" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Language"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/country':
                        begin
                            TmpItemSubstAIProposal."Company Country Code" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Country Code"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                    '/contacts/contact/companyemail':
                        begin
                            TmpItemSubstAIProposal."Company Email" := CopyStr(TmpXmlBuffer.GetValue(), 1, MaxStrLen(TmpItemSubstAIProposal."Company Email"));
                            TmpItemSubstAIProposal.Modify();
                        end;
                end;
            until TmpXmlBuffer.Next() = 0;
    end;

    local procedure GetSystemPrompt() SystemPrompt: Text

    begin
        SystemPrompt += 'The user will provide an email body from an unknown contact. Your task is to find relevant contact information in the email body.';
        SystemPrompt += 'Only use the email body for this task. If you cannot find any information for a specific field skip it.';
        SystemPrompt += 'The output should be in xml, containing contact name (use name tag in proper case), contact email (use email tag), contacts job role (use role tag), contact phone no. (use phone tag),';
        systemPrompt += 'company name (use company tag), company address (use address tag do not include county, state or postal code), county/state (use county tag), company city (use city tag), company country (use country tag do not confuse for county),';
        SystemPrompt += 'company phone no. (use companyphone tag), company email (use companyemail tag), company website (use website tag), company postal code (use postalcode tag).';
        SystemPrompt += 'language code (use language tag based on the language the email is written in 3 characters only), country code (use country tag based on the country of the address 2 characters only).';
        SystemPrompt += 'Use contacts as a root level tag, use contact as item tag.';
        SystemPrompt += 'Do not use line breaks or other special characters in explanation.';
        SystemPrompt += 'Skip empty nodes.';
    end;

    local procedure GetFinalUserPrompt(InputUserPrompt: Text) FinalUserPrompt: Text
    var
        Item: Record Item;
        Newline: Char;
    begin
        Newline := 10;
        FinalUserPrompt := 'This is the email body:' + Newline;
        FinalUserPrompt += InputUserPrompt;
    end;

    var
        TmpItemSubstAIProposal: Record "CP Create Contact Proposal" temporary;
        UserPrompt: Text;
}
