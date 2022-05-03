#################################
# UI
radarSumarizacionesMedicionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Sumarizaciones Mediciones"),
          
          sidebarLayout(
            sidebarPanel(
              dateRangeInput(
                ns("inFechas"),
                "Rango de fechas:",
                min    = "2020-01-01",
                max    = "2022-04-01",
                start  = "2022-02-01",
                end    = "2022-04-01",
                format = "dd/mm/yyyy",
                separator = " - ",
                language = "es"
              )
              
            ),
            
            mainPanel(
              h2("Listado con llamado a la api por fecha filtrada"),
              # textOutput(ns("debug")),
              tableOutput(ns("tabla"))
            )
            
          ))
  
}

#################################
# SERVER
radarSumarizacionesMedicionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 output$tabla <- renderTable({
                   ns <- session$ns
                   llamar_api(
                     "sumarizaciones_mediciones",
                     fechaDesde = input$inFechas[1],
                     fechaHasta = input$inFechas[2]
                   )
                 })
                 
               })
}
