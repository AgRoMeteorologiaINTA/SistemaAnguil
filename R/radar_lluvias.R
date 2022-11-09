#################################
# UI
radarLluviasUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Lluvias"),
          
          sidebarLayout(
            sidebarPanel(
              dateInput(
                ns("inFecha"),
                "Seleccione fecha:",
                language = "es",
                min = "2022-01-01",
                max = Sys.Date(),
                value = "2022-04-21"
              ),
              
              fluidRow(
                column(width = 6,
                       selectInput(
                         ns('inHora'),
                         'Hora',
                         choices = sprintf("%02d", 0:23)
                       )),
                column(width = 6,
                       selectInput(
                         ns('inMinutos'),
                         'Minutos',
                         choices = c("00 - 09", "10 - 19", "20 - 29", "30 - 39", "40 - 49", "50 - 59")
                       ))
              )
              
              
            ),
            
            mainPanel(
              # h2("Listado con llamado a la api por fecha filtrada"),
              #textOutput(ns("debug")),
              tableOutput(ns("tabla")),
              shinycssloaders::withSpinner(
                leafletOutput(ns("mapLluvia"),height = 700),
                type = 6, 
                color = "#2c3e50", 
                size = 2
                )
            )
            
          ))
}

#################################
# SERVER
radarLluviasServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 obtenerImagen <- function() {
                   retorno <- llamar_api(
                     "lluvias",
                     fechaDesde = paste0(
                       input$inFecha,
                       "T",
                       input$inHora,
                       ":",
                       str_sub(input$inMinutos, 1, 2),
                       # 2 digitos de la izq.
                       ":00"
                     ),
                     fechaHasta = paste0(
                       input$inFecha,
                       "T",
                       input$inHora,
                       ":",
                       str_sub(input$inMinutos,-2,-1),
                       # 2 digitos de la der.
                       ":59"
                     )
                   )
                   
                   if (is_empty(retorno)) {
                     print(retorno)
                     return(NULL)
                   }
                   
                   # retorno <- as_tibble(retorno) %>% select(imageUrl)
                   retorno <-
                     retorno %>% select(imageUrl)  %>% slice_head(n = 1)
                   return(retorno)
                 }
                 
                 output$tabla <- renderTable({
                   print(obtenerImagen())
                 })
                 
                 output$mapLluvia <- renderLeaflet({
                   img <- obtenerImagen()
                   
                   if (is_null(img)) {
                     
                     content <- paste(sep = "<br/>",
                                      "<h1>No hay imagenes</h1>",
                                      "<h5>Seleccionar nueva fecha u hora y minutos</h5>"
                     )
                     
                     mapa <- leaflet() %>%
                       # addTiles() %>%
                       addProviderTiles(providers$CartoDB.Positron,
                                        options = providerTileOptions(minZoom = 6, maxZoom = 8)) %>%
                       # addProviderTiles("Stamen.TonerLite") 
                       addPopups(lat = -36.5386559, lng = -63.9913761, content)
                      
                     
                     return(mapa)
                       
                   }
                   
                   #img <- "https://s3.dev.fundacionsadosky.org.ar/palenque-integration/inta/lluvias/2022-04-21/2022042100000200Lluvias.tif"
                   img <- paste0('/vsicurl/', img)
                   img
                   
                   r <- raster::raster(img)
                   
                   pal <- colorNumeric(RColorBrewer::brewer.pal(name = "Blues", n=3), 
                                       raster::values(r),
                                       na.color = "transparent")
                   
                   leaflet() %>%
                     addProviderTiles("Stamen.TonerLite") %>%
                     addRasterImage(r, colors = pal, opacity = 0.9) %>%
                     addLegend(pal = pal, values = raster::values(r),
                               title = "(descripción medida)") 
                     
                 })
                 
                 
                 #   output$tabla <- DT::renderDT({
                 #     ns <- session$ns
                 #
                 #     retorno <- llamar_api(
                 #       "lluvias",
                 #       fechaDesde = paste0(input$inFecha,"T",
                 #                           input$inHora,
                 #                           ":",
                 #                           str_sub(input$inMinutos, 1, 2), # 2 digitos de la izq.
                 #                           ":00"),
                 #       fechaHasta = paste0(input$inFecha,"T",
                 #                           input$inHora,
                 #                           ":",
                 #                           str_sub(input$inMinutos, -2, -1), # 2 digitos de la der.
                 #                           ":59")
                 #     )
                 #
                 #
                 #
                 #     if (is_empty(retorno)) {
                 #       print("Sin Datos !!!")
                 #     } else {
                 #       retorno
                 #     }
                 #
                 #   },options = list(
                 #     pageLength = 5,
                 #     lengthMenu = c(5, 10, 25, 100)
                 #   ))
                 #
                 
                 
               })
}
