#################################
# UI
radarVolsUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Vols"))
}

#################################
# SERVER
radarVolsServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
