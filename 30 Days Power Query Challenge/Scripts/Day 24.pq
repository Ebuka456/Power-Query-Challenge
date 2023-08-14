let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    #"Dimension_Transaction Type" = WideWorldImportersDW{[Schema="Dimension",Item="Transaction Type"]}
                    [Data][[Transaction Type Key], [Transaction Type]],
    columnToFilter = #"Dimension_Transaction Type"[Transaction Type],
       // Function to check if the second letter is in the desired letters
    checkSecondLetter = (text) => List.Contains({"a", "e", "i", "o", "u", "y", "w"}, Text.Range(text, 1, 1), Comparer.Ordinal),

    // Add a new column to indicate if the second letter is in the desired letters
    filteredColumn = Table.AddColumn(#"Dimension_Transaction Type", "Filtered", each checkSecondLetter([Transaction Type])),

    // Filter the table to keep only the rows where the condition is true
    filteredTable = Table.SelectRows(filteredColumn, each [Filtered] = true),
    #"Removed Other Columns" = Table.SelectColumns(filteredTable,{"Transaction Type Key", "Transaction Type"})
in
    #"Removed Other Columns"