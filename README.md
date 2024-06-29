# Introduction
Dive into the data job market focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and their intersections.

# Background
Data hails from [SQL Course] (https://lukebarousse.com/sql).

### The questions answered through SQL queries:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used

- **SQL**: allowing me to query the database
- **PostgreSQL**: The chosen database management system.
- **Visual Studio Code**: allowing me to execute SQL queries.

# The Analysis
Each query in this project investigated specific aspects of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
This query retrieves the top-paying data analyst jobs by querying the `job_postings_fact` table joined with `company_dim` to fetch details such as job title, location, salary, and company name. It uses JOIN for combining tables, ORDER BY to sort by salary, and LIMIT to restrict results.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND (
        job_location = 'Tel Aviv-Yafo, Israel'
        OR job_location = 'Anywhere'
    )
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### 2. Top Skills for Top Data Paying Jobs
This query identifies the skills required for top-paying data analyst jobs. It utilizes subqueries (CTE `jobs_with_skills`) to filter jobs that have associated skills, then joins with `skills_job_dim` and `skills_dim` to list these skills. SQL tools such as DISTINCT ensure unique job IDs are considered, and LIMIT restricts results to the top 100 paying jobs.

```sql
WITH jobs_with_skills AS (
    SELECT DISTINCT job_postings_fact.job_id
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
),
top_100_paying_jobs AS (
    SELECT job_postings_fact.job_id
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    INNER JOIN jobs_with_skills ON job_postings_fact.job_id = jobs_with_skills.job_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND (
            job_location = 'Tel Aviv-Yafo, Israel'
            OR job_location = 'Anywhere'
        )
    ORDER BY
        salary_year_avg DESC
    LIMIT 100
)
SELECT 
    skills_dim.skills AS top_skill,
    COUNT(skills_job_dim.job_id) AS job_count
FROM skills_job_dim
INNER JOIN top_100_paying_jobs ON skills_job_dim.job_id = top_100_paying_jobs.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    job_count DESC
LIMIT 5;
```
### 3. In Demand Skills
 This query analyzes which skills are most in demand for data analysts. It aggregates skill counts using GROUP BY and COUNT functions on `skills_job_dim` and `skills_dim` tables, focusing on jobs with the title 'Data Analyst' and filtering by job location. Results are sorted in descending order by demand count and limited to the top 5 skills.
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND (
        job_postings_fact.job_location = 'Tel Aviv-Yafo, Israel'
        OR job_postings_fact.job_location = 'Anywhere'
    )
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
### 4. Top Paying Skills
This query identifies skills associated with higher salaries among data analysts. It calculates average salaries using AVG and filters out skills with insufficient demand using HAVING. Results are ordered by average salary in descending order and limited to the top 50 skills.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND (
        job_postings_fact.job_location = 'Tel Aviv-Yafo, Israel'
        OR job_postings_fact.job_location = 'Anywhere'
    )
GROUP BY
    skills
HAVING COUNT(skills_job_dim.job_id) > 10 
ORDER BY
    average_salary DESC
LIMIT 50;
```
### 5. Optimal Skills to Learn
This query determines the most optimal skills to learn for aspiring data analysts. It combines skills demand counts and average salaries to compute a skill score, rounded and scaled for readability. Results are sorted by skill score in descending order and limited to the top 10 skills.
```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND (
            job_postings_fact.job_location = 'Tel Aviv-Yafo, Israel'
            OR job_postings_fact.job_location = 'Anywhere'
        )
    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills
    HAVING
        COUNT(skills_job_dim.job_id) > 10
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND (
            job_postings_fact.job_location = 'Tel Aviv-Yafo, Israel'
            OR job_postings_fact.job_location = 'Anywhere'
        )
    GROUP BY
        skills_job_dim.skill_id
)
SELECT 
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary,
    ROUND((skills_demand.demand_count * average_salary.avg_salary) / 1000000) AS skill_score
FROM skills_demand 
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
  skill_score DESC
LIMIT 10;
```
# What I learned

- **Basic and Complex Query Crafting**: joining tables, subquries, and CTEs
- **Data Aggregation**: GROUP BY, COUNT AVG etc
- **Planning and Gradual Query Writing**: first thinking about how I want my output to look, then planning my steps, before diving into the actual code writing
