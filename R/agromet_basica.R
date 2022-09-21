#################################
# UI
agroBasicaUI <- function(id) {
  ns <- NS(id)
  
  tags$style(HTML(".datepicker {z-index:99999 !important;}"))
  
  tagList(sidebarLayout(
    sidebarPanel(
      h3("Estación meteorológica EEA INTA Anguil"),
      dateRangeInput(
        ns("inFechas"),
        "Rango de fechas:",
        min    = fecha_min_datos_siga,
        max    = fecha_max_datos_siga,
        start  = fecha_max_datos_siga - 10,
        end    = fecha_max_datos_siga,
        format = "dd/mm/yyyy",
        separator = " - ",
        language = "es"
      ),
      tags$style(HTML(
        ".datepicker {z-index:99999 !important;}"
      ))
      
    ),
    
    mainPanel(
      dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
          fluidRow(column(6,
                          h3(
                            "Período seleccionado: "
                          ))
                   ,
                   column(6,
                          h3(textOutput(
                            ns("titulo")
                          )))),
          
          fluidRow(
            valueBoxOutput(ns("temp_min")),
            valueBoxOutput(ns("temp_max")),
            valueBoxOutput(ns("temp_mean")),
            valueBoxOutput(ns("lluvia_sum")),
            valueBoxOutput(ns("viento_mean"))
            
          )
          
        )
      )
      
    )
    
  ))
}

#################################
# SERVER
agroBasicaServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$titulo <- renderText({
                   paste0(
                     format(input$inFechas[1], "%d/%m/%Y"),
                     " - ",
                     format(input$inFechas[2], "%d/%m/%Y")
                   )
                 })
                 
                 ##### estadísticas generales
                 
                 # dataset
                 data_aux_2 <- reactive({
                   retorno <- datos_siga %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2]) %>%
                     summarise(
                       tmin = min(temperatura_abrigo_150cm_minima, na.rm = TRUE),
                       tmax = max(temperatura_abrigo_150cm_maxima, na.rm = TRUE),
                       tmean = mean(temperatura_abrigo_150cm, na.rm = TRUE),
                       sum = sum(precipitacion_pluviometrica, na.rm = TRUE),
                       media_viento = mean(velocidad_viento_200cm_media, na.rm = TRUE)
                     )
                   
                   retorno
                   
                 })
                 
                 
                 # TEMP
                 output$temp_min <- renderValueBox({
                   data <- data_aux_2() %>% select(tmin)
                   valueBox(
                     paste0(round(data, 1), "ºC"),
                     "Temp. mínima",
                     icon = icon("thermometer-empty", verify_fa = FALSE),
                     color = "blue"
                   )
                 })
                 
                 output$temp_max <- renderValueBox({
                   data <- data_aux_2() %>% select(tmax)
                   valueBox(
                     paste0(round(data, 1), "ºC"),
                     "Temp. máxima",
                     icon = icon("thermometer-full", verify_fa = FALSE),
                     color = "red"
                   )
                 })
                 
                 output$temp_mean <- renderValueBox({
                   data <- data_aux_2() %>% select(tmean)
                   valueBox(
                     paste0(round(data, 1), "ºC"),
                     "Temp. promedio",
                     icon = icon("thermometer-half", verify_fa = FALSE),
                     color = "purple"
                   )
                 })
                 
                 # PRECIP
                 output$lluvia_sum <- renderValueBox({
                   data <- data_aux_2() %>% select(sum)
                   valueBox(
                     paste0(round(data, 1), "mm"),
                     "Acumulado de precipitación",
                     icon = icon("cloud-showers-heavy"),
                     color = "teal"
                   )
                 })
                 
                 # VIENTO
                 output$viento_mean <- renderValueBox({
                   data <- data_aux_2() %>% select(media_viento)
                   valueBox(
                     paste0(round(data, 1), "km/h"),
                     "Viento Medio",
                     icon = icon("wind"),
                     color = "light-blue"
                   )
                 })
                 
               })
}
