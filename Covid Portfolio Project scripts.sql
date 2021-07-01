select *
from [Portfolio Project].dbo.CovidDeaths$
order by 3,4

select *
from [Portfolio Project].dbo.CovidVaccinations$
order by 3,4

--Select data 
select location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project].dbo.CovidDeaths$
order by 1,2

--Total Cases vs Total Deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from [Portfolio Project].dbo.CovidDeaths$
where location like '%india%'
order by 1,2

--Total Cases vs Population
select location,date,total_cases,population,(total_cases/population)*100 as covidinfected_Percentage
from [Portfolio Project].dbo.CovidDeaths$
--where location like '%india%'
order by 1,2

--Highest infected percentage countries
select location,population,max(population),max((total_cases/population)*100) as covidinfected_Percentage
from [Portfolio Project].dbo.CovidDeaths$
group by location,population
order by covidinfected_Percentage desc

--Highest Death Count percentage countries
select location,population,max(population),max((total_deaths/population)*100) as Deathcount_Percentage
from [Portfolio Project].dbo.CovidDeaths$
group by location,population
order by  Deathcount_Percentage desc

--Death Count
select location,max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

--Death Count by continent
select location,max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths$
where continent is null
group by location
order by TotalDeathCount desc

--Showing continent with highest death count
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
select date,sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths$
where continent is not null
group by date
order by 1,2

select *
from [Portfolio Project].dbo.CovidVaccinations$

--Looking Total Population vs Vaccinations
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project].dbo.CovidVaccinations$ v
join 
[Portfolio Project].dbo.CovidDeaths$ d on 
v.date=d.date and v.location=d.location
where d.continent is not null
order by 1,2,3

--Use CTE
with popvsvac (continent,location,date,population,new_vaccinations,people_vaccinated)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project].dbo.CovidVaccinations$ v
join 
[Portfolio Project].dbo.CovidDeaths$ d on 
v.date=d.date and v.location=d.location
where d.continent is not null
--order by 1,2,3
)
select *
from popvsvac

--Temp Table
drop table if exists peoplevaccinated
create table peoplevaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
people_vaccinated numeric)

insert into peoplevaccinated
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project].dbo.CovidVaccinations$ v
join 
[Portfolio Project].dbo.CovidDeaths$ d on 
v.date=d.date and v.location=d.location
where d.continent is not null
--order by 1,2,3
select *
from peoplevaccinated

--Create View
create view vaccinated_people as
select d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location,d.date) as people_vaccinated
from [Portfolio Project].dbo.CovidVaccinations$ v
join 
[Portfolio Project].dbo.CovidDeaths$ d on 
v.date=d.date and v.location=d.location
where d.continent is not null
--order by 1,2,3

select *
from vaccinated_people
