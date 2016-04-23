library(shiny)
library('rCharts')


# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Shiny Freeny dynamic update demo"),
        h5("This demo app illustratie how plots and data tabels in Shiny can be
          updated using the"),
        code("reactive"),
        h5("function"),
        
        
        # Sidebar with 2 input values to update the first row of the dataset.
        sidebarLayout(
                sidebarPanel(
                        p("The input in the data fields below will update the values in the plot and
                        the data table in the mainPanel by updating the first row in the dataset. It illustrating that the table and plot can be
                        dynamically updated by input of the user"),
                        p("The first input box will dynamically update the first row value in Lag Quarterly Revenue and will update the plot."),
                        p("The second input box will dynamically update the first row value in Market Potential and will update the plot."),
                        # data input field to update the first value for Lag Quarterly Revenue
                        numericInput('id1', 
                                     label = 'Lag Quarterly Revenue First Entry',
                                     min = 0,
                                     max = 20,
                                     value = freeny$lag.quarterly.revenue[1]),
                        # data input field to update the first value for Market Potential
                        numericInput('id2', 
                                     label = 'Market Potential First Entry',
                                     min = 0,
                                     max = 20,
                                     value = freeny$market.potential[1])
                ),
                
                
                # Show a plot of the generated distribution
                mainPanel(
                        
                        showOutput("freenyPlot","NVD3"),
                        h5('Below he first 30 records of the freeny dataset for the columns Lag Quarterly Revenue and market potential dynamically updated'),
                        dataTableOutput('freenyTable')
                )
        )
))