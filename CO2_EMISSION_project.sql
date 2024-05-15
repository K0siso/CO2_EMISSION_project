-- I WANT TO PERFORM EDA

-- 1. Look at the dataset
Select *
From co2_emission;

-- 2. Create data copy
Create Table emission_copy
Like co2_emission;

Select *
From emission_copy;

Insert emission_copy
Select *
From co2_emission;

-- 3. Find and remove duplicates
	-- First, I create a row number to find unique rows.
Select *,
Row_number() Over(Partition By `CO2 emission estimates`, `Year`, Series, `Value`) as row_num
From emission_copy;

-- Create cte for complex query (To find where row_num > 1 i.e not unique)
With emission_cte as (
Select *,
Row_number() Over(Partition By `CO2 emission estimates`, `Year`, Series, `Value`) as row_num
From emission_copy)
Select *
From emission_cte
Where row_num > 1;
	-- returned none, meaning; no duplicates

-- 4. Check if columns have NULL values
Select *
From emission_copy
Where `Value` is NULL;

-- The data seems to be good already for EDA

-- 5. Let's begin EDA
Select *
From emission_copy;

-- I want to change the column name for simplicity
Alter Table emission_copy
Change `CO2 emission estimates` Country Varchar(255);

-- Finding the Min and Max for emission per cap in America.
Select Country, Min(`Value`), Max(`Value`)
From emission_copy
Where Country Like "United States%"
And Series = "Emissions per capita (metric tons of carbon dioxide)"
Group By Country;

-- Knowing the year of Max and Min emission in America
Select `Year`
From emission_copy
Where Country = "United States of America"
And `Value` In (20.168, 14.606);

-- To know the changes of emission per cap between 1975 and 2017
With value1975 as (
Select Country, `Value` as old_value
From emission_copy
Where Series = "Emissions per capita (metric tons of carbon dioxide)"
And `Year` = 1975),
value2017 as (
Select Country, `Value` as new_value
From emission_copy
Where Series = "Emissions per capita (metric tons of carbon dioxide)"
And `Year` = 2017)
Select Distinct value1975.Country, Round((value2017.new_value - value1975.old_value)/value1975.old_value,2)*100 as changes
From value1975
Join value2017 On value1975.Country = value2017.Country
Order By 2 Desc;

Select Country, Min(`Value`), Max(`Value`)
From emission_copy
Where Series = "Emissions per capita (metric tons of carbon dioxide)"
Group By Country;

-- Find the overall lowest and highest emission
Select Min(`Value`), Max(`Value`)
From emission_copy
Where Series = "Emissions per capita (metric tons of carbon dioxide)";

-- What Country had that amount of emission and what year?
Select Country, `Year`
From emission_copy
Where Series = "Emissions per capita (metric tons of carbon dioxide)"
And `Value`= 38.395;

-- 6. EDA on Emissions
Select Country, Min(`Value`), Max(`Value`), `Year`
From emission_copy
Where Series = "Emissions (thousand metric tons of carbon dioxide)"
And Country = "Nigeria"
Group By Country, `Year`;

-- Top 5 countries with highest emission
Select Country, Sum(`Value`) as total_value
From emission_copy
Where Series = "Emissions (thousand metric tons of carbon dioxide)"
Group By Country
Order By total_value Desc
Limit 5;