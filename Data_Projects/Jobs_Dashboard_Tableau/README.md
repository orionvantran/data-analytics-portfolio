## 🧠 2024 US Data Science Job Postings Dashboard

![Dashboard Screenshot](images/dashboard-screenshot.png)

### 📘 Overview

This Tableau dashboard visualizes over **10,000 U.S. data science job postings** sourced from **LinkedIn (via Kaggle, 2024)**.
I created it to explore which **roles, skills, and companies dominate the data science job market**, while showcasing my ability to perform data cleaning, transformation, and interactive dashboard design in Tableau.

---

### 🎯 Project Goals

* Identify **top hiring companies** and **most common job categories**
* Map **job distribution by state** across the U.S.
* Compare **work types** (on-site, hybrid, remote) and **job levels**
* Highlight **in-demand technical skills** across the data industry

---

### 🧩 Process Summary

**Data Preparation**

* Imported the LinkedIn job postings dataset from Kaggle
* Cleaned missing values and filtered incomplete rows
* Created **calculated fields** to standardize job categories (e.g., Analyst, Engineer, Scientist, Manager)
* Added state name mapping logic to expand abbreviations, with unlisted jobs labeled as *“United States (Unlisted)”*
* Ensured consistent formatting for skills, companies, and work types

**Dashboard Design**

* Built **KPI cards** for total postings, unique companies, remote %, and clearance %
* Created visuals for **Top Technical Skills**, **Job Categories**, **Job Levels**, and **Top 10 Hiring Companies**
* Designed a **U.S. map** for geographic distribution, including insets for Alaska, Hawaii, and D.C.
* Applied a cohesive blue color palette, inside-bar labels, and minimal axis lines for readability
* Added a footer with source attribution and author credit

---

### 💡 Key Insights

* **Analyst and Engineer roles** dominate the data-science job market nationwide
* **California, Texas, and New York** have the highest concentration of postings
* Many listings are **hybrid or unlisted**, reflecting flexibility in work location
* **SQL, Python, and Tableau** are among the most requested technical skills

---

### 🛠️ Tools & Skills

* **Tableau Public** – Data visualization, calculated fields, interactive dashboard design
* **Excel & Power Query** – Text filtering, data transformation, and declassification of job summaries into standardized categories (ETL)
* **Data Preparation** – Extracting and merging CSVs, handling missing values, mapping state abbreviations, and standardizing columns
* **Data Storytelling** – Clear KPI framing, visual hierarchy, and layout consistency

---

### 📁 Project Files

```
tableau-us-data-science-jobs/
│
├── 📂 data/
│   ├── job_postings_raw.csv
│   ├── job_skills_raw.csv
│   ├── job_summary_raw.csv
│   └── cleaned_data.xlsx
│
├── 📂 dashboard/
│   └── us_data_jobs_dashboard.twbx
│
├── 📂 images/
│   └── dashboard-screenshot.png
│
└── README.md
```

---

### 🌐 View the Dashboard

🔗 [View on Tableau Public](https://public.tableau.com/app/profile/orion.tran8284/viz/2024USDataScienceJobPostingsDashboard/Dashboard1)

---

### 🧾 Data Source

> Data Science Job Postings & Skills (2024) (https://www.kaggle.com/datasets/asaniczka/data-science-job-postings-and-skills/data)

---

_Created by **Orion Tran** as part of a personal data visualization portfolio using Tableau and Power Query._
