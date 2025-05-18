# An analysis on Netflix TV shows and Moives using SQL 
![logo](https://akm-img-a-in.tosshub.com/indiatoday/images/story/202012/Netflix-New-Feature-Audio-Only_1200x768.jpeg?size=690:388)
## OBJECTIVE: 
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
## DATASET
- The data is collected on [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Analysis
### Create table
```sql
  drop table if exists netflix_dataset;
  create table netflix_dataset
  (
  show_id varchar(10) primary key,
  movie_type varchar(7),
  title varchar(110),
  director varchar(210),
  cast varchar(780),
  country varchar(130),
  date_added varchar(80),
  release_year int,	
  rating varchar(10),
  duration varchar(10),
  listed_in varchar(80),
  movie_description varchar(250));
```

### Problem 1: Count the Number of Movies vs TV Shows
- *Objective:* Determine the distribution of content types on Netflix.
```sql
  select count(show_id), movie_type from netflix_dataset
  group by 2;
```

### Problem 2: 2. Find the Most Common Rating for Movies and TV 
- *Objective:* Identify the most frequently occurring rating for each type of content.
```sql
SELECT movie_type, rating
FROM (
    SELECT  
        movie_type,
        rating, 
        COUNT(show_id) AS count_rating,
        RANK() OVER (PARTITION BY movie_type ORDER BY COUNT(show_id) DESC) AS the_most_rating
    FROM netflix_dataset
    GROUP BY movie_type, rating
) AS the_ranking_table
WHERE the_most_rating = 1;
```

### Problem 3: List All Movies Released in a Specific Year (e.g., 2020)
- *Objective:* Retrieve all movies released in a specific year.
```sql
select 
	movie_type,
    title,
    release_year
 from netflix_dataset
 where release_year = 2020 and movie_type = "movie";
```

### Problem 4: Find the Top 5 Countries with the Most Content on Netflix
- *Objective:* Identify the top 5 countries with the highest number of content items.
```sql
drop table if exists numbers;
CREATE TEMPORARY TABLE numbers AS (
  select 1 as n
  union select 2
  union select 3
  union select 4
  union select 5
  union select 6
  union select 7 
  union select 8
); -- make sure the temporary table cover enough comma in country

select new_country, count(show_id) as count 
from 
	(select show_id, substring_index(substring_index(country, ',', n), ',', -1) as new_country
	from netflix_dataset
	join numbers on char_length(country) - char_length(replace(country, ',', '')) >= n-1) as country_list
group by 1
order by 2 desc 
limit 5;
```
### Problem 5: Identify the Longest Movie
- *Objective:* Find the movie with the longest duration.
```sql
select 
	movie_type, 
	title, 
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS duration_in_min -- Cast to convert the extracted string to number
from netflix_dataset
where movie_type = "movie"
order by 3 desc
limit 1;
```

### Problem 6: Find Content Added in the Last 5 Years
- *Objective:* Retrieve content added to Netflix in the last 5 years.
```sql
select show_id, title, date_added from netflix_dataset
where str_to_date(date_added, '%M %d, %y') >= DATE_SUB(current_date(), INTERVAL 5 year);
```

### Problem 7: Find All Movies/TV Shows by Director 'Stephen Kijak'
Objective: List all content directed by 'Stephen Kijak'.
```sql
drop table if exists di_numbers;
CREATE TEMPORARY TABLE di_numbers AS (
  select 1 as n
  union select 2
  union select 3
  union select 4
  union select 5
  union select 6
  union select 7 
  union select 8
  union select 9
  union select 10
); -- make sure the temporary table cover enough comma in country

select title, movie_type, seperated_director
from
	(select show_id, title, movie_type, substring_index(substring_index(director, ',', n), ',', -1) as seperated_director
		from netflix_dataset
	join di_numbers 
	on char_length(director) - char_length(replace(director, ',', '')) >= n-1) as new_list
WHERE LOWER(seperated_director) LIKE '%stephen kijak%';
```

### Problem 8: List All TV Shows with More Than 5 Seasons
- *Objective:* Identify TV shows with more than 5 seasons.
```sql
select movie_type, title, duration from netflix_dataset
where CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5 and movie_type = 'TV Show';
```

### Problem 9: Count the Number of Content Items in Each Genre
- *Objective:* Count the number of content items in each genre

```sql
drop table if exists new_category;
create temporary table new_category AS (
  select 1 as n
  union select 2
  union select 3
  union select 4
  union select 5
  union select 6
  union select 7 
  union select 8
  union select 9
  union select 10);
  
select count(show_id), seperated_category
from (
select show_id, title, substring_index(substring_index(listed_in, ',', n), ',', -1) as seperated_category 
from netflix_dataset 
join new_category 
on char_length(listed_in) - char_length(replace(listed_in, ',', '')) >= n-1) as category
group by 2
order by 1 desc;
```

### Problem 10: Find each year and the average numbers of content release in India on Netflix. Return top 5 year with highest avg content release!
- *Objective:* Calculate and rank years by the average number of content releases by India.
```sql
SELECT YEAR(STR_TO_DATE(date_added, '%M %d %Y')) AS year, COUNT(*) AS total_releases 
from netflix_dataset
WHERE LOWER(country) = 'india'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### Problem 11: List All Movies that are Documentaries
- *Objective:* Retrieve all movies classified as documentaries.
```sql
drop table if exists new_category;
create temporary table new_category AS (
  select 1 as n
  union select 2
  union select 3
  union select 4
  union select 5
  union select 6
  union select 7 
  union select 8
  union select 9
  union select 10);
  
select show_id, seperated_category, title
from
(select show_id, title, substring_index(substring_index(listed_in, ',', n), ',', -1) as seperated_category 
from netflix_dataset 
join new_category 
on char_length(listed_in) - char_length(replace(listed_in, ',', '')) >= n-1) as category
where upper(seperated_category) like '%Documentaries%';
```

### Problem 12: Find All Content Without a Director
- *Objective:* List content that does not have a director.
```sql
select * from netflix_dataset
where director is null or TRIM(director) = '';
```

### Problem 13: Find How Many Movies Actor 'Julie Delpy' Appeared in the Last 10 Years
- *Objective:* Count the number of movies featuring 'Salman Khan' in the last 10 years.
```sql
select * from netflix_dataset
where upper(cast) like '%Julie Delpy%'
	And str_to_date(date_added, '%M %d, %y') > DATE_SUB(current_date(), INTERVAL 10 year);
```

### Problem 14: 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
- *Objective:* Identify the top 10 actors with the most appearances in Indian-produced movies.
```sql
-- where upper(cast) like '%Julie Delpy%'
-- 	And str_to_date(date_added, '%M %d, %y') > DATE_SUB(current_date(), INTERVAL 10 year);


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
drop table if exists new_actor;
create temporary table new_actor AS (
  select 1 as n
  union select 2
  union select 3
  union select 4
  union select 5
  union select 6
  union select 7 
  union select 8
  union select 9
  union select 10
  union select 11
  union select 12
  union select 13
  union select 14
  union select 15);
  
select show_id, movie_type, title, country, seperated_actor from
(select show_id, movie_type, title, country, substring_index(substring_index(cast, ',', n), ',', -1) as seperated_actor 
from netflix_dataset 
join new_actor
on char_length(cast) - char_length(replace(cast, ',', '')) >= n-1) as actor
where movie_type = 'Movie' and country = 'India';
```

### Problem 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
- *Objective:* Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
```sql
select * from netflix_dataset
where lower(movie_description) like '%kill%' or '%violence%';
```
## FINDING: 
- Content Distribution: The dataset includes a varied selection of movies and television series with various ratings and genres
- Ratings: help you determine the content's intended demographic
- Geographical Insights: The top nations and average content releases from India demonstrate regional content dispersion
- Content Categorisation: Categorising content using certain keywords aids in understanding the nature of the content accessible on Netflix.

   
