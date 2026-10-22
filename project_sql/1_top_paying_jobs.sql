/*
Question: What are the top-paying remote Software Engineer jobs?

What this query does:
- Pulls job postings with the short title 'Software Engineer'
- Keeps only remote roles (job_location = 'Anywhere')
- Excludes postings with no listed salary (salary_year_avg IS NOT NULL)
- Joins company_dim to show the company name for each posting
- Sorts by average yearly salary, highest first, and returns the top 10

Why: shows which companies and roles offer the best pay for remote
software engineering work, and gives a starting point for the next
analysis (which skills those high-paying roles require).
*/

-- SQL
SELECT
    job_id,
    job_title AS title,
    name AS company_name, 
    job_location AS location,
    job_schedule_type as schedule,
    salary_year_avg, 
    job_posted_date
FROM
    job_postings_fact
-- join the company_dim table to get company name
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id 
WHERE
    job_title_short = 'Software Engineer' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

