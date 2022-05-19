archivos_rad_solar <-
  list.files("./www/radiacion/", recursive = TRUE)

archivo_info <- paste0("./radiacion/", "radiacion.png")

# flag <- TRUE

#################################
# UI
radiacionUI <- function(id) {
  ns <- NS(id)
  
  # tagList(
  # tags$h1("Radiación solar")
  sidebarLayout(
    sidebarPanel(
      tags$h2("Información"),
      actionButton(ns("inBotonInfo"),
                   "Info"),
      
      tags$h2("Irradiación diaria, promedio mensual"),
      radioGroupButtons(
        inputId = ns("inGB1"),
        label = "",
        choices = mes_desc,
        direction = "horizontal",
        individual = TRUE
      ),
      
      tags$h2("Radiación solar mensual"),
      selectInput(ns('inAnio'),
                  'AÑO',
                  choices = c("2022",
                              "2021",
                              "2020")),
      selectInput(ns('inMes'),
                  'MES',
                  choices = mes_desc),
      
      tags$h2("Irradiación acumulada, promedio anual"),
      actionButton(ns("inBotonAnual"),
                   "Promedio anual")
      
    ),
    mainPanel(
      # textOutput(ns("salida")),
      uiOutput(ns(
        "imagen_radiacion"
      )))
    
  )
  
  # )
}

#################################
# SERVER
radiacionServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 observeEvent(input$inBotonInfo, {
                   output$imagen_radiacion <- renderUI({
                     src <- paste0("./radiacion/", "radiacion.png")
                     img(src = src, width = "65%")
                   })
                   
                 })
                 
                 observeEvent(input$inGB1, {
                   output$imagen_radiacion <- renderUI({
                     src <-
                       paste0("./radiacion/", "RD_promedio_", input$inGB1, ".png")
                     
                     if (identical(src, character(0))) {
                       HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                     } else {
                       img(src = src)
                       # img(src = src, width = "80%")
                     }
                     
                   })
                 })
                 
                 # output$salida <- renderText({
                 #   src <- paste0("./radiacion/Radiacion_solar_",input$inMes,"_",input$inAnio,".jpg")
                 #   src
                 # })
                 
                 # Radiacion solar
                 observeEvent(c(input$inAnio, input$inMes), {
                   
                   output$imagen_radiacion <- renderUI({
                     #ns <- session$ns
                     
                     src <- archivos_rad_solar %>%
                       str_subset(input$inAnio) %>%
                       str_subset(input$inMes)
                     
                     if (identical(src, character(0))) {
                       texto_rojo <- '<h3 style="color: red;">¡No hay imagen para el periodo seleccionado!</h3>'
                       texto_negro <- '<h4>Información:</h4>'
                       imagen_info <- paste0('<img src="',archivo_info,'">')
                       code_html <- paste0(texto_rojo, texto_negro, imagen_info)
                       HTML(code_html)
                       
                     } else {
                       src <- paste0("./radiacion/", src)
                       img(src = src, width = "85%")
                     }
                     
                   })
                 })
                 
                 observeEvent(input$inBotonAnual, {
                   output$imagen_radiacion <- renderUI({
                     src <- paste0("./radiacion/", "RD_promedio_Anual.png")
                     img(src = src, width = "60%")
                   })
                   
                 })
                 
                 # # solo para el aranque por default
                 # output$imagen_radiacion <- renderUI({
                 #   # src <- paste0("./radiacion/", "radiacion.png")
                 #   src <- archivo_info
                 #   img(src = src, width = "65%")
                 # })
                 
                 
                 
               })
}
