library(neonDivData)
library(dplyr)
library(tidyr)
library(vegan)
library(tibble)


setwd("/home/aly/Beetles/SAEs")

data(data_beetle)

df <- data_beetle

#### Create Species Column ####
df$Species <- ifelse(
  df$taxon_rank == "species",
  paste0(df$taxon_name),
  ifelse(
    df$taxon_rank == "subspecies",
    sub("^(\\S+\\s+\\S+).*", "\\1", df$taxon_name),
    NA
  )
)

df_counts <- df %>%
  filter(
    !is.na(Species),
    variable_name == "abundance",
    observation_datetime >= "2018-01-01",
    observation_datetime <= "2018-12-31"
  ) %>%
  mutate(
    Year = format(as.Date(observation_datetime), "%Y"),
    PlotYear = paste(plotID, Year, sep = "_")
  )

com_matrix <- cast(df_counts[,c("plotID","Species","value")], plotID~Species, sum)
write.csv(com_matrix, "./CommunityMatrix_abund_2018.csv",row.names=FALSE)
