// M code 

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    #"Expanded Fact.Order(Employee Key)" = Table.ExpandTableColumn(Dimension_Employee, 
                                            "Fact.Order(Employee Key)", {"Dimension.Customer"}, {"Dimension.Customer"}),
    #"Expanded Dimension.Customer" = Table.ExpandRecordColumn(#"Expanded Fact.Order(Employee Key)", 
                                    "Dimension.Customer", {"Primary Contact"}, {"Primary Contact"}),
    #"Filtered Rows" = Table.SelectRows(#"Expanded Dimension.Customer", each true),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Employee", "Primary Contact"}),
    #"Merged Columns" = Table.CombineColumns(#"Removed Other Columns",{"Employee", "Primary Contact"},
                        Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"Full Name"),
    #"Removed Duplicates" = Table.Distinct(#"Merged Columns"),
    #"Sorted Rows" = Table.Sort(#"Removed Duplicates",{{"Full Name", Order.Ascending}})
in
    #"Sorted Rows"