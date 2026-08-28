/* what are the most in demand skills for data analyst? */
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count 

FROM job_postings_fact

INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE

group by 
    skills
order by 
    demand_count desc
limit 5