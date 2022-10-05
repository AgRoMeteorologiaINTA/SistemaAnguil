# Archivo para poder desplegar la app en la cuenta de shinyapps.io

# Se sigue del tutorial:
# https://www.r-bloggers.com/2021/02/deploy-to-shinyapps-io-from-github-actions/

library(rsconnect)

# Función para detener el script cuando no se puede encontrar una de las variables; 
# y eliminar las comillas de los secretos
error_on_missing_name <- function(name){
	var <- Sys.getenv(name, unset=NA)
	if(is.na(var)){
		stop(paste0("cannot find ",name, " !"),call. = FALSE)
	}
	gsub("\"", '',var)
}

# Autenticacion para shinyapps.io
rsconnect::setAccountInfo(
	name = error_on_missing_name("SHINY_ACC_NAME"),
	token = error_on_missing_name("TOKEN"),
	secret = error_on_missing_name("SECRET")
)

# Despliege de la app
rsconnect::deployApp(
  # appFiles = NULL: 
  #  despliega todo el directorio. El archivo app.R, ya se encuentra allí
	appFiles = NULL, 
	appName = error_on_missing_name("MASTERNAME"),
	appTitle = "shinyapplication"
)