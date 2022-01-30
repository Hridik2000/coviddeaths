CREATE TABLE coviddeaths
( 
	iso_code CHAR(3),
    continent VARCHAR(40),
    location VARCHAR(40),
    date VARCHAR(40),
    population VARCHAR(40),
    total_cases VARCHAR(40),
    new_cases VARCHAR(40),
    new_cases_smoothed VARCHAR(40),
    total_deaths varchar(40),
    new_deaths VARCHAR(40),
    new_deaths_smoothed VARCHAR(40),
    total_cases_per_million VARCHAR(40),
    new_cases_per_million VARCHAR(40),
    new_cases_smoothed_per_million VARCHAR(40),
    total_deaths_per_million VARCHAR(40),
    new_deaths_per_million VARCHAR(40),
    new_deaths_smoothed_per_million VARCHAR(40),
    reproduction_rate VARCHAR(40),
    icu_patients VARCHAR(40),
    icu_patients_per_million VARCHAR(40),
    hosp_patients VARCHAR(40),
    hosp_patients_per_million VARCHAR(40),
    weekly_icu_admissions VARCHAR(40),
	weekly_icu_admissions_per_million VARCHAR(40),
    weekly_hosp_admissions_per_million VARCHAR(40)
);

SELECT 
    *
FROM
    coviddeaths
WHERE
    continent IS NOT NULL



Select 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths;

#Total cases vs Total Deaths
#shows likelihood of dying if you contract covid in your country

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS Death_percentage
FROM
    coviddeaths
WHERE
    location LIKE '%India%'
        AND continent IS NOT NULL;

#total cases vs population
#shows what percentage of population infected with covid

SELECT 
    location,
    date,
    population,
    total_cases,
    (total_cases / population) AS percentage_of_infected
FROM
    coviddeaths
WHERE
    location LIKE '%india%';


#countries with highest infection rate compared to population
SELECT 
    location,
    population,
    MAX(total_cases) AS Infection_count,
    MAX(total_cases / population) * 100 AS Population_infected
FROM
    coviddeaths
GROUP BY location , population
ORDER BY Population_infected DESC; 


#countries with highest death count per population

SELECT 
    location, MAX(total_deaths) AS Total_death_count
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY Total_death_count DESC;

#BREAKING THINGS DOWN BY CONTINENT
#SHOWING CONTINENT WITH THE HIGHEST DEATH RATE
SELECT 
    continent, Max(total_deaths) AS Total_death_count
FROM
    coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC;

#GLOBAL NUMBERS
SELECT date,SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,SUM(new_cases)/SUM(new_deaths)*100 as Death_Percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date;

#joining
SELECT 
    *
FROM
    coviddeaths dea
        JOIN
    covidvaccination vac ON dea.location = vac.location
        AND dea.date = vac.date;


#looking at total population vs vaccination
#USING CTE
WITH population_vs_vaccination(continent,location,date,population,new_vaccinations,Rolling_People_Vaccinated)
as
(
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
OVER(partition by dea.location ORDER BY dea.location,dea.date) as Rolling_People_Vaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccination vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL )

SELECT *,(Rolling_People_Vaccinated/population)
FROM population_vs_vaccination

#TEMP TABLE

CREATE TABLE PercentPopulationVaccinated
(
	continent varchar(255),
	location varchar(255),
	date datetime,
	population int,
	new_vaccinations int,
	Rolling_People_Vaccinated INT
)

INSERT INTO PercentPopulationVaccinated
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
OVER(partition by dea.location ORDER BY dea.location,dea.date) as Rolling_People_Vaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccination vac ON dea.location = vac.location
        AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL 

SELECT *,(Rolling_People_Vaccinated/population)*100
FROM PercentPopulationVaccinated






