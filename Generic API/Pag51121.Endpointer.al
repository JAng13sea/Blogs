page 51121 "Endpointer"
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'endpointer';
    DelayedInsert = true;
    EntityName = 'endpointer';
    EntitySetName = 'endpointers';
    PageType = API;
    SourceTable = "Endpoint Table Config.";
    ODataKeyFields = "Table ID";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(tableID; Rec."Table ID")
                {
                    Caption = 'Table ID';
                }
                field(JsonResponse; JsonResponse)
                {
                    Caption = 'Response';
                }
            }
        }
    }

    var
        JsonResponse: Text;

    trigger OnAfterGetRecord()
    var
        ResponseJobject: JsonObject;
        EndpointMgt: Codeunit "Endpoint Mgt.";
    begin

        ResponseJObject := EndpointMgt.PrepareGetDataResponse(Rec);

        ResponseJObject.WriteTo(JsonResponse);
        
    end;


    // [ServiceEnabled]
    // procedure GetData(var actionContext: WebServiceActionContext;input: Integer): Text
    // var
    //     //actionContext: WebServiceActionContext;
    //     EndpointMgt: Codeunit "Endpoint Mgt.";
    //     TableConfig: Record "Endpoint Table Config.";
    //     GetJson: JsonObject;
    //     Output: Text;
    //     JsonResponse: JsonObject;
    // begin
    //     //JObject.ReadFrom(Format(TableId));

    //     TableConfig.SetRange("Table ID", input);
    //     If TableConfig.FindFirst() then begin
    //         ResponseJObject := EndpointMgt.PrepareGetDataResponse(Rec);
    //         ResponseJObject.WriteTo(Output);
    //     end;

    //     // actionContext.SetObjectType(ObjectType::Page);
    //     // actionContext.SetObjectId(Page::"Endpoint Table Config. Card");
    //     // actionContext.AddEntityKey(Rec.FieldNo("Table ID"), Rec."Table ID");
    //     // GetJson := EndpointMgt.PrepareGetDataResponse(Rec);
    //     actionContext.SetResultCode(WebServiceActionResultCode::Get);
    //     exit(Output);
    // end;
    // procedure GetSalesAmount(var actionContext: WebServiceActionContext;customerno: Code[20])
    // var
    //     //actionContext: WebServiceActionContext;
    //     EndpointMgt: Codeunit "Misc";
    //     GetJson: JsonObject;
    //     TextRes: Text;
    // begin
    //     actionContext.SetObjectType(ObjectType::Page);
    //     actionContext.SetObjectId(Page::Endpointer);
    //     actionContext.AddEntityKey(Rec.FieldNo("Table ID"), Rec."Table ID");
    //     TextRes := EndpointMgt.GetSalesAmount(customerno);
    //     actionContext.SetResultCode(WebServiceActionResultCode::Get);
    //     //exit(TextRes);
    // end;
}
