let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_Supplier = WideWorldImportersDW{[Schema="Dimension",Item="Supplier"]}[Data],
    #"Expanded Fact.Transaction" = Table.ExpandTableColumn(Dimension_Supplier, 
                "Fact.Transaction", {"Is Finalized"}, {"Is Finalized"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Fact.Transaction", 
                each ([Supplier] <> "Unknown") and ([Is Finalized] = false)),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Filtered Rows", 
                {{"Supplier Key", type text}}, "en-US"),{"Supplier Key", "Supplier Reference"},Combiner.CombineTextByDelimiter("-", QuoteStyle.None),"Supplier Key Preference"),
    #"Removed Other Columns" = Table.SelectColumns(#"Merged Columns",
            {"Supplier Key Preference", "Supplier", "Category", "Primary Contact"})
in
    #"Removed Other Columns"