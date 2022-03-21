page 50265 "Field"
{
    APIGroup = 'pbi';
    APIPublisher = 'JAngle';
    APIVersion = 'v2.0';
    Caption = 'field';
    DelayedInsert = true;
    EntityName = 'field';
    EntitySetName = 'fields';
    PageType = API;
    SourceTable = "Field";
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
                field(fieldName; Rec.FieldName)
                {
                    Caption = 'FieldName';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(class; Rec.Class)
                {
                    Caption = 'Class';
                }
                field(enabled; Rec.Enabled)
                {
                    Caption = 'Enabled';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(relationTableNo; Rec.RelationTableNo)
                {
                    Caption = 'RelationTableNo';
                }
                field(relationFieldNo; Rec.RelationFieldNo)
                {
                    Caption = 'RelationFieldNo';
                }
                field("dataClassification"; Rec."DataClassification")
                {
                    Caption = 'DataClassification';
                }
                field(isPartOfPrimaryKey; Rec.IsPartOfPrimaryKey)
                {
                    Caption = 'IsPartOfPrimaryKey';
                }
                field(len; Rec.Len)
                {
                    Caption = 'Len';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(optionString; Rec.OptionString)
                {
                    Caption = 'OptionString';
                }
                field(sqlDataType; Rec.SQLDataType)
                {
                    Caption = 'SQLDataType';
                }
            }
        }
    }
}
