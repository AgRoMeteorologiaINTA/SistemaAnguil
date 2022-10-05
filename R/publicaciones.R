# Archivo para la sección "Informes y publicaciones".
# Se obtienen los nombres de los archivos dentro de la carpeta "./www/informes/".
# Luego, dependiendo si tienen la palabra "Informe", se colocan en la parte superior
# de "Informes de evaluación de cultivos",
# o en la inferior de "Publicaciones climáticas".
# A cada archivo, se le concatenan 2 digitos al comienzo de cada nombre,
# con el fin de ordenarlos alfabéticamente.
# Se usa la funcion "lapply", para crear todos los objetos "tabPanel"

# Listado de archivos en la carpeta www/informes
carpeta_informes <-
  list.files("./www/informes/", recursive = TRUE)

#Los que contienen la palabra "Informe"
archivos_informes <-
  carpeta_informes %>% str_subset("Informe") %>% str_sort(decreasing = TRUE)

#Los que NO contienen la palabra "Informe"
archivos_publicaciones <-
  carpeta_informes %>% str_subset("Informe", negate = TRUE) %>% str_sort(decreasing = TRUE)

#################################
# UI
publicacionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Informes y publicaciones"),
          
          do.call(
            navlistPanel,
            c(
              "Informes de evaluación de cultivos",
              lapply(1:length(archivos_informes), function(j) {
                tabPanel(
                  title = stringr::str_sub(archivos_informes[j], 4, -5),
                  # se sacan los nºs del comienzo, y el ".pdf"
                  value = archivos_informes[j],
                  tags$iframe(
                    style = "height:800px; width:100%; scrolling=yes",
                    src = paste0("./informes/", archivos_informes[j])
                  )
                )
              }),
              
              "Publicaciones climáticas",
              lapply(1:length(archivos_publicaciones), function(j) {
                tabPanel(
                  title = stringr::str_sub(archivos_publicaciones[j], 4, -5),
                  # se sacan los nºs del comienzo, y el ".pdf"
                  value = archivos_publicaciones[j],
                  tags$iframe(
                    style = "height:800px; width:100%; scrolling=yes",
                    src = paste0("./informes/", archivos_publicaciones[j])
                  )
                )
              })
            )
          ))
}

#################################
# SERVER
publicacionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
