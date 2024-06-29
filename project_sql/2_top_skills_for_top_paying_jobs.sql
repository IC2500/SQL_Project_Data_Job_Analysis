/*
Question: What skills are required for the top-paying data analyst jobs?
- use the top 10 highest-paying Data Analyst jobs from the first query.
- Add the specific skills required for these roles
- Why? it provides a detailed look at which high-paying jobs demand certain skills, 
helping job seekers understand which skills to develop that align with top salaries.
*/

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

/* top 5 skills for top 100 paying data analyst jobs
*/
[
  {
    "top_skill": "sql",
    "job_count": "83"
  },
  {
    "top_skill": "python",
    "job_count": "57"
  },
  {
    "top_skill": "tableau",
    "job_count": "45"
  },
  {
    "top_skill": "sas",
    "job_count": "34"
  },
  {
    "top_skill": "r",
    "job_count": "33"
  }
]