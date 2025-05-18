drop table if exists netflix_dataset;
create table netflix_dataset
	(show_id varchar(10) primary key,
    movie_type varchar(7),
	title varchar(110),
	director varchar(210),
	cast varchar(780),
	country varchar(130),
	date_added varchar(80),
	release_year int(5),	
    rating varchar(10),
	duration varchar(10),
	listed_in varchar(80),
	movie_description varchar(250));

-- check the created table
select * from netflix_dataset
order by show_id asc;

-- Business problems
-- 1. Count the Number of Movies vs TV Shows
select count(show_id), movie_type from netflix_dataset
group by 2
-- 2. Find the Most Common Rating for Movies and TV 
select * from netflix_dataset
-- 3. List All Movies Released in a Specific Year (e.g., 2020)
-- Objective: Retrieve all movies released in a specific year.
-- 4. Find the Top 5 Countries with the Most Content on Netflix
-- 5. Identify the Longest Movie
-- 6. Find Content Added in the Last 5 Years
-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
-- 8. List All TV Shows with More Than 5 Seasons
-- 9. Count the Number of Content Items in Each Genre
-- 10.Find each year and the average numbers of content release in India on netflix.
-- return top 5 year with highest avg content release!
-- 11. List All Movies that are Documentaries
-- 12. Find All Content Without a Director
-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
