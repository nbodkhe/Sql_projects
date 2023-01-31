-- creating view to store data for later visullazations:

create view PercentPopulationVaccinated as
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