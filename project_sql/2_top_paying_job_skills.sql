/*
Question: What skills do the top-paying remote Software Engineer jobs require?

What this query does:
- Step 1 (CTE): finds the 10 highest-paying remote Software Engineer
  postings that list a salary (same logic as the previous query)
- Step 2: joins those 10 jobs to skills_job_dim and skills_dim to list
  every skill required by each job
- Returns one row per job-skill pair, sorted by salary, highest first

Why: shows which skills are tied to the best-paying remote roles, which
helps decide what to learn or highlight on a resume.
*/

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title AS title,
        name AS company_name, 
        salary_year_avg 
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
    LIMIT 10

)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC;
