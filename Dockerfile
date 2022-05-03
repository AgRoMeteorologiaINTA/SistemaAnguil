FROM rocker/shiny:4.1.3
WORKDIR /home/shinyusr

# Instalación de bibliotecas en R
RUN install2.r rsconnect \
				remotes \
				DT \
				tidyverse \
				plotly \
				reshape2 \
				shinydashboard \
				shinythemes \
				wesanderson \
				leaflet \
				jsonlite

# Instalación de software del INTA
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/agromet", build_vignettes = FALSE)'
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/siga", build = FALSE)'

# Copiado de archivos adentro del la imagen
COPY deploy.R deploy.R
COPY data/ data/
COPY app.R app.R
COPY R/ R/
COPY www/ www/

# Para pasar la KEY desde GITHUB, al contenedor
ARG BUILD_PALENQUE_KEY=valor_default 
RUN echo "PALENQUE_KEY=${BUILD_PALENQUE_KEY}" >> .Renviron

# Deploy de la aplicación
CMD Rscript deploy.R