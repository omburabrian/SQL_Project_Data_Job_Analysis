/*
Question: What are the optimal skills for a remote Software Engineer to learn?
(Optimal = high demand AND high salary)

What this query does:
- CTE 1 (skills_demand): counts how many remote Software Engineer postings
  with a listed salary mention each skill
- CTE 2 (average_salary): averages the yearly salary of Software Engineer
  postings with a listed salary for each skill, in all locations
  (there is no remote filter in this CTE)
- Final SELECT: joins the two on skill_id so each skill shows its demand
  count next to its average salary
- Sorts by demand count first, then by salary, and returns the top 40 rows

Why: demand alone favors common skills, and salary alone can favor
rare ones. Seeing both side by side helps pick skills worth learning.

Note: demand describes remote jobs only, while average salary covers all
locations, so the two columns are based on different sets of postings.
*/

-- CTE 1
WITH skills_demand AS( 
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Software Engineer' 
        AND job_work_from_home = TRUE
        AND salary_year_avg is NOT NULL
    GROUP BY 
        skills_dim.skill_id
      
), 
-- CTE 2
average_salary AS( 
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS average_salary_usd
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Software Engineer' 
        AND
        salary_year_avg is NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
    
)
-- combine
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary_usd
FROM 
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC,
    average_salary_usd DESC
LIMIT 40;
