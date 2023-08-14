// M code


let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    #"Dimension_Stock Item" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Filtered Rows" = Table.SelectRows(
        #"Dimension_Stock Item",
        each (Number.Mod([Stock Item Key], 2) = 0) and ([Color] <> "N/A")
    ),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Stock Item Key", "Stock Item", "Color"})
in
    #"Removed Other Columns"