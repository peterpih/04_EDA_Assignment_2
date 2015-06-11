
emissionFile <- "data/SummarySCC_PM25.rds"
sourceClassFile <- "data/Source_Classification_Code.rds"

emission <- readRDS(emissionFile)
sourceClass <- readRDS(sourceClassFile)

result <- data.frame()
years <- unique(emission$year)
for (i in years){
    x <- subset(emission, i == emission$year)
    se <- sum(x$Emission)
    result <- rbind(result, data.frame(year=i, emission=se))
}

plot(result$emission ~ result$year, type="b", xlab="Year", ylab="Emission")

#
# Baltimore
#
Baltimore <- "24510"

baltEmission <- subset(emission, emission$fips == Baltimore)

baltResult <- data.frame()
years <- unique(baltEmission$year)
for (i in years){
  x <- subset(baltEmission, i == baltEmission$year)
  se <- sum(x$Emission)
  baltResult <- rbind(baltResult, data.frame(year=i, emission=se))
}

plot(baltResult$emission ~ baltResult$year, xlab="Year", ylab="Baltimore Emission", type="b")


#
# Coal Sources
#

sum(grepl("Coal", q_u, ignore.case=TRUE))


"Ext Comb"
"In-Process Fuel Use"
"Stationary Fuel Comb"



