#################################
# UI
radarMedicionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Mediciones"),
          
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
              ),
              
              fluidRow(
                column(width = 6,
                       selectInput(
                         ns('inVariable'),
                         'Variable',
                         choices = c("dBZ", "RhoHV", "ZDR")
                       )),
                column(width = 6,
                       selectInput(
                         ns('inElevacion'),
                         'Elevación',
                         choices = seq(1:12)
                       ))
              )
              
            ),
            
            mainPanel(
              h2("Listado con llamado a la api por fecha filtrada"),
              # textOutput(ns("debug")),
              tableOutput(ns("tabla")),
              # DT::DTOutput(ns("tabla"), height = "80%")
              shinycssloaders::withSpinner(
                leafletOutput(ns("mapMediciones"), height = 700),
                type = 6,
                color = "#2c3e50",
                size = 2
              )
              
              
              
            )
            
          ))
}

#################################
# SERVER
radarMedicionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 obtenerImagen <- function() {
                   retorno <- llamar_api(
                     "mediciones",
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
                       str_sub(input$inMinutos, -2, -1),
                       # 2 digitos de la der.
                       ":59"
                     )
                   )
                   
                   if (is_empty(retorno)) {
                     print(retorno)
                     return(NULL)
                   }
                   
                   # otros filtros
                   
                   retorno <- retorno %>%
                     filter(indexType == toupper(input$inVariable) &
                              elevation == (as.numeric(input$inElevacion) * 2) - 1) %>%
                     select(imageUrl) %>%
                     slice_head(n = 1)
                   
                   if (is_empty(retorno)) {
                     # Si la api no retorna registros:
                     return(NULL)
                   } else {
                     return (retorno)
                   }
                   
                 }
                 
                 output$tabla <- renderTable({
                   print(obtenerImagen())
                 })
                 
                 # output$tabla <- DT::renderDT({
                 #   obtenerImagen()
                 # })
                 
                 output$mapMediciones <- renderLeaflet({
                   img <- obtenerImagen()
                   
                   if (is_null(img)) {
                     content <- paste(
                       sep = "<br/>",
                       "<h1>No hay imagenes</h1>",
                       "<h5>Seleccionar nueva fecha u hora y minutos</h5>"
                     )
                     
                     mapa <- leaflet() %>%
                       # addTiles() %>%
                       addProviderTiles(providers$CartoDB.Positron,
                                        options = providerTileOptions(minZoom = 6, maxZoom = 8)) %>%
                       # addProviderTiles("Stamen.TonerLite")
                       addPopups(lat = -36.5386559,
                                 lng = -63.9913761,
                                 content)
                     
                     
                     return(mapa)
                     
                   } else {
                     img <- paste0('/vsicurl/', img)
                     img
                     
                     # tryCatch, por si hay algun error al renderear el mapa
                     tryCatch({
                       r <- raster::raster(img)
                       
                       pal <-
                         colorNumeric(
                           RColorBrewer::brewer.pal(name = "Blues", n = 3),
                           raster::values(r),
                           na.color = "transparent"
                         )
                       
                       
                       leaflet() %>%
                         addProviderTiles("Stamen.TonerLite") %>%
                         addRasterImage(r, colors = pal, opacity = 0.9) %>%
                         addLegend(
                           pal = pal,
                           values = raster::values(r),
                           title = "(descripción medida)"
                         )
                     },
                     # Si hubo un error:
                     error = function(cond) {
                       content <- paste(
                         sep = "<br/>",
                         "<h1>Hay un error en los datos de la imagen</h1>",
                         "<h5>Seleccionar nueva fecha u hora y minutos</h5>"
                       )
                       
                       mapa <- leaflet() %>%
                         # addTiles() %>%
                         addProviderTiles(providers$CartoDB.Positron,
                                          options = providerTileOptions(minZoom = 6, maxZoom = 8)) %>%
                         # addProviderTiles("Stamen.TonerLite")
                         addPopups(lat = -36.5386559,
                                   lng = -63.9913761,
                                   content)
                       
                       
                       return(mapa)
                       
                     })
                     
                   } # else
                   
                 })
                 
                 
               })
}
