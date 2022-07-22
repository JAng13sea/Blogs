pageextension 59980 "Demand Forecast Card Ext." extends "Demand Forecast Card"
{
    actions
    {
        addlast("F&unctions")
        {
            action(SaveFilter)
            {
                ApplicationArea = All;
                Caption = 'Save Filters';
                Image = SaveViewAs;
                trigger OnAction()
                var
                    SaveDemandForecast: Report "Save Demand Forecast Filters";
                begin
                    SaveDemandForecast.Initialise(Rec);
                    SaveDemandForecast.RunModal();
                    Rec.Validate("Filter Name",'');
                end;
            }

            action(RetrieveSavedFilter)
            {
                ApplicationArea = All;
                Caption = 'Retrieve Saved Filters';
                Image = Filter;
                trigger OnAction()
                var
                    SavedForecastFilters: Record "Prod. Forecast Saved Filters";
                    DemandForecast: Record "Production Forecast Name";
                begin
                    if rec."Filter Name" <> '' then
                        SavedForecastFilters.SetFilter("Filter Name", '<>%1', Rec."Filter Name");
                    if Page.RunModal(59980, SavedForecastFilters) = Action::LookupOK then begin
                        SavedForecastFilters.CalcFields("Item Filter","Location Filter","Variant Filter");
                        DemandForecast.TransferFields(SavedForecastFilters);
                        DemandForecast.Modify(true);
                        CurrPage.close();
                        Page.Run(2901,DemandForecast);
                    end;
                end;
            }
        }
        addlast(Navigation)
        {
            action(SavedFilters)
            {
                
            }
        }
    }
}
