// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimCustomer = AdventureWorksDW2017{[Schema="dbo",Item="DimCustomer"]}[Data],
    #"Expanded FactInternetSales" = Table.ExpandTableColumn(dbo_DimCustomer, 
                                "FactInternetSales", 
                                {"OrderQuantity"}, {"OrderQuantity"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Expanded FactInternetSales",
                                {"Gender", "EnglishEducation", "CommuteDistance", "OrderQuantity"}),
    #"Pivoted Column" = Table.Pivot(#"Removed Other Columns", List.Distinct(#"Removed Other Columns"[CommuteDistance]), 
                                "CommuteDistance", "OrderQuantity", List.Sum),
    #"Reordered Columns" = Table.ReorderColumns(#"Pivoted Column",
                                {"Gender", "EnglishEducation", "0-1 Miles", "1-2 Miles", "2-5 Miles", "5-10 Miles", "10+ Miles"}),
    #"Added Conditional Column" = Table.AddColumn(#"Reordered Columns", "EducationSort", 
                                each if [EnglishEducation] = "Partial High School" then 1 else 
                                if [EnglishEducation] = "High School" then 2 else 
                                if [EnglishEducation] = "Partial College" then 3 else 
                                if [EnglishEducation] = "Bachelors" then 4 else 
                                if [EnglishEducation] = "Graduate Degree" then 5 
                                else null),
    #"Sorted Rows" = Table.Sort(#"Added Conditional Column",{
                                {"EducationSort", Order.Ascending}, {"Gender", Order.Ascending}}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Sorted Rows",
                                {"Gender", "EnglishEducation", "0-1 Miles", "1-2 Miles", "2-5 Miles", "5-10 Miles", "10+ Miles"})
in
    #"Removed Other Columns1"