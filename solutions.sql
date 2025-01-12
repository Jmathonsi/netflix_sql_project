-- NETFLIX PROJECT 

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix;

-- 10 BUSINESS PROBLEMS

-- 1.COUNT THE NUMBER OF MOVIES VS TV SHOWS 

SELECT * FROM netflix;

SELECT TYPE , COUNT(*) AS total
From netflix 
GROUP BY TYPE;


-- 2.FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS 
SELECT 
    Type, 
    Rating
FROM (
    SELECT 
        Type, 
        Rating, 
        COUNT(*) AS Count,
        RANK() OVER (PARTITION BY Type ORDER BY COUNT(*) DESC) AS Ranking
    FROM netflix
    GROUP BY Type, Rating
) AS t1
WHERE Ranking = 1;

-- 3.LIST ALL MOVIES RELEASED IN A SPECIFIC YEAR (E.G 2020)

SELECT * FROM netflix ;

SELECT TITLE 
FROM netflix 
WHERE TYPE = 'Movie' AND release_year = 2020;

--4.FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX

SELECT * FROM netflix ;

SELECT TRIM(UNNEST(STRING_TO_ARRAY(country ,','))) AS new_country ,COUNT(show_id) AS total_content
FROM NETFLIX 
GROUP BY 1
ORDER BY COUNT(show_id) DESC
LIMIT 5;

Select 
UNNEST(STRING_TO_ARRAY(country , ',')) AS new_country
from netflix;

-- 5. FIND THE LONGEST MOVIE 

SELECT * FROM netflix ;

select title, substring(duration,1,position('m' in duration)-1):: int duration
from netflix 
where type = 'Movie' and duration is not null 
order by 2 desc 
LIMIT 1;


-- 6. FIND THE CONTENT ADDED IN THE LAST 5 YEARS

SELECT * 
FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7.FIND ALL THE MOVIES/TV_SHOWS BY DIRECTOR 'Rajiv Chilaka'

SELECT * 
FROM netflix;


SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
 ;

 -- 8. LIST ALL TV SHOWS WITH MORE THEN 5 SEASONS 
 
SELECT * 
FROM netflix;
 
 
 select * 
from netflix 
where type = 'TV Show' 
and SPLIT_PART(duration,' ',1) :: int > 5
;

-- 9.COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE

SELECT  
UNNEST(STRING_TO_ARRAY(listed_in , ', ')) AS GENRE ,
COUNT(show_id) as total
from netflix 
GROUP BY 1;

-- 10.FIND EACH YEAR AND THE AVERAGE NUMBER OF CONTENT RELEASED BY INDIA ON NETFLIX . 
--	 RETURN TOP 5 YEAR WITH HIGHEST AVG CONTENT RELEASE 

SELECT * 
FROM netflix;

SELECT 
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country ILIKE '%India%')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
 









