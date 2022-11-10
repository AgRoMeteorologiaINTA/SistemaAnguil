# Archivo para variables, arrays, y funciones comunes entre modulos de la app.

library(shiny)
library(shinythemes)
library(agromet)
library(siga)
library(shinydashboard)
library(plotly)
library(RColorBrewer)
library(wesanderson)
library(shinyWidgets)
library(shinycssloaders)
library(leaflet)
library(DT)
library(rjson)

mes_id <-
  c("ENE",
    "FEB",
    "MAR",
    "ABR",
    "MAY",
    "JUN",
    "JUL",
    "AGO",
    "SEP",
    "OCT",
    "NOV",
    "DIC")
mes_desc <-
  c(
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  )

# La parte izquierda es la que se ve por ejemplo en la tabla de historicos
# La parte derecha, es la que busca coincidencia en los nombres de la cartografía
meses_df <- data.frame(mes_id, mes_desc)
meses = setNames(meses_df$mes_id , meses_df$mes_desc)

direcciones_viento <-
  as_tibble(c("E", "NE", "N", "NO", "O", "SO", "S", "SE"))

## Para gromet
# A872823 <-
#   siga::siga_datos("A872823") # Descarga de datos de Anguil
# fecha_min_A872823 <- min(A872823$fecha) # Fecha minima del dataset
# fecha_max_A872823 <- max(A872823$fecha) # Fecha maxima del dataset
datos_siga <-
  siga::siga_datos("NH0446") # Descarga de datos de Anguil
fecha_min_datos_siga <- min(datos_siga$fecha) # Fecha minima del dataset
fecha_max_datos_siga <- max(datos_siga$fecha) # Fecha maxima del dataset

# Para cartografía
# Listado de los nombres de los archivos (imagenes, pdf's, etc)
archivos_precip <-
  list.files("./www/precipitaciones/", recursive = TRUE)

archivos_sequia <- list.files("./www/sequias/", pattern = "^SP3")

archivos_heladas <-
  list.files("./www/heladas/", pattern = "^HELADAS", recursive = TRUE)

fechas_heladas <-
  as.Date(str_sub(archivos_heladas, start = -13, end = -6), format = "%d%m%Y")

# ordenado
fechas_heladas <- sort(fechas_heladas)

dias <- seq(from = as.Date("2021/7/1"),
            to = Sys.Date(),
            by = "day")

sacar_fechas <- dias[!(dias %in% fechas_heladas)]

archivos_repositorio <-
  list.files("./www/repositorios_sig/Presipitaciones/", pattern = "\\.xls$")

# Para radar
api_url <- "https://inta-api.dev.fundacionsadosky.org.ar/v1.0.0/"
palenque_key <- Sys.getenv("PALENQUE_KEY", unset = NA)

llamar_api <-
  function(metodo,
           fechaDesde = "2022-01-01",
           fechaHasta = "2022-01-01") {
    #imagenes <- c()
    imagenes <- data.frame()
    page <- 0
    
    repeat {
      url <-
        paste0(
          api_url,
          metodo,
          "?desde=",
          fechaDesde,
          "&hasta=",
          fechaHasta,
          "&pageIndex=",
          page
        )
      
      res <- httr::GET(
        url = url,
        httr::add_headers(
          "Authorization" = paste0("Bearer palenque:", palenque_key),
          "accept" = "application/json",
          "Content-Type" = "application/json"
        )
      )
      
      print("res")
      print(res)
      
      # Si la respuesta no es 200, hubo un problema
      if(res$status != 200)
        return(NULL)
      
      data <- fromJSON(rawToChar(res$content))
      
      
      print("res$status")
      print(res$status)
      
      
      
      
      
      #imagenes <- append(imagenes, data$items$imageUrl)
      imagenes <- rbind(imagenes, data.frame(data$items))
      
      if (is.null(imagenes)) {
        return(NULL)
      }
      
      if (is.null(data$moreData)) {
        return(NULL)
      }
      
      if (data$moreData == FALSE) {
        break
      }
      
      page <- page + 1
      
    }
    
    return(imagenes)
  }