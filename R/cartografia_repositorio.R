# Archivo para Repositorio digital de archivos.
# En este caso, se usan conjuntamente las funciones "lapply" y "actionButton"
# para crear los 12 botones por año. Cada botón, tiene asociado
# un archivo .xls dentro de la carpeta "./www/repositorios_sig/Precipitaciones/"
# para su descarga

#################################
# UI
cartografiaRepositorioUI <- function(id) {
  ns <- NS(id)
  
  # repositorio digital de archivos ######################
  tagList(#
    # Botones para el año 2023
    tags$h2("2023"),
    fluidRow(lapply(1:12, function(i) {
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('repositorios_sig/Precipitaciones/2023/",
          mes_id[i] ,
          "2023" ,
          ".xls','_blank','resizable')"
        )
      )
    })),
    
    # Botones para el año 2022
    tags$h2("2022"),
    fluidRow(lapply(1:12, function(i) {
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('repositorios_sig/Precipitaciones/2022/",
          mes_id[i] ,
          "2022" ,
          ".xls','_blank','resizable')"
        )
      )
    })),
    
    # Botones para el año 2021
    tags$h2("2021"),
    fluidRow(lapply(1:12, function(i) {
      actionButton(
        paste0('boton', mes_id[i]),
        label = mes_desc[i],
        value = mes_id[i],
        onclick = paste0(
          "window.open('repositorios_sig/Precipitaciones/2021/",
          mes_id[i] ,
          "2021" ,
          ".xls','_blank','resizable')"
        )
      )
    })))
}

#################################
# SERVER
cartografiaRepositorioServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
