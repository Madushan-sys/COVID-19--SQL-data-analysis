--		 		=====================================
-- 				      COVID-19 DATA ANALYSIS PROJECT
-- 				=====================================

-- Select all the data
SELECT date, location, total_cases, total_deaths, population, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM `coviddeaths` 
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total Death percentage
SELECT date, location, total_cases, total_deaths, population, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM `coviddeaths` 
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total Death percentage in Europe(Continent)
SELECT date, location, total_cases, total_deaths, population, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM `coviddeaths` 
WHERE continent LIKE 'Europe' AND 
ORDER BY 1, 2;

-- Total Death percentage in United States 
SELECT date, location, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM `coviddeaths` 
WHERE location LIKE '%United States%'
ORDER BY 1, 2;

-- Total Death percentage in Sri Lanka
SELECT date, location, ROUND((total_deaths/total_cases)*100, 2) AS DeathPercentage
FROM `coviddeaths` 
WHERE location LIKE '%Sri Lanka%'
ORDER BY 1, 2;

-- The country where the first Covid-19 patients were reported
WITH CTE AS(
    SELECT date, continent, location, RANK() OVER(PARTITION BY continent ORDER BY date ASC) AS rn
	FROM coviddeaths
	WHERE continent IS NOT NULL AND continent <> '')

SELECT date, continent, location
FROM CTE
WHERE rn <= 10;

-- First patient reported date in Sri Lanka
SELECT continent, location, date, total_cases
FROM coviddeaths
WHERE location LIKE '%Sri Lanka%' AND total_cases IS NOT NULL
ORDER BY total_cases ASC, date
LIMIT 1;

-- Percentage of Population who got Covid
SELECT date, location, total_cases, population, ROUND(AVG((total_cases/population * 100 )), 2) AS InfectedPercentage
FROM coviddeaths
WHERE continent IS NOT NULL AND population IS NOT NULL
GROUP BY location
ORDER BY InfectedPercentage DESC;

-- Counties with highest infection rates
SELECT date, location, MAX(total_cases), population, ROUND(MAX((total_cases/population * 100 )), 2) AS MaxInfectedPercentage
FROM coviddeaths
WHERE continent IS NOT NULL AND population IS NOT NULL
GROUP BY location
ORDER BY MaxInfectedPercentage DESC;

-- Counties with highest death rates
SELECT date, location, MAX(total_deaths), population, CONCAT(ROUND(MAX((total_deaths/population * 100 )), 2), '%') AS MaxDeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL AND population IS NOT NULL
GROUP BY location
ORDER BY MaxDeathPercentage DESC;

-- Total death count in each continent 
SELECT continent, SUM(new_cases) AS InfectedPatients
FROM coviddeaths
WHERE continent <> '' AND continent IS NOT NULL
GROUP BY continent
ORDER BY continent;

-- Total new cases and new deaths in each day
SELECT date, SUM(new_cases) AS InfectedPatients , SUM(new_deaths) AS Deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

-- Showing the continents with highest death count per population
SELECT continent, CONCAT(ROUND(SUM((total_deaths/ population * 100)), 2), '%') AS DeathCountRate
FROM coviddeaths
WHERE continent IS NOT NULL AND continent <> ''
GROUP BY continent
ORDER BY continent;

-- Recovery rate of each country
WITH infected AS(
    SELECT YEAR(date) AS Year, location, SUM(new_cases) OVER(PARTITION BY location, YEAR(date) ORDER BY (YEAR(date)))AS infected_patient, population
    FROM coviddeaths
    WHERE location IS NOT NULL)
SELECT DISTINCT  location, Year,  CONCAT(ROUND(infected_patient/population * 100, 2), '%') AS percentage
FROM infected
LIMIT 20;
