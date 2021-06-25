
library(shiny)
library(tidyverse)
library(babynames)
library(rsconnect)

sex_options <- babynames %>% 
  distinct(sex) %>% 
  pull(sex)

ui <- fluidPage("My Babynames App",
                textInput(inputId = "name", 
                          label = "Name (capitalize first letter):",
                          placeholder = "Lisa"),
                selectInput(inputId = "sex",
                            label = "Sex",
                            choices = sex_options),
                sliderInput(inputId = "years",
                            label = "Select Range on Year",
                            min = 1880, max = 2019, step = 1,
                            value = c(1880,2019),
                            sep = ""),
                submitButton(text = "Create my plot!"),
                plotOutput(outputId = "myplot"))


server <- function(input, output) {
  output$myplot <- renderPlot({
    babynames %>% 
      filter(name == input$name, 
             sex == input$sex) %>% 
      ggplot(aes(x = year, 
                 y = n)) + 
      geom_line() + 
      scale_x_continuous(limits = input$years) +
      theme_minimal() + 
      labs(x = "",
           y = "Number")
  })
  }
shinyApp(ui = ui, server = server)