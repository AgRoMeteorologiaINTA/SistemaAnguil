##############################
# UI
ui <- navbarPage(
  id = "tabs",
  title =  div(img(src = "logo_inta_40px.png"), "Sistema Anguil"),
  windowTitle = "Sistema Anguil",
  
  theme = shinytheme("flatly"),
  
  # #################
  # # Inicio
  # tabPanel(
  #   title = " Inicio",
  #   icon = icon("home", verify_fa = FALSE),
  #   shinythemes::themeSelector(),
  #   inicioUI(id = "inicio")
  # ),
  #################
  # Registros históricos y Climatología Anguil
  navbarMenu(
    title = "Índices Agrometeorológicos",
    #shinythemes::themeSelector(),
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
  
  #################
  # Cartografía de variables agrometeorológicas
  # tabPanel(
  #   title = "Cartografía",
  #   icon = icon("map-marked-alt", verify_fa = FALSE),
  #   value = "cartografia",
  #   h1("Cartografía de variables agrometeorológicas"),
  #   cartografiaUI(id = "cartografia")
  # ),
  
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
      h1("Promedios históricos de precipitacion en la provincia de La Pampa"),
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
  tabPanel(
    title = "Radar",
    icon = icon("radar", verify_fa = FALSE),
    value = "radar",
    radarUI(id = "radar")
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


#################################
# SERVER
server <- function(input, output, session) {
  #################
  # Inicio
  #callModule(inicioServer, "inicio", parent_session = session)
  
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
  # cartografia
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
  radarServer(id = "radar")
  
  #################
  # Radiación solar
  radiacionServer(id = "radiacion")
  
  
  #################
  # Estadisticas Anguil
  estadisticasAnguilServer(id = "estadisticas_anguil")
  
}

shinyApp(ui = ui, server = server)
