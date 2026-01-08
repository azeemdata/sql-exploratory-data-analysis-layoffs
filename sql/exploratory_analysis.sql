/* =========================================================
   SQL EXPLORATORY DATA ANALYSIS – GLOBAL LAYOFFS DATASET
   Author: Azeem
   Input Table: layoffs_staging2 (cleaned data)
   Purpose: Identify trends, patterns, and insights
   ========================================================= */

-- Preview cleaned dataset
SELECT *
FROM layoffs_staging2;


/* =========================================================
   1) OVERVIEW STATISTICS
   ========================================================= */

-- Total number of records
SELECT COUNT(*) AS total_rows
FROM layoffs_staging2;

-- Total number of unique companies
SELECT COUNT(DISTINCT company) AS unique_companies
FROM layoffs_staging2;

-- Date range of the dataset
SELECT 
  MIN(`date`) AS start_date,
  MAX(`date`) AS end_date
FROM layoffs_staging2;


/* =========================================================
   2) COMPANY-LEVEL ANALYSIS
   ========================================================= */

-- Companies with the highest total layoffs
SELECT 
  company,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;


/* =========================================================
   3) INDUSTRY-LEVEL ANALYSIS
   ========================================================= */

-- Industries most affected by layoffs
SELECT 
  industry,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;


/* =========================================================
   4) COUNTRY-LEVEL ANALYSIS
   ========================================================= */

-- Layoffs by country
SELECT 
  country,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;


/* =========================================================
   5) PERCENTAGE LAID OFF ANALYSIS
   ========================================================= */

-- Companies with the highest percentage of workforce laid off
SELECT 
  company,
  industry,
  MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
GROUP BY company, industry
ORDER BY max_percentage_laid_off DESC
LIMIT 10;


/* =========================================================
   6) FUNDING VS LAYOFFS
   ========================================================= */

-- Relationship between funding raised and layoffs
SELECT 
  company,
  SUM(funds_raised_millions) AS total_funds_raised_millions,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
HAVING total_funds_raised_millions > 0
ORDER BY total_laid_off DESC;


/* =========================================================
   7) COMPANY STAGE VS LAYOFFS
   ========================================================= */

-- Layoffs by company stage
SELECT 
  stage,
  SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;


/* =========================================================
   8) YEAR-ON-YEAR COMPARISON (2022 vs 2023)
   ========================================================= */

-- Compare layoffs by industry across years
WITH layoffs_by_year AS (
    SELECT 
      industry,
      YEAR(`date`) AS yr,
      SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY industry, YEAR(`date`)
)
SELECT 
  industry,
  SUM(CASE WHEN yr = 2022 THEN total_laid_off END) AS layoffs_2022,
  SUM(CASE WHEN yr = 2023 THEN total_laid_off END) AS layoffs_2023
FROM layoffs_by_year
GROUP BY industry
ORDER BY layoffs_2023 DESC;
