# Load packages
library(dplyr)
library(stringr)

# Download data
dataurl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
datafile <- "data.csv.bz2"
download.file(dataurl, datafile, method = "curl")

# Loading the data
stormdata <- read.csv(datafile)

# Tidying up the data
### Extract records from 1996
tidydata <- mutate(stormdata,
                   Year = as.numeric(format(as.Date(stormdata$BGN_DATE, format = "%m/%d/%Y %H:%M:%S"), "%Y")))
tidydata <- filter(tidydata, Year > 1995)

## Fixing the property damage and crop damage columns
### Replace the exponent identifiers to numerical exponents
exponents <- data.frame(sort(unique(tidydata$PROPDMGEXP)))
exponents <- cbind(exponents, c(0, 10^0, 10^9, 10^3, 10^6))
colnames(exponents) <- c("identifier", "value")
tidydata$PROPDMGEXP <- exponents$value[match(tidydata$PROPDMGEXP, exponents$identifier)]
tidydata$CROPDMGEXP <- exponents$value[match(tidydata$CROPDMGEXP, exponents$identifier)]

### Merge PROPDMG/CROPDMG & their respective exponent values to one column
tidydata <- tidydata %>%
        mutate(PropertyDmg = PROPDMG * PROPDMGEXP,
               CropDmg = CROPDMG * CROPDMGEXP) %>%
        select(-(c(PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP)))

### Fix EVTYPE labels
source("EVType_fixer.R")
events <- c("ASTRONOMICAL LOW TIDE", "AVALANCHE", "BLIZZARD", "COASTAL FLOOD", 
            "COLD/WIND CHILL", "DEBRIS FLOW", "DENSE FOG", "DENSE SMOKE", 
            "DROUGHT", "DUST DEVIL", "DUST STORM", "EXCESSIVE HEAT", 
            "EXTREME COLD/WIND CHILL", "FLASH FLOOD", "FLOOD", "FROST/FREEZE", 
            "FUNNEL CLOUD", "FREEZING FOG", "HAIL", "HEAT", "HEAVY RAIN", "HEAVY SNOW", 
            "HIGH SURF", "HIGH WIND", "HURRICANE(TYPHOON)", "ICE STORM", "LAKE-EFFECT SNOW", 
            "LAKESHORE FLOOD", "LIGHTNING", "MARINE HAIL", "MARINE HIGH WIND", 
            "MARINE STRONG WIND", "MARINE THUNDERSTORM WIND", "RIP CURRENT", "SEICHE", 
            "SLEET", "STORM SURGE/TIDE", "STRONG WIND", "THUNDERSTORM WIND", "TORNADO", 
            "TROPICAL DEPRESSION", "TROPICAL STORM", "TSUNAMI", "VOLCANIC ASH", "WATERSPOUT", 
            "WILDFIRE", "WINTER STORM", "WINTER WEATHER", "SUMMARY")
### Removing summary values
tidydata <- tidydata %>%
        mutate(EVTYPE = ifelse(EVTYPE %in% events, EVTYPE, "OTHERS")) %>%
        filter(EVTYPE != "SUMMARY")

# Analysing health impact
stormfatal <- tidydata %>%
        select(EVTYPE, FATALITIES) %>%
        group_by(EVTYPE) %>%
        summarise(TotalFatalities = sum(FATALITIES)) %>%
        arrange(desc(TotalFatalities))

storminj <- tidydata %>%
        select(EVTYPE, INJURIES) %>%
        group_by(EVTYPE) %>%
        summarise(TotalInjuries = sum(INJURIES)) %>%
        arrange(desc(TotalInjuries))

fatal10 <- head(stormfatal, 10)
inj10 <- head(storminj, 10)

# Analysing economic impact
stormdmg <- tidydata %>%
        select(EVTYPE, PropertyDmg, CropDmg) %>%
        mutate(OverallDmg = PropertyDmg + CropDmg) %>%
        group_by(EVTYPE) %>%
        summarise(TotalDmg = sum(OverallDmg)) %>%
        arrange(desc(TotalDmg))

dmg10 <- head(stormdmg, 10)

# Plotting values
par(mai=c(1,2.5,1,1))
barplot(fatal10$TotalFatalities, 
        names.arg = fatal10$EVTYPE, 
        xlab = "Total Fatalities", 
        col = "#FE7F9C", 
        main = "Top 10 Weather Events with Most Fatalities", 
        horiz = TRUE, 
        las = 1)

barplot(inj10$TotalInjuries, 
        names.arg = inj10$EVTYPE, 
        xlab = "Total Injuries", 
        col = "#B19CD9", 
        main = "Top 10 Weather Events with Most Injuries", 
        horiz = TRUE, 
        las = 1)

barplot(dmg10$TotalDmg, 
        names.arg = dmg10$EVTYPE, 
        xlab = "Total Injuries", 
        col = "#B0DFE5", 
        main = "Top 10 Weather Events with Most Damage", 
        horiz = TRUE, 
        las = 1)