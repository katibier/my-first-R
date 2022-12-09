## Part 1
install.packages(c("tidyverse", "caret", "mlbench", "rpart", "ranger", "randomForest"))
library(tidyverse)
library(caret)
library(mlbench)

## example linear regression
head(mtcars)

# mpg = f(hp, wt, am ) = b0 + b1*hp + b2*wt + b3*am
model_lm <- lm(mpg ~ hp + wt + am, data = mtcars)
model_lm

# caret interface
set.seed(42)
model_lm_caret <- train(mpg ~ .,
                        data = mtcars,
                        method = "lm") # algorithm 

model_lm_caret$finalModel

x <- c(2,3)
y <- c(6,8)
sqrt( sum(x-y)**2 )


## your first model - knn
## load data set BostonHousing

data("BostonHousing")

## 1. Split Data
df <- BostonHousing

n <- nrow(df)
set.seed(42)
id <- sample(1:n, size = n*0.8)
train_df <- df[id, ]
test_df <- df[-id, ]
nrow(train_df); nrow(test_df)

train_test_split <- function(df, train_size = 0.8) {
    set.seed(42)
    n <- nrow(df)
    id <- sample(1:n, size = n*train_size)
    train_df <- df[id, ]
    test_df <- df[-id, ]
    return( list(train=train_df, test=test_df) )
}

split_data <- train_test_split(BostonHousing, 0.7)
train_df <- split_data$train
test_df <- split_data$test

## 2. Train Model
set.seed(42)

grid_k <- data.frame(k = 2:9)

ctrl <- trainControl(
    method = "boot",
    number = 200 # 200 - 300 raps
)
# https://topepo.github.io/
ctrl <- trainControl(
    method = "LOOCV"
)

ctrl <- trainControl(
    method = "cv", # k-fold cross validation
    number = 5 
)

ctrl <- trainControl(
    method = "repeatedcv", # k-fold cross validation
    number = 5,
    repeats = 5
)


knn_model <- train(medv ~ crim + rm + tax + zn + nox,
                   data = train_df,
                   method = "knn",
                   metric = "RMSE",
                   tuneGrid  = grid_k,
                   trControl = ctrl) # absolute (tuneLength = 5)

## Predict Train Data
pred_medv_train <- predict(knn_model)
train_rmse <- sqrt(mean((train_df$medv - pred_medv_train)**2))

## 3. Test Model
## Scoring => Prediction
pred_medv <- predict(knn_model, newdata = test_df)

test_rmse <- sqrt(mean((test_df$medv - pred_medv)**2))

# higher K => underfit ,, lower K => overfit, optimal K ?

## Save Model
saveRDS(knn_model, "knn_model_25June2022_v1.RDS")

## Load Model
knn_model <- readRDS("knn_model_25June2022_v1.RDS")
 

## Part 2

data("BostonHousing")

df <- BostonHousing

train_test_split <- function(df, train_size = 0.8) {
    set.seed(42)
    n <- nrow(df)
    id <- sample(1:n, size = n*train_size)
    train_df <- df[id, ]
    test_df <- df[-id, ]
    return( list(train=train_df, test=test_df) )
}

## 1. Split Data
set.seed(42)
split_data <- train_test_split(BostonHousing, 0.8)
train_df <- split_data$train
test_df <- split_data$test


## 2. Train Model K-Fold CV
set.seed(42)
ctrl <- trainControl(
    method = "cv",
    number = 5,
    verboseIter = TRUE
)

knn_full_model <- train(
    medv ~ .,
    data = train_df,
    method = "knn",
    metric = "RMSE",
    tuneLength = 5,
    trControl = ctrl
)

knn_model <- train(
    medv ~ .,
    data = train_df %>%
        select(-age, -dis, -chas),
    method = "knn",
    metric = "RMSE",
    preProcess = c("center", "scale"),
    tuneLength = 5,
    trControl = ctrl
)


## Variable Importance
varImp(knn_model)

## 3. Test Model
p <- predict(knn_model, newdata=test_df)
RMSE(p, test_df$medv)


## Binary Classification

data("Sonar")
head(Sonar)
glimpse(Sonar)
table(Sonar$Class)

## missing value?
mean(complete.cases(Sonar))

## preview data
Sonar %>% head()

## 1. split data
set.seed(42)
id <- createDataPartition(y = Sonar$Class, 
                        p = 0.7, 
                        list = FALSE)

train_df <- Sonar[id, ]
test_df <- Sonar[-id, ]

## 2. train model
## Logistic Regression
set.seed(42)

ctrl <- trainControl(
    method = "cv",
    number = 3,
    verboseIter = TRUE
)

logistic_model <- train(Class ~.,
                        data = train_df,
                        method = "glm",
                        trControl = ctrl)

knn_model <- train(Class ~.,
                   data = train_df,
                   method = "knn",
                   trControl = ctrl)

rf_model <- train(Class ~.,
                  data = train_df,
                  method = "rf",
                  trControl = ctrl)

## compare three models
result <- resamples(
    list(
        logisticReg = logistic_model,
        knn = knn_model,
        randomForest = rf_model
        )
    )

summary(result)

varImp(logistic_model)

## 3. test model
p <- predict(logistic_model, newdata = test_df)
p

p == test_df$Class
mean(p == test_df$Class)

## Confusion Matrix
table(p, test_df$Class, dnn=c("Prediction", "Actual"))

## Accuracy 
(25+19) / (25+10+8+19)

## Recall
25 / (25 +8)

## Precision
25 / (25 + 10)

## F1 Score (Harmonic Mean of Recall + Precision)
recall <- 25 / (25 +8)
precision <- 25 / (25 + 10)
f1_score <- 2*recall*precision / (precision+recall)

## test 109-110
recall_test <- 105 / (105 + 13)
precision_test <- 105 / (105 + 38)
f1_score_test <- 2*recall_test*precision_test / (precision_test+recall_test)

confusionMatrix(p, test_df$Class, mode = "prec_recall")


# Pima Indian Diabetes

data("PimaIndiansDiabetes")

## complete ?
## taget/ label

df <- PimaIndiansDiabetes

checks_complete <- function(df) mean(complete.cases(df))

checks_complete(df)

## glimpse data
glimpse(df)
df %>% count(diabetes)
df %>% 
    count(diabetes) %>%
    mutate(pct = n/sum(n))

## 1. split data
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)

train_df <- df[id, ]
test_df <- df[-id, ]
nrow(train_df)
nrow(test_df)

## 2. train data
set.seed(42)

ctrl <- trainControl(
    method = "cv",
    number = 5,
    classProbs = TRUE, # important accuracy -> ROC
    summaryFunction = twoClassSummary,
    verboseIter = TRUE
)

logistic_model <- train(
    diabetes ~ .,
    data = train_df,
    method = "glm",
    metric = "Accuracy",
    preProcess = c("center", "scale"),
    trControl = ctrl
)

rf_model <- train(
    diabetes ~ .,
    data = train_df,
    method = "rf",
    metric = "ROC",
    preProcess = c("center", "scale"),
    trControl = ctrl
)


## 3. test data
p <- predict(rf_model, newdata = test_df)
mean(p == test_df$diabetes)

confusionMatrix(p, test_df$diabetes,
                positive = "pos",
                mode = "prec_recall")



y <- mtcars$mpg
X <- mtcars[, 2:4]

# model training - 01
set.seed(42)
train(mpg ~ cyl + disp + hp,
      data = mtcars,
      method = "lm")

# model training - 02 (X, y)
set.seed(42)
train(X, y, method = "lm")

## CHURN prediction
## not use accuracy


# Pima Indian Diabetes
data("PimaIndiansDiabetes")

df <- PimaIndiansDiabetes

## glimpse data
glimpse(df)

## 1. split data
set.seed(42)
id <- createDataPartition(y = df$diabetes,
                          p = 0.8,
                          list = FALSE)

train_df <- df[id, ]
test_df <- df[-id, ]

## 2. train model
set.seed(99)

myGrid <- data.frame(cp = seq(0.001, 0.3, by=0.005))

tree_model <- train(diabetes ~ .,
                    data = train_df,
                    method = "rpart",
                    tuneLength = 10,
                    trControl = trainControl(
                        method = "cv",
                        number = 5
                    ))

tree_model <- train(diabetes ~ .,
                    data = train_df,
                    method = "rpart",
                    tuneGrid = myGrid,
                    trControl = trainControl(
                        method = "cv",
                        number = 5
                    ))

tree_model$finalModel

# rpart.plot
library(rpart.plot)
library(MLmetrics)


rpart.plot(tree_model$finalModel)

## 2. train model
set.seed(99)

myGrid <- data.frame(mtry = 2:7)

rf_model <- train(diabetes ~ .,
                    data = train_df,
                    method = "rf",
                    metric = "AUC",
                    preProcess = c("center", "scale", "nzv"),
                    tuneGrid = myGrid,
                    trControl = trainControl(
                        method = "cv",
                        number = 5,
                        verboseIter = TRUE,
                        classProbs = TRUE,
                        summaryFunction = prSummary
                    ))

p <- predict(rf_model, newdata = test_df)
confusionMatrix(p,
                test_df$diabetes,
                mode = "prec_recall",
                positive = "pos")




## ridge / lasso regression

df %>% glimpse()

## train model
## help with overfitting
set.seed(42)

# alpha=0 ridge (use overfitting)
# alpha=1 lasso (use feature selection + overfitting)
myGrid <- expand.grid(alpha = 0:1,
                      lambda = seq(0.001, 1, length=20))

regularized_model <- train(
    diabetes ~ .,
    data = train_df,
    method = "glmnet",
    tuneGrid = myGrid,
    trControl = trainControl(
        method = "cv",
        number = 5,
        verboseIter = TRUE
    )
)

## test model
p <- predict(regularized_model, newdata = test_df)

confusionMatrix(p, test_df$diabetes,
                mode = "prec_recall",
                positive = "pos")


























