# Library Call
library(tidyverse)
library(tidymodels)
library(skimr)

train <- read_csv('data/train.csv')

skim(train)
