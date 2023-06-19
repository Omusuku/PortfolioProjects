SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

SELECT *
FROM PortfolioProject..
ORDER BY 3,4

SELECT location,date, total_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where location like '%nigeria%'
order by 1,2


SELECT location, date, total_cases, population, (total_cases / population) * 100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location LIKE '%nigeria%'
ORDER BY 1, 2;

---Showing The Highest Infection BY Percentage 

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) * 100 AS PercentagePopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 1, 2;


---Showing the Countries with the Highest Death Count Per population


SELECT location, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
where continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

---Break Down By Continent

SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

---Showing the Continen tWith The Highest Deathpopulation

SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


---Looking AT Total Population VS Vaccinations




---Looking at Total Population vs Vaccinations



With PopvsVac (Continent,location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


---TEMP TABLE



DROP Table if exists #PercentPopulationVaccinatated
Create Table #PercentPopulationVaccinatated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
new_vaccination numeric,
Rollingpeoplevaccinated numeric
)

Insert Into #PercentPopulationVaccinatated
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinatated




Create View PercentPopulationVaccinatated as
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
on dea.location =vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Create View ContinentWithTheHighestDeathpopulation as
SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths 
where continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount desc
