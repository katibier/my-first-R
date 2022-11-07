# R code example
# input x, weights w
x <- c(1, 2, 3)
w <- c(0.5, -0.4, 0.25); w0 <- 0.1

# neurons workout the sum
weighted_sum <- w0 + sum(x*w)

# ReLU activation
output <- max(0, weighted_sum)

# MSE (Mean Squared Error)
# R code example
actual <- c(9, 9, 8)
prediction <- c(10, 8, 5)
MSE <- mean((actual - prediction)^2)


# iris dataset
# import library
library(dplyr)
library(nnet)
library(NeuralNetTools)

# train test split
set.seed(42)
n <- nrow(iris)
shuffle_iris <- iris %>%
    sample_n(n, replace = FALSE)

iris_train <- shuffle_iris[1:120,]
iris_test <- shuffle_iris[121:150,]

# model training
nn_model <- nnet(Species ~ .,
                 data = iris_train,
                 size = 3)

# plot network
plotnet(nn_model)

# summary
summary(nn_model)

# model evalution
p <- predict(nn_model, newdata = iris_test, type = "class")
mean(p == iris_test$Species)








