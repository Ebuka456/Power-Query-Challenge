// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimReseller = AdventureWorksDW2017{[Schema="dbo",Item="DimReseller"]}[Data],
    #"Expanded DimGeography" = Table.ExpandRecordColumn(dbo_DimReseller, "DimGeography", {"CountryRegionCode", "EnglishCountryRegionName"}, {"CountryRegionCode", "EnglishCountryRegionName"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded DimGeography", each Text.Contains([ResellerName], "Bike") or Text.Contains([ResellerName], "Bicycle")),
    #"Filtered Rows1" = Table.SelectRows(#"Filtered Rows", each not Text.Contains([CountryRegionCode], "DE") and not Text.Contains([CountryRegionCode], "GB")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows1",{"ResellerKey", "BusinessType", "ResellerName", "NumberEmployees", "ProductLine", "AnnualRevenue", "EnglishCountryRegionName"})
in
    #"Removed Other Columns"

