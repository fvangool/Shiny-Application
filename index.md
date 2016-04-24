---
title       : Shiny Freeny dynamic update demo
subtitle    : Assignemnt Data Products MOOC
author      : Filip Van Gool
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
url         :
        lib: ./libraries
        assets: ./assets
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides


--- .class #id 

## Introduction

### Context

This Slidify Deck describes the demo Shiny application create by Filip Van Gool in the context of the Coursera course Data Prodocuts for the assignment "Course Project: Shiny Application and Reproducible Pitch."


###  Demo Application

The demo Shiny application can be fond here:  [link to Shiny application](https://metiomai.shinyapps.io/ShinyCourseraDataProduct/)

The "server.R" and "ui.R" R code can be found on Github on the links below
- [link to server.R](https://github.com/fvangool/Shiny-Application/blob/master/server.R)
- [link to ui.R](https://github.com/fvangool/Shiny-Application/blob/master/ui.R)

--- .class #id 

## Purpose

The goal of the Shiny application was to illustrate the powerfull possiblities of dynamically updating graphs and data tables using Shiny.

###  Libraries used

For the demo application the following libraries were used:
```r
library(shiny)
```
```r
library(rCharts)
```

--- .class #id 

## Data Set used


We used the dataset "freeny" containing data on quarterly revenue and explanatory variables as it is a default dataset that comes with an R installation.

As this is just a demo we just used the first 30 rows in the "freeny dataset" of just 2 columns, "freeny$lag.quarterly.revenue" and "freeny$market.potential"

```r
data <- head(data.frame(freeny$lag.quarterly.revenue, freeny$market.potential),30)

```
The illustrate the power of the "reactive" function in R, we provide two input boxes the update the first row
of the dataset used. Respectivly the values in the first row for: 'Lag Quarterly  Revenue' and 'Market Potential'.


```
##   freeny.lag.quarterly.revenue freeny.market.potential
## 1                      8.79636                 12.9699
```

--- .class #id 

## Conclusion

Using the "reactive" function in R this demonstrates the possibility dynamically update data in tables and plots based on user input.

A further project would be to create entirely updatable data table and not only the first row.

Note: We used rCharts as we were unfamiliar with the library and wanted to at least include it in the Shiny application to get a feeling of what it can.

#### Very curious about the projects you created for the assignment!


