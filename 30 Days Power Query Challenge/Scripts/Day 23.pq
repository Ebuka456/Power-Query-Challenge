let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data],
    #"Expanded Dimension.Customer(Customer Key)" = Table.ExpandRecordColumn(Fact_Sale, 
                "Dimension.Customer(Customer Key)", {"Bill To Customer"}, {"Bill To Customer"}),
    #"Added Conditional Column" = Table.AddColumn(#"Expanded Dimension.Customer(Customer Key)", "Order", each if [Bill To Customer] = "N/A" then 2 else 1),
    #"Sorted Rows" = Table.Sort(#"Added Conditional Column",{{"Order", Order.Ascending}, {"Bill To Customer", Order.Ascending}}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Sorted Rows",{"Sale Key", "Salesperson Key", "Description", "Bill To Customer"})
in
    #"Removed Other Columns1"