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
# Get the Coal SCC codes
#
# first process the SCCs to get all Coal related
#
scc_class<-unique(sourceClass$Short.Name)
coal_class <- scc_class[grepl("Coal", scc_class, ignore.case=TRUE)] #Coal
#
#
# Within Coal, get the different combustion usages as opposed to shipping or storage
#
f1 <- grepl("Ext Comb", coal_class, ignore.case=TRUE)
f2 <- grepl("In-Process Fuel Use", coal_class, ignore.case=TRUE)
f3 <- grepl("Stationary Fuel Comb", coal_class, ignore.case=TRUE)
coal_labels <- coal_class[f1 | f2 | f3]
#
# Now get the Coal SCCs from the SCC file
#

coal_subset <- subset(sourceClass, sourceClass$Short.Name %in% coal_labels)
coal_scc <- coal_subset$SCC
#
# And make Coal subset() from the emissions file
#
coal_emission <- subset(emission, emission$SCC %in% coal_scc)
#
# Now get each of the SCCs
#
result <- data.frame()
coal_scc = unique(coal_emission$SCC)
years <- unique(coal_emission$year)
for (i in years){
  emission_subset <- subset(coal_emission, coal_emission$year == i)
  
  t_sum <- sum(emission_subset$Emissions)
  result <- rbind(result, data.frame(year=i, emission=t_sum))
}
#
# Plot the result
#
plot(result$year, result$emission, xlab="Year", ylab="Emission", main="Coal Combustion Emission", type="b")
#
# Save the graph
#
dev.copy(png, file="plot4.png")
dev.off()
