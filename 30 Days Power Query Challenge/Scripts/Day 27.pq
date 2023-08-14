let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimCurrency = AdventureWorksDW2017{[Schema="dbo",Item="DimCurrency"]}[Data]
                [[CurrencyKey],[CurrencyAlternateKey], [CurrencyName]],
      // Extract country names with two 'e' into a list
    #"Select Multiple e's" = List.Transform(
		dbo_DimCurrency[CurrencyName], 
		each {_, List.Count(List.Select(Text.ToList(_), each _ = "e")) > 1}
	),
	// 
	#"List of Currency" = List.Transform(
		List.Select(#"Select Multiple e's", each _{1} = true), 
		each _{0}
	),
	#"Filtered Rows" = Table.SelectRows(
		dbo_DimCurrency, 
		each List.Contains(#"List of Currency", [CurrencyName])
	)
in
    #"Filtered Rows"