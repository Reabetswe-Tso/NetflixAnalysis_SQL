--Netflix Project
--USE NetflixDB;  
--GO  
--SELECT * FROM dbo.netflix_titles;

-- Creating The table
CREATE TABLE netflix_titles (
    show_id NVARCHAR(30),
    type NVARCHAR(100),
    title NVARCHAR(600),
    director NVARCHAR(600),
    cast NVARCHAR(MAX),
    country NVARCHAR(300),
    date_added NVARCHAR(200),
    release_year NVARCHAR(50),
    rating NVARCHAR(100),
    duration NVARCHAR(MAX),
    listed_in NVARCHAR(600),
    description NVARCHAR(MAX)
);

--1. Count the number of shows vs movies
   Select type as Type_of_Content, COUNT(*) as Num_Of_Contents
   from netflix_titles
   Group by type;


--2. Find the most common rating for movies and and tv shows
    select type, rating
    from 
   (Select type, rating, COUNT(*) as countt,
   rank() over (partition by type order by count(*) desc) as ranking
   from netflix_titles
   Group by type,rating ) as S2
   where ranking = 1;

--3. List all the movies released in a specific year
    Select title as Movie_Title
    from netflix_titles
    where type LIKE 'Movie' AND release_year = 2021;

-- Earliest and latest release years
	Select min(release_year) as Earliest_release_year, max(release_year) as Latest_release_year
    from netflix_titles
    
--4. Identify the longest movie or tv show
     SELECT *
     FROM netflix_titles
     WHERE type = 'Movie'
     AND CAST(REPLACE(duration, ' min', '') AS INT) = (
     SELECT MAX(CAST(REPLACE(duration, ' min', '') AS INT))
     FROM netflix_titles
     WHERE type = 'Movie' );


--5. Find the top 5 countries with the most content on Netflix
     SELECT 
     LTRIM(RTRIM(value)) AS new_country,
     COUNT(show_id) AS total_content
     FROM netflix_titles
     CROSS APPLY STRING_SPLIT(country, ',')
     GROUP BY LTRIM(RTRIM(value))
     ORDER BY total_content DESC
     OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--6. Find content added in the last 5 years
     SELECT *
     FROM netflix_titles
     WHERE TRY_CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

--7. Find all the movies/Tv shows by director Rajiv Chalaka
     Select title
	 from netflix_titles
	 where director LIKE '%Rajiv Chilaka%'

--8. List shows with more than 5 seasons
     SELECT *
     FROM netflix_titles
     WHERE type = 'TV Show'
     AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;
     
--9. Count the number of content items in each genre
     SELECT 
    LTRIM(RTRIM(listed_in)) AS genre,
    COUNT(show_id) AS total_content
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY LTRIM(RTRIM(listed_in))
ORDER BY total_content DESC;

   
--10.Find the average release year for content in each country
      Select country as Countries, Avg(release_year) as Average_Release_Year
	  from netflix_titles 
	  Group by country

--11.List all movies that are documentaries
       SELECT title AS Documentaries
       FROM netflix_titles
       WHERE type = 'Movie' 
       AND listed_in LIKE '%Documentaries%';

--12. Find All content without a director
      Select*
	  From netflix_titles
	  where director = '';

--13. Find how many movies actor Salman Khan appeared in movies for the past 10 years
      SELECT *
      FROM netflix_titles
      WHERE [cast] LIKE '%Salman Khan%'
      AND release_year > YEAR(GETDATE()) - 10;










