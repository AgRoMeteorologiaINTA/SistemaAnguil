# Archivo para la sección Estadísticas datos Anguil.
# Se usan conjuntamente las funciones "lapply" y "actionButton"
# para crear los 12 botones por año. Cada botón, tiene asociado
# un archivo .xls dentro de la carpeta "./www/estadisticas_anguil/"
# para su descarga

#################################
# UI
estadisticasAnguilUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h1("Estadisticas Anguil"),
    
    tags$h2("2023"),
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
