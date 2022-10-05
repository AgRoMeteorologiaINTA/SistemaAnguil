# Archivo para la sección "Eventos".
# Simplemente se coloca un "uiOutput" para mostrar la imagen .png
# que esta dentro de la carpeta "./www/eventos/"
# En la función de server, se concatena el nombre del archivo, para facilitar
# el cambio de las imagenes.

#################################
# UI
eventosUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Eventos"),
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
