library(httr)

library(stringr)
library(tidyverse)
library(lubridate)
library(RCurl)
library(XML)
library(rvest)
library(RSelenium)

if(interactive()){
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Launch Selenium and Run ###
cprof <- list(chromeOptions = 
                list(args = list("--incognito")))

rD <- rsDriver(port = 8889L, browser="chrome", chromever = "94.0.4606.61", extraCapabilities = cprof)
remDr <- rD$client


# KBB Car finder link
link <- "https://www.kbb.com/car-finder/"

#As of 8/31/2021 KBB has 577 unique pages under car finder
max_pages <- 577


datalist = list()
for (j in 1:max_pages) {

#Got to current Page
remDr$navigate(paste0(link, j))
Sys.sleep(1)

#Get all cars on that page
x <- remDr$findElements("class", "eye8adl3")
y <- remDr$findElements("class", "e1obsm7a0")

match_num <- seq(1, NROW(y), by = 2)

  datalist2 = list()
  for (i in 1:NROW(x)){
    car_name <- x[[i]]$getElementAttribute("href")[[1]]
    price <- y[[ match_num[i] ]]$getElementText()[[1]]
    mpg <- y[[ match_num[i] + 1]]$getElementText()[[1]]
    
    datalist2[[i]] <- data.frame(car_name, price, mpg)  
  }
  
  datalist[[j]] <- bind_rows(datalist2)
  Sys.sleep(sample(1:5, 1))
}

df <- bind_rows(datalist)

##Clean Data
#Clean Car name
df$list <- gsub("https://www.kbb.com/", "", df$car_name)

df$list <- list(strsplit(df$list, "/"))[[1]]

df$brand <- lapply(df$list, `[[`, 1)   
df$type <- lapply(df$list, `[[`, 2)
df$year <- lapply(df$list, `[[`, 3)

df$brand <- unlist(df$brand)
df$type <- unlist(df$type)
df$year <- unlist(df$year)

#Clean Price
df$price <- gsub("\\$|,", "", df$price)

#Reorder Columns
df <- select(df, c("brand", "type", "year", "price", "mpg", "link" = "car_name"))

#Save
write.csv(df, "KBB_Data.csv", row.names = FALSE)

# Close Selenium properly when compelte
remDr$close()
rD$server$stop()
rm(rD)
gc()
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


