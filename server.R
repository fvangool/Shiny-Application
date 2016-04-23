library(shiny)
# The dataset used is 'freeny' which is a base dataset included in R
# The columns used for this Shiny demo application are:
# - lag.quarterly.revenue
# - market.potential
# We change the data column names to "Lag Quarterly Revenue", "Market Potential" for readability
# As this is a demo application we limit the data to the first 30 rows of the dataset
# The first row of this dataset can be manipulated with in the application which will dynamically change
# the plot and the data table

# Retrieve the first 30 rows for the selected columns
data <- head(data.frame(freeny$lag.quarterly.revenue, freeny$market.potential),30)
# Change the name of the columns to make them more readable 
colnames(data) <- (c("Lag Quarterly Revenue", "Market Potential"))

# Defines the server logic to display a plot mapping the "Lag Quarterly Revenue" and"Market Potential"
# dat in the dataset
shinyServer(function(input, output) {
        
        # Expression that generates a generetes the plot mapping the Lag Quarterly Revenue" and"Market Potential"
        # using rCharts library.
        
        
        output$freenyPlot <- renderChart({
                
                library(rCharts)
                # get the userinput in input$id1 into  x using the reactive function
                x <- reactive(as.numeric(input$id1))
                # get the userinput in input$id2 into y using the reactive function
                y <- reactive(as.numeric(input$id2))
                # insert x into the first value of Lag Quarterly revenue
                data$`Lag Quarterly Revenue`[1] <-x()
                # insert y into the first value of Market Potential
                data$`Market Potential`[1] <-y()
                # plot Lag Quarterly Revenue ~ Market potential, dynamically update with user input
                n1 <- nPlot(`Lag Quarterly Revenue` ~ `Market Potential`,
                            type = 'scatterChart',
                            data = data,
                            width = 600
                )
                n1$xAxis(axisLabel = "Lag Quarterly Revenue")
                n1$yAxis(axisLabel = "Market Potential")
                n1$set(title="Freeny: Lag Quarterly Revenue vs Market Potential")
                n1$set(dom = "freenyPlot")
                return(n1)
        })
        # get the userinput in input$id1 into  x using the reactive function
        x <- reactive(as.numeric(input$id1))
        # get the userinput in input$id2 into y using the reactive function
        y <- reactive(as.numeric(input$id2))
        # Expression renders the data frame in a DataTable output dynamically updating
        # based using the reactive function
        output$freenyTable <- renderDataTable({
                # insert x into the first value of Lag Quarterly revenue
                data$`Lag Quarterly Revenue`[1] <-x()
                # insert y into the first value of Market Potential
                data$`Market Potential`[1] <-y()
                data
        })

})