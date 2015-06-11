#
# This program is part of the Exploratory Data Analysis Assignment #1 
#
# Read in the data for emissions and classifications
#
emissionFile <- "data/SummarySCC_PM25.rds"
sourceClassFile <- "data/Source_Classification_Code.rds"
#
emission <- readRDS(emissionFile)
sourceClass <- readRDS(sourceClassFile)
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
years <- unique(baltimoreEmission$year)            # what years are included in the data
result <- data.frame()                    # initialize the output data frame
for (i in years){                         # loop over each year
    x <- subset(baltimoreEmission, i == baltimoreEmission$year)
    se <- sum(x$Emission)
    result <- rbind(result, data.frame(year=i, emission=se))
}
#
# Plot the graph 
#
plot(result$emission ~ result$year, type="b", xlab="Year", ylab="Aggregate Emission",main="Baltimore Emission Trend")
#
# Save the graph
dev.copy(png, file="plot2.png")
dev.off()



baltimoreResult <- data.frame()
years <- unique(baltimoreEmission$year)
for (i in years){
    x <- subset(baltimoreEmission, i == baltimoreEmission$year)
  
    types <- unique(x$type)
    for (k in types){
        x2 <- subset(x, k == x$type)
        se <- sum(x2$Emission)
        baltimoreResult <- rbind(baltimoreResult, data.frame(year=i, type=k, emission=se))
    }
}

g<-ggplot(baltimoreResult, aes(year, emission)) + geom_line() + facet_grid(.~type) + labs(title="Baltimore Emission Types")
print(g)

plot(baltimoreResult$emission ~ baltimoreResult$year, xlab="Year", ylab="Baltimore Emission", type="b")

qplot(year, emission, data=baltimoreResult, facets=. ~ type)
+ geom_line()


qplot(year, Emissions, data=baltimoreEmission, facets=. ~ type)

#
# Get the Coal SCC codes
#
# first process the SCCs to get all Coal related
#
q_u<-unique(sourceClass$Short.Name)
q_coal <- q_u[grepl("Coal", q_u, ignore.case=TRUE)] #Coal
#
# Within Coal, get different combustion usages as opposed to shipping or storage
#
f1 <- grepl("Ext Comb", q_coal, ignore.case=TRUE)
f2 <- grepl("In-Process Fuel Use", q_coal, ignore.case=TRUE)
f3 <- grepl("Stationary Fuel Comb", q_coal, ignore.case=TRUE)
#
# Now get the Coal SCCs from the SCC file
#
coal_factors <- q_coal[f1 | f2 | f3]    # qq will have all the factor names
coal_subset <- subset(sourceClass, sourceClass$Short.Name %in% coal_factors)
coal_scc <- coal_subset$SCC
#
# And make Coal subset() from the emissions file
#
coal_emission <- subset(emission, emission$SCC %in% coal_scc)
#
# Now get each of the SCCs
coal_result <- data.frame()
coal_scc = unique(coal_emission$SCC)
years <- unique(coal_emission$year)
for (i in years){
    t <- subset(coal_emission, coal_emission$year == i)
    t_sum <- sum(t$Emissions)
    coal_result <- rbind(coal_result, data.frame(year=i, emission=t_sum))
}

plot(coal_result$year, coal_result$emission)


w <- subset(sourceClass, sourceClass$Short.Name %in% qq)


x.df[x.df$y %in% c(1, 4), ]

