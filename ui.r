### Created by Justin Freels
### email: jfreels@gmail.com
### twitter: https://twitter.com/jfreels4
### github: https://github.com/jfreels

# taken from timelyportfolio
# http://timelyportfolio.blogspot.com/2012/12/shinyr-conversion-of-another-one-of-my.html
#R and Shiny adaptation of http://bl.ocks.org/4063663

reactiveSvg <- function (outputId) 
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\"><svg /></div>", sep=""))
}

##### SHINY UI
shinyUI(pageWithSidebar(
# HEADER PANEL
  headerPanel(title=HTML("Shiny + d3js: Scatterplot (<a href = \"http://bl.ocks.org/4063663\">Mike Bostock </a> & <a href=\"http://timelyportfolio.blogspot.com/2012/12/shinyr-conversion-of-another-one-of-my.html\">Timelyportfolio</a>)")),
# SIDEBAR PANEL
  sidebarPanel(
    # import own dataset
    radioButtons(inputId="upload",label="Would you like to use an uploaded dataset?",choices=c("Yes","No"),selected="No"),
    conditionalPanel(
      condition="input.upload=='Yes'",
      helpText("Import data from a CSV file in the format of the \"Example\" tab."),
      helpText("The \"date\" column should be formatted yyyy/mm/dd."),
      fileInput(inputId="csv", label="Select CSV file:")
    ),
    # choose the subset of the data you want to look at
    uiOutput("example_choose_fund"),
    uiOutput("upload_choose_fund"),
    # start date and end date of the dataset
    uiOutput("data_start_date"),
    uiOutput("data_end_date"),
    # contact info
    helpText(HTML("<br>*Created by: <a href = \"https://twitter.com/jfreels4\">@jfreels4</a>
                  <br>*github <a href = \"https://github.com/jfreels/d3js/tree/master/shiny_d3js_scatterplot\">code</a>
                  ")
    )
  ),
# MAIN PANEL
  mainPanel(
    tabsetPanel(
      #tabPanel("Test",
      #  verbatimTextOutput("test")
      #),
      tabPanel("Scatterplot",
        includeHTML("scatterplot.js"),
        reactiveSvg(outputId = "scatterplot")
      )
    )
  )
))