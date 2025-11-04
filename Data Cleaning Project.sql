-- SQL Data Cleaning Project
-- Dataset : https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- First of all , we would create a new database for this project .
-- We are executing the entire project in Postgresql .
-- Create a table to add data in it .

CREATE TABLE layoffs(
 company text,
 location text,
 industry text,
 total_laid_off INT,
 percentage_laid_off text,
 date text,
 stage text,
 country text,
 funds_raised_millions int);

-- Faced a error in importing the data due to datatype difference
-- Changing the data type of specific column 

 alter table layoffs 
 alter column funds_raised_millions Type Decimal(10,2) ;

 select * from layoffs ;

 -- Steps of Data Cleaning :
 -- 1. Remove Duplicates
 -- 2. Standardize the Data 
 -- 3. Null Values or blank values 
 -- 4. Remove any columns or rows

 -- 1. Remove Duplicates 
 -- Before starting the cleaning process , we would create a staging table .
 -- The data in layoffs table would be sent to staging table to preserve the original table . 

Create table layoffs_staging 
AS Table layoffs ;

select * from layoffs_staging;
select * from layoffs ;

-- You have to select all the columns in queries to identify real duplicates :
select * , Row_number() Over(Partition By company , location ,industry , total_laid_off
            , percentage_laid_off, date , stage , country, funds_raised_millions) as row_num
from layoffs_staging ;

-- Extracting out row_names greater than 1 : 
select * from (select * , Row_number() Over(Partition By company , location ,industry , total_laid_off
            , percentage_laid_off, date , stage , country, funds_raised_millions) as row_num
from layoffs_staging ) duplicates
where row_num > 1 ;

-- cross-checking the duplicate values :
select * from layoffs_staging 
where company = 'Hibob' ;

-- Now , we have to delete those values wher row_num is greater than 1 . 
-- For that purpose , we would create another table where we add a row_num column .

CREATE TABLE layoffs_staging2(
 company text,
 location text,
 industry text,
 total_laid_off INT,
 percentage_laid_off text,
 date text,
 stage text,
 country text,
 funds_raised_millions Decimal(10,2),
 row_num Int);

-- insert data into the new table from layoffs_staging table .
insert into layoffs_staging2
select * , Row_number() Over(Partition By company , location ,industry , total_laid_off
            , percentage_laid_off, date , stage , country, funds_raised_millions) as row_num
from layoffs_staging ;

select * from layoffs_staging2
where row_num > 1 ;

-- Deleting the duplicates 
 delete from layoffs_staging2
 where row_num > 1 ;

 -- Standardizing the Data :
 -- Finding the issues in data and then fixing it 

 select * from layoffs_staging2 ;

-- You should also run TRIM function in order to remove the blank spaces if present there.
-- But in our case , this is not the issue .

-- By generally observing the data , we see there are null or blank values in industry column .
-- We have to dive deep and resolve this issue .

-- We will look into each column individually and rectify the issues
select distinct company from layoffs_staging2 
order by company ;

select distinct location  from layoffs_staging2 
order by location ;

select distinct industry from layoffs_staging2 
order by industry ;

select * from layoffs_staging2 
where industry is null or industry = '' 
order by industry ; 

-- There are 4 companies that have null or blank industry column.

select * from layoffs_staging2 
where company like 'Bally%' ;

-- Bally's Interaction has a null value , not a blank column.

select * from layoffs_staging2 t1
join layoffs_staging2 t2 on t1.company = t2.company 
where (t1.industry is null or t1.industry = '')
and t2.industry is not null ;

select * from layoffs_staging2 
where company like 'Airbnb%' ;

select * from layoffs_staging2 
where company like 'Carvana%' ;

select * from layoffs_staging2 
where company like 'Juul%' ;

-- Airbnb, Carvana, Juul are travel , transportation and consumer companies respectively .
-- But their they have unpopulated rows .
-- Write a query that if there is another row with the same company name.
-- It will update it to the non-null industry values .
-- Makes it easy so if there were thousands we wouldn't have to manually check them all.

-- We would set the blank values to null to prevent any error in query .

Update layoffs_staging2
set industry = Null 
where industry = '' ;

-- Now, we would populate those null values .

UPDATE layoffs_staging2 t1
SET industry = t2.industry
FROM layoffs_staging2 t2
WHERE t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Finally , checking the results 

select * from layoffs_staging2 
where industry = 'Null'
or industry = '' ;

-- We have 3 crypto related industries with slight different names .
-- We have to standardize them on one format .

select * from layoffs_staging2
where industry Like 'Crypto%' ;

update layoffs_staging2 
Set industry = 'Crypto'
where industry like 'Crypto%' ;

select distinct total_laid_off from layoffs_staging2 
order by total_laid_off ;

select distinct percentage_laid_off from layoffs_staging2
order by percentage_laid_off ;

select distinct date from layoffs_staging2 
order by date ;

select distinct stage from layoffs_staging2 
order by stage ;

select distinct country from layoffs_staging2 
order by country ;

-- We see that there are 2 entries related to US with slight difference in name .
-- We would standardize it .

select * from layoffs_staging2 
where country like 'United States%' ;

update layoffs_staging2 
set country = 'United States'
where country like 'United States%' ;

-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. 
-- I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values

-- 4. Remove any columns or rows if required 

-- The values in total_laid_off and percentage_laid_off  are very important.
-- If the values in these columns are null then they are of no use .
-- So, we would remove the rows in which the values are null in these three columns .


SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

-- Delete the useless null values present in both the columns
Delete from layoffs_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

-- Now , we would delete the row_num column that was created previously to detect the duplicates .

alter table layoffs_staging2 
drop column row_num ;

select * from layoffs_staging2 ;

-- SQL Data Cleaning project is successfully completed.
