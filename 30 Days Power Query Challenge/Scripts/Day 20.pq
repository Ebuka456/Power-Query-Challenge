let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    #"DimensionStockItem" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data],
    #"Text Columns" = Table.ColumnsOfType(DimensionStockItem, {type nullable text}),
	#"Removed Other Columns" = Table.SelectColumns(DimensionStockItem, #"Text Columns")

in
    #"Removed Other Columns"