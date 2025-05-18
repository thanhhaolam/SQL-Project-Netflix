# An analysis on Netflix TV shows and Moives using SQL 
![logo](https://akm-img-a-in.tosshub.com/indiatoday/images/story/202012/Netflix-New-Feature-Audio-Only_1200x768.jpeg?size=690:388)
## OBJECTIVE: 
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
## Dataset
- The data is collected on Kaggle [dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
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

### Problem 4: 
4. Find the Top 5 Countries with the Most Content on Netflix
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

