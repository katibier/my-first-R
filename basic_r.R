## create variables
income <- 50000
expense <- 30000
saving <- income - expense

## remove variable
rm(saving)

## compare values
1 + 1 == 2
2 * 2 <= 4
5 >= 10
5 - 2 != 3 ## not equal
10 < 2
10 > 2

## compare text/ characters
"Hello" == "Hello"

## Data Types

## 1. numeric
age <- 32
print(age)
class(age)

## 2. character
my_name <- "Kati"
my_university <- 'KMUTT'
print(my_name)
print(my_university)
class(my_name); class(my_university)

## 3. logical
result <- 1 + 1 == 2
print(result)
class(result)

## 4. factor
animal <- c("Dog", "Cat", "Cat", "Hippo")
class(animal)

animal <- factor(animal)
class(animal)

## 5. date
time_now <- Sys.time()
class(time_now)

## Convert Data Types

## main functions
## as.numeric()
## as.character()
## as.logical()

x <- 100
class(x)

char_x <- as.character(x)
num_x <- as.numeric(char_x)

## logical: TRUE/ FALSE
as.logical(0)
as.logical(1)
as.numeric(TRUE)
as.numeric(FALSE)

## Data Structures
## 1. Vector
## 2. Matrix
## 3. List
## 4. DataFrame

## -----------------
## Vector

1:10
16:25

## sequence generation
seq(from = 1, to = 100, by = 5)

## help file
help("seq")

## function c
friends <- c("David", "Marry", "Anna", "John", "William")
ages <- c(30, 31, 25, 39, 32)
is_male <- c(TRUE, FALSE, FALSE, TRUE, TRUE)

## Matrix
x <- 1:25
length(x)
dim(x) <- c(5,5)

m1 <- matrix(1:25, ncol=5)
m2 <- matrix(1:6, ncol=3, nrow=2, byrow = T)

## element wise computation
m2 + 100
m2 *4

## List

my_name <- "Toy"
my_friends <- c("Wan", "Ink", "Zue")
m1 <- matrix(1:25, ncol = 5)
R_is_cool <- TRUE

my_list <- list(item1 = my_name,
                item2 = my_friends,
                item3 = m1,
                item4 = R_is_cool)

my_list$item3
my_list$item4

## Data Frame

friends <- c("Wan", "Ink", "Aan", "Bee", "Top")

ages <- c(26, 27, 32, 31, 28)

locations <- c("New York", "London", "London", "Tokyo", "Manchester")

movie_lover <- c(TRUE, TRUE, FALSE, TRUE, TRUE)


df <- data.frame(friends,            
                 ages,
                 locations,
                 movie_lover)
View(df)

friends <- c("Wan", "Ink", "Aan", "Bee", "Top")

ages <- c(26, 27, 32, 31, 28)

locations <- c("New York", "London", "London", "Tokyo", "Manchester")

movie_lover <- c(TRUE, TRUE, FALSE, TRUE, TRUE)

## create dataframe from list
my_list <- list(friends = friends,
                ages = ages,
                locations = locations,
                movie =movie_lover)
data.frame(my_list)


## Subset
## Subset by position
friends[1]
friends[2]
friends[5]
friends[1:3]
friends[4:5]
friends[ c(1,3,5) ]

## Subset by condition
ages
ages[ ages > 30]
ages[ ages <= 30]

## Subset by name
ages
names(ages) <- friends
ages

ages["Wan"]
ages["Top"]
ages[ c("Wan", "Bee", "Aan") ]

## Subset dataframe
# position
df[1, 3]
df[2, 4]
df[1:2, 4]
df[1:2, 2:4]
# name
df[ , "friends"]
df[ , c("friends", "locations")]
# condition
df[ df$movie_lover == TRUE,  ]
df[ df$movie_lover == FALSE,  ]
df[ df$ages < 30,  ]
df[ df$friends == "Top", ]
