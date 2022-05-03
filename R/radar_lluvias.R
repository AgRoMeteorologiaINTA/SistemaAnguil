#################################
# UI
radarLluviasUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Lluvias"),
          
          sidebarLayout(
            sidebarPanel(
              dateRangeInput(
                ns("inFechas"),
                "Rango de fechas:",
                min    = "2020-01-01",
                max    = "2022-05-01",
                start  = "2022-04-01",
                end    = "2022-04-20",
                format = "dd/mm/yyyy",
                separator = " - ",
                language = "es"
              )
              
            ),
            
            mainPanel(
              h2("Listado con llamado a la api por fecha filtrada"),
              # textOutput(ns("debug")),
              #tableOutput(ns("tabla")),
              DT::DTOutput(ns("tabla"))
            )
            
          ))
}

#################################
# SERVER
radarLluviasServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 #output$tabla <- renderTable({
                 output$tabla <- DT::renderDT({
                   ns <- session$ns
                   
                   retorno <- llamar_api(
                     "lluvias",
                     fechaDesde = paste0(input$inFechas[1],"T00:00:00"),
                     fechaHasta = paste0(input$inFechas[2],"T00:00:00")
                   )
                   
                   if (is.null(retorno)) {
                     print("Sin Datos !!!")
                   } else {
                     retorno
                   }
                   
                 },options = list(
                   pageLength = 5,
                   lengthMenu = c(5, 10, 25, 100)
                 ))
                 
               })
}
