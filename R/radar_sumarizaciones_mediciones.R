#################################
# UI
radarSumarizacionesMedicionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Sumarizaciones Mediciones"))
}

#################################
# SERVER
radarSumarizacionesMedicionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
