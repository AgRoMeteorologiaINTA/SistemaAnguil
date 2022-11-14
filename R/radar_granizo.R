#################################
# UI
radarGranizoUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Granizo"),
          
          sidebarLayout(
            sidebarPanel(
              dateInput(
                ns("inFecha"),
                "Seleccione fecha:",
                language = "es",
                min = "2022-01-29",
                max = Sys.Date(),
                value = "2022-02-26"
              )
              
            ),
            
            mainPanel(
              # h2("Listado con llamado a la api por fecha filtrada"),
              #textOutput(ns("debug")),
              tableOutput(ns("tabla")),
              shinycssloaders::withSpinner(
                leafletOutput(ns("mapGranizo"), height = 700),
                type = 6,
                color = "#2c3e50",
                size = 2
              )
            )
            
          ))
  
}

#################################
# SERVER
radarGranizoServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 obtenerImagen <- function() {
                   retorno <- llamar_api(
                     "granizo",
                     fechaDesde = paste0(input$inFecha),
                     fechaHasta = paste0(as.Date(input$inFecha) + 1)
                   )
                   
                   # if (is_empty(retorno)) {
                   #   print(retorno)
                   #   return(NULL)
                   # }
                   
                   print("tipo de retorno")
                   print(typeof(retorno))
                   print(retorno)
                   
                   
                   retorno <- ifelse(is_null(retorno) ,  
                                     NULL , 
                                     retorno)
                   
                   # if (is_null(retorno)) {
                   #     print("Sin Datos en VOLS !!!")
                   #     return(NULL)
                   # 
                   # } else 
                     
                  if (is.na(retorno)) {
                     print("Problema con la API !!!")
                     return(NA)
                   } 
                   
                     # retorno <- as_tibble(retorno) %>% select(imageUrl)
                   
                     retorno <-
                       retorno %>% select(imageUrl)  %>% slice_head(n = 1)
                   
                    # retorno <-
                    #   as_tibble(retorno) %>% select(imageUrl)  %>% slice_head(n = 1)
                   
                     return(retorno)
                     
                   
                 }
                 
                 output$tabla <- renderTable({
                   print(obtenerImagen())
                 })
                 
                 output$mapGranizo <- renderLeaflet({
                   img <- obtenerImagen()
                   
                   # La API volvio sin datos
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
                     
                   }
                   
                   # Problema con la conexión a la API
                   if (is.na(img)) {
                     content <- paste(sep = "<br/>",
                                      '<h5><span style="color:red">¡ Hubo un problema con la API !</span></h5>')
                     
                     mapa <- leaflet() %>%
                       # addTiles() %>%
                       addProviderTiles(providers$CartoDB.Positron,
                                        options = providerTileOptions(minZoom = 6, maxZoom = 8)) %>%
                       # addProviderTiles("Stamen.TonerLite")
                       addPopups(lat = -36.5386559,
                                 lng = -63.9913761,
                                 content)
                     
                     
                     return(mapa)
                     
                   }
                   
                   #img <- "https://s3.dev.fundacionsadosky.org.ar/palenque-integration/inta/lluvias/2022-04-21/2022042100000200Lluvias.tif"
                   img <- paste0('/vsicurl/', img)
                   img
                   
                   r <- raster::raster(img)
                   # r[r <= -99] <- NA
                   r[r < 0] <- NA
                   
                   
                   pal <-
                     colorNumeric(
                       RColorBrewer::brewer.pal(name = "Spectral", n = 9),
                       raster::values(r),
                       na.color = "transparent"
                     )
                   
                   leaflet() %>%
                     addProviderTiles("Stamen.TonerLite") %>%
                     addRasterImage(r, colors = pal, opacity = 0.9) %>%
                     addLegend(pal = pal,
                               values = raster::values(r),
                               title = "(descripción medida)")
                   
                 })
                 
                 
                 
                 
               })
}
