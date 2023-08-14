Day 17

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_FactCallCenter = AdventureWorksDW2017{[Schema="dbo",Item="FactCallCenter"]}[Data],
    #"Added Custom" = Table.AddColumn(dbo_FactCallCenter, "Total Time", each [Calls] * [AverageTimePerIssue]),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"Total Time", Int64.Type}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each Text.Contains([Shift], "PM")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"DateKey", "Shift", "Calls", "AverageTimePerIssue", "Total Time"}),
    #"Sorted Ascending" = Table.Sort(#"Removed Other Columns", {{"Total Time", Order.Ascending}}),
	#"Total Calls" = List.Count(#"Sorted Ascending"[Total Time]),
	#"10th Shortest Call" = #"Sorted Ascending"[Total Time]{9},
	#"10th Longest Call" = #"Sorted Ascending"[Total Time]{#"Total Calls" - 10},
	#"Kept Longest Calls" = Table.SelectRows(
		#"Sorted Ascending", 
		each [Total Time] >= #"10th Longest Call" or [Total Time] <= #"10th Shortest Call"
	)
in
    #"Kept Longest Calls"