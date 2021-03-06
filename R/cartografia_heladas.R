#################################
# UI
cartografiaHeladasUI <- function(id) {
  ns <- NS(id)
  
  # HELADAS ######################
  
           sidebarLayout(sidebarPanel(
             dateInput(
               ns("inImgHeladas"),
               "Seleccione fecha:",
               language = "es",
               min = "2021-07-01",
               #desde
               max = Sys.Date(),
               #hasta
               value = tail(fechas_heladas, 1),
               #de arranque, ultimo dia con heleada
               datesdisabled = sacar_fechas # se sacan las fechas que no tengan heladas
             )
           ),
           mainPanel(uiOutput(ns(
             "imagen_3"
           ))))
}

#################################
# SERVER
cartografiaHeladasServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 # HELADAS ######################
                 output$imagen_3 <- renderUI({
                   ns <- session$ns
                   
                   src <- paste0("./heladas/",
                                 grep(
                                   pattern = format(input$inImgHeladas,
                                                    format = "%d%m%Y"),
                                   archivos_heladas,
                                   value = TRUE
                                 ))
                   
                   img(src = src, width = "100%")
                 })
                 
               })
}
