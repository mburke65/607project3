library(plyr)
library(tidyverse)
library(splitstackshape)
library(magrittr)
library(stringr)

raw.data <- read_csv("https://raw.githubusercontent.com/brian-cuny/607project3/master/multipleChoiceResponses.csv", na = c('')) %>%
  subset(DataScienceIdentitySelect == 'Yes' & CodeWriter == 'Yes') %>%
  rowid_to_column('id')
raw.data <- as.data.table(raw.data)



tidy.names <- names(raw.data)[83:132]%>% 
  str_extract('(?<=WorkToolsFrequency)(\\w+)') %>% 
  str_replace_all('(?<=[a-z])([A-Z])', '_\\1') 


# data was very untidy and expanded into two columns passed the "WorkToolsSelect" column. I brought in the 3 columns and replaced elements to ensure a easy split 
tools.data <- raw.data %>%
  select(c(1, 82:84)) %>%
  setNames(c('id', 'tool_used', "temp_1", "temp_2"))%>%
  unite_("tool_used", c("tool_used","temp_1","temp_2"))%>%
  mutate(tool_used = (str_replace_all(tool_used, '/', ',')),
         tool_used = (str_replace_all(tool_used, '_', ',')))%>%
  mutate(tool_counter =1)
tools.data<-cSplit(tools.data, 'tool_used', ',')
head(tools.data,10)


#use the gather function to reformat the table
id.tool.df <- gather(tools.data, tool_group, tool, names(tools.data)[3:63])%>%
  group_by(id, tool)%>%
  summarise(sum_tool = sum(tool_counter))%>%
  drop_na()%>%
  filter(!tool %in% c("Rarely", "Often",
                      "Sometimes", "Most of the time"))
id.tool.df


#use the gather function to reformat the table
summary.tool.df <- gather(tools.data, tool_group, tool, names(tools.data)[3:63])%>%
  group_by(tool)%>%
  summarise(sum_tool = sum(tool_counter))%>%
  drop_na()%>%
  arrange(desc(sum_tool))%>%
  filter(!tool %in% c("Rarely", "Often",
                      "Sometimes", "Most of the time"))%>%
  mutate(percent_total = round((sum_tool/ sum(sum_tool))*100,digits = 2))
summary.tool.df


# plot of the top data science skills given the filters used
ggplot(head(summary.tool.df,15), aes(x=reorder(tool, -sum_tool), y=percent_total)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3") +
  geom_text(aes(label=percent_total))+
  labs(x='Tool', 
       y='Percent Total',
       title="Top 15 Data Science Tools", 
       caption="Source: Multiple Choice Responses") + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

#select the applicable columns and change name 
frequency.data <- raw.data %>%
  select(c(1, 83:132)) %>%
  setNames(c('id', tidy.names))

#Tool frequency by id
id.frquency.table <-gather(frequency.data, tool_name, frequency_id, names(frequency.data)[2:51])%>%
  filter(frequency_id %in% c("Rarely", "Often",
                             "Sometimes", "Most of the time"))%>%
  arrange(id)
id.frquency.table

#grouped the frequency information by the actual tool name & response 
summary.frquency.table <-gather(frequency.data, tool_name, frequency_id, names(frequency.data)[2:51])%>%
  filter(frequency_id %in% c("Rarely", "Often",
                             "Sometimes", "Most of the time"))%>%
  mutate(freq_counter =1) %>%
  group_by(tool_name,frequency_id)%>%
  summarise(sum_feq = sum(freq_counter))%>%
  arrange(desc(sum_feq))
summary.frquency.table

# Plotted the top 50, i need to look into editing so i can show all data
ordering <- c('Most of the time', 'Often', 'Sometimes', 'Rarely')

ggplot(head(summary.frquency.table,50), aes(x = frequency_id, y = sum_feq, fill = tool_name)) + 
  geom_bar(stat = "identity") + 
  facet_wrap(~tool_name) + 
  ylab("Number of times a response was selected") + 
  xlim(ordering) +
  theme(legend.position="none") +
  theme(axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1))