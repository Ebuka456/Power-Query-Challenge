let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data][[Order Key], [Description], [Quantity]],
    #"Filtered Rows" = Table.SelectRows(Fact_Order, each true),
    #"Added Conditional Column" = Table.AddColumn(#"Filtered Rows", "Category", each if [Quantity] < 100 then "Less than 100" 
                    else if [Quantity] >= 100 and [Quantity] <= 250  then "Between 100 and 250" else "More than 250")
in
    #"Added Conditional Column"