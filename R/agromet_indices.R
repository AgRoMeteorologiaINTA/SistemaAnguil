#################################
# UI
agroIndicesUI <- function(id) {
  ns <- NS(id)
  
  tagList(sidebarLayout(
    sidebarPanel(
      h3("Estación meteorológica EEA INTA Anguil"),
      h4("filtros"),
      h6("EJ: t_min <= 0  , para filtrar sólo los días donde hay heladas."),
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
      
      fluidRow(column(
        8,
        selectInput(
          ns("operacion"),
          "operacion",
          choices = c(
            "Temp. min. abrigo a 150cm <=" = "t_a_min",
            "Temp. max. abrigo a 150cm >=" = "t_a_max",
            "Temp. min. intemperie 50cm <=" = "t_i_min"
          )
        )
      ),
      column(
        4,
        numericInput(
          inputId = ns("valor"),
          label = "valor (en ºC)",
          value = 0,
          min = -10,
          max = 10,
          step = 1
        )
      ))
      
    ),
    
    mainPanel(
      dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
          fluidRow(column(6,
                          h3(
                            "Período seleccionado"
                          ))
                   ,
                   column(6,
                          h3(textOutput(
                            ns("titulo")
                          )))),
          
          h3(textOutput(ns("subtitulo_1"))),
          fluidRow(valueBoxOutput(ns("boxN")))
        )
      )
    )
  ))
}

#################################
# SERVER
agroIndicesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$titulo <- renderText({
                   paste0(
                     format(input$inFechas[1], "%d/%m/%Y"),
                     " - ",
                     format(input$inFechas[2], "%d/%m/%Y")
                   )
                 })
                 
                 ##### agromet - umbrales
                 output$subtitulo_1 <- renderText({
                   aux_formula <- switch(
                     input$operacion,
                     "t_a_min" = "Temperatura mínima en abrigo a 150cm <= ",
                     "t_a_max" = "Temperatura máxima en abrigo a 150cm >=" ,
                     "t_i_min" = "Temperatura mínima a la intemperie a 50cm <= "
                   )
                   
                   paste0("Uso de la funcion 'umbrales' con el filtro de ",
                          aux_formula,
                          input$valor)
                 })
                 
                 
                 data_aux <- reactive({
                   retorno <- datos_siga %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2])
                   
                   retorno <- switch(
                     input$operacion,
                     "t_a_min" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_abrigo_150cm_minima <= input$valor)
                     ),
                     "t_a_max" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_abrigo_150cm_maxima >= input$valor)
                     ) ,
                     "t_i_min" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_intemperie_50cm_minima <= input$valor)
                     )
                   )
                   
                   retorno
                   
                 })
                 
                 # Caja con cantidad de días retornada por la funcion
                 output$boxN <- renderValueBox({
                   data <- data_aux() %>% select(N)
                   if (is.na(data)) {
                     data <- 0
                   }
                   valueBox(paste0(data),
                            "día/s",
                            icon = icon("list"),
                            color = "green")
                 })
                 
               })
}
