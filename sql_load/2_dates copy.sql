SELECT  
   company_dim.name AS company_name,
   COUNT(job_postings_fact.job_id) AS number_of_jobs,
   total_health_jobs.total_jobs_with_health_insurance
FROM    
   job_postings_fact
INNER JOIN 
    company_dim 
ON 
    job_postings_fact.company_id = company_dim.company_id 
INNER JOIN (
    SELECT 
        COUNT(job_id) AS total_jobs_with_health_insurance
    FROM 
        job_postings_fact
    WHERE 
        job_health_insurance = TRUE AND
        EXTRACT(QUARTER FROM job_posted_date) = 2 AND
        job_posted_date >= '2023-01-01' AND job_posted_date < '2024-01-01'
) AS total_health_jobs ON 1=1
WHERE
    job_health_insurance = TRUE AND
    EXTRACT(QUARTER FROM job_posted_date) = 2 AND
    job_posted_date >= '2023-01-01' AND job_posted_date < '2024-01-01'
GROUP BY
    company_name, total_health_jobs.total_jobs_with_health_insurance
ORDER BY
    number_of_jobs DESC;
