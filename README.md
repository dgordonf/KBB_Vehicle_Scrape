# KBB_Vehicle_Scrape
This R Script uses RSelenium to scrape car details from the pages of Kelly Blue Book's Car Finder. Details are exported to a CSV and include brand, type, year, price, mpg, and link to car's detail page.

Kelly Blue Book makes it difficult to see all of their data at once. In case you want to create your own mtcars dataframe or compare mpg or price of cars by brand over time, this is web scraper for you. 

Kelly Blue Book has protections to prevent normal scrapping. To get around this, we launch [RSelenium](https://rpubs.com/johndharrison/RSelenium-Basics) to navigate through each car finder page here: https://www.kbb.com/car-finder/ . If this is your first time getting started with RSelenium, it can be a little tricky to initially set up. Most importantly, you'll need to the version of [Chrome Web Driver](https://chromedriver.chromium.org/) that to match the version of Chrome you have on your machine. 

In order to grab every bit of data, you'll need to update the `max_pages` variable in the `Scrape_KBB.r` file to the number of pages of cars Kelly Blue Book currently has on that page. As of 8/31/2021, there were 577 pages of cars to navigate through.

Once that is set, when you run the code, it will launch Rselenium and navigate through each of the pages on car finder. Once it navigates through each page, a csv of the data titled `KBB_Data.csv` will appear in your working directory. 
