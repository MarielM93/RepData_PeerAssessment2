# Load packages
library(dplyr)

# Download data
dataurl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
datafile <- "data.csv.bz2"
download.file(dataurl, datafile, method = "curl")

# Loading the data
stormdata <- read.csv(datafile)

# Tidying up the data
### Extract records from 1996
tidydata <- mutate(stormdata, Year = as.numeric(format
                                                (as.Date
                                                        (stormdata$BGN_DATE,
                                                               format = "%m/%d/%Y %H:%M:%S"),
                                                        "%Y")))
tidydata <- filter(tidydata, Year > 1995)

## Fixing the property damage and crop damage columns
### Replace the exponent identifiers to numerical exponents
exponents <- data.frame(sort(unique(tidydata$PROPDMGEXP)))
exponents <- cbind(exponents, c(0, 10^0, 10^9, 10^3, 10^6))
colnames(exponents) <- c("identifier", "value")
tidydata$PROPDMGEXP <- exponents[tidydata$PROPDMGEXP, 2]
tidydata$CROPDMGEXP <- exponents[tidydata$CROPDMGEXP, 2]

### Merge PROPDMG/CROPDMG & their respective exponent values to one column
tidydata <- tidydata %>%
        mutate(PropertyDmg = PROPDMG * PROPDMGEXP,
               CropDmg = CROPDMG * CROPDMGEXP) %>%
        select(-(c(PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP)))

### Fix EVTYPE labels
source("EVType_fixer.R")
