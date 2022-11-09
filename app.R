# Archivo con las funciones principales de la app

############################################################
# UI
# Disposición de los objetos "navbarMenu", 
# y llamados a la parte gráfica de los modulos 

ui <- navbarPage(
  id = "tabs",
  title =  div(img(src = "logo_inta_40px.png"), "Sistema Anguil"),
  windowTitle = "Sistema Anguil",
  
  theme = shinytheme("flatly"),
  
  #################
  # Registros históricos y Climatología Anguil
  navbarMenu(
    title = "Índices Agrometeorológicos",
    tabPanel(
      title = "Estadística Básica",
      value = "agromet_basica",
      agroBasicaUI(id = "agromet_basica")
    ),
    tabPanel(
      title = "Índices",
      value = "agromet_indices",
      agroIndicesUI(id = "agromet_indices")
    )
  ),
  
  #################
  # Registros históricos y Climatología Anguil
  navbarMenu(
    title = "Registros históricos",
    tabPanel(
      title = "Registro Histórico",
      value = "historico",
      h1("Histórico"),
      historicoUI(id = "historico")
    ),
    tabPanel(title = "Climatología Anguil",
             value = "anguil",
             anguilUI(id = "anguil"))
  ),
  
  navbarMenu(
    title = "Cartografía",
    icon = icon("map-marked-alt", verify_fa = FALSE),
    tabPanel(
      title = "Precipitaciones",
      value = "precipitaciones",
      h1("Precipitaciones"),
      cartografiaPrecipitacionesUI(id = "precipitaciones")
    ),
    tabPanel(
      title = "Índices de sequia",
      value = "indices_sequia",
      h1("Índices de sequia"),
      cartografiaSequiasUI(id = "indices_sequia")
    ),
    tabPanel(
      title = "Mapas de heladas",
      value = "mapas_heladas",
      h1("Mapas de heladas"),
      cartografiaHeladasUI(id = "mapas_heladas")
    ),
    tabPanel(
      title = "Promedios históricos",
      value = "promedios_historicos",
      h1("Promedios históricos de precipitación en la provincia de La Pampa"),
      cartografiaHistoricosUI(id = "promedios_historicos")
    ),
    tabPanel(
      title = "Repositorio digital de archivos",
      value = "repositorio_digital",
      h1("Repositorio digital de archivos"),
      cartografiaRepositorioUI(id = "repositorio_digital")
    )
  ),
  
  #################
  # Links
  tabPanel(
    title = "Links",
    icon = icon("link", verify_fa = FALSE),
    value = "links",
    linksUI(id = "links")
  ),
  
  #################
  # Informes técnicos y publicaciones
  tabPanel(
    title = "Informes técnicos y publicaciones",
    icon = icon("publicaciones", verify_fa = FALSE),
    value = "publicaciones",
    publicacionesUI(id = "publicaciones")
  ),
  
  #################
  # Eventos climáticos extremos
  tabPanel(
    title = "Eventos",
    icon = icon("eventos", verify_fa = FALSE),
    value = "eventos",
    eventosUI(id = "eventos")
  ),
  
  #################
  # Radar meteorológico
  # https://inta-api.dev.fundacionsadosky.org.ar/v1.0.0/swagger-ui.html#/
  navbarMenu(
    title = "Radar",
    icon = icon("satellite-dish", verify_fa = FALSE),
    tabPanel(
      title = "Granizo",
      value = "radar_granizo",
      radarGranizoUI(id = "radar_granizo")
    ),
    tabPanel(
      title = "Lluvias",
      value = "radar_lluvias",
      radarLluviasUI(id = "radar_lluvias")
    ),
    tabPanel(
      title = "Mediciones",
      value = "radar_mediciones",
      radarMedicionesUI(id = "radar_mediciones")
    ),
    tabPanel(
      title = "Sumarizaciones Mediciones",
      value = "radar_sumarizaciones_mediciones",
      radarSumarizacionesMedicionesUI(id = "radar_sumarizaciones_mediciones")
    ),
    tabPanel(
      title = "Vols",
      value = "radar_vols",
      radarVolsUI(id = "radar_vols")
    )
  ),
  
  #################
  # Radiación solar
  tabPanel(
    title = "Radiación solar",
    #icon = icon("radiacion", verify_fa = FALSE),
    value = "radiacion",
    radiacionUI(id = "radiacion")
  ),
  
  #################
  # Estadisticas Anguil
  tabPanel(
    title = "Estadísticas datos Anguil",
    icon = icon("", verify_fa = FALSE),
    value = "estadisticas_anguil",
    estadisticasAnguilUI(id = "estadisticas_anguil")
  ),
  
  tags$footer(
    'Estación Experimental Agropecuaria Anguil "Ing. Agr. Guillermo Covas".
    Ruta Nacional N| 5. Km 580. (6326) Anguil, La Pampa. 02954-495057 - @intaanguil',
    align = "center",
    style = "
            position:fixed;
            bottom:0;
            width:100%;
            height:50px;
            color: #e6e6e6;
            padding: 10px;
            background-color: #2c3e50;
            z-index: 1000;
            right: 0;
            text-align:center;
            font-size: 14px;
    "
  )
)


############################################################
# SERVER
# Llamados a la parte de "server" de los modulos

server <- function(input, output, session) {
  #################
  # agromet
  agroBasicaServer(id = "agromet_basica")
  agroIndicesServer(id = "agromet_indices")
  
  #################
  # historico
  historicoServer(id = "historico")
  
  #################
  # anguil
  anguilServer(id = "anguil")
  
  #################
  # cartografía
  cartografiaPrecipitacionesServer(id = "precipitaciones")
  cartografiaSequiasServer(id = "indices_sequia")
  cartografiaHeladasServer(id = "mapas_heladas")
  cartografiaHistoricosServer(id = "promedios_historicos")
  cartografiaRepositorioServer(id = "repositorio_digital")
  
  #################
  # links
  linksServer(id = "links")
  
  #################
  # publicaciones
  publicacionesServer(id = "publicaciones")
  
  #################
  # eventos
  eventosServer(id = "eventos")
  
  #################
  # radar
  radarGranizoServer(id = "radar_granizo")
  radarLluviasServer(id = "radar_lluvias")
  radarMedicionesServer(id = "radar_mediciones")
  radarSumarizacionesMedicionesServer(id = "radar_sumarizaciones_mediciones")
  radarVolsServer(id = "radar_vols")
  
  
  #################
  # Radiación solar
  radiacionServer(id = "radiacion")
  
  #################
  # Estadisticas Anguil
  estadisticasAnguilServer(id = "estadisticas_anguil")
  
}

shinyApp(ui = ui, server = server)
