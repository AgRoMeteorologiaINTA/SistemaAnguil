#################################
# UI
radarLluviasUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Lluvias"))
}

#################################
# SERVER
radarLluviasServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
