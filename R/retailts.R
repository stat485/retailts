setwd("D:/retailts/")
rm(list=ls())

library(forecast)

#### Note:
####
#### Sales data are adjusted for seasonal, holiday, and
#### trading day differences, but not for price changes
####
#### This code uses auto.arima to suggest a model for each of the data sets
#### under Monthly and Annual Retail Trade (US Census Bureau)

# Retail, and Food Services, total
foodURL <- "https://www.census.gov/retail/marts/www/adv44x72.txt"

# Retail, total
retailTotalURL <- "https://www.census.gov/retail/marts/www/adv44000.txt"

# Motor, vehicle and parts dealers
motorURL <- "https://www.census.gov/retail/marts/www/adv44100.txt"

# Furniture, and Home Furnishings Stores
furnitureURL <- "https://www.census.gov/retail/marts/www/adv44200.txt"

# Building Material and Garden Equipment and Supplies Dealers
buildingURL <- "https://www.census.gov/retail/marts/www/adv44400.txt"

# Grocery Stores
groceryURL <- "https://www.census.gov/retail/marts/www/adv44510.txt"

# Gasonline Stations
gasolineURL <- "https://www.census.gov/retail/marts/www/adv44700.txt"

# Sporting Goods, Hobby, Book and Music Stores
sportURL <- "https://www.census.gov/retail/marts/www/adv45100.txt"

# Dept. Stores (ex. leased depts)
deptURL <- "https://www.census.gov/retail/marts/www/adv45210.txt"

# Nonstore Retailers
nonstoreURL <- "https://www.census.gov/retail/marts/www/adv45400.txt"

# Total (excl. Motor Vehicle)
totalexclMotorURL <- "https://www.census.gov/retail/marts/www/adv44y72.txt"

# Retail (excl. Motor Vehicle and Parts Dealers)
retailexclMotorURL <- "https://www.census.gov/retail/marts/www/adv4400a.txt"

# Auto, other Motor Vehicle
autootherMotorURL <- "https://www.census.gov/retail/marts/www/adv441x0.txt"

# Electronics and Appliance Stores
electronicsURL <- "https://www.census.gov/retail/marts/www/adv44300.txt"

# Food and Beverage Stores
foodbeverageURL <- "https://www.census.gov/retail/marts/www/adv44500.txt"

# Health and Personal Care Stores
healthURL <- "https://www.census.gov/retail/marts/www/adv44600.txt"

# Clothing and Clothing Accessories Stores
clothingURL <- "https://www.census.gov/retail/marts/www/adv44800.txt"

# General Merchandise Stores
genMerchandiseURL <- "https://www.census.gov/retail/marts/www/adv45200.txt"

# Miscellaneous Store Retailers
miscellaneousURL <- "https://www.census.gov/retail/marts/www/adv45300.txt"

# Food Services and Drinking Places
foodServicesDrinkingURL <- "https://www.census.gov/retail/marts/www/adv72200.txt"


url <- sapply(ls(), get)
topic <- as.character(strsplit(names(url), "URL"))

for(i in 1:length(topic))
{
  DataFile <- paste0("Data/", topic[i], ".txt")
  download.file(url[i], destfile = DataFile)

  RetailData <- read.table(DataFile, skip = 2, header = TRUE, nrows = 24)

  years <- RetailData$YEAR
  RetailData <- RetailData[,-1]

  RetailTS <- as.numeric(apply(RetailData, MARGIN = 1, c))
  RetailTS <- ts(RetailTS, start = c(min(years), 1), 
                           end = c(max(years), 12), 
                           frequency = 12)

  plot(RetailTS, main = topic[i])
  
  cat("Model ", i, "\n")
  print(auto.arima(RetailTS))
}