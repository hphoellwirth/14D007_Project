# ----------------------------------------------------------------------
# Information
# ----------------------------------------------------------------------

# Data Visualization Project
# CSV to JSON converter
#
# (Author) Hans-Peter Höllwirth
# (Date)   22.03.2017


# ----------------------------------------------------------------------
# Loading data
# ----------------------------------------------------------------------

# house cleaning
rm(list = ls())
par(mfrow=c(1,1))

# load libraries
library(openxlsx)
library(rjson)
library(RJSONIO)
library(jsonlite)

# if interactive, during the development, set to TRUE
interactive <- TRUE
if (interactive) {
    setwd("/Users/Hans-Peter/Documents/Masters/14D007/project/data")
} 

# load data
data = read.xlsx("military.xlsx", sheet = 1, colNames = TRUE)

# ----------------------------------------------------------------------
# Convert to list
# ----------------------------------------------------------------------
N <- length(unique(data[,"name"]))
ldata <-vector("list",N)

for(i in 1:N) {
    #print(unique(data[,"name"])[i])
    
    name <- unique(data[,"name"])[i]
    region <- unique(data[data$name==name, c("region")])
    print(region)
    
    df.gdp.captiva <- data[data$name==name, c("gdp_captiva_year","gdp_captiva")]
    df.gdp <- data[data$name==name, c("gdp_year","gdp")]
    df.me <- data[data$name==name, c("me_year","me")]
    
    # remove NA rows
    gdp.captiva <- data.matrix(df.gdp.captiva[complete.cases(df.gdp.captiva),])
    gdp <- data.matrix(df.gdp[complete.cases(df.gdp),])
    me <- data.matrix(df.me[complete.cases(df.me),])
    
    lctry <- list(name=name, region=region, gdpCaptiva=gdp.captiva, gdp=gdp, militaryExp=me)
    #ldata <- list(ldata, lctry)
    ldata[[i]] <- lctry
}


# ----------------------------------------------------------------------
# Convert to JSON
# ----------------------------------------------------------------------
json <- toJSON(ldata, container=c(FALSE, FALSE, TRUE, TRUE, TRUE),
               .withNames=TRUE, pretty=TRUE)
write(json, "military.json")



