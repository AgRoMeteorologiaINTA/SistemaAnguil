#################################
# UI
estadisticasAnguilUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h1("Estadisticas Anguil"),
    
    tags$h2("2022"),
    fluidRow(lapply(1:12, function(i) {
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('estadisticas_anguil/Sintesis_",
          mes_id[i] ,
          "2022" ,
          ".xlsx','_blank','resizable')"
        )
      )
    })),
    
    tags$h2("2021"),
    fluidRow(lapply(1:12, function(i) {
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('estadisticas_anguil/Sintesis_",
          mes_id[i] ,
          "2021" ,
          ".xlsx','_blank','resizable')"
        )
      )
    })),
    
    tags$h2("2020"),
    fluidRow(lapply(1:12, function(i) {
      #column(1,
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('estadisticas_anguil/Sintesis_",
          mes_id[i] ,
          "2020" ,
          ".xlsx','_blank','resizable')"
        )
      )
      #)
    }))
    
    
  )
}

#################################
# SERVER
estadisticasAnguilServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ns <- session$ns
                 
               })
}
