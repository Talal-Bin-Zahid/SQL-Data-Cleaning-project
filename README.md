🧹 SQL Data Cleaning Project (PostgreSQL)
👨‍💻 Author : Dr. Talal Bin Zahid

📅 Created on: 01-Nov-2025

🔗 Project Type: Exploratory Data Cleaning (SQL)

📘 Overview
This project demonstrates a complete data cleaning workflow using SQL (PostgreSQL).
The dataset used was sourced from Kaggle:
👉 Layoffs 2022 Dataset
The objective was to clean, standardize, and prepare global tech layoff data (2022–2023) for accurate and reliable analysis.
All operations were carried out using pure SQL, emphasizing data integrity, reproducibility, and best practices in SQL-based data cleaning.

🧩 Workflow Steps
1. Database & Table Setup
Created a dedicated PostgreSQL database for the project.
Defined the base table layoffs with appropriate schema.
Updated column data types for accuracy (e.g., funds_raised_millions → DECIMAL(10,2)).

2. Staging Table Creation
Created staging tables: layoffs_staging and layoffs_staging2 to preserve raw data integrity.
Added a row_num column using ROW_NUMBER() for duplicate identification.

3. Duplicate Handling
Detected duplicates using partitioning across all key attributes.
Deleted rows with row_num > 1, ensuring unique and accurate records.

4. Data Standardization
Trimmed extra spaces and unified inconsistent entries (industry, country, etc.).
Merged overlapping categories:
Example: "Crypto/Web3/Blockchain" → "Crypto".
Fixed inconsistent naming conventions:
"United States of America" → "United States".

5. Null & Blank Value Treatment
Replaced blank fields with NULL for consistency.
Updated missing industry values by joining with non-null records of the same company.
Removed records where both total_laid_off and percentage_laid_off were NULL.

6. Final Cleanup & Verification
Dropped helper columns (e.g., row_num).
Verified dataset consistency and integrity.
Ensured the cleaned dataset is fully analysis-ready.

🛠️ Tools & Technologies
Database: PostgreSQL
Language: SQL
Dataset Source: Kaggle
Focus Areas: Data Cleaning, Transformation, Deduplication, Standardization

📈 Key Learning Outcomes
Applying SQL techniques for real-world data cleaning challenges.
Managing missing values, duplicates, and inconsistent text data.
Building reproducible and efficient SQL-based EDA workflows.
