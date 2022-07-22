report 59980 "Save Demand Forecast Filters"
{
    Caption = 'Save Demand Forecast Filters';
    ProcessingOnly = true;
    dataset
    {
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Details)
                {
                    field(FilterName; FilterName)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter Name';
                    }
                    field(ForecastCode; ProductionForecast.Name)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        caption = 'Demand Forecast Name';
                    }
                    field(ForecastName; ProductionForecast.Description)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        caption = 'Demand Forecast Description';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if FilterName = '' then
            Error(Text000);
        SaveFilters;
    end;

    procedure Initialise(var SelectedDemandForecast: Record "Production Forecast Name")
    begin
        ProductionForecast.Copy(SelectedDemandForecast);
    end;

    local procedure SaveFilters()
    var
        SavedDemandForecastFilters: Record "Prod. Forecast Saved Filters";
    begin
        SavedDemandForecastFilters.Init();
        ProductionForecast.Validate("Filter Name", FilterName);
        SavedDemandForecastFilters.TransferFields(ProductionForecast);
        SavedDemandForecastFilters.Insert(false);
    end;

    var
        FilterName: Code[20];
        Text000: Label 'Enter a Filter Name to save the current filters';
        ProductionForecast: Record "Production Forecast Name";
}
