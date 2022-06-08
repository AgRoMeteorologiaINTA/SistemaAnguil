#################################
# UI
cartografiaRepositorioUI <- function(id) {
  ns <- NS(id)
  
  # repositorio digital de archivos ######################
    tagList(
      # # preparado para 2023, 2024 y 2025
      
      # tags$h2("2025"),
      # fluidRow(lapply(1:12, function(i) {
      #   actionButton(
      #     paste0('boton', mes_id[i]),
      #     label = mes_desc[i],
      #     value = mes_id[i],
      #     onclick = paste0(
      #       "window.open('repositorios_sig/Precipitaciones/2025/",
      #       mes_id[i] ,
      #       "2025" ,
      #       ".xls','_blank','resizable')"
      #     )
      #   )
      # })),
      
      # tags$h2("2024"),
      # fluidRow(lapply(1:12, function(i) {
      #   actionButton(
      #     paste0('boton', mes_id[i]),
      #     label = mes_desc[i],
      #     value = mes_id[i],
      #     onclick = paste0(
      #       "window.open('repositorios_sig/Precipitaciones/2024/",
      #       mes_id[i] ,
      #       "2024" ,
      #       ".xls','_blank','resizable')"
      #     )
      #   )
      # })),
      
      # tags$h2("2023"),
      # fluidRow(lapply(1:12, function(i) {
      #   actionButton(
      #     paste0('boton', mes_id[i]),
      #     label = mes_desc[i],
      #     value = mes_id[i],
      #     onclick = paste0(
      #       "window.open('repositorios_sig/Precipitaciones/2023/",
      #       mes_id[i] ,
      #       "2023" ,
      #       ".xls','_blank','resizable')"
      #     )
      #   )
      # })),
      
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
      }))
    )
  
}

#################################
# SERVER
cartografiaRepositorioServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
