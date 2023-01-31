Select *
From PortfolioProject..CovidDeaths
order by 3,4;

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4;

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2;


-- Looking at total cases Vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Percentage_Death
From PortfolioProject..CovidDeaths
where location LIKE '%INDIA%'
order by 1,2;

-- Looking at total cases Vs Population
-- shows what percentage of population got covid


Select location, date,total_cases, population, (total_cases/population)*100 As CovidInfection_Vs_Population
From PortfolioProject..CovidDeaths
--where location LIKE '%INDIA%'
order by 1,2;



-- Looking at Countries with highest Infection Rate Compared to population

Select location, population, MAX(total_cases) as highest_infection, 
	MAX(total_cases/population)*100 As PercentPopulationInfected
From 
	PortfolioProject..CovidDeaths
-- where location LIKE '%INDIA%'
Group By  location, population
order by 
		PercentPopulationInfected DESC;

-- Showing Countries with highest death per population


Select location, MAX(cast(total_deaths as int))  As TotalDeathCount
From 
	PortfolioProject..CovidDeaths
-- where location LIKE '%INDIA%'
where continent is Not Null
Group By  location
order by 
		 TotalDeathCount DESC;

-- lets things break down by continent

Select continent, MAX(cast(total_deaths as int))  As TotalDeathCount
From 
	PortfolioProject..CovidDeaths
-- where location LIKE '%INDIA%'
where continent is Not Null
Group By  continent
order by 
		 TotalDeathCount DESC;

-- showing continent with highest Death count
Select continent, MAX(cast(total_deaths as int))  As TotalDeathCount
From 
	PortfolioProject..CovidDeaths
-- where location LIKE '%INDIA%'
where continent is Not Null
Group By  continent
order by 
		 TotalDeathCount DESC;

-- Global Numbers
Select date,SUM(new_cases) as DailyTotalNewCases, SUM(CAST(new_deaths as int)) DailyTotalDeaths,
	SUM(cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
where  continent is not null
group by date
order by 1,2;


-- Global Numbers
Select SUM(new_cases) as DailyTotalNewCases, SUM(CAST(new_deaths as int)) DailyTotalDeaths,
	SUM(cast(new_deaths as int))/Sum(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
where  continent is not null
order by 1,2;

select * 
From PortfolioProject..CovidVaccinations;

-- Looking at total population Vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as float))  OVER (partition by dea.location order by dea.location
,dea.Date) As ToatlVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on 
	dea.location= vac.location
	and dea.date = vac.date 
where dea.continent is not null --and dea.location like '%india%'
order by 2,3;


-- CTE
With PopvsVac (Continet, location, Date, population,new_vaccinations, RollingPeopleVaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as float))  OVER (partition by dea.location order by dea.location
,dea.Date) As RollingPeopleVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on 
	dea.location= vac.location
	and dea.date = vac.date 
where dea.continent is not null --and dea.location like '%india%'
--order by 2,3
)
select *, (RollingPeopleVaccinations/population)*100
from PopvsVac


-- Tem table
DROP table if exists PercentPopulationVaccinated;


	Create table  PercentPopulationVaccinated(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric, 
	new_vaccinations numeric,
	RollingPeopleVaccinations numeric
	)

	insert into PercentPopulationVaccinated
	select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, Sum(cast(vac.new_vaccinations as float))  OVER (partition by dea.location order by dea.location
	,dea.Date) As RollingPeopleVaccinations
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccinations vac
	on 
		dea.location= vac.location
		and dea.date = vac.date 
	--where dea.continent is not null --and dea.location like '%india%'
	--order by 2,3;

	Select *, (RollingPeopleVaccinations/population)*100
	from PercentPopulationVaccinated





-- creating view to store data for later visullazations:

create view M_PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, Sum(cast(vac.new_vaccinations as float))  OVER (partition by dea.location order by dea.location
	,dea.Date) As RollingPeopleVaccinations
	From PortfolioProject..CovidDeaths dea
	Join PortfolioProject..CovidVaccinations vac
	on 
		dea.location= vac.location
		and dea.date = vac.date 
	where dea.continent is not null --and dea.location like '%india%'
	--order by 2,3


select *
from N_PercentPopulationVaccinated;



