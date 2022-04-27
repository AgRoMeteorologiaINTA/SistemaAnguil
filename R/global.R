library(shiny)
library(shinythemes)
library(agromet)
library(siga)
library(shinydashboard)
library(plotly)
library(RColorBrewer)
library(wesanderson)
library(leaflet)
library(jsonlite)



# La parte izquierda es la que se ve por ejemplo en la tabla de historicos
# La parte derecha, es la que busca coincidencia en los nombres de la cartografía

mes_id <- c("ENE", "FEB","MAR", "ABR","MAY", "JUN","JUL", "AGO","SEP", "OCT", "NOV", "DIC")
mes_desc <- c("Enero", "Febrero", "Marzo", "Abril","Mayo", "Junio","Julio", "Agosto","Septiembre", "Octubre","Noviembre", "Diciembre")
meses_df <- data.frame(mes_id,mes_desc)
meses = setNames(meses_df$mes_id , meses_df$mes_desc)

direcciones_viento <- as_tibble(c("E","NE", "N","NO","O","SO","S","SE"))


# Para anguil.r
# Lectura del archivo anguil.csv
anguil_csv <- readr::read_csv(
  "data/anguil.csv",
  col_types = cols(
    #X1 = col_skip(),
    fecha = col_date(format = "%d/%m/%Y"),
    codigo_nh = col_integer(),
    t_max = col_double(),
    hr = col_integer(),
    heliofania_efec = col_double(),
    radiacion = col_double(),
    etp = col_double(),
    t_media = col_double(),
    amplitud = col_double()
  )
)

# se agregan algunas columnas calculadas
data_anguil <- anguil_csv %>%
  mutate(
    anio = as.integer(lubridate::year(fecha)),
    mes =  as_factor(lubridate::month(fecha)),
    dias_mes = lubridate::days_in_month(fecha),
    dias_mes = replace(dias_mes, dias_mes == 29, 28),
    # en febrero, cambio el dia para bisiestos
    semana = lubridate::week(fecha),
    mes_nombre = as_factor(
      case_when(
        mes == 1  ~ "Ene",
        mes == 2  ~ "Feb",
        mes == 3  ~ "Mar",
        mes == 4  ~ "Abr",
        mes == 5  ~ "May",
        mes == 6  ~ "Jun",
        mes == 7  ~ "Jul",
        mes == 8  ~ "Ago",
        mes == 9  ~ "Sep",
        mes == 10  ~ "Oct",
        mes == 11  ~ "Nov",
        mes == 12  ~ "Dic"
      )
    ),
    clase_t_max = as_factor(case_when(
      t_max > 40 ~ "> 40º",
      t_max > 35 ~ "> 35º",
      t_max > 30 ~ "> 30º"
    )),
    clase_precip = as_factor(
      case_when(
        precip > 50 ~ "> 50mm",
        precip > 20 ~ "> 20mm",
        precip > 10 ~ "> 10mm",
        precip > 5 ~ "> 5mm",
        #precip > 2 ~ "> 2mm",
        precip > 0 ~ "> 0mm",
        precip == 0 ~ "0mm"
      )
    )
  )


# Para gromet
A872823 <-  siga::siga_datos("A872823") # Descarga de datos de Anguil
fecha_min_A872823 <- min(A872823$fecha) # Fecha minima del dataset
fecha_max_A872823 <- max(A872823$fecha) # Fecha maxima del dataset

# Para radar
api_url   <-   "https://inta-api.dev.fundacionsadosky.org.ar/v1.0.0/"
api_token <- Sys.getenv("PALENQUE_KEY")
