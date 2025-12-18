-- netflix project 
DROP TABLE IF EXISTS netflix; 
CREATE TABLE netflix
(
		show_id	varchar(7),
		type varchar(10),	
		title varchar(200),
		director varchar(208),	
		casts varchar(1000),
		country	char(150),
		date_added varchar(50),
		release_year int,	
		rating	varchar(10),
		duration varchar(15),
		listed_in varchar(100),
		description varchar(250)
);
SELECT * FROM netflix;

SELECT 
	count(*) as total_content 
FROM netflix;

SELECT 
	DISTINCT type
FROM netflix;

SELECT 
	count(*) as total_content 
FROM netflix;

-- 15 bussiness problem
1. Count the number of Movies vs TV Shows
SELECT 
	type,
	count(*) as total_content
FROM netflix
GROUP BY type;


2. Find the most common rating for movies and TV shows

SELECT 
	type,
	rating,
	count(*)
FROM netflix
group by type,rating
ORDER BY count DESC;

3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE type = 'Movie'and release_year = 2020;

4. Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST(string_to_array(country,',')) as new_country,
	 count(show_id) as total_content
FROM netflix  
group by new_country  
ORDER BY total_content DESC
LIMIT 5;

5. Identify the longest movie

SELECT 
	type ,
	title, 
	duration 
FROM netflix
where type = 'Movie' and duration = (select max(duration)from netflix)
;


6. Find content added in the last 5 years

SELECT 
	* 
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
	show_id,
	title,
	director
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

8. List all TV shows with more than 5 seasons
SELECT 
	*
FROM netflix
WHERE 
	TYPE = 'TV shows' 
	AND 
	SPLIT_PART(duration,' ',1)::numeric > 5

9. Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id)
FROM netflix
GROUP BY 1

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD YYYY'))AS year,
	count(*),
	ROUND(
		COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric * 100
		,2)AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1


11. List all movies that are documentaries

SELECT * FROM netflix
where listed_in ILIKE '%Documentaries%'

12. Find all content without a director

SELECT * FROM netflix
where director IS NULL

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%' 
	AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

14. Find the top 10 actors who have appeared in the highest number of movies producedin India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
	COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT(10)



15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
WITH new_table
AS(
SELECT 
	*,
	CASE
	WHEN description ILIKE '%kill%' 
	OR
	description ILIKE '%violence%' THEN 'Bad_content'
	ELSE 'Good_content'
	END category
FROM netflix
)
SELECT 
	category,
	count(*) as total_content
FROM new_table
GROUP BY 1



