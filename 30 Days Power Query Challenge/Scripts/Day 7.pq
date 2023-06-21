// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    ColumnsToRemove = List.Select(Table.ColumnNames(dbo_DimEmployee), each Text.Contains(Text.Lower(_), "key")),
    RemovedColumns = Table.RemoveColumns(dbo_DimEmployee, ColumnsToRemove)
in
    RemovedColumns
