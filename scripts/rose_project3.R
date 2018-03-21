# - Common Job Algorithms: Rose
# - CA WorkDatasetSize
# - CB WorkAlgorithmsSelect
# - EC WorkMethodsSelect
# - ED-FJ WOrkMethodsFrequency

library(tidyverse)


raw.data <- read_csv("C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\607project3\\multipleChoiceResponses.csv", na = c('')) %>%
  subset(DataScienceIdentitySelect == 'Yes' & CodeWriter == 'Yes') %>%
  rowid_to_column('id')

raw.data <- as.data.table(raw.data)

# Filter
data.rose <- raw.data %>%
  select(c(1, 80:81, 134:167))

# Make long format
tidy.names <- c(names(data.rose)[1:4], 
                names(data.rose)[5:37] %>% 
                  str_extract('(?<=WorkMethodsFrequency)(.+)')
                )

melt.dt <- data.rose %>%
  setNames(tidy.names) %>%
  gather('WorkMethodsFrequency', 'Frequency', 5:37)

# seperate WorkAlgorithmsSelect as independent table
alg.select <- melt.dt %>%
  select(c('id', 'WorkAlgorithmsSelect'))
alg.select.list <- alg.select$WorkAlgorithmsSelect %>%
  strsplit(split = ",")
alg.select.dt <- tibble(id = rep(alg.select$id, sapply(alg.select.list, length)), 
                            algorithm = unlist(alg.select.list))

# separate WorkMethodsSelect as independent table
method.select <- melt.dt %>%
  select(c('id', 'WorkMethodsSelect'))
method.select.list <- method.select$WorkMethodsSelect %>%
  as.character() %>% 
  strsplit(split = ",")
method.select.dt <- tibble(id = rep(method.select$id, sapply(method.select.list, length)), 
                               method = unlist(method.select.list))

# Subset the rest
freq.dt <- melt.dt %>%
  select(c('id', 'WorkDatasetSize', 'WorkMethodsFrequency', 'Frequency'))

# final data set sep in 3 tables
head(freq.dt)
head(alg.select.dt)
head(method.select.dt)

