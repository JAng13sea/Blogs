page 59981 "Saved Demand Filters Card"
{
    Caption = 'Saved Demand Filters Card';
    PageType = Card;
    SourceTable = "Prod. Forecast Saved Filters";
    DataCaptionFields = "Filter Name", Name;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name; Rec.Name)
                {
                    ApplicationArea = Planning;
                    Caption = 'Demand Forecast Name';
                    ToolTip = 'Specifies the name of the demand forecast.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Planning;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the demand forecast.';
                }
                field("View By"; Rec."View By")
                {
                    ApplicationArea = Planning;
                    Caption = 'View by';
                    ToolTip = 'Specifies the period of time for which amounts are displayed.';
                }
                field("Quantity Type"; Rec."Quantity Type")
                {
                    ApplicationArea = Planning;
                    Caption = 'View as';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';
                }
                field("Forecast Type"; Rec."Forecast Type")
                {
                    ApplicationArea = Planning;
                    Caption = 'Forecast Type';
                    ToolTip = 'Specifies whether the demand forecast entry is for a sales item or a component item. If you choose Sales Item, only sales orders net the forecast. If you choose Component Item, demand from production order components net the forecast.';
                }
                field("Item Filter"; ItemFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies a filter that will show specific items on the Demand Forecast Matrix FastTab. This reduces the number of entries on the FastTab.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        ItemFilterXMLText: Text;
                    begin
                        if not IsEditable then
                            exit;

                        ItemFilterXMLText := ItemFilterDrillDown(Rec.GetItemFilterBlobAsText());
                        if ItemFilterXMLText <> '' then begin
                            Rec.SetTextFilterToItemFilterBlob(ItemFilterXMLText);
                            Rec.Modify();
                            ItemFilter := Rec.GetItemFilterAsDisplayText();
                        end;
                    end;
                }
                field("Forecast By Locations"; Rec."Forecast By Locations")
                {
                    ApplicationArea = Planning;
                    Caption = 'Forecast by Locations';
                    ToolTip = 'Specifies whether to create a forecast entry that includes locations.';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        LocationFilterIsEnabled := Rec."Forecast By Locations";
                        if not Rec."Forecast By Locations" then
                            LocationFilter := '';
                    end;
                }
                field("Location Filter"; LocationFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Location Filter';
                    ToolTip = 'Specifies a location code if you want to create a forecast entry for a specific location.';
                    Importance = Additional;
                    Enabled = LocationFilterIsEnabled;
                    Editable = IsEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(OnLookupLocationFilter(Text, LocationFilter));
                    end;

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.SetFilter(Code, LocationFilter);
                        LocationFilter := Location.GetFilter(Code);
                        Rec.SetTextFilterToLocationBlob(LocationFilter);
                        Rec.Modify();
                    end;
                }
                field("Forecast By Variants"; Rec."Forecast By Variants")
                {
                    ApplicationArea = Planning;
                    Caption = 'Forecast by Variants';
                    ToolTip = 'Use this if you want to create a forecast entry including the variants.';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        VariantFilterIsEnabled := Rec."Forecast By Variants";
                        if not Rec."Forecast By Variants" then
                            VariantFilter := '';
                    end;
                }
                field("Variant Filter"; VariantFilter)
                {
                    ApplicationArea = Planning;
                    Caption = 'Variant Filter';
                    ToolTip = 'Specifies an item variant code if you want to create a forecast entry for a specific item variant.';
                    Importance = Additional;
                    Enabled = VariantFilterIsEnabled;
                    Editable = IsEditable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(OnLookupVariantFilter(Text));
                    end;

                    trigger OnValidate()
                    var
                        ItemVariant: Record "Item Variant";
                    begin
                        ItemVariant.SetFilter(Code, VariantFilter);
                        VariantFilter := ItemVariant.GetFilter(Code);
                        Rec.SetTextFilterToVariantFilterBlob(VariantFilter);
                        Rec.Modify();
                    end;
                }
                field("Date Filter"; Rec."Date Filter")
                {
                    ApplicationArea = Planning;
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the dates that will be used to filter the amounts in the window.';
                    Editable = IsEditable;

                    trigger OnValidate()
                    var
                        FilterTokens: Codeunit "Filter Tokens";
                        DateFilter: Text;
                    begin
                        DateFilter := Rec."Date Filter";
                        FilterTokens.MakeDateFilter(DateFilter);
                        Rec."Date Filter" := CopyStr(DateFilter, 1, MaxStrLen(Rec."Date Filter"));
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsEditable := CurrPage.Editable;
    end;

    trigger OnAfterGetRecord()
    begin
        IsEditable := CurrPage.Editable;
        ItemFilter := Rec.GetItemFilterAsDisplayText();
        LocationFilter := Rec.GetLocationFilterBlobAsText();
        VariantFilter := Rec.GetVariantFilterBlobAsText();
        VariantFilterIsEnabled := Rec."Forecast By Variants";
        LocationFilterIsEnabled := Rec."Forecast By Locations";
    end;

    var
        VariantFilterIsEnabled: Boolean;
        LocationFilterIsEnabled: Boolean;
        IsEditable: Boolean;
        ItemFilter: Text;
        LocationFilter: Text;
        VariantFilter: Text;

    local procedure ItemFilterDrillDown(ItemFilterBlobText: Text): Text
    var
        Item: Record Item;
        RequestPageParametersHelper: Codeunit "Request Page Parameters Helper";
        FilterPage: FilterPageBuilder;
        ItemCaptionTxt: Code[20];
    begin
        ItemCaptionTxt := CopyStr(Item.TableCaption, 1, MaxStrLen(ItemCaptionTxt));
        RequestPageParametersHelper.BuildDynamicRequestPage(FilterPage, ItemCaptionTxt, Database::Item);
        RequestPageParametersHelper.SetViewOnDynamicRequestPage(FilterPage, ItemFilterBlobText, ItemCaptionTxt, Database::Item);
        FilterPage.PageCaption := ItemCaptionTxt;
        if not FilterPage.RunModal() then
            exit;
        exit(RequestPageParametersHelper.GetViewFromDynamicRequestPage(FilterPage, ItemCaptionTxt, Database::Item));
    end;

    local procedure OnLookupLocationFilter(var Text: Text; LocationFilterVal: Text): Boolean
    var
        Loc: Record Location;
        LocList: Page "Location List";
    begin
        Loc.SetRange("Use As In-Transit", false);
        LocList.SetTableView(Loc);

        Loc.SetFilter(Code, LocationFilterVal);
        if Loc.FindSet() then
            LocList.SetRecord(Loc);

        LocList.LookupMode(true);
        if not (LocList.RunModal() = ACTION::LookupOK) then
            exit(false);

        Text := LocList.GetSelectionFilter();

        exit(true);
    end;

    local procedure OnLookupVariantFilter(var Text: Text): Boolean
    var
        ItemVariant: Record "Item Variant";
        ItemVariantList: Page "Item Variants";
    begin
        ItemVariantList.LookupMode(true);
        ItemVariantList.SetTableView(ItemVariant);
        if not (ItemVariantList.RunModal() = ACTION::LookupOK) then
            exit(false);

        Text := ItemVariantList.GetSelectionFilter();

        exit(true);
    end;
}
