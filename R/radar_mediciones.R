#################################
# UI
radarMedicionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Mediciones"))
}

#################################
# SERVER
radarMedicionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
