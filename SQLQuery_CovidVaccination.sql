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

create view N_PercentPopulationVaccinated as
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
