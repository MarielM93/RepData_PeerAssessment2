# This script fixes the EVTYPE values in the storm data set.

tidydata$EVTYPE <- toupper(tidydata$EVTYPE)
tidydata$EVTYPE <- str_trim(tidydata$EVTYPE, side = "left")
tidydata$EVTYPE <- gsub("TSTM", "THUNDERSTORM", tidydata$EVTYPE)
tidydata$EVTYPE[grep("SUMMARY", tidydata$EVTYPE)] <- "SUMMARY"
tidydata$EVTYPE[grep("COAST|CSTL|TIDAL", tidydata$EVTYPE)] <- "COASTAL FLOODING"
tidydata$EVTYPE[grep(
        "^(RECORD|EXTREME|UNSEASONABL[EY]|SEVERE|PROLONG|EXCESSIVE|EXTENDED|UNUSUALLY|UNSEASONALLY|UNSEASONAL).*(COLD|COOL|LOW)",
        tidydata$EVTYPE)] <- "EXTREME COLD/WIND CHILL"
tidydata$EVTYPE[grep("^(COLD|COOL|HYPO)", tidydata$EVTYPE)] <- "COLD/WIND CHILL"
tidydata$EVTYPE[grep("WIND.?CHILL", tidydata$EVTYPE)] <- "COLD/WIND CHILL"
tidydata$EVTYPE[grep("(SLIDE|SLUMP)", tidydata$EVTYPE)] <- "DEBRIS FLOW"
tidydata$EVTYPE[grep("ICE FOG", tidydata$EVTYPE)] <- "FREEZING FOG"
tidydata$EVTYPE[grep("^.OG", tidydata$EVTYPE)] <- "DENSE FOG"
tidydata$EVTYPE[grep("PATCHY DENSE FOG", tidydata$EVTYPE)] <- "DENSE FOG"
tidydata$EVTYPE[grep("SMOKE", tidydata$EVTYPE)] <- "DENSE SMOKE"
tidydata$EVTYPE[grep("SNOW DROUGHT", tidydata$EVTYPE)] <- "DROUGHT"
tidydata$EVTYPE[grep("LOW RAINFALL", tidydata$EVTYPE)] <- "DROUGHT"
tidydata$EVTYPE[grep("DRY|DRIEST", tidydata$EVTYPE)] <- "DROUGHT"
tidydata$EVTYPE[grep("DEV", tidydata$EVTYPE)] <- "DUST DEVIL"
tidydata$EVTYPE[grep("DUST$", tidydata$EVTYPE)] <- "DUST STORM"
tidydata$EVTYPE[grep("(EXCESSIVE|RECORD|PROLONG) (HEAT|WARM|HIGH)", 
                      tidydata$EVTYPE)] <- "EXCESSIVE HEAT"
tidydata$EVTYPE[grep("^(HEAT|WARM|HOT|HYPER)", tidydata$EVTYPE)] <- "HEAT"
tidydata$EVTYPE[grep("(UNSEASONABLY|ABNORMAL|UNUSUAL|UNUSUALLY|VERY) (HOT|WARM)", 
                     tidydata$EVTYPE)] <- "HEAT"
tidydata$EVTYPE[grep("(ICE JAM|STREET|URBAN|FLASH|SNOWMELT|STREAM).*(FLOOD|FLDG|FLD)",
                     tidydata$EVTYPE)] <- "FLASH FLOOD"
tidydata$EVTYPE[grep("(MINOR|RIVER).*FLOOD", tidydata$EVTYPE)] <- "FLOOD"
tidydata$EVTYPE[grep("^FLOOD", tidydata$EVTYPE)] <- "FLOOD"
tidydata$EVTYPE[grep("(SLEET|(FREEZING (RAIN|DRIZZLE|PRECIP)))",
                     tidydata$EVTYPE)] <- "SLEET"
tidydata$EVTYPE[grep("^(?=.*(FREEZ(E|ING)|FROST))(?!.*FOG)",
                     tidydata$EVTYPE,
                     perl = TRUE)] <-"FROST/FREEZE"
tidydata$EVTYPE[grep("FU", tidydata$EVTYPE)] <- "FUNNEL CLOUD"
tidydata$EVTYPE[grep("^(?=.*HAIL)(?!.*MARINE)",
                     tidydata$EVTYPE,
                     perl = TRUE)] <- "HAIL"
tidydata$EVTYPE[grep("RAIN|PRECIP|WET", tidydata$EVTYPE)] <- "HEAVY RAIN"
tidydata$EVTYPE[grep("^(?=.*SNOW)(?!.*LAKE)",
                     tidydata$EVTYPE, 
                     perl = TRUE)] <- "HEAVY SNOW"
tidydata$EVTYPE[grep("SURF", tidydata$EVTYPE)] <- "HIGH SURF"
tidydata$EVTYPE[grep("HURRICANE|TYPHOON", tidydata$EVTYPE)] <- "HURRICANE(TYPHOON)"
tidydata$EVTYPE[grep("ICE", tidydata$EVTYPE)] <- "ICE STORM"
tidydata$EVTYPE[grep("LAKE.*SNOW", tidydata$EVTYPE)] <- "LAKE-EFFECT SNOW"
tidydata$EVTYPE[grep("RIP", tidydata$EVTYPE)] <- "RIP CURRENT"
tidydata$EVTYPE[grep("SURGE", tidydata$EVTYPE)] <- "STORM SURGE/TIDE"
tidydata$EVTYPE[grep("^(?=.*STORM)(?!.*NON|MARINE|WINTER|ICE|SURGE|TROPICAL|DUST)",
                     tidydata$EVTYPE,
                     perl = TRUE)] <- "THUNDERSTORM WIND"
tidydata$EVTYPE[grep("TORNADO", tidydata$EVTYPE)] <- "TORNADO"
tidydata$EVTYPE[grep("LANDSPOUT", tidydata$EVTYPE)] <- "TORNADO"
tidydata$EVTYPE[grep("^(?=.*ASH)(?!.*FLOOD)",
                     tidydata$EVTYPE,
                     perl = TRUE)] <- "VOLCANIC ASH"
tidydata$EVTYPE[grep("SPOUT", tidydata$EVTYPE)] <- "WATERSPOUT"
tidydata$EVTYPE[grep("FIRE", tidydata$EVTYPE)] <- "WILDFIRE"
tidydata$EVTYPE[grep("(WINTER|WINTRY|WINTERY) (WEATHER|MIX)", tidydata$EVTYPE)] <- "WINTER WEATHER"
tidydata$EVTYPE[grep("^(?=.*(HEAVY|STRONG|NON[ -]THUNDERSTORM|LAKE|GUSTY) (WIND|WINDS))(?!.*MARINE)",
                     tidydata$EVTYPE, perl = TRUE)] <- "STRONG WIND"
tidydata$EVTYPE[grep("^(WIND|WND)", tidydata$EVTYPE)] <- "STRONG WIND"
tidydata$EVTYPE[grep("^(?=.*HIGH.*(SWELLS|WIND|WINDS))(?!.*MARINE)",
                     tidydata$EVTYPE, perl = TRUE)] <- "HIGH WIND"
