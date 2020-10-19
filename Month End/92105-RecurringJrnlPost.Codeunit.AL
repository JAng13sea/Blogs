codeunit 92105 "GenJrnl Post"
{
    trigger OnRun()
    begin

    end;

    procedure postJrnl(JrnlName: Code[20])
    var
        GenJrnl: Record "Gen. Journal Line";
    begin
        GenJrnl.SetFilter("Journal Template Name",'RECURRING');
        GenJrnl.SetRange("Journal Batch Name", JrnlName);
        if GenJrnl.FindSet() then begin
            CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", GenJrnl);
        end;
    end;

    procedure AdjustGLSetup(FromDate: Date; ToDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
    Begin
        GLSetup.Get;
        GLSetup."Allow Posting To" := ToDate;
        GLSetup."Allow Posting From" := FromDate;
        GLSetup.Modify;
    End;
}