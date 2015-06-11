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
Baltimore <- "24510"                                                # this is the Baltimore fips ID
baltimoreEmission <- subset(emission, emission$fips == Baltimore)   # emissions data for only Baltimore
#
#
# Merge the classifications with the Baltimore data to get the labels, then screen on "Highway Veh"
#
baltimore_emission_scc <- merge(baltimoreEmission, sourceClass, by.x="SCC", by.y="SCC", all.x=TRUE)
#
#
# NOTE: assuming "Highway Veh" this is sufficent for this exercise to identify vehicle usage
#
shortNames <- baltimore_emission_scc$Short.Name
vehicle_filter <- grepl("^Highway Veh", shortNames, ignore.case=TRUE)
#
vehicle_emission_scc <- subset(baltimore_emission_scc, vehicle_filter)
#
# Loop to the get yearly sums
#
result <- data.frame()
years <- unique(vehicle_emission_scc$year)
for (i in years){
  year_subset <- subset(vehicle_emission_scc, vehicle_emission_scc$year == i)
  t_sum <- sum(year_subset$Emissions)
  result <- rbind(result, data.frame(year=i, emission=t_sum))
}
#
# Plot the results
#
plot(result$year, result$emission, xlab="Year", ylab="Emission", main="Baltimore Vehicle Emission", type="b")
#
# Save the plot
#
dev.copy(png, file="plot5.png")
dev.off()
