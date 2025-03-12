-- This query was inspired by Alex The Analyst (https://www.youtube.com/watch?v=qfyynHBFOsM)

Select *
From CovidDeaths cd 
Where cd.continent is not null
order by 3,4

--Data that we are goin to be using
Select Location, date, cd.total_cases , cd.new_cases , cd.total_deaths, cd.population 
From CovidDeaths cd 
order by 1,2

-- Total Cases VS Total Death
-- Shows Likelihood of dying if you contract covid in your country
Select Location, date, cd.total_cases, cd.total_deaths, (CAST(cd.total_deaths AS REAL) / cd.total_cases)*100 AS Death_Percentage
From CovidDeaths cd 
Where location like '%indonesia%'
order by 1,2

-- Total Cases VS Total Death
-- Shows what percentatge of population got covid
Select Location, date, cd.total_cases, cd.population , (CAST(cd.total_cases AS REAL) / cd.population)*100 AS Death_Percentage
From CovidDeaths cd 
--Where location like '%indonesia%'
order by 1,2

-- Country with Highest Infection Rate compared to Population
Select Location, cd.population , MAX(total_cases) as HighestInfectionCount, (CAST(cd.total_cases  AS REAL) / cd.population )*100 AS PercentPopulationInfected
From CovidDeaths cd 
--Where location like '%indonesia%'
Group by cd.Location, cd.population 
order by PercentPopulationInfected DESC 

--By Continent
Select Continent, MAX(cast(cd.total_deaths as INTEGER)) as TotalDeathCount
From CovidDeaths cd 
--Where location like '%indonesia%'
Where cd.continent is not null
Group by cd.Continent 
order by TotalDeathCount DESC 

--Country with Highest Death Count to Population
Select Location, MAX(cast(cd.total_deaths as INTEGER)) as TotalDeathCount
From CovidDeaths cd 
--Where location like '%indonesia%'
Where cd.continent is not null
Group by cd.Location 
order by TotalDeathCount DESC 

-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as INTEGER)) as total_deaths, SUM(cast(new_deaths as INTEGER))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths cd
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Calculating Total Population vs Vaccinations
SELECT cd.continent, 
       cd.location, 
       cd.date, 
       cd.population, 
       cv.new_vaccinations,
       -- Using SUM() as a window function to calculate cumulative vaccinations per location
       SUM(COALESCE(cv.new_vaccinations, 0)) 
           OVER (PARTITION BY cd.Location ORDER BY cd.Date) AS RollingPeopleVaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
    ON cd.location = cv.location
    AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cd.date;


-- Using CTE (Common Table Expression) to perform calculations on Partition By
SELECT *, 
       (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM (
    SELECT cd.continent, 
           cd.location, 
           cd.date, 
           cd.population, 
           cv.new_vaccinations,
           -- Applying a rolling sum to track cumulative vaccinations
           SUM(COALESCE(cv.new_vaccinations, 0)) 
               OVER (PARTITION BY cd.Location ORDER BY cd.Date) AS RollingPeopleVaccinated
    FROM CovidDeaths cd
    JOIN CovidVaccinations cv
        ON cd.location = cv.location
        AND cd.date = cv.date
    WHERE cd.continent IS NOT NULL
) AS PopvsVac;

-- Calculating the percentage of the population that has been vaccinated
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM PopvsVac;


-- Using a Temporary Table for calculations
DROP TABLE IF EXISTS temp_PercentPopulationVaccinated;

-- Creating a temporary table to store cumulative vaccination data
CREATE TABLE temp_PercentPopulationVaccinated (
    Continent TEXT,
    Location TEXT,
    Date TEXT,
    Population REAL,
    New_vaccinations REAL,
    RollingPeopleVaccinated REAL
);

-- Inserting calculated values into the temporary table
INSERT INTO temp_PercentPopulationVaccinated
SELECT cd.continent, 
       cd.location, 
       cd.date, 
       cd.population, 
       cv.new_vaccinations,
       SUM(COALESCE(cv.new_vaccinations, 0)) 
           OVER (PARTITION BY cd.Location ORDER BY cd.Date) AS RollingPeopleVaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
    ON cd.location = cv.location
    AND cd.date = cv.date;

-- Selecting the final dataset with percentage calculation
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM temp_PercentPopulationVaccinated;


-- Creating a View to store the data for later visualization
DROP VIEW IF EXISTS PercentPopulationVaccinated;

-- Creating a view for easier access to cumulative vaccination data
CREATE VIEW PercentPopulationVaccinated AS
SELECT cd.continent, 
       cd.location, 
       cd.date, 
       cd.population, 
       cv.new_vaccinations,
       -- Storing cumulative vaccination numbers in a view
       SUM(COALESCE(cv.new_vaccinations, 0)) 
           OVER (PARTITION BY cd.Location ORDER BY cd.Date) AS RollingPeopleVaccinated
FROM CovidDeaths cd
JOIN CovidVaccinations cv
    ON cd.location = cv.location
    AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;
