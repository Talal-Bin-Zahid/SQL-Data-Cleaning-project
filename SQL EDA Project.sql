-- EDA in SQL 

-- Here we are just going to explore the data and find insights from the data 

-- We are just going to look around and see what we find!

select * from layoffs_staging2 ;

-- Max. Employees laid off in 1 day 
select Max(total_laid_off)
from layoffs_staging2 ;

-- Max.  Employees laid off in 1 day in percentage terms 
select Max(percentage_laid_off)
from layoffs_staging2 ;

-- Data according to percentage laid off 
select * from layoffs_staging2 
where percentage_laid_off = '1'
order by  total_laid_off DESC ;

-- Employees by total_laid_off and percentage_laid_off 
select distinct company , total_laid_off , percentage_laid_off from layoffs_staging2 
where percentage_laid_off = '1'
and total_laid_off is not null
order by  total_laid_off DESC ;

-- Min. and Max. percentage laid off 
select Min(percentage_laid_off), Max(percentage_laid_off) from layoffs_staging2
where percentage_laid_off is not null ;

-- Companies where all the employees were laid off in a single day 
select * from layoffs_staging2 
where percentage_laid_off = '1'
order by company ;

-- we would order by funds_raised_millions to see the size of the companies
SELECT * FROM layoffs_staging2
WHERE  percentage_laid_off = '1'
and funds_raised_millions is not null
ORDER BY funds_raised_millions DESC;

-- Max. employees laid off in a single day 
SELECT company, total_laid_off FROM layoffs_staging
where total_laid_off is not null
ORDER BY total_laid_off DESC
LIMIT 5;

-- Total employees laid off by each company 
select company , Sum(total_laid_off) from layoffs_staging2
where total_laid_off is not null
group by company 
order by Sum(total_laid_off) DESC ;

-- Min. and Max. Date range 
select Min(date) , Max(date)
from layoffs_staging2 ;

-- Total employees laid off by industry 
select industry, Sum(total_laid_off) from layoffs_staging2
where total_laid_off is not null
group by industry
order by Sum(total_laid_off) DESC ;

-- Total employees laid off by location 
select location , sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by location
order by sum(total_laid_off) DESC ;

-- Total employees laid off by country 
select country , Sum(total_laid_off) from layoffs_staging2
where total_laid_off is not null
group by country 
order by Sum(total_laid_off) DESC ;

-- Total employees laid off by date 
select date , Sum(total_laid_off) from layoffs_staging2
where total_laid_off is not null
group by date 
order by Sum(total_laid_off) DESC ;

-- Total employees laid off by year 
SELECT EXTRACT(YEAR FROM date) as year, SUM(total_laid_off) FROM layoffs_staging2
WHERE  total_laid_off IS NOT NULL
GROUP BY year
ORDER BY year DESC;

-- Total employees laid off by stage of the company
select stage , Sum(total_laid_off) from layoffs_staging2
where total_laid_off is not null
group by stage
order by Sum(total_laid_off) DESC ;

-- Total employees laid off by each month :
SELECT TO_CHAR(date, 'YYYY-MM') AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE date IS NOT NULL
GROUP BY month
ORDER BY month ASC ;

-- Rolling total of laid off employees
With Rolling_total as 
(
SELECT TO_CHAR(date, 'YYYY-MM') AS month, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE date IS NOT NULL
GROUP BY month
ORDER BY month ASC 
)
Select Month , total_off , SUM(total_off) over (Order By Month ) as rolling_total
from Rolling_total ; 

-- Total employees laid off from each company on yearly basis 
select company , EXTRACT(YEAR FROM date) as year , Sum(total_laid_off)
from layoffs_staging2 
group by company , year 
order by company asc ;

-- Total employees laid off in 1 year 
select company , EXTRACT(YEAR FROM date) as year , Sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by company , year 
order by sum(total_laid_off) DESC;

-- Companies by ranking
With company_year (Company,years,total_laid_off ) as 
(
select company , EXTRACT(YEAR FROM date) as year , Sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by company , year 
)
select * , Dense_rank()  Over(Partition By years order by total_laid_off DESC) as ranking
from Company_year 
where years is not null 
order by ranking ASC ;

-- Top 5 companies according to ranking 
With company_year (Company,years,total_laid_off ) as 
(
select company , EXTRACT(YEAR FROM date) as year , Sum(total_laid_off)
from layoffs_staging2
where total_laid_off is not null
group by company , year 
) , Company_year_rank as
(select * , Dense_rank()  Over(Partition By years order by total_laid_off DESC) as ranking
from Company_year 
where years is not null 
)
select * from Company_year_rank
where ranking <= 5 ;





