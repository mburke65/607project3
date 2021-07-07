# - Common Job Algorithms: Rose
# - CA WorkDatasetSize
# - CB WorkAlgorithmsSelect
# - EC WorkMethodsSelect
# - ED-FJ WOrkMethodsFrequency

library(tidyverse)

raw.data <- read_csv("https://raw.githubusercontent.com/brian-cuny/607project3/master/multipleChoiceResponses.csv", na = c('')) %>%
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

# Visualization
library(data.table)
library(ggplot2)

## Which algorithms are used the most?
alg.select.dt <- as.data.table(alg.select.dt)
alg.total <- nrow(na.omit(alg.select.dt))
alg.vis <- na.omit(alg.select.dt)[, .(count = length(id)), by = .(algorithm)][order(-count)]
alg.vis$perc <- paste0(round((alg.vis$count / alg.total) * 100, 2), "%")

ggplot(alg.vis, aes(reorder(algorithm, count), count, fill = algorithm)) + 
  geom_text(aes(label = perc), hjust = -0.5, size = 3, color = "black") +
  guides(fill=FALSE) +
  geom_bar(stat = 'identity') +
  coord_flip() + 
  labs(title = "Algorithm used by data scientists",
       x = "algorithm",
       y = "proportion") 


## Which methods are used the most??
method.select.dt <- as.data.table(method.select.dt)
method.total <- nrow(na.omit(method.select.dt))
method.vis <- na.omit(method.select.dt)[, .(count = length(id)), by = .(method)][order(-count)]
method.vis$perc <- paste0(round((method.vis$count / method.total) * 100, 2), "%")


ggplot(method.vis, aes(reorder(method, count), count, fill = method)) + 
  geom_text(aes(label = perc), hjust = -0.5, size = 3, color = "black") +
  guides(fill=FALSE) +
  geom_bar(stat = 'identity') +
  coord_flip() + 
  labs(title = "Method used by data scientists",
       x = "method",
       y = "proportion") 


## method by frequency
freq.dt <- as.data.table(freq.dt)
freq.dt <- freq.dt[, .(count = .N), by = .(Frequency, WorkMethodsFrequency,WorkDatasetSize)]
method.freq <- freq.dt[, .(count = sum(count)), by = .(WorkMethodsFrequency, Frequency)][order(-count)]
size.freq <- freq.dt[, .(count = sum(count)), by = .(WorkDatasetSize, Frequency)][order(-count)]

### method by frequency
ggplot(na.omit(method.freq), aes(reorder(WorkMethodsFrequency, count), count, fill = WorkMethodsFrequency)) +
  guides(fill=FALSE) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle= 90, hjust=1)) +
  coord_flip() +
  facet_wrap(~Frequency) +
  labs(title = "Method used by frequency",
       x = "work methods",
       y = "count")

### data size by frequency
ggplot(na.omit(size.freq), aes(reorder(WorkDatasetSize, count), count, fill = WorkDatasetSize)) +
  guides(fill=FALSE) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle= 90, hjust=1)) +
  coord_flip() +
  facet_wrap(~Frequency) +
  labs(title = "Datasetsize used by frequency",
       x = "dataset size",
       y = "count")

### method by size (total count > 25)
ggplot(na.omit(freq.dt[count>25]), aes(reorder(WorkMethodsFrequency, count), count, fill = WorkMethodsFrequency)) +
  guides(fill=FALSE) +
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(angle= 90, hjust=1)) +
  coord_flip() +
  facet_wrap(~WorkDatasetSize) +
  labs(title = "Method used per data size",
       x = "work methods",
       y = "count")

