-- let's see the data 
select * 
from [2003_2017_waste]
ORDER BY [Year];

select * 
from [2018_2020_waste]
ORDER BY [Year];

-- DATA HANDLING 

-- deleted the row 1 as it contains the column names
DELETE FROM [2018_2020_waste]       
WHERE "Waste Type" = 'Waste Type';

-- Deleting unnecessary rows from both the tables
DELETE FROM [2018_2020_waste]       
WHERE "Waste Type" = 'Overall';   -- 3 rows deleted from 45 rows

DELETE FROM [2003_2017_waste]       
WHERE "waste_type" = 'Total';     --15 rows deleted from 225 rows

-- Creating new table of 2018_2020_waste data same as 2003_2017_waste to make both consistent .

--Converted data types of columns [Total Generated ('000 tonnes)] , [Total Recycled ('000 tonnes)] form varchar(50) 
--to int so that we can do calculations on these columns

--Created custom columns (waste_disposed_of_tonne) and (recycling_rate) by performing calculation on the columns 
--[Total Generated ('000 tonnes)] and [Total Recycled ('000 tonnes)].

SELECT 
    [Waste Type] AS waste_type,
    
    -- Convert from '000 tonnes to tonnes (multiply by 1000)
    (TRY_CAST(REPLACE([Total Generated ('000 tonnes)], ',', '') AS FLOAT) * 1000) AS total_waste_generated_tonne,
    (TRY_CAST(REPLACE([Total Recycled ('000 tonnes)], ',', '') AS FLOAT) * 1000) AS total_waste_recycled_tonne,
    
    -- Calculate disposed and recycling rate
    ((TRY_CAST(REPLACE([Total Generated ('000 tonnes)], ',', '') AS FLOAT) 
      - TRY_CAST(REPLACE([Total Recycled ('000 tonnes)], ',', '') AS FLOAT)) * 1000) AS waste_disposed_of_tonne,
    
    -- Recycling rate
    TRY_CAST(REPLACE([Total Recycled ('000 tonnes)], ',', '') AS FLOAT) 
      / NULLIF(TRY_CAST(REPLACE([Total Generated ('000 tonnes)], ',', '') AS FLOAT), 0) AS recycling_rate,
    
    [Year] AS year
INTO [2018_2020_waste_aligned]
FROM [2018_2020_waste];

--view of newly created table 
select * from [2018_2020_waste_aligned]


-- Combine 2003-2017 and 2018-2020 waste data into one table so that we can work efficiently
-- Joining table using UNION ALL.
-- Combine tables chronologically into one table
SELECT *
INTO [Waste_2003_2020]
FROM
(
    SELECT * FROM [2003_2017_waste]
    UNION ALL
    SELECT * FROM [2018_2020_waste_aligned]
) AS Combined
ORDER BY [Year];

--let's see the combined table
SELECT * 
FROM [Waste_2003_2020]
ORDER BY [Year];
