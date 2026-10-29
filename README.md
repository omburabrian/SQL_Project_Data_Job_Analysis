# Introduction

This project explores the top paying jobs, in-demand skills and where demand meets high salary for Software Engineering roles. The project uses SQL qto dig and find those jobs and skills. Chekout the SQL queries here: [project_sql folder](/project_sql/)

# Background

I wanted to learn the job market for remote Software Engineers more strategically: where the best pay is, which skills employers ask for most, and which skills are worth the time to learn. Through sql queries, I wanted to answer these questions:

### Questions

1. What are the top-paying remote Software Engineer jobs?
2. What skills do those top-paying jobs require?
3. What skills are most in demand for remote Software Engineers?
4. Which skills are associated with the highest salaries?
5. What are the optimal skills to learn (high demand and high salary)?

# Tools I Used

- **SQL:** The core of the analysis, used to query the data and answer each question.
- **PostgreSQL:** The database management system that stores the job posting data.
- **Visual Studio Code:** My editor for writing and running queries.
- **Git & GitHub:** Version control and sharing the project and analysis, ensuring collaboration and project tracking.

# The Analysis

Each query targets one question about the remote Software Engineer job market.

### 1. Top-Paying Remote Software Engineer Jobs

To find the highest-paying roles, I filtered Software Engineer postings by remote location and listed salary, then kept the top 10
Code

```sql
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
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Software Engineer' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

What the top 10 show:

Salary range: $182,500 to $225,000, with a median of $200,000 and a mean of about $197,800.
Top posting: Senior Software Engineer at Datavant, at $225,000.
Employers: MongoDB has two roles in the top 10, alongside Huckleberry Labs, SmarterDx, Orbis, Webflow, Pulley, ConsenSys, and Robert Half.
Seniority: most of the highest-paying titles are Senior, Staff, or Director level.

### 2. Skills for Top-Paying Jobs

To see which skills these roles require, I put the query above in a CTE and joined it to the skills tables.

```sql
WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title AS title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
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
```

Here is the breakdown fo the most demanded skills for the top 10 Software Engineering jobs

# Conclusions
