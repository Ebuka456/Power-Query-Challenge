// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimGeography = AdventureWorksDW2017{[Schema="dbo",Item="DimGeography"]}[Data],
    #"Expanded DimCustomer" = Table.ExpandTableColumn(dbo_DimGeography, 
                                "DimCustomer", {"FactInternetSales"}, {"FactInternetSales"}),
    #"Expanded FactInternetSales" = Table.ExpandTableColumn(#"Expanded DimCustomer", 
                                    "FactInternetSales", {"SalesAmount"}, {"SalesAmount"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded FactInternetSales", each ([SalesAmount] = null)),
    #"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"CountryRegionCode", Order.Ascending}, 
                                {"City", Order.Ascending}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Sorted Rows",
                                {"City", "CountryRegionCode", "EnglishCountryRegionName"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns")
in
    #"Removed Duplicates"