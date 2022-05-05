#################################
# UI
linksUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h1("Links"),
    tags$a("INTA EEA Anguil",
           href = "https://inta.gob.ar/anguil", target = "_blank"),
    tags$br(),
    tags$a(
      "INTA Instituto de Clima y Agua",
      href = "https://inta.gob.ar/clima-y-agua",
      target = "_blank"
    ),
    tags$br(),
    tags$a(
      "INTA Sistema de Información y Gestión Agrometeorológica",
      href = "http://siga.inta.gob.ar/#/",
      target = "_blank"
    ),
    tags$br(),
    tags$a("INTA Geointa",
           href = "http://www.geointa.inta.gob.ar", target = "_blank"),
    tags$br(),
    tags$a(
      "Radares Meteorológicos de INTA",
      href = "https://radar.inta.gob.ar",
      target = "_blank"
    ),
    tags$br(),
    tags$a(
      "INTA ICyA Herramientas satelitales para el seguimiento de la producción agropecuaria",
      href = "http://sepa.inta.gob.ar",
      target = "_blank"
    ),
    tags$br(),
    tags$a(
      "INTA Pronósticos a corto plazo",
      href = "https://inta.gob.ar/documentos/pronosticos",
      target = "_blank"
    ),
    tags$br(),
    tags$a(
      "Servicio Meteorológico Nacional",
      href = "https://www.smn.gob.ar",
      target = "_blank"
    ),
    tags$br(),
    tags$a(
      "Gob. de La Pampa Red de Estaciones Climáticas",
      href = "https://lapampa.redesclimaticas.com/accounts",
      target = "_blank"
    )
  )
  
}

#################################
# SERVER
linksServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
