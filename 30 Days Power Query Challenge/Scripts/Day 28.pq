let
    Source = Sql.Databases("DESKTOP-TTT07HN"),
    // Selecting the AdventureWorks Database
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    // Using the DimProduct Table and selecting the columns of choice
    dbo_DimProduct = AdventureWorksDW2017{[Schema="dbo",Item="DimProduct"]}[Data][[ProductKey], [ProductAlternateKey], 
                [EnglishProductName], [DealerPrice]],
    // Excluding Null Values in DealerPrice Column
    #"Filtered Rows" = Table.SelectRows(dbo_DimProduct, each ([DealerPrice] <> null)),
    // Calculating the total sum of the DealerPrice
    #"Calculated Sum" = List.Sum(#"Filtered Rows"[DealerPrice]),
    // Calculating the Percent of Total for each row
    #"Inserted Percent Of" = Table.AddColumn(#"Filtered Rows", "OverallPercentage", each [DealerPrice] / #"Calculated Sum" * 100, 
                type number)
in
    #"Inserted Percent Of"