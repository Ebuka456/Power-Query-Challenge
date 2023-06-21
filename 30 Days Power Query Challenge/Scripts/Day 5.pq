// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns
            (Dimension_Employee,
                {"Employee Key", "Employee", "Is Salesperson", "Valid From", "Valid To"}
            ),
    #"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each (
        // first filter condition
        [Is Salesperson] = true and Date.Year([Valid To]) <> 9999 and Duration.TotalDays([Valid To] - [Valid From]) > 365) 
        or (
            // second filter condition
            [Is Salesperson] = false and Date.Year([Valid To]) = 9999)
            )
in
    #"Filtered Rows"
