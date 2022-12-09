## install pakages
## install.packages("dplyr")

## load package
library(dplyr)

## read csv file into RStudio
imdb <- read.csv("imdb.csv", stringsAsFactors = FALSE)
View(imdb)

## review data structure
glimpse(imdb)

## print head and tail of data
head(imdb, 10)
tail(imdb, 10)

## Select columns
head(imdb)
names(imdb)
select(imdb, MOVIE_NAME, RATING)
select(imdb, 1 ,5)

## new name column
select(imdb, movie_name = MOVIE_NAME, released_year = YEAR)

## pipe operator (7-8 step)
head(imdb)
imdb %>% head()
imdb %>% 
    select(movie_name = MOVIE_NAME, released_year = YEAR) %>%
    head(10) 

## filter numeric columns
filter(imdb, SCORE >= 9.0)
 
imdb %>% filter(SCORE >= 9.0)

names(imdb) <- tolower(names(imdb))
head(imdb)

imdb %>% 
    select(movie_name, year, score) %>%
    filter(score >= 9 & year > 2000)

imdb %>% 
    select(movie_name, length, score) %>%
    filter(score == 8.8 | score == 8.3 | score == 9.0)

imdb %>%
    select(movie_name, length, score) %>%
    filter(score %in% c(8.3, 8.8, 9.0))

## filter string columns
imdb %>%
    select(movie_name, genre, rating) %>%
    filter(rating == "R")
imdb %>%
    select(movie_name, genre, rating) %>%
    filter(rating == "PG-13")
imdb %>%
    select(movie_name, genre, rating) %>%
    filter(grepl("Drama", imdb$genre))

imdb %>%
    select(movie_name) %>%
    filter(grepl("King", imdb$movie_name))

## Mutate (create) new columns
imdb %>%
    select(movie_name, score, length) %>%
    mutate(score_group = if_else(score >= 9, "High Rating", "Low Rating"),
           length_group = if_else(length >= 120, "Long Film", "Short Film"))

imdb %>%
    select(movie_name, score) %>%
    mutate(score_update = score + 0.1) %>%
    head(10)

imdb %>%
    select(movie_name, score) %>%
    mutate(score = score + 0.1) %>%
    head(10)

## Arrange Data
head(imdb)
imdb %>%
    arrange(desc(length)) %>% ## descending order
    head(10)

imdb %>%
    select(movie_name, year, rating, length) %>%
    arrange(rating, desc(length))

imdb %>%
    filter(!is.na(rating)) %>%
    arrange(rating, desc(length))

## summarise and group_by
imdb %>%
    filter(rating != "") %>%
    group_by(rating) %>%
    summarise(mean_length = mean(length),
              sum_length = sum(length),
              sd_length = sd(length),
              min_length = min(length),
              max_length = max(length),
              n = n())

# Join Table
favourite_films <- data.frame(id = c(5, 10, 25, 30, 98))

favourite_films %>%
    inner_join(imdb, by = c("id" = "no"))

## write csv file (export result)
imdb_prep <- imdb %>%
    select(movie_name, released_year = year, rating, length, score) %>%
    filter(rating == "R" & released_year > 2000)

## export file
write.csv(imdb_prep, "imdb_prep2.csv", row.names = FALSE)










