let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data][[Invoice Date Key], [Profit]],
    #"Added Custom" = Table.AddColumn(Fact_Sale, "YYYYMM", each Text.From(Date.Year([Invoice Date Key])) & 
                        Text.PadStart(Text.From(Date.Month([Invoice Date Key])), 2, "0")),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"YYYYMM", Int64.Type}}),
    #"Custom: YYYYMM Offset" = Table.AddColumn(
		#"Changed Type", 
		"Offset", 
		each if Date.Month([Invoice Date Key]) = 12 then [YYYYMM] + 100 - 11 else [YYYYMM] + 1, 
		Int64.Type),
    #"Grouped Rows" = Table.Group(#"Custom: YYYYMM Offset", {"YYYYMM", "Offset"}, {{"Total Profit", 
                      each List.Sum([Profit]), type number}}),
    #"Merge Offsets" = Table.NestedJoin(#"Grouped Rows", {"YYYYMM"}, #"Grouped Rows", {"Offset"}, "Offset Results", 
		                   JoinKind.LeftOuter),
    #"Expanded Offset Results" = Table.ExpandTableColumn(#"Merge Offsets", "Offset Results", {"Offset", "Total Profit"}, {"Offset.1", "Total Profit.1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expanded Offset Results",{{"Total Profit.1", "Offset Profit"}, {"Offset.1", "Offset YYYYMM"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "Change Percentage", each if [Offset Profit]  = null then 0 else ([Total Profit] - [Offset Profit])
			/ [Offset Profit]),
    #"Sorted Rows" = Table.Sort(#"Added Custom1",{{"YYYYMM", Order.Ascending}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Sorted Rows",{"YYYYMM", "Total Profit", "Change Percentage"})
in
    #"Removed Other Columns"