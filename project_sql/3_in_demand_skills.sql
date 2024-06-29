/*
Question: What are the most in-demand skills for data analysts?
- Join job postings similar to query 2.
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highst demand in the job market, 
    providing insights into the most valuble skills for job seekers.
*/

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

[
  {
    "skills": "sql",
    "demand_count": "7612"
  },
  {
    "skills": "excel",
    "demand_count": "4698"
  },
  {
    "skills": "python",
    "demand_count": "4556"
  },
  {
    "skills": "tableau",
    "demand_count": "3869"
  },
  {
    "skills": "power bi",
    "demand_count": "2647"
  }
]