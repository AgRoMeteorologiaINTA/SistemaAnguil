#################################
# UI
cartografiaRepositorioUI <- function(id) {
  ns <- NS(id)
  
  # repositorio digital de archivos ######################
  tagList(tags$h2("2022"),
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
          })))
}

#################################
# SERVER
cartografiaRepositorioServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
