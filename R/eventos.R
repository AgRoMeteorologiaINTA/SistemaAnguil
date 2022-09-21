#################################
# UI
eventosUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("eventos"),
          uiOutput(ns("imagen_1")))
}

#################################
# SERVER
eventosServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$imagen_1 <- renderUI({
                   ns <- session$ns
                   src <- paste0("eventos/", "Taller_de_datos.png")
                   img(src = src, width = "100%")
                 })
                 
               })
}
