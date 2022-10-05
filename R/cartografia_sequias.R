# Archivo para Índices de sequia.
# Dependiendo de la seleccion de "selectInput", se levanta el archivo .jpeg
# dentro de la carpeta "./www/sequias/".
# Tambien, hay un link a la página del INTA
# https://inta.gob.ar/documentos/mapas-de-indice-de-sequia-provincia-de-la-pampa-2015-2019

#################################
# UI
cartografiaSequiasUI <- function(id) {
  ns <- NS(id)
  
  # SEQUIA  ######################
  sidebarLayout(sidebarPanel(
    selectInput(ns('inAnioSeq'),
                'Año',
                choices = c("2022",
                            "2021",
                            "2020")),
    selectInput(ns('inMesSeq'),
                'Mes',
                choices = c(meses)),
    tags$a(
      "Índice de Sequía de Palmer (2015-2019)",
      href = "https://inta.gob.ar/documentos/mapas-de-indice-de-sequia-provincia-de-la-pampa-2015-2019",
      target =
        "_blank"
    )
  ),
  mainPanel(uiOutput(ns("imagen_2"))))
}

#################################
# SERVER
cartografiaSequiasServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$imagen_2 <- renderUI({
                   ns <- session$ns
                   
                   src <- archivos_sequia %>%
                     str_subset(input$inAnioSeq) %>%
                     str_subset(input$inMesSeq)
                   
                   if (identical(src, character(0))) {
                     HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                   } else {
                     src <- paste0("./sequias/", src)
                     img(src = src, width = "100%")
                   }
                 })
                 
               })
}
