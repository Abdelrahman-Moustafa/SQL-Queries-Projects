SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3, 4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

-- SELECT Data that we are going to using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2

-- Looking at total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100  AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Egypt%'
ORDER BY 1, 2

-- Looking the total cases vs population
SELECT location, date, population, total_cases, (total_cases/population) * 100  AS Percent_of_population_infected
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%german%'
ORDER BY 1, 2

-- Looking at countries with hightest infection rate compared to population
SELECT location, population, MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population)) * 100  AS Percent_of_population_infected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

-- Showing countries with highest deaths count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%states'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- Break things down by continent
SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS  NULL
GROUP BY location
ORDER BY 2 DESC


-- Showing contintents with the highest death count per population
--SELECT location, MAX(CAST(total_deaths AS int)) AS total_death_count
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS  NULL
--GROUP BY location
--ORDER BY 2 DESC

SELECT date, SUM(new_cases) new_cases, SUM(CAST(new_deaths AS int)) new_deaths, SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Global numbers
SELECT SUM(new_cases) new_cases, SUM(CAST(new_deaths AS int)) new_deaths, SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100 death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL

SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Looking at total population vs vaccinations
-- Instead of cast to in we cast to numeric cuz the int gives us an error
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_Vaccinated
--, (Rolling_people_Vaccinated / population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH Pop_vs_Vac (continent, location, date, population, new_vaccinations, Rolling_people_Vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_Vaccinated
--(Rolling_people_Vaccination / population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (Rolling_people_Vaccinated / population) * 100 
FROM Pop_vs_Vac

DROP TABLE #PercentPopulationVaccinated
-- Temp table
--IF OBJECT_ID('PortfolioProject..#PercentPopulationVaccinated') IS NOT NULL DROP TABLE #PercentPopulationVaccinated
--GO
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccination numeric,
Rolling_people_Vaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_Vaccinated
--(Rolling_people_Vaccination / population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM #PercentPopulationVaccinated


--Creating a view to store date for later visualization
CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS NUMERIC)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS Rolling_people_Vaccinated
--(Rolling_people_Vaccination / population) * 100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated