/*
Question: What are the most optimal skills to learn? (high demand and high-paying)
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on Tel aviv + remote positions
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/

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

/*Results*/

[
  {
    "skills": "sql",
    "demand_count": "411",
    "avg_salary": "97041",
    "skill_score": "40"
  },
  {
    "skills": "python",
    "demand_count": "247",
    "avg_salary": "101188",
    "skill_score": "25"
  },
  {
    "skills": "tableau",
    "demand_count": "233",
    "avg_salary": "99135",
    "skill_score": "23"
  },
  {
    "skills": "excel",
    "demand_count": "257",
    "avg_salary": "87357",
    "skill_score": "22"
  },
  {
    "skills": "r",
    "demand_count": "150",
    "avg_salary": "100600",
    "skill_score": "15"
  },
  {
    "skills": "power bi",
    "demand_count": "110",
    "avg_salary": "97431",
    "skill_score": "11"
  },
  {
    "skills": "sas",
    "demand_count": "63",
    "avg_salary": "98902",
    "skill_score": "6"
  },
  {
    "skills": "sas",
    "demand_count": "63",
    "avg_salary": "98902",
    "skill_score": "6"
  },
  {
    "skills": "looker",
    "demand_count": "49",
    "avg_salary": "103795",
    "skill_score": "5"
  },
  {
    "skills": "powerpoint",
    "demand_count": "58",
    "avg_salary": "88701",
    "skill_score": "5"
  }
]



