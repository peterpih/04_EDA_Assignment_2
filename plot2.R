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
years <- unique(baltimoreEmission$year)             # what years are included in the data
result <- data.frame()                              # initialize the output data frame
for (i in years){                                   # loop over each year
  year_subset <- subset(baltimoreEmission, i == baltimoreEmission$year)
  t_sum <- sum(year_subset$Emission)
  result <- rbind(result, data.frame(year=i, emission=t_sum))
}
#
# Plot the result
#
plot(result$emission ~ result$year, type="b", xlab="Year", ylab="Aggregate Emission",main="Baltimore Total Emission Trend")
#
# Save the graph
dev.copy(png, file="plot2.png")
dev.off()
