// M Code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data],
    #"Extract Modulo" = Table.AddColumn(Fact_Order, "Modulo", each  Number.Mod(Text.Length([Description]), 10), Int64.Type),
    #"Filter Modulo = 1" = Table.SelectRows(#"Extract Modulo", each ([Modulo] = 1)),
    #"Removed Other Columns" = Table.SelectColumns(#"Filter Modulo = 1",{"Order Key", "Description"})
in
    #"Removed Other Columns"
