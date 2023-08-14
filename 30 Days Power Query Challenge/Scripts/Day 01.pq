// M code

let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorks2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    DimEmployee = AdventureWorks2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Filtered Rows" = Table.SelectRows(DimEmployee, each [BirthDate] >= #date(1974, 1, 1) and [BirthDate] <= #date(1974, 12, 31)),
    #"Added Custom" = Table.AddColumn(#"Filtered Rows", "FullName", each [FirstName] & (if [MiddleName] <> null then " " & [MiddleName] 
                        & " " else " " ) & [LastName]),
    #"Removed Other Columns" = Table.SelectColumns(#"Added Custom",{"EmployeeKey", "BirthDate", "Gender", "FullName"})
in
    #"Removed Other Columns"