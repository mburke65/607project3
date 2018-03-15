# - Common Job Algorithms: Rose
# - CA WorkDatasetSize
# - CB WorkAlgorithmsSelect
# - EC WorkMethodsSelect
# - ED-FJ WOrkMethodsFrequency

library(readr)
library(tidyr)
library(tidyverse)

raw.data <- read_csv("https://raw.githubusercontent.com/brian-cuny/607project3/master/multipleChoiceResponses.csv", na = c('')) %>%
  subset(DataScienceIdentitySelect == 'Yes' & CodeWriter == 'Yes') %>%
  rowid_to_column('id')

raw.data <- as.data.table(raw.data)

# Filter
data.rose <- raw.data[DataScienceIdentitySelect == 'Yes'][CodeWriter == "Yes"][, .(id, WorkDatasetSize,WorkAlgorithmsSelect,WorkMethodsSelect,
                                           `WorkMethodsFrequencyA/B`,	
                                           WorkMethodsFrequencyAssociationRules,	
                                           WorkMethodsFrequencyBayesian,	
                                           WorkMethodsFrequencyCNNs,	
                                           WorkMethodsFrequencyCollaborativeFiltering,
                                           `WorkMethodsFrequencyCross-Validation`,
                                           WorkMethodsFrequencyDataVisualization,	
                                           WorkMethodsFrequencyDecisionTrees,
                                           WorkMethodsFrequencyEnsembleMethods,	
                                           WorkMethodsFrequencyEvolutionaryApproaches,	
                                           WorkMethodsFrequencyGANs,
                                           WorkMethodsFrequencyGBM,
                                           WorkMethodsFrequencyHMMs,
                                           WorkMethodsFrequencyKNN,
                                           WorkMethodsFrequencyLiftAnalysis,
                                           WorkMethodsFrequencyLogisticRegression,
                                           WorkMethodsFrequencyMLN,
                                           WorkMethodsFrequencyNaiveBayes,	
                                           WorkMethodsFrequencyNLP,
                                           WorkMethodsFrequencyNeuralNetworks,
                                           WorkMethodsFrequencyPCA,
                                           WorkMethodsFrequencyPrescriptiveModeling,
                                           WorkMethodsFrequencyRandomForests,
                                           WorkMethodsFrequencyRecommenderSystems,
                                           WorkMethodsFrequencyRNNs,
                                           WorkMethodsFrequencySegmentation,
                                           WorkMethodsFrequencySimulation,
                                           WorkMethodsFrequencySVMs,
                                           WorkMethodsFrequencyTextAnalysis,
                                           WorkMethodsFrequencyTimeSeriesAnalysis,
                                           WorkMethodsFrequencySelect1,
                                           WorkMethodsFrequencySelect2,
                                           WorkMethodsFrequencySelect3)]

# Make long format
melt.dt <- melt(data.rose, id.vars = c("id","WorkDatasetSize","WorkAlgorithmsSelect","WorkMethodsSelect"),
                variable.name = "WorkMethodsFrequency",
                value.name = "Frequency")


# seperate WorkAlgorithmsSelect as independent table
alg.select <- melt.dt[, .(id,WorkAlgorithmsSelect)]
alg.select.list <- strsplit(alg.select$WorkAlgorithmsSelect, split = ",")
alg.select.dt <- data.table(id = rep(alg.select$id, sapply(alg.select.list, length)), 
                            algorithm = unlist(alg.select.list))

# separate WorkMethodsSelect as independent table
method.select <- melt.dt[, .(id,WorkMethodsSelect)]
method.select.list <- strsplit(as.character(method.select$WorkMethodsSelect), split = ",")
method.select.dt <- data.table(id = rep(method.select$id, sapply(method.select.list, length)), 
                               method = unlist(method.select.list))

# Subset the rest
freq.dt <- melt.dt[, .(id, WorkDatasetSize,WorkMethodsFrequency,Frequency)]

# final data set sep in 3 tables
head(freq.dt)
head(alg.select.dt)
head(method.select.dt)

