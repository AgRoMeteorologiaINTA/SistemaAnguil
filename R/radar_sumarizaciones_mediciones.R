#################################
# UI
radarSumarizacionesMedicionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Sumarizaciones Mediciones"),
          
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
              
              selectInput(
                ns('inVariable'),
                'Variable',
                choices = c("dBZ" = "DBZ",
                            "RhoHV" = "RHOHV",
                            "ZDR" = "ZDR")
              )
                ,
                selectInput(
                ns('inOperacion'),
                'Operación',
                choices = c("Mínimo" = "MIN",
                            "Máximo" = "MAX",
                            "Promedio" = "AVG",
                            "Total" = "TOT")
                
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
radarSumarizacionesMedicionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 obtenerImagen <- function() {
                   retorno <- llamar_api(
                     "sumarizaciones_mediciones",
                     fechaDesde = paste0(
                       input$inFecha
                     ),
                     fechaHasta = paste0(
                       input$inFecha
                     )
                   )
                   
                   # if (is_empty(retorno)) {
                   #   print(retorno)
                   #   return(NULL)
                   # }
                   
                   if (is.null(retorno)) {
                     print("Sin Datos en VOLS !!!")
                     return(NULL)
                   } else if (is.na(retorno)) {
                     print("Problema con la API !!!")
                     return(NA)
                   }
                   
                   # otros filtros
                   
                   retorno <- retorno %>%
                     filter(
                       # indexType == toupper(input$inVariable) &
                       indexType == input$inVariable &
                              operation == input$inOperacion
                       ) %>%
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
                   obtenerImagen()
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
                     
                   } else if (is.na(img)) {
                     content <- paste(
                       sep = "<br/>",
                       '<h5><span style="color:red">¡ Hubo un problema con la API !</span></h5>'
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
