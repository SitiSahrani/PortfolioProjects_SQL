# PortfolioProjects_SQL
# COVID-19 Data Exploration using SQL

This project explores COVID-19 data using SQL queries to analyze various aspects, such as total cases, death rates, infection rates, and vaccination progress worldwide.

## 📌 Overview
The dataset used in this project contains COVID-19 cases, deaths, and vaccination records from various countries. The goal is to extract meaningful insights by applying SQL queries.

## 🛠️ Technologies Used
- **SQL** (for data analysis)
- **SQLite / PostgreSQL / MySQL** (depending on your setup)
- **Jupyter Notebook (Optional, for visualization)**

## 📂 Dataset
The data used in this project comes from the COVID-19 dataset, which includes:
- **COVID-19 Cases & Deaths** (`CovidDeaths`)
- **COVID-19 Vaccinations** (`CovidVaccinations`)

## 📊 SQL Queries & Analysis

### 1️⃣ Basic Data Exploration
- Selecting relevant fields from the dataset
- Filtering data for specific locations

### 2️⃣ Case Fatality Rate Analysis
- Calculating the likelihood of dying if infected with COVID-19
- Finding infection rate per country

### 3️⃣ Highest Infection & Death Rate
- Identifying countries with the highest infection rate
- Comparing infection rates across continents

### 4️⃣ Global Statistics
- Total cases and deaths worldwide
- Calculating global death percentage

### 5️⃣ Vaccination Analysis
- Comparing total population vs vaccinated individuals
- Using **Window Functions (SUM OVER PARTITION BY)** to track cumulative vaccinations
- Using **Common Table Expressions (CTEs)** for population vaccination analysis
- Storing results in a **temporary table** and a **view** for easier visualization

## 📜 SQL Queries
The SQL scripts used in this project can be found in [`Project1_COVID.sql`](Project1_COVID.sql). These queries cover:
- Case & death analysis
- Infection rate comparison
- Vaccination tracking using **CTE, Temp Tables, and Views**

## 🎥 Acknowledgment
This project was inspired by [Alex The Analyst](https://www.youtube.com/watch?v=qfyynHBFOsM). Some SQL concepts were adapted and modified for this project.

## 📌 How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/SitiSahrani/PortfolioProjects_SQL.git
