#################################
# UI
cartografiaHistoricosUI <- function(id) {
  ns <- NS(id)
  
  # PROMEDIOS HISTORICOS ######################
  navlistPanel(
    #"Informes mensuales",
    tabPanel(
      "Mapa 1",
      # "inta-mapa-precipitaciones-la-pampa-1.pdf",
      tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                  src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-1.pdf")
    ),
    tabPanel(
      "Mapa 2",
      # "inta-mapa-precipitaciones-la-pampa-2.pdf",
      tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                  src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-2.pdf")
    ),
    tabPanel(
      "Mapa 3",
      # "inta-mapa-precipitaciones-la-pampa-3.pdf",
      tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                  src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-3.pdf")
    ),
    tabPanel(
      "Mapa 4",
      # "inta-mapa-precipitaciones-la-pampa-4.pdf",
      tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                  src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-4.pdf")
    )
  )
  
}

#################################
# SERVER
cartografiaHistoricosServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
