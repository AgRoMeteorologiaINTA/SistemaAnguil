llamar_api <-
  function(metodo,
           fechaDesde = "2022-01-01",
           fechaHasta = "2022-01-01") {
    url <-
      paste0(api_url,
             metodo,
             "?desde=",
             fechaDesde,
             "&hasta=",
             fechaHasta,
             "&pageIndex=0")
    
    imagenes <- c()
    page <- 0
    repeat {
      res <- httr::GET(
        url = url,
        httr::add_headers(
          "Authorization" = paste0("Bearer palenque:", palenque_key),
          "accept" = "application/json",
          "Content-Type" = "application/json"
        )
      )
      
      data <- fromJSON(rawToChar(res$content))
      
      imagenes <- append(imagenes, data$items$imageUrl)
      
      #data$nextPageIndex
      page <- page + 1
      
      if (data$moreData == FALSE) {
        break
      }
      
    }
    
    return(imagenes)
  }

#################################
# UI
radarGranizoUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Granizo"),
          
          sidebarLayout(
            sidebarPanel(
              dateRangeInput(
                ns("inFechas"),
                "Rango de fechas:",
                min    = "2020-01-01",
                max    = "2022-04-01",
                start  = "2022-02-01",
                end    = "2022-04-01",
                format = "dd/mm/yyyy",
                separator = " - ",
                language = "es"
              )
              
            ),
            
            mainPanel(
              h2("Listado con llamado a la api por fecha filtrada"),
              textOutput(ns("debug")),
              tableOutput(ns("tabla"))
            )
            
          ))
  
}

#################################
# SERVER
radarGranizoServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$tabla <- renderTable({
                   ns <- session$ns
                   llamar_api(
                     "granizo",
                     fechaDesde = input$inFechas[1],
                     fechaHasta = input$inFechas[2]
                   )
                 })
                 
                 output$debug <- renderText({
                   ns <- session$ns
                   paste0("Sys.getenv PALENQUE_KEY: ", palenque_key)
                 })
                 
               })
}
