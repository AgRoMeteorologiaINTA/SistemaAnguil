#################################
# UI
radarGranizoUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Granizo"),
          
          sidebarLayout(
            sidebarPanel(
              dateRangeInput(
                ns("inFechas"),
                "Rango de fechas:",
                min    = "2020-01-01",
                max    = "2022-05-01",
                start  = "2022-01-01",
                end    = "2022-03-01",
                format = "dd/mm/yyyy",
                separator = " - ",
                language = "es"
              )
              
            ),
            
            mainPanel(
              h2("Listado con llamado a la api por fecha filtrada"),
              # textOutput(ns("debug")),
              # tableOutput(ns("tabla")),
              DT::DTOutput(ns("tabla"),
                           height = 5
                           # ,
                           # options = list(
                           #   pageLength = 5,
                           #   lengthMenu = c(5, 10, 25, 100)
                           # )
                           )
            )
            
          ))
  
}

#################################
# SERVER
radarGranizoServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 # output$tabla <- renderTable({
                 output$tabla <- DT::renderDT({
                   ns <- session$ns
                   
                   retorno <- llamar_api(
                     "granizo",
                     fechaDesde = input$inFechas[1],
                     fechaHasta = input$inFechas[2]
                   )
                   
                   if (is.null(retorno)) {
                     print("Sin Datos !!!")
                   } else {
                     retorno
                   }
                   
                 },options = list(
                     pageLength = 5,
                     lengthMenu = c(5, 10, 25, 100)
                   )
                 )
                 
                 # output$debug <- renderText({
                 #   ns <- session$ns
                 #   retorno <- llamar_api(
                 #     "granizo",
                 #     fechaDesde = input$inFechas[1],
                 #     fechaHasta = input$inFechas[2]
                 #   )
                 #   print(retorno)
                 # })
                 
               })
}
