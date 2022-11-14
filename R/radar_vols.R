#################################
# UI
radarVolsUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Vols"),
          
          sidebarLayout(sidebarPanel(
            dateInput(
              ns("inFecha"),
              "Seleccione fecha:",
              language = "es",
              min = "2022-01-01",
              max = Sys.Date(),
              value = "2022-04-21"
            )
            
          ),
          
          mainPanel(
            h2("Listado con llamado a la api por fecha filtrada"),
            #textOutput(ns("debug")),
            # tableOutput(ns("tabla"))
            DT::DTOutput(ns("tabla"), height = "80%")
          )))
  
}

#################################
# SERVER
radarVolsServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
                 # output$debug <- renderText({
                 #   print(palenque_key)
                 # })
                 
                 shinyInput <- function(FUN, len, id, ns, ...) {
                   inputs <- character(len)
                   for (i in seq_len(len)) {
                     inputs[i] <- as.character(FUN(paste0(ns(id), i), ...))
                   }
                   inputs
                 }
                 
                 
                 
                 my_data_table <- reactive({
                   retorno <- llamar_api(
                     "vols",
                     fechaDesde = paste0(input$inFecha, "T00:00:00"),
                     fechaHasta = paste0(input$inFecha, "T23:59:59")
                   )
                   
                   if (is.null(retorno)) {
                     print("Sin Datos en VOLS !!!")
                   } else if (is.na(retorno)) {
                     print("Problema con la API !!!")
                   } else {
                     retorno %>%
                       select(measurementTime, indexType, fileUrl) %>%
                       rowwise() %>%
                       mutate(
                         Actions = shinyInput(
                           FUN = downloadLink,
                           len = n(),
                           id = 'button_',
                           ns = ns,
                           label = basename(.data[["fileUrl"]]),
                           #download = .Variable,
                           href = .data[["fileUrl"]]
                         )
                       ) %>%
                       relocate(
                         `Fecha y hora` = measurementTime,
                         `Variable` = indexType ,
                         `Descarga` = Actions,
                         `Url del archivo` = fileUrl
                       )
                   }
                   
                   return(retorno)
                 })
                 
                 
                 output$tabla <- DT::renderDT({
                   data <- my_data_table()
                   
                   # el llamdo volvio, pero sin datos
                   if(is.null(data)){
                     print("La data es NULL!!!!!!")
                     
                     data <- tribble(
                       ~MENSAJE,
                       "No hay DATOS"
                     )
                   } 
                   # Problemas con la API
                   else if (is.na(data)){     
                     print("La data es NA !!!!!!")
                     
                     data <- tribble(
                       ~MENSAJE,
                       '<span style="color:red">¡ Hubo un problema con la API !</span>'
                     )
                   }
                   
                   datatable(data,
                             escape = FALSE,
                             # ,
                             # options =
                             #   list(
                             #     preDrawCallback = JS('function() { Shiny.unbindAll(this.api().table().node()); }'),
                             #     drawCallback = JS('function() { Shiny.bindAll(this.api().table().node()); } ')
                             #   )
                             options = list(
                               pageLength = 5,
                               lengthMenu = c(5, 10, 25, 100)
                             ))
                 })
                 
                 
                 
                 # output$tabla <- renderTable({
                 # output$tabla <- DT::renderDT({
                 #   ns <- session$ns
                 #
                 #   retorno <- llamar_api(
                 #     "vols",
                 #     fechaDesde = paste0(input$inFecha,"T00:00:00"),
                 #     fechaHasta = paste0(input$inFecha,"T23:59:59")
                 #   )
                 #
                 #   if (is.null(retorno)) {
                 #     print("Sin Datos !!!")
                 #   } else {
                 #     retorno %>%
                 #       select(measurementTime, indexType, fileUrl) %>%
                 #       rename(`Fecha y hora` = measurementTime, Variable = indexType , `Archivo (click para descarga)` = fileUrl)
                 #
                 #   }
                 #
                 # },extensions = 'Buttons',
                 #
                 # options = list(
                 #   pageLength = 5,
                 #   lengthMenu = c(5, 10, 25, 100)
                 # ))
                 
               })
}
