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
'''sql
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
'''

### Problem 1: Count the Number of Movies vs TV Shows
- Objective: Determine the distribution of content types on Netflix.
'''sql
  select count(show_id), movie_type from netflix_dataset
  group by 2;
'''

