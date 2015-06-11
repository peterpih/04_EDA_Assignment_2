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
baltimoreEmission$fips <- "Baltimore"

LACounty <- "06037"
lacountyEmission <- subset(emission, emission$fips == LACounty)     # emissions data for only LA County
lacountyEmission$fips <- "LACounty"

combo_emission <- rbind(baltimoreEmission, lacountyEmission)
#
#
# Merge the classifications with the Baltimore data to get the labels, then screen on "Highway Veh"
#
combo_emission_scc <- merge(combo_emission, sourceClass, by.x="SCC", by.y="SCC", all.x=TRUE)
#
#
# NOTE: assuming "Highway Veh" this is sufficent for this exercise to identify vehicle usage
#
shortNames <- combo_emission_scc$Short.Name
vehicle_filter <- grepl("^Highway Veh", shortNames, ignore.case=TRUE)
#
vehicle_emission_scc <- subset(combo_emission_scc, vehicle_filter)
#
# Loop over years and the two areas to compare
#
result <- data.frame()
years <- unique(vehicle_emission_scc$year)
for (i in years){
    year_subset <- subset(vehicle_emission_scc, vehicle_emission_scc$year == i)
    fips <- unique(year_subset$fips)
    for (k in fips){
        fips_subset <- subset(year_subset, year_subset$fips == k)
        t_sum <- sum(fips_subset$Emissions)
        result <- rbind(result, data.frame(year=i, fips = k, emission=t_sum))
    }
}
#
# Plot the results in side by side charts
#
g<-ggplot(result, aes(year, emission)) + geom_line() + facet_grid(.~fips) + labs(title="LA County vs Baltimore Vehicle Emission")
print(g)
#
# Save the plot
#
dev.copy(png, file="plot6.png")
dev.off()
