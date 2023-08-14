let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimCustomer = AdventureWorksDW2017{[Schema="dbo",Item="DimCustomer"]}[Data],
    #"Calculated Day of Week" = Table.TransformColumns(dbo_DimCustomer,{{"BirthDate", Date.DayOfWeek, Int64.Type}}),
    #"Filtered Rows" = Table.SelectRows(#"Calculated Day of Week", each ([BirthDate] <> 0 and [BirthDate] <> 6)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"CustomerKey", "EmailAddress", "YearlyIncome", "EnglishOccupation"})
in
    #"Removed Other Columns"