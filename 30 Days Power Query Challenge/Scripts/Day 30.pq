let
    Source = Sql.Databases("DESKTOP-TTT07HN"),

    // Connecting to the AdventureWorks Database
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],

    // Importing the DimProduction table
    dbo_DimPromotion = AdventureWorksDW2017{[Schema="dbo",Item="DimPromotion"]}[Data],
    
    // Inserting a space in the column names
    UpdatedColumnNames = Table.TransformColumnNames(dbo_DimPromotion, each Text.Combine(
                Splitter.SplitTextByCharacterTransition({"a".."z"}, {"A".."Z"})(_), " "))
    
in
    UpdatedColumnNames