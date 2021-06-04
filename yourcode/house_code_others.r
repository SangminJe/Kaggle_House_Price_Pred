library(knitr)
library(ggplot2)
library(plyr)
library(dplyr)
library(corrplot)
library(caret)
library(gridExtra)
library(scales)
library(Rmisc)
library(ggrepel)
library(randomForest)
library(psych)
library(xgboost)
library(tidyverse)
library(tidymodels)

# data load
train <- read.csv("../input/house-prices-advanced-regression-techniques/train.csv", stringsAsFactors = F)
test <- read.csv("../input/house-prices-advanced-regression-techniques/test.csv", stringsAsFactors = F)

all <- bind_rows(train, test) %>% 
  select(-c(PoolQC, Fence, MiscFeature, Alley, SaleType, Id))
  

# EDA
all[!is.na(all$SalePrice),] %>% 
  ggplot(aes(x = SalePrice)) +
  geom_histogram(fill="blue", binwidth = 10000) +
  scale_x_continuous(breaks = seq(0, 800000, by = 100000), labels = comma)

# Get Numeric
numericVars <- which(sapply(all, is.numeric))
numericVarNames <- names(numericVars)

# Correlation
all_numVar <- all[, numericVars]
cor_numVar <- cor(all_numVar, use = 'pairwise.complete.obs') # https://rfriend.tistory.com/tag/use%3D%22pairwise.complete.obs%22
cor_numVar %>% head(5)

cor_sorted <- as.matrix(sort(cor_numVar[,"SalePrice"], decreasing = T))
CorHigh <- names(which(apply(cor_sorted, 1, function(x) abs(x)>0.5)))
cor_numVar <- cor_numVar[CorHigh, CorHigh]

corrplot.mixed(cor_numVar, tl.col="black", tl.pos = "lt")
## matrix로 바꾸고 하는 과정이 너무 귀찮고 지난하다...
## 그냥 데이터 프레임으로 만드는 방법은 없을까?


# Overall Quality
all[!is.na(all$SalePrice),] %>% 
  ggplot(aes(x = factor(OverallQual), y = SalePrice)) +
  geom_boxplot()+
  scale_y_continuous(breaks = seq(0,800000, by=100000), labels = comma)

# Grade Living Area
all[!is.na(all$SalePrice),] %>% 
  ggplot(aes(x = GrLivArea, y = SalePrice)) +
  geom_point()+
  geom_smooth(mothod = 'lm', se = F) +
  geom_text_repel(aes(label = ifelse(all$GrLivArea[!is.na(all$SalePrice)]>4500,
                                     rownames(all), '')))

all[c(524, 1299), c('SalePrice', 'GrLivArea', 'OverallQual')]
## Quality가 좋은데 가격이 낮으므로, Outlier로 처리하는 게 합리적이어 보임

NAcol <- which(colSums(is.na(all)) > 0)
sort(colSums(sapply(all[NAcol], is.na)), decreasing = TRUE)



  

  
