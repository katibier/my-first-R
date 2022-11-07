## comment
## intro to R programming

1+1
2*2
5-3
10-6
print("hello world")

income <- 45000
expense <- 26000
saving <- income - expense
print(saving)

# saving data in RAM 

# remove variable
rm(expense)
rm(saving)

# create your own function
greeting <- function() {
    print("hello world")
}

my_sum <- function(a,b) {
    return(a + b)
}

my_sum <- function(a,b) {
    a + b
}

my_sum2 <- function(a,b) a+b
greeting2 <- function() print("hello world")

## control flow
# if, for, while

# 1. if

score <- 75 

if (score >= 80) {
    print("Passed")
} else {
    print("Failed")
}

if (score >= 90) {
    print("A")
} else if (score >= 80) {
    print("B")
} else if (score >= 70) {
    print("C")
} else {
    print("D")
}

# function grade

grading <- function(score) {
    if (score >= 90) {
        return("A")
    } else if (score >= 80) {
        return("B")
    } else if (score >= 70) {
        return("C")
    } else {
        return("D")
    }  
}

# 2. for loop
for (i in 1:10) {
    print(i)
}

for (i in 1:10) {
    print("hello world")
}

# five student scores
scores <- c(95, 50, 88, 72, 75)
for (score in scores) {
    print(grading(score))
}

scores <- scores + 2
(scores <- scores - 10)

# while loop
count <- 0

while (count < 10) {
    print("hello")
    count <- count + 1
}

# guess animal name

username <- readline("What's your name: ")
print(username)

animal <- "hippo"

while (TRUE) {
    user_input <- readline("Guess animal: ")
    if (user_input == animal) {
        print("Congratulations! your guess is correct!")
        break
    } else {
        print("Your guess is incorrect. Please try again")
    }
}

# fuction animal game
guess_animal_game <- function(animal) {
    while (TRUE) {
        user_input <- readline("Guess animal: ")
        if (user_input == animal) {
            print("Congratulations! your guess is correct!")
            break
        } else {
            print("Your guess is incorrect. Please try again")
        }
    }   
}

# username password login application

login_fn <- function() {
    username <- "toyeiei"
    password <- "1234"
    
    # get input from user
    un_input <- readline("Username: ")
    pw_input <- readline("Password: ")
    
    # check username, password
    if (username == un_input & password == pw_input) {
        print("Thank you! You have successfully login.")
    } else {
        print("Sorry, please try again")
    }
}

# tolower()
# toupper()

### HOMEWORK assignment - 01 a user can try 3 times attempt to login.

login_fn <- function() {
    username <- "toyeiei"
    password <- "1234"
    count <- 0
    
    # get input from user
    while (count < 3) {
        un_input <- readline("Username: ")
        pw_input <- readline("Password: ")
        
        # check username, password
        if (username == un_input & password == pw_input) {
            print("Thank you! You have successfully login.")
            break
        } else {
            print("Sorry, please try again")
            count <- count + 1
        }  
    }
}

# if else
score <- 95
ifelse(score >= 80, "Passed", "Failed")

score <- c(95, 90, 78, 56, 82)
ifelse(score >= 80, "Passed", "Failed")

## Data Types
## numeric, character, logical, factor

friends <- c("toy", "ink", "aan", "top", "wan")
length(friends)
friends[1]
friends[2]
friends[3]
friends[4]
friends[5]
friends[6] ## NA
friends[1:3]
friends[4,5]
friends[ c(1, 3, 5) ]
friends[ c(5, 2, 4) ] # subset, index
class(friends)

ages <- c(33, 30, 34, 28, 25)
movie_lover <- c(T, T, F, T, F)
class(ages)
class(movie_lover)

# nominal factor
jobs <- c("data", "data", "digital", "digital", "phd")
jobs <- factor(jobs)
class(jobs)

# ordinal factor
handsome_degree <- c("low", "medium", "high", "high", "high")
handsome_degree <- factor(handsome_degree, 
                          levels = c("low", "medium", "high"),
                          ordered = TRUE)

class(handsome_degree)
handsome_degree

## create dataframe
length(friends)
friends <- data.frame(friend_id = 1:5,
                 friends,
                 ages,
                 movie_lover,
                 jobs,
                 handsome_degree)
class(df)

## Write CSV file
write.csv(df, "friends.csv", row.names = F)

## Read CSV file
df <- read.csv("friends.csv")

## Read CSSV file from internet
url <- "https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv"

mtcars_df <- read.csv(url) 
View(mtcars_df)

friends
friends[1:3, ]
friends[4:5, ]
friends[1:3, 1:3]
friends[1:3, 4:5]
friends[, c(2, 4, 5)]

# subset by condition
friends$ages < 30
friends[ friends$ages < 30, 2:5 ]
friends[ friends$movie_lover, 2:5 ]
friends$jobs == "digital"
friends[ friends$jobs == "digital", ]
friends[ friends$jobs != "digital", ]

friends$jobs %in% c("data", "digital")
friends[friends$jobs %in% c("data", "digital"), ]

# subset by name
friends[ , c("friends", "ages", "movie_lover")]
cond1 <- friends$jobs == "data"
cond2 <- friends$movie_lover == TRUE

friends[cond1 & cond2, ]
friends[cond1 | cond2, ]

# Stat
ages <- friends$ages
sum(ages); median(ages); min(ages); max(ages); sd(ages); var(ages)

# create new column
friends
friends$segment <- ifelse(friends$ages >= 30, "Old", "Young")

table(friends$segment)
table(friends$jobs)
ncol(friends)
nrow(friends)

table(friends$segment) / nrow(friends)

table(friends$jobs)
table(friends$jobs) / nrow(friends)

# summary dataframe
summary(friends)

str(friends)
friends$segment <- factor(friends$segment)
str(friends)

friends$jobs == "data"
friends[friends$jobs == "data", ]

# drop column
friends_subset <- friends[ , 1:5]
friends_subset

friends
friends$handsome_degree <- NULL
friends$segment <- NULL

# Regular Expression
state.name
grep("^A", state.name) # return index
grep("^S", state.name)
state.name[ grep("^S", state.name) ]
grep("^s", state.name, ignore.case = TRUE)

x <- grepl("^S", state.name) # return true/false
sum(x)
x <- grepl("^[ABS]", state.name) # return true/false
sum(x)

grep("^[ABS]", state.name, value = TRUE)

# replace value
gsub("South", "Dragon", state.name)

# matrix
matrix(1:25, ncol=5)
matrix(1:25, ncol=5, byrow = TRUE)
m <- matrix(1:10, ncol =2)
m
nrow(m)
ncol(m)
m * 2
# matrix multiplication .dot notation
m1 <- matrix(c(1,5,3,6), ncol=2)
m1
m2 <- matrix(c(2,4,5,5), ncol=2)
m2
m1 + m2
m1 * m2
m1 %*% m2

# list
john <- list(
    fullname = "John Davis",
    age = 26,
    city = "London",
    email = "john.davis@gmail.com"
)
john["fullname"] # key
john$fullname # value

marry <- list(
    fullname = "Marry Anne",
    age = 22,
    city = "Liverpool",
    email = "marry.anne@gmail.com"
)

# nested list
customers <- list(john = john, marry = marry)
customers

customers$john$fullname

kevin <- list(
    fullname = "Kevin Herst",
    age = 25,
    city = "USA",
    email = "kevin.h@gmail.com",
    movies = c("Batman", "Dark Knight", "Dr.Strange")
)


customers <- list(john = john, marry = marry, kevin = kevin)
customers[["kevin"]] # customers$kevin

