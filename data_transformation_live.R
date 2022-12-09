library(tidyverse)
library(sqldf)
library(jsonlite)
library(RSQLite)
library(RPostgreSQL)
library(glue)

## Data Transformation +50% upskill
## dplyr => grammar of data manipulation

View(mtcars)
rownames(mtcars)

## 5 functions 
## 1. select() => SELECT
## 2. filter() => WHERE
## 3. arrange() => ORDER BY
## 4. mutate() => SELECT .. AS newColumn
## 5. summarise() + group_by()

select(mtcars, 1:5)
select(mtcars, 1:3, 5, 10)
select(mtcars, mpg, wt, hp, 10:11)

select(mtcars, starts_with("a"))
select(mtcars, starts_with("h"))
select(mtcars, ends_with("p"))
select(mtcars, contains("a"))
select(mtcars, carb, everything())

# create new column
mtcars$model <- rownames(mtcars)
head(mtcars)
rownames(mtcars) <- NULL

mtcars <- select(mtcars, model, everything())

## Data Pipeline %>% (Pipe operator)
tibble(mtcars)

mtcars %>% 
    select(mpg, hp, wt) %>%
    filter(hp < 100 & wt < 2)

mtcars %>% 
    select(mpg, hp, wt) %>%
    filter(hp < 100 | wt < 2)

m1 <- mtcars %>%
    select(mpg, hp, wt) %>%
    filter(hp < 100 | wt < 2) %>%
    arrange(desc(hp))

summary(m1)

## filter data == WHERE SQL
mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    filter(mpg >= 25 & mpg <= 30)

mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    filter(between(mpg, 25, 30))

mtcars %>%
    select(model, cyl) %>%
    filter(cyl %in% c(4,6) )

grep("^M", models)
grep("^M", models, value = T)
grepl("^M", models)

mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    filter(grepl("^M", model))

## mutate() create new column

mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    mutate(hp_segment = if_else(hp<100, "low", 'high')) %>%
    head(10)

## CASE WHEN in SQL ?
m2 <- mtcars %>%
    select(model, mpg, hp, wt, am) %>%
    mutate(hp_segment = if_else(hp<100, "low", 'high'),
           hp_segment2 = case_when(
               hp < 100 ~ 'low',
               hp < 200 ~ 'medium',
               TRUE ~ 'high' # other ELSE
           )) %>%
    filter(hp >= 200)
View(m2)

## glimpse data structure
str(mtcars) # old
glimpse(mtcars) # new

## am => 0 = Auto, 1 = Manual
mtcars %>%
    select(model, am) %>%
    mutate(am = if_else(am == 0, "Auto", "Manual")) %>%
    head(10)

mtcars %>%
    select(model, am) %>%
    mutate(am = if_else(am == 0, "Auto", "Manual")) %>%
    count(am)

mtcars <- mtcars %>%
    mutate(am = if_else(am == 0, "Auto", "Manual"),
           vs = if_else(vs == 0, "V-Shaped", "Straight"))
View(mtcars)

## count
mtcars %>%
    count(am)

mtcars %>%
    count(vs)

m3 <- mtcars %>%
    count(am, vs)  %>%
    mutate(percent = n/ nrow(mtcars))

View(m3)

## Read Write CSV Files
write_csv(m3, "summary_mtcars.csv")

rm(m3)
 
m3 <- read_csv("summary_mtcars.csv")
m3 <- as.data.frame(m3)
m3 <- as_tibble(m3)

## Change Data Types
mtcars %>%
    select(model, mpg, vs, am) %>%
    mutate(vs = as.factor(vs),
           am = as.factor(am)) %>%
    glimpse()

mtcars <- mtcars %>%
    mutate(vs = as.factor(vs),
           am = as.factor(am))
glimpse(mtcars)

## Data Wrangling
## Data Transformation

## summarise() + group_by()
mtcars %>%
    summarise(
        avg_mpg = mean(mpg),
        sum_mpg = sum(mpg),
        min_mpg = min(mpg),
        max_mpg = max(mpg),
        var_mpg = var(mpg),
        sd_mpg  = sd(mpg),
        median_mpg = median(mpg),
        n = n()
    )

mtcars %>%
    group_by(am, vs) %>%
    summarise(
        avg_mpg = mean(mpg),
        sum_mpg = sum(mpg),
        min_mpg = min(mpg),
        max_mpg = max(mpg),
        var_mpg = var(mpg),
        sd_mpg  = sd(mpg),
        median_mpg = median(mpg),
        n = n()
    ) -> result

result
write_csv(result, "result.csv")
 

## JOIN TABLES
band_members
glimpse(band_members)
band_instruments

inner_join(band_members,
           band_instruments,
           by = "name")

left_join(band_members,
          band_instruments,
          by = "name")

right_join(band_members,
          band_instruments,
          by = "name")

full_join(band_members,
           band_instruments,
           by = "name")

## refactor (max 8-10 data pipline)
band_members %>%
    full_join(band_instruments,
              by = "name") %>%
    filter(name %in% c("John", "Paul")) %>%
    mutate(hello = "OK") 

## library load package
library(nycflights13)

flights
View(flights)
glimpse(flights)

flights %>%
    filter(month == 9, day == 15) %>%
    count(origin, dest)

flights %>%
    filter(between(month, 3, 5) & origin == "JFK") %>%
    count(carrier) %>%
    arrange(desc(n))

flights %>%
    filter(origin == "JFK" &
           month %in% c(3,4,5)) %>%
    count(carrier) %>%
    arrange(desc(n))

flights %>%
    filter(origin == "JFK" &
           month %in% c(3,4,5)) %>%
    count(carrier) %>%
    arrange(desc(n))

airlines
df <- flights %>%
    filter(origin == "JFK" &
               month %in% c(3,4,5)) %>%
    count(carrier) %>%
    arrange(desc(n)) %>%
    left_join(airlines, by='carrier')

write_csv(df, "requested_data.csv")

## Mock up data
## One-to-One
student <- data.frame(
    id = 1:5,
    name = c("toy", "joe", "anna", "mary", "kevin"),
    cid = c(1,2,2,3,2),
    uid = c(1,1,1,2,2)
)

course <- data.frame(
    course_id = 1:3,
    course_name = c("Data", "R", "Python")
)

student %>%
    left_join(course, by = c("cid" = "course_id")) %>%
    filter(course_name == "R") %>%
    select(name, course_name)

university <- data.frame(
    uid = 1:2,
    uname = c("University of London", "Chula University")
)

student; course; university

## JOIN more than two tables
df <- student %>%
    left_join(course, by = c("cid" = "course_id")) %>%
    left_join(university, by = "uid") %>%
    select(student_name = name, 
           course_name, 
           university_name = uname)

write_csv(df, "studentProfile.csv")


## Wide format use in report 
WorldPhones
## Long format is the best in data analysis

## wide -> Long format transformation
long_worldphones <- WorldPhones %>%
    as.data.frame() %>%
    rownames_to_column(var = "Year") %>%
    pivot_longer(N.Amer:Mid.Amer, 
                 names_to = "Region",
                 values_to = "Sales")

long_worldphones %>%
    filter(Region == "Asia")

long_worldphones %>%
    group_by(Region) %>%
    summarise(total_sales = sum(Sales))

## long -> wide format
wide_data <- long_worldphones %>%
    pivot_wider(names_from = "Region",
                values_from = "Sales")

write_csv(wide_data, "data.csv")

## Connect SQL database
## 1. SQLite
## 2. PostgreSQL sever
library(RSQLite)
library(RPostgreSQL)

## steps to connect database
## create connection > query > close con

con <- dbConnect(SQLite(), "chinook.db")

dbListTables(con) 
dbListFields(con, "customers")
dbGetQuery(con, "
            SELECT
                firstname, 
                lastname, 
                country 
           FROM customers
           WHERE country IN ('France', 'Austria', 'Belgium')")

query01 <- "
    SELECT * FROM artists
    JOIN albums ON artists.artistid = albums.artistid
    JOIN tracks ON tracks.albumid = albums.albumid 
"

tracks <- dbGetQuery(con, query01)
View(tracks)

tracks %>%
    select(Composer, Milliseconds, Bytes, UnitPrice) %>%
    filter(Milliseconds > 200000,
           grepl("^C", Composer)) %>%
    summarise(
        sum(Bytes),
        sum(UnitPrice)
    )

## Quit
dbDisconnect(con)
con

# dbConnect
# dbListTables
# dbListFields
# dbGetQuery
# dbDisconnect

nrow(tracks)

# library janitor
names(tracks)
library(janitor)
tracks_clean <- clean_names(tracks)

## sample data n=10
tracks_clean %>%
    sample_n(10) %>%
    View()

set.seed(42)
tracks_clean %>%
    select(1:2) %>%
    sample_n(10) 

### R connect to PostgreSQL
## username, password, host (sever), port, dbname
library(RPostgreSQL)
con <- dbConnect(PostgreSQL(),
                 user = "qxinexas",
                 password = "U1ZkKp4u4PJFODNSqdYRgd4KvNgjGgkg",
                 host = "topsy.db.elephantsql.com",
                 port = 5432,
                 dbname = "qxinexas")

dbListTables(con)

course <- data.frame(
    id = 1:3,
    name = c("Data Science", "SOftware", "R")
)

dbWriteTable(con, "course", course)
dbListTables(con)

dbGetQuery(con, "select * from course;")
dbRemoveTable(con, "course")
dbListTables(con)

dbWriteTable(con, "course", data.frame(
    id = 1:5,
    course_name = c("Data", "Software", "Design", "R", "SQL")
), row.names = FALSE)

dbListTables(con)
dbGetQuery(con, "select * from course;")

dbDisconnect(con)


## Test
mtcars %>%
    select(starts_with("a"))

select(mtcars, hp, wt, am)

mtcars %>%
    select(hp, wt, am)

mtcars %>%
    select(1, 2:5, 10)

mtcars %>%
    head(5)

mtcars %>%
    select(11, everything())


## test confusion matrix
# Precision
pre = 105 / (105 + 38)

# Recall
rec = 105 / (105 + 13)

# F1 Score
2 *((pre * rec) / (pre + rec))

## mean mtcars all column
apply(mtcars, 1, mean)
apply(mtcars, 2, mean() )
apply(mtcars, 3, mean)
apply(mtcars, 2, mean) # collect

