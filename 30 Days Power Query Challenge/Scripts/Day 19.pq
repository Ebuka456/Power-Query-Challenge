let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    #"FactResellerSales" = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data][[SalesOrderNumber], 
                        [OrderDate], [ResellerKey], [EmployeeKey]],
    #"Added Unix Timestamp" = Table.AddColumn(FactResellerSales, "UnixTimestamp", each Duration.TotalSeconds([OrderDate]- 
                        #datetime(1970,1,1,0,0,0)))
in
    #"Added Unix Timestamp"