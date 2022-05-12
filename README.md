## home Assignment

This app is home assignment from Appsilon recruitment process.

In this app you can select a species by their vernacularName and scientificName. 
In result, app shows on the map a location of every observation, with a popup contain ID of observation and URL to site with description of observation event, and a timeline when selected species were observed.

Live app available [here](https://przemyslawlagosz.shinyapps.io/myapp/)

All necessary files are in R [folder](https://github.com/PrzemyslawLagosz/homeAssignment/tree/main/R)

### Tests  

I projected only one test, located in [test-myAppModules.R script](https://github.com/PrzemyslawLagosz/homeAssignment/blob/main/tests/testthat/test-myAppModules.R)

### Future development  
* Add a dataRangeInput to filter markers on map, and points on time line.
* Add a selectInput with choices from kingdom column to reduce choices shown at once in vernacularName and scientificName inputs.
* Add a feature which allows users add their own observations. 

#### Time Line

While date range is wide, axies are hard to read, because months names are overlapping.  
*POSSIBLE SOLUTIONS:*  

* Turn months names 90 degree and display them one above, one below, and so on.
* * Rewrite function in `plotly` not `ggplot2` because `plotly` has problem with the "angle" aesthetic. [DETAILS](https://github.com/plotly/plotly.R/issues/709)  
* * Implement feature, which will show only years, while date range is wide.
* Improve hovering over points to show, more sensibly data.

#### Select
* Show both options of selectInput in alphabetical order  

#### Disclaimer

I used data from first 10000 rows because occurrence.csv file is to big for R to handle it.
I tried resolve this problem with a `sqldf` package which `read.csv.sql()` function allows to filter while reading the file.
Unfortunetlly it can't handle a *NA* values. I couldn't implement solution presented [here](https://github.com/ggrothendieck/sqldf#14-how-does-one-read-files-where-numeric-nas-are-represented-as-missing-empty-fields). Question #14.  

In another approach I tried to read file in chunks with a loop presented in [sql.R](https://github.com/PrzemyslawLagosz/homeAssignment/blob/main/sql.R) file, and filter it, but met a problem with a memory buffer.  
Additionally, loop somehow corrupted all data types, changing them to the character type.

# Update 12.05.2022

Data problem solution:
* I created data base with SQLite, containing table occurence with all the data.
* Read required data with help of `RSQLite` library. (solution in [sql.R](https://github.com/PrzemyslawLagosz/homeAssignment/blob/main/sql.R))
* Changed data type of eventDate to Date type in R because SQLite DB can't handle DATE type.
* Save as occurencePLDB.csv