let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data],
    #"Merged Queries" = Table.NestedJoin(Fact_Order, {"Order Key"}, #"Day 15c", {"Sale Key"}, "Fact Sale", JoinKind.Inner),
    #"Expanded Fact Sale" = Table.ExpandTableColumn(#"Merged Queries", "Fact Sale", {"Delivery Date Key"}, {"Delivery Date Key"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded Fact Sale",{"City Key", "Order Date Key", "Delivery Date Key"}),
    #"Added Custom" = Table.AddColumn(#"Removed Other Columns", "Delivery Days", each Duration.TotalDays([Delivery Date Key] - [Order Date Key])),
    #"Grouped Rows" = Table.Group(#"Added Custom", {"City Key"}, {{"Average Delivery Days", each List.Average([Delivery Days]), type number}}),
    #"Rounded Down" = Table.TransformColumns(#"Grouped Rows",{{"Average Delivery Days", Number.RoundDown, Int64.Type}}),
    #"Merged Queries1" = Table.NestedJoin(#"Rounded Down", {"City Key"}, #"Day 15 b", {"City Key"}, "Dimension City (2)", JoinKind.Inner),
    #"Expanded Dimension City (2)" = Table.ExpandTableColumn(#"Merged Queries1", "Dimension City (2)", {"City"}, {"City"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Expanded Dimension City (2)",{"City Key", "City", "Average Delivery Days"}),
    #"Sorted Rows" = Table.Sort(#"Reordered Columns",{{"Average Delivery Days", Order.Descending}}),
    #"10th Value" = List.Sort(
		List.Distinct(#"Sorted Rows"[Average Delivery Days]), 
		Order.Descending
	){10} - 1,
  #"Filter Top 10" = Table.SelectRows(
		#"Sorted Rows", 
		each [Average Delivery Days] > #"10th Value"
	)
in
    #"Filter Top 10"