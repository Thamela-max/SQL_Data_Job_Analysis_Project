# SQL_Data_Job_Analysis_Project
Answering the ultimate job hunter's questions: Where are the highest-paying remote Data Analyst roles, and what specific skills command top dollar? Data-backed insights and visualizations built to optimize your career strategy.


# Introduction
This project explores the data analyst job market to uncover the most lucrative and strategic career paths. By analyzing job postings, salaries, and required skill sets, this analysis answers five core questions to help data professionals navigate the industry:

1. **What are the top-paying data analyst jobs?**
2. **What skills are required for these top-paying roles?**
3. **What are the most in-demand skills for data analysts?**
4. **What skills are associated with the highest average salaries?**
5. **What are the most optimal skills to learn (high demand *and* high pay)?**

The goal is to provide data-driven insights for aspiring analysts, career changers, and remote job seekers looking to maximize their value in the current tech economy.


# Background

The tech landscape is shifting rapidly, with remote and hybrid roles becoming highly sought after by data professionals. To navigate this evolving market, I wanted to dive into a massive dataset of job postings rather than relying on guesswork or hype. 

This project was born out of a need to use actual data to find out which skills truly give data analysts the highest return on investment (ROI) for their time, training, and career development.

# Tools I Used

To handle this large-scale dataset and extract meaningful insights, I used the following tools:

* **SQL:** The backbone of the project, used for querying the database, filtering roles, and aggregating salary and skill data.
* **PostgreSQL:** The database management system chosen to host and manage the massive job dataset.
* **Visual Studio Code:** My primary environment for writing clean SQL queries and managing project files.
* **Git & GitHub:** Used for version control and sharing this analysis with the data community.

# The Analysis

### 1. What are the top-paying data analyst jobs?
To identify the highest-paying opportunities, I filtered data analyst roles by average yearly salaries, focusing specifically on remote ('Anywhere') positions with specified salaries. This query highlights the top 10 highest-earning opportunities in the field, helping professionals target high-value companies and roles.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

![Top Paying Jobs](images/top_paying_jobs.png)


### 2. What skills are required for these top-paying roles?
By leveraging a Common Table Expression (CTE) to isolate the top 10 highest-paying remote data analyst jobs, this query joins those listings against the skills dimensions. This reveals the specific technical competencies and tools required to command top-tier salaries in the remote job market.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT top_paying_jobs.*, 
       skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

![Skills for Top Paying Jobs](images/top_paying_skills_required.png)


### 3. What are the most in-demand skills for a data analyst?
To understand what skills keep an analyst highly marketable, I aggregated the total volume of job postings demanding specific tools. This query focuses strictly on data analyst roles with remote options ('job_work_from_home = TRUE') to reveal the top 5 most frequently requested competencies.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```

| Skills | Demand Count |
| :--- | :--- |
| SQL | 7,291 |
| Excel | 4,611 |
| Python | 4,330 |
| Tableau | 3,745 |
| Power BI | 2,609 |


### 4. What are the top paying skills based on salary?
Different skills command different premiums. This query looks at the average salaries associated with specific tools and languages, revealing the top 10 specialized skills that offer the highest financial reward for remote Data Analysts.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 10;
```

![Top Paying Skills](images/top_paying_skills.png)


### 5. What are the most optimal skills to learn?
To identify the ultimate "sweet spot," this query combines demand volume and average salary data. By applying a `HAVING` filter to ensure the tools appear in more than 10 postings, this analysis eliminates low-volume anomalies and isolates the top 10 most optimal, high-value skills to master for a strong return on investment (ROI).

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id
HAVING    
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 10;
```

![Most Optimal Skills](images/most_optimal_skills.png)




# What I Learned

# Conclusion
