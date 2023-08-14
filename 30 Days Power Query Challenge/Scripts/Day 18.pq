Day 18

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_City = WideWorldImportersDW{[Schema="Dimension",Item="City"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(Dimension_City,{"City Key", "City", "State Province", "Sales Territory"}),
    All_Cities_List = List.Transform(Dimension_City[City], each Text.ToList(_)),
	Name_Locator = List.Select(
		All_Cities_List, 
		each List.ContainsAll(_, {"A", "d", "C"}, Comparer.Ordinal)
	),
	Matching_Cities = List.Distinct(List.Transform(Name_Locator, each Text.Combine(_, ""))),
	Filter_Cities = Table.SelectRows(#"Removed Other Columns", each List.Contains(Matching_Cities, [City]))
in
    Filter_Cities