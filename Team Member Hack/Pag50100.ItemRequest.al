page 50100 "Item Request"
{

    Caption = '';
    PageType = NavigatePage;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(ItemReq)
            {
                Caption = '';

                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                }
                field(ItemUoM; ItemUoM)
                {
                    ApplicationArea = All;
                    TableRelation = "Unit of Measure".Code;
                    Caption = 'Item Unit of Measure';
                }
                field(ItemCategory; ItemCategory)
                {
                    ApplicationArea = All;
                    TableRelation = "Item Category".Code;
                    Caption = 'Item Category Code';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel', comment = 'ENG="Cancel"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Cancel;
                InFooterBar = true;
                
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
            action(RequestData)
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Send Request';
                InFooterBar = true;
                trigger OnAction()
                begin
                    if SendHTTPRequest(ItemDescription, ItemUoM, ItemCategory) then begin
                        Message('Request Sent');
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    local procedure SendHTTPRequest(pItemDescription: Text; pItemUoM: Code[20]; pItemCategory: Code[20]): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Jobject: JsonObject;
        tmpString: Text;
        Headers: HttpHeaders;
    begin
        Request.Method := 'POST';
        //Request.SetRequestUri('https://ptsv2.com/t/1jqii-1639481761/post');
        Request.SetRequestUri('your flow URL');
        Jobject.Add('ItemDescription', pItemDescription);
        Jobject.Add('ItemUoM', pItemUoM);
        Jobject.Add('ItemCategory', pItemCategory);
        Jobject.WriteTo(tmpString);
        Content.WriteFrom(tmpString);
        Content.ReadAs(tmpString);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
        Request.Content := Content;
        if Client.Send(Request, Response) then
            exit(true)
        else
            exit(false);
        
    end;

    var

        ItemDescription: Text[100];
        ItemUoM: Code[20];
        ItemCategory: Code[20];
        RequestSent: Boolean;
}
