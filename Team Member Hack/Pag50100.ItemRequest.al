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
                    trigger OnValidate()
                    begin
                        //ItemDescription := ItemDescription;
                    end;
                }
                field(ItemUoM; ItemUoM)
                {
                    ApplicationArea = All;
                    TableRelation = "Unit of Measure".Code;
                    Caption = 'Item Unit of Measure';
                    trigger OnValidate()
                    begin
                        //ItemUoM := ItemUoM;
                    end;
                }
                field(ItemCategory; ItemCategory)
                {
                    ApplicationArea = All;
                    TableRelation = "Item Category".Code;
                    Caption = 'Item Category Code';
                    trigger OnValidate()
                    begin
                        //ItemCategory := ItemCategory;
                    end;
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
                    if SendHTTPRequest(ItemDescription, ItemUoM) then begin
                        Message('Request Sent');
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    local procedure SendHTTPRequest(pItemDescription: Text; pItemUoM: Code[20]): Boolean
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
        Request.SetRequestUri('https://prod-28.uksouth.logic.azure.com:443/workflows/7e537bb5254648969566a8b61dedffcf/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=SAkN8Rj6Zp6KCrS8Kpmw0D3LvLo6G1Skmt06i4Y-AaE');
        Jobject.Add('ItemDescription', ItemDescription);
        Jobject.Add('ItemUoM', ItemUoM);
        Jobject.Add('ItemCategory', ItemCategory);
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
