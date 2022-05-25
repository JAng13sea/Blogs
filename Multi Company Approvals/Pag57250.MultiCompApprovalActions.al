page 57250 MultiCompApprovalActions
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    Caption = 'multiCompApprovalActions', Locked = true;
    DelayedInsert = true;
    EntityName = 'approvalAction';
    EntitySetName = 'approvalActions';
    PageType = API;
    SourceTable = "Approval Entry";
    ODataKeyFields = SystemId;
    SourceTableView = where(Status = const(Open));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(approverID; Rec."Approver ID")
                {
                    Caption = 'approver_ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(senderID; Rec."Sender ID")
                {
                    Caption = 'Sender_ID';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(amountLCY; Rec."Amount (LCY)")
                {
                    Caption = 'Amount_LCY';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(amount; Rec."Amount")
                {
                    Caption = 'Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(details; Rec.RecordDetails())
                {
                    Caption = 'Details';
                    ApplicationArea = All;
                }
                field(toapprove; Rec."Record ID to Approve")
                {
                    Caption = 'ToApprove';
                    ApplicationArea = All;
                }
                field(comment;Rec.Comment)
                {
                    Caption = 'Comment';
                    ApplicationArea = All;
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                }
                field(currencycode; Rec."Currency Code")
                {
                    Caption = 'Currency_Code';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    [ServiceEnabled]
    procedure MultiApprove(var actionContext: WebServiceActionContext)
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::MultiCompApprovalActions);
        actionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ApprovalMgt.ApproveApprovalRequests(Rec);
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);

    end;

    [ServiceEnabled]
    procedure MultiReject(var actionContext: WebServiceActionContext)
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::MultiCompApprovalActions);
        actionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ApprovalMgt.RejectApprovalRequests(Rec);
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    [ServiceEnabled]
    procedure MultiDelegate(var actionContext: WebServiceActionContext)
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        actionContext.SetObjectType(ObjectType::Page);
        actionContext.SetObjectId(Page::MultiCompApprovalActions);
        actionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ApprovalMgt.DelegateApprovalRequests(Rec);
        actionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}
