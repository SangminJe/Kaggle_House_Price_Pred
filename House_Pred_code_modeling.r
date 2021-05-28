## library

library(tidyverse)
library(tidymodels)
library(skimr)


#### data load
train <- read_csv('data/train.csv')
test <- read_csv('data/test.csv')

all_origin <- bind_rows(train, test)

skim(all_origin) # PoolQC, Fence, Alley, MiscFeature, SaleType가 결측률이 높음

all_origin %>% 
  select(-c(PoolQC, Fence, MiscFeature, Alley, SaleType, Id)) %>% 
  # janitor::clean_names() %>% 
  mutate_if(is.character, as.factor) %>% # Character -> Factor
  mutate(
    MSSubClass = as.factor(MSSubClass), # MSSubClass는 범주형 변수이므로 factor로 변환
    OverallQual = factor(OverallQual, order = T, levels = c(1,2,3,4,5,6,7,8,9,10)),
    OverallCond = factor(OverallCond, order = T, levels = c(1,2,3,4,5,6,7,8,9,10)),
  )-> all

all %>% skim()