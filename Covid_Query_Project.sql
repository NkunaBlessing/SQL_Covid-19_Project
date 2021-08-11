/*Data analyzing using covid-19 data*/

--Select every entry from covid_deaths table
SELECT *
FROM PortfolioProject..Covid_Deaths


--Select eveything from the covid_vaccination table
SELECT *
FROM PortfolioProject..Covid_vaccination



--What is the fatal rate of the infected people in south africa? 
SELECT date
,location
,total_deaths
,new_deaths
,CAST(total_cases as int)
,new_cases
,(total_deaths/total_cases) * 100 AS IFR -- IFR is an infection fatal rate
-- The above line means that % of the people infected have a fatal outcome
FROM PortfolioProject..Covid_Deaths
WHERE location = 'south africa'


--Finding the rate of fatal infection from the continent africa
SELECT date
,continent
,location
,population
,(total_cases/population) * 100 AS PIR -- PIR is people infected rate
FROM PortfolioProject..Covid_Deaths
WHERE continent = 'Africa' 
ORDER BY PIR DESC 



--What is the highest infected rate from each each countries?
SELECT location
,population
,MAX((total_cases/population) * 100) AS PIR -- PIR is people infected rate
FROM PortfolioProject..Covid_Deaths
GROUP BY population, location
ORDER BY PIR DESC 



--What is the highest death rate from each countries?
SELECT location
,population
,MAX(total_deaths/total_cases) * 100 AS IFR
FROM PortfolioProject..Covid_Deaths
GROUP BY location
,population
ORDER BY IFR DESC


--Total number of cases and death in each continent
SELECT continent
,SUM(new_cases) OVER (PARTITION BY continent ORDER BY continent) AS Number_Of_Cases
,SUM(CAST([new_deaths] AS INT)) OVER (PARTITION BY continent ORDER BY continent) AS Number_Of_Deaths
FROM PortfolioProject..Covid_Deaths
WHERE continent is not null


--The below query does the same thing as the one above. (Total number of cases and death in each continent)
SELECT continent
,SUM(new_cases) AS Number_Of_Cases
,SUM(CAST([new_deaths] AS INT)) AS Number_Of_Deaths
FROM PortfolioProject..Covid_Deaths
WHERE continent is not null
GROUP BY  continent


--Total number of infected individuals globally
SELECT date
,SUM(new_cases) AS Global_Cases
FROM PortfolioProject..Covid_Deaths
WHERE continent is not null
GROUP BY date


/*Obtaining location, date, population, new_deaths, total_deaths from the PortfolioProject..Covid_Deaths table
and new_vaccinations, total_vaccinations from the PortfolioProject..Covid_vaccination.*/
SELECT D.location
,D.date
,D.population
,D.new_deaths
,D.total_deaths
,V.new_vaccinations
,V.total_vaccinations
FROM PortfolioProject..Covid_Deaths D
  JOIN PortfolioProject..Covid_vaccination  V
   ON D.date = V.date
   AND D.location = V.location
ORDER BY 1, 2


--What is the overall averages of deaths in locations where the country name start with a letter 'A'
SELECT location
,AVG(CAST(new_deaths AS DECIMAL(6))) AS Average_Total_deaths
FROM PortfolioProject..Covid_Deaths
WHERE location LIKE 'A%'
GROUP BY location


--Which countries have on a single day vaccinated at least 100 people but not more than a 1000?
SELECT date
,location
,people_vaccinated
FROM PortfolioProject..Covid_vaccination
WHERE people_vaccinated BETWEEN 100 AND 1000
ORDER BY people_vaccinated DESC


--Specify which dates vaccinations took place and which ones no vaccinations took place in Africa
SELECT date
,continent
,location
,new_vaccinations
,  CASE
     WHEN new_vaccinations IS NULL THEN 'No vaccination took place'
	 WHEN new_vaccinations IS NOT NULL THEN 'Vaccination took place'
	 END AS If_Vaccination_Took_Place
FROM PortfolioProject..Covid_vaccination
WHERE continent = 'Africa'


--Creating a temporary table named #DeathsAndVaccinations
CREATE TABLE #DeathAndVaccination
( location nvarchar(225),
  date datetime,
  population numeric,
  new_deaths numeric,
  total_deaths numeric,
  new_vaccinations numeric,
  total_vaccinations numeric
)

INSERT INTO #DeathAndVaccination
SELECT D.location
,D.date
,D.population
,D.new_deaths
,D.total_deaths
,V.new_vaccinations
,V.total_vaccinations
FROM PortfolioProject..Covid_Deaths D
  JOIN PortfolioProject..Covid_vaccination  V
   ON D.date = V.date
   AND D.location = V.location
ORDER BY 1, 2


--Creating a veiw to store data for visualization
CREATE VIEW DeathAndVaccination AS
SELECT D.location
,D.date
,D.population
,D.new_deaths
,D.total_deaths
,V.new_vaccinations
,V.total_vaccinations
FROM PortfolioProject..Covid_Deaths D
  JOIN PortfolioProject..Covid_vaccination  V
   ON D.date = V.date
   AND D.location = V.location


SELECT *
FROM #DeathAndVaccination