query 56666 "Item List Query"
{
    APIGroup = 'jagrp';
    APIPublisher = 'ja';
    APIVersion = 'v2.0';
    EntityName = 'itemQuery';
    EntitySetName = 'itemQueries';
    QueryType = API;

    elements
    {
        dataitem(item; Item)
        {
            column(id; SystemId)
            {
            }
            column(no; "No.")
            {
            }
            column(description; Description)
            {
            }
            column(inventory; Inventory)
            {
            }
            column(salesUnitOfMeasure; "Sales Unit of Measure")
            {
            }
            column(baseUnitOfMeasure; "Base Unit of Measure")
            {
            }
            filter(locationFilter; "Location Filter")
            { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
