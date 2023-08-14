let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],

    // Getting the DimEmployee table and getting only selected columns
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data]
            [[EmployeeKey], [FirstName], [MiddleName], [LastName]],
            
       // Function to check if the first letter is in the desired letters
    checkSecondLetter = (text) => List.Contains({"A", "B", "C", "D", "E"}, Text.Range(text, 0, 1), Comparer.Ordinal),

    // Add a new column to indicate if the first letter is in the desired letters
    filteredColumn = Table.AddColumn(dbo_DimEmployee, "Filtered", each checkSecondLetter([LastName])),

    // To filter out rows that starts with the letters specified
    #"Filtered Rows" = Table.SelectRows(filteredColumn, each ([Filtered] = false)),

    // Removing the filter column
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",
            {"EmployeeKey", "FirstName", "MiddleName", "LastName"})
in
    #"Removed Other Columns"