page 50264 key_table
{
    APIGroup = 'pbi';
    APIPublisher = 'JAngle';
    APIVersion = 'v2.0';
    Caption = 'keyTable';
    DelayedInsert = true;
    EntityName = 'allTable';
    EntitySetName = 'allTables';
    PageType = API;
    SourceTable = "Key";
    ODataKeyFields = SystemId;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(tableNo; Rec.TableNo)
                {
                    Caption = 'TableNo';
                }
                field(tableName; Rec.TableName)
                {
                    Caption = 'TableName';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field("key"; Rec."Key")
                {
                    Caption = 'Key';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
