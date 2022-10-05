# Archivo para la seccion Radar

#################################
# UI
radarUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Radar"),
          tags$h4("(sección en construcción)"))
}

#################################
# SERVER
radarServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
