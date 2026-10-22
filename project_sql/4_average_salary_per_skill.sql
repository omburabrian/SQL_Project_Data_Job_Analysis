/*
Question: Which skills are associated with the highest salaries for
Software Engineers?

What this query does:
- Looks at Software Engineer postings that list a yearly salary
- Includes all locations (no remote filter)
- Joins to skills_job_dim and skills_dim to get the skills in each posting
- Averages the yearly salary of the postings that mention each skill
- Returns every skill, sorted by average salary, highest first

Why: shows which skills are linked to higher pay, to help decide which
skills are worth learning. A skill with only a few postings can rank high
by chance, so read the results alongside how often each skill appears.
*/


SELECT
    
    skills,
    ROUND(AVG(salary_year_avg),2) AS average_salary_usd
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Software Engineer' 
    AND
    salary_year_avg is NOT NULL
GROUP BY 
        skills
ORDER BY
    average_salary_usd DESC;

