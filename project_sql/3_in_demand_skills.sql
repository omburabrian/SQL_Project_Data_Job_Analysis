/*
Question: What are the most in-demand skills for remote Software Engineers?

What this query does:
- Looks at job postings with the short title 'Software Engineer'
- Keeps only remote postings (job_work_from_home = TRUE)
- Joins to skills_job_dim and skills_dim to get the skills listed in each posting
- Counts how many postings mention each skill
- Returns the top 5 skills by posting count, highest first

Why: shows which skills employers ask for most often in remote
software engineering roles, to help prioritize what to learn.
*/

SELECT
    
    skills,
    COUNT(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Software Engineer' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
