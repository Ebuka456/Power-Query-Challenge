let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_FactResellerSales = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data][[ProductKey], [SalesOrderNumber],
                            [ShipDate], [SalesAmount]],
    #"Changed Type" = Table.TransformColumnTypes(dbo_FactResellerSales,{{"ShipDate", type date}}),
    #"Previous 10 Years" = Table.SelectRows(#"Changed Type", each Date.IsInPreviousNYears([ShipDate], 10))
in
    #"Previous 10 Years"