### Created by Justin Freels
### email: jfreels@gmail.com
### twitter: https://twitter.com/jfreels4
### github: https://github.com/jfreels

# Load libraries
libs<-c("lubridate","plyr","reshape2","ggplot2","xts","PerformanceAnalytics","shiny","devtools","scales","jfreels")
lapply(libs,require,character.only=TRUE)
#install_github(repo="r_jfreels",username="jfreels")
#library(jfreels)

# example_data
data(edhec)
example_data<-as.data.frame(edhec)
example_data$date<-as.Date(row.names(example_data))
example_data<-subset(example_data,select=c(ncol(example_data),1:(ncol(example_data)-1)))
row.names(example_data)<-NULL
#dataset.example<-as.matrix(dataset.example)

##### SHINY SERVER
shinyServer(function(input, output) {
  ### TEST AREA
  output$test<-renderPrint({
  	dataset_final()
  })



  ### Upload data area
  # reactive: upload_dataset
  upload_dataset <- reactive({
    if (is.null(input$csv)) { return(NULL) }
    d<-read.csv(input$csv$datapath,check.names=FALSE)
    d$date<-as.Date(d$date)
    d
  })

# reactive: dataset_original
  dataset_original <- reactive({
    dat<-if (input$upload=="Yes") { 
      dat<-upload_dataset()
      dat$date<-dat$date
      dat
    }
    else { 
      example_data
    }
    dat
  })

### sideBarPanel reactive UIs
  output$example_choose_fund<-renderUI({
    if (input$upload=="No") { return(NULL) }
    conditionalPanel(
      condition="input.upload=='Yes'",
      selectInput(inputId="upload_choose_fund",label="Choose Funds:",choices=names(dataset_original()[-1]),multiple=TRUE)
    )
  })
  
  output$upload_choose_fund<-renderUI({
    if (input$upload=="Yes") { return(NULL) }
    conditionalPanel(
      condition="input.upload=='No'",
      selectInput(inputId="example_choose_fund",label="Choose Funds:",choices=names(dataset_original()[-1]),multiple=TRUE)
    )    
  })
  
  # reactive: choice
  choices<-reactive({
  	if (input$upload=="Yes") { input$upload_choose_fund }
  	else { input$example_choose_fund }
  	})

  # reactive: dataset
  dataset <- reactive({
    na.omit(droplevels(dataset_original()[,c("date",choices())]))    
  })

  output$data_start_date<-renderUI({
    selectInput(inputId="data_start_date_input",label="Start date:",choices=unique(as.character(dataset()$date)))
  })
  
  output$data_end_date<-renderUI({
    selectInput(inputId="data_end_date_input",label="End date:",choices=rev(unique(as.character(dataset()$date))))
  })

  # reactive: dataset_final
  dataset_final<-reactive({
    subset(dataset(),date>=as.Date(input$data_start_date_input)&date<=as.Date(input$data_end_date_input))
  })


  ### Scatterplot Tab
  output$scatterplot<-reactive({
  	as.matrix(dataset_final())
  })

})