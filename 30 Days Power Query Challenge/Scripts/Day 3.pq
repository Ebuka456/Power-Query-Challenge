// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimProduct = AdventureWorksDW2017{[Schema="dbo",Item="DimProduct"]}[Data],
    #"Expanded FactResellerSales" = Table.ExpandTableColumn(dbo_DimProduct, "FactResellerSales", {"OrderQuantity", "UnitPrice"}, {"OrderQuantity", "UnitPrice"}),
    #"Calculated Total Unit Price" = Table.AddColumn(#"Expanded FactResellerSales", "Total Unit Price", each [OrderQuantity] * [UnitPrice]),
    #"Removed Other Columns" = Table.SelectColumns(#"Calculated Total Unit Price",{"ProductKey", "EnglishProductName", "Total Unit Price"}),
    #"Grouped Rows" = Table.Group(#"Removed Other Columns", {"ProductKey", "EnglishProductName"}, {{"Total Revenue", each List.Sum([Total Unit Price]), type number}}),
    #"Filtered Rows" = Table.SelectRows(#"Grouped Rows", each [Total Revenue] > 1000000)
in
    #"Filtered Rows"
