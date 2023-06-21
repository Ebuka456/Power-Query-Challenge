// M code 

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(Dimension_Employee,{"WWI Employee ID", "Employee"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns", {"Employee"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Duplicates",{{"Employee", "Teammate"}}),
    #"Subtracted from Column" = Table.TransformColumns(#"Renamed Columns", {{"WWI Employee ID", each _ - 1, type number}}),
    #"Merged Queries" = Table.Join(#"Removed Duplicates", {"WWI Employee ID"}, #"Subtracted from Column", {"WWI Employee ID"}, JoinKind.Inner),
    #"Filtered Rows" = Table.SelectRows(#"Merged Queries", each (Number.Mod([WWI Employee ID], 2) = 0))
in
    #"Filtered Rows"