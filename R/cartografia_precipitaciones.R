#################################
# UI
cartografiaPrecipitacionesUI <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    sidebarPanel(
      h3("Informes mensuales"),
      selectInput(ns('inAnio'),
                  'Año',
                  choices = c("2022",
                              "2021",
                              "2020")),
      selectInput(ns('inMes'),
                  'Mes',
                  choices = c(meses)),
      selectInput(
        ns('inItem'),
        'Ítem',
        choices = c(
          "Acumulado en primera quincena" = "1Q",
          "Acumulado en segunda quincena" = "2Q",
          "Acumulado mensual" = "TOT",
          "Anomalia mensual" = "ANOM"
        )
      ),
      h3("Promedios históricos"),
      selectInput(
        ns('inProm'),
        'Mapa',
        choices = c(
          "Mapa 1" = "mapa_1.jpg",
          "Mapa 2" = "mapa_2.jpg",
          "Mapa 3" = "mapa_3.jpg",
          "Mapa 4" = "mapa_4.jpg"
        )
      )
    ),
    mainPanel(textOutput(ns("salida")),
              uiOutput(ns("imagen_1")))
  )
}

#################################
# SERVER
cartografiaPrecipitacionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 # Cuando cambia el combo de promedios
                 observeEvent(input$inProm, {
                   output$imagen_1 <- renderUI({
                     ns <- session$ns
                     
                     src <- paste0("promedios/", input$inProm)
                     
                     if (identical(src, character(0))) {
                       HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                     } else {
                       src <- paste0("./precipitaciones/", src)
                       img(src = src, width = "100%")
                     }
                   })
                 })
                 
                 observeEvent(c(input$inAnio, input$inMes, input$inItem), {
                   output$imagen_1 <- renderUI({
                     ns <- session$ns
                     
                     src <- archivos_precip %>%
                       str_subset(input$inAnio) %>%
                       str_subset(input$inMes) %>%
                       str_subset(input$inItem)
                     
                     if (identical(src, character(0))) {
                       HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                     } else {
                       src <- paste0("./precipitaciones/", src)
                       img(src = src, width = "100%")
                     }
                   })
                 })
               })
}
