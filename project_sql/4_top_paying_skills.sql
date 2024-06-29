/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries
- Why? It reveals how diffrent skills impact salary levels for Data Analysts and
    helps identify the most financially rewarding skills to acquire or improve
*/

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

/*Results*/

[
  {
    "skills": "go",
    "average_salary": "114951",
    "demand_count": "28"
  },
  {
    "skills": "confluence",
    "average_salary": "114210",
    "demand_count": "11"
  },
  {
    "skills": "hadoop",
    "average_salary": "113193",
    "demand_count": "22"
  },
  {
    "skills": "snowflake",
    "average_salary": "112901",
    "demand_count": "38"
  },
  {
    "skills": "azure",
    "average_salary": "111225",
    "demand_count": "34"
  },
  {
    "skills": "bigquery",
    "average_salary": "109654",
    "demand_count": "13"
  },
  {
    "skills": "aws",
    "average_salary": "108317",
    "demand_count": "32"
  },
  {
    "skills": "java",
    "average_salary": "106906",
    "demand_count": "17"
  },
  {
    "skills": "ssis",
    "average_salary": "106683",
    "demand_count": "12"
  },
  {
    "skills": "jira",
    "average_salary": "104918",
    "demand_count": "20"
  },
  {
    "skills": "oracle",
    "average_salary": "104534",
    "demand_count": "37"
  },
  {
    "skills": "looker",
    "average_salary": "103795",
    "demand_count": "49"
  },
  {
    "skills": "nosql",
    "average_salary": "101414",
    "demand_count": "13"
  },
  {
    "skills": "python",
    "average_salary": "101188",
    "demand_count": "247"
  },
  {
    "skills": "r",
    "average_salary": "100600",
    "demand_count": "150"
  },
  {
    "skills": "redshift",
    "average_salary": "99936",
    "demand_count": "16"
  },
  {
    "skills": "qlik",
    "average_salary": "99631",
    "demand_count": "13"
  },
  {
    "skills": "ssrs",
    "average_salary": "99171",
    "demand_count": "14"
  },
  {
    "skills": "tableau",
    "average_salary": "99135",
    "demand_count": "233"
  },
  {
    "skills": "spark",
    "average_salary": "99077",
    "demand_count": "13"
  },
  {
    "skills": "c++",
    "average_salary": "98958",
    "demand_count": "11"
  },
  {
    "skills": "sas",
    "average_salary": "98902",
    "demand_count": "126"
  },
  {
    "skills": "sql server",
    "average_salary": "97786",
    "demand_count": "35"
  },
  {
    "skills": "javascript",
    "average_salary": "97587",
    "demand_count": "20"
  },
  {
    "skills": "power bi",
    "average_salary": "97431",
    "demand_count": "110"
  },
  {
    "skills": "flow",
    "average_salary": "97200",
    "demand_count": "28"
  },
  {
    "skills": "sql",
    "average_salary": "97041",
    "demand_count": "411"
  },
  {
    "skills": "alteryx",
    "average_salary": "94145",
    "demand_count": "17"
  },
  {
    "skills": "spss",
    "average_salary": "92170",
    "demand_count": "24"
  },
  {
    "skills": "outlook",
    "average_salary": "90077",
    "demand_count": "13"
  },
  {
    "skills": "vba",
    "average_salary": "88783",
    "demand_count": "24"
  },
  {
    "skills": "powerpoint",
    "average_salary": "88701",
    "demand_count": "58"
  },
  {
    "skills": "excel",
    "average_salary": "87357",
    "demand_count": "257"
  },
  {
    "skills": "sheets",
    "average_salary": "86088",
    "demand_count": "32"
  },
  {
    "skills": "word",
    "average_salary": "82576",
    "demand_count": "48"
  },
  {
    "skills": "sharepoint",
    "average_salary": "81634",
    "demand_count": "18"
  }
]

