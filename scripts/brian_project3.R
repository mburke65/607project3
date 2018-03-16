library(plyr)
library(tidyverse)
library(splitstackshape)
library(magrittr)


raw.data <- read_csv('https://raw.githubusercontent.com/brian-cuny/607project3/master/multipleChoiceResponses.csv', na=c('', 'NA')) %>%
  subset(DataScienceIdentitySelect == 'Yes' & CodeWriter == 'Yes') %>%
  rowid_to_column('id') 

tidy.data <- raw.data %>%
  select(c(1, 61:66)) %>%
  setNames(c('id', names(.)[2:7] %>% str_extract('(?<=LearningCategory)(\\w+)') %>% tolower())) %>%
  gather('category', 'percent', 2:7, na.rm=TRUE) %T>%
  write_csv('learning_category.csv')

tidy.data$percent %<>% as.numeric()

tidy.data$category %<>% factor(levels=c('selfttaught', 'university', 'onlinecourses', 'work', 'kaggle', 'other'), ordered=TRUE)

ggplot(tidy.data) +
  geom_histogram(aes(percent), binwidth=10) +
  facet_wrap(~category) + 
  labs(x='Percent', 
       y='Frequency',
       title='Temporary Header'
  )



ggplot(tidy.data) +
  geom_bar(aes(category, fill=percent %>% round_any(10) %>% factor(seq(0, 100, 10))), position=position_fill(reverse=TRUE)) +
  scale_color_brewer(palette='Set1') + 
  labs(x='Learning Source', 
       y='Proportion',
       title='Data Scientists Learn From Diverse Sources'
  )

tidy.summary.data <- tidy.data %>% 
  group_by(category) %>% 
  summarise(avg=mean(percent), sd=sd(percent))

g <- ggplot(data.frame(x=c(-50, 150)), aes(x))

for(i in 1:length(tidy.summary.data$avg)){
  g <- g + stat_function(fun=dnorm, args=list(mean=tidy.summary.data$avg[i], sd=tidy.summary.data$sd[i]), color=c('red', 'blue', 'green', 'black', 'orange', 'yellow')[i]) 
  
}
g

ggplot(tidy.data) +
  geom_boxplot(aes(category, percent))




