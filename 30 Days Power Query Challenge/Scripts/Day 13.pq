// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee,{"BirthDate", "EmailAddress", "Gender"}),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each [BirthDate] >= #date(1990, 1, 1) and 
                        [BirthDate] <= #date(1990, 12, 31))
in
    #"Filtered Rows"