library(plyr)
library(tidyverse)
library(splitstackshape)
library(magrittr)


# read in -----------------------------------------------------------------
raw.data <- read_csv('https://raw.githubusercontent.com/brian-cuny/607project3/master/multipleChoiceResponses.csv', na=c('', 'NA')) %>%
  subset(DataScienceIdentitySelect == 'Yes' & CodeWriter == 'Yes') %>%
  rowid_to_column('id') 



# tidy --------------------------------------------------------------------
tidy.names <- names(raw.data)[61:66] %>% 
  str_extract('(?<=LearningCategory)(\\w+)') %>% 
  str_replace_all('(?<=[a-z])([A-Z])', '_\\1') %>% 
  tolower()

tidy.data <- raw.data %>%
  select(c(1, 61:66)) %>%
  setNames(c('id', tidy.names)) %>%
  gather('category', 'percent', 2:7, na.rm=TRUE) %T>%
  write_csv('learning_category.csv')

tidy.data$percent %<>% as.numeric()

tidy.data$category %<>% factor(levels=tidy.names, ordered=TRUE)


# summarize ---------------------------------------------------------------
tidy.summary.data <- tidy.data %>% 
  group_by(category) %>% 
  summarise(avg=mean(percent), sd=sd(percent))


# displays ----------------------------------------------------------------
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
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  labs(x='Learning Source', 
       y='Proportion',
       title='Data Scientists Learn From Diverse Sources',
       fill='Percent'
  )

ggplot(tidy.data) +
  geom_boxplot(aes(category, percent)) +
  xlim(tidy.names %>% rev()) +
  coord_flip() + 
  labs(x='Learning Source', 
       y='Proportion',
       title='Data Scientists Learn From Diverse Sources'
  )