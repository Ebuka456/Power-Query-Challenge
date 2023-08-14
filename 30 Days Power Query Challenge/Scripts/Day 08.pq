// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data],
    #"Filtered End of Month Only" = Table.SelectRows(Fact_Sale, each [Invoice Date Key] = Date.EndOfMonth([Invoice Date Key])),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered End of Month Only",{"Sale Key", "Customer Key", 
                                "Invoice Date Key", "Total Excluding Tax", "Tax Amount", "Profit"})
in
    #"Removed Other Columns"