#
# This program is part of the Exploratory Data Analysis Assignment #1 
#
# Read in the data for emissions and classifications
# This program assumes the data is in a subdirectory named "data/"
#
rm(list=ls())
#
emissionFile <- "data/SummarySCC_PM25.rds"
sourceClassFile <- "data/Source_Classification_Code.rds"
#
emission <- readRDS(emissionFile)
sourceClass <- readRDS(sourceClassFile)
#
###############################################################################################
#
# Filter out Baltimore emissions only
#
Baltimore <- "24510"
baltimoreEmission <- subset(emission, emission$fips == Baltimore)
#
# Aggregate the data by year to see what the emission trend has been
#
# This loop will subset() by year and sum emissions then save (year, emission) into result
#
result <- data.frame()
years <- unique(baltimoreEmission$year)
for (i in years){
    year_subset <- subset(baltimoreEmission, i == baltimoreEmission$year)
  
    types <- unique(year_subset$type)
    for (k in types){
      
        type_subset <- subset(year_subset, k == year_subset$type)
        
        t_sum <- sum(type_subset$Emission)
        result <- rbind(result, data.frame(year=i, type=k, emission=t_sum))
  }
}
#
# Plot the result in multipanels by type
#
png(filename = "3.png", width = 800, height = 480, units = "px")
#
g<-ggplot(result, aes(year, emission)) + geom_line() + facet_grid(.~type) + labs(title="Baltimore Emission Types")
print(g)
#
# Save the plot
#
dev.off()