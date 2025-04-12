
# =======================================
# DASHBOARD SHINY EXTENDIDO: MARKETING EN BOLIVIA
# =======================================
# ================================
#  INSTALAR LIBRERÍAS PARA SHINY
# ================================
if (!require("shiny")) install.packages("shiny")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("shinyWidgets")) install.packages("shinyWidgets")
# INSTALAR PAQUETES NECESARIOS (si no están)
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("sf")) install.packages("sf")
if (!require("leaflet")) install.packages("leaflet")
if (!require("patchwork")) install.packages("patchwork")
# =======================================
# DASHBOARD SHINY EXTENDIDO: MARKETING EN BOLIVIA
# =======================================

#  Librerías necesarias
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(leaflet)
library(sf)

#  Cargar datos
clientes <- read_csv("_data/marketing_clientes.csv")
servicios <- read_csv("_data/marketing_servicios.csv")
campañas <- read_csv("_data/marketing_campañas.csv") %>%
  rename(Departamento_Campaña = Departamento)
transacciones <- read_csv("_data/marketing_transacciones.csv")
departamentos <- st_read("_data/bo.json")

#  Unión de datos
datos_completos <- transacciones %>%
  left_join(clientes, by = "ID_Cliente") %>%
  left_join(servicios, by = "ID_Servicio") %>%
  left_join(campañas, by = "ID_Campaña")

#  Resumen por departamento
resumen_dpto <- datos_completos %>%
  group_by(Departamento) %>%
  summarise(
    Total_Ventas = sum(Total, na.rm = TRUE),
    Transacciones = n(),
    Clientes_Unicos = n_distinct(ID_Cliente),
    .groups = "drop"
  )

# ️ Unir con geojson
mapa_datos <- departamentos %>%
  left_join(resumen_dpto, by = c("name" = "Departamento"))

#  Paleta y descripción emergente
paleta <- colorNumeric("YlGnBu", domain = mapa_datos$Total_Ventas)
popup_contenido <- paste0(
  "<strong>", mapa_datos$name, "</strong><br/>",
  "🛒 Ventas: <b>", round(mapa_datos$Total_Ventas, 2), "</b><br/>",
  "🔁 Transacciones: <b>", mapa_datos$Transacciones, "</b><br/>",
  "👥 Clientes: <b>", mapa_datos$Clientes_Unicos, "</b>"
)

#  KPIs
total_ventas <- sum(datos_completos$Total, na.rm = TRUE)
total_clientes <- n_distinct(datos_completos$ID_Cliente)
total_transacciones <- nrow(datos_completos)

# =======================================
# UI
# =======================================
ui <- dashboardPage(
  dashboardHeader(title = "Marketing Bolivia"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Inicio", tabName = "inicio", icon = icon("home")),
      menuItem("KPIs", tabName = "kpi", icon = icon("tachometer-alt")),
      menuItem("Gráficos", tabName = "graficos", icon = icon("chart-bar")),
      menuItem("Geomarketing", tabName = "geomarketing", icon = icon("bullseye")),
      menuItem("Mapa", tabName = "mapa", icon = icon("globe")),
      menuItem("Créditos", tabName = "creditos", icon = icon("info-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "inicio",
              h2("Bienvenido al Dashboard de Marketing en Bolivia"),
              p("Explora visualizaciones y métricas sobre campañas, clientes y servicios."),
              p("Desarrollado con Shiny, Leaflet y análisis geoespacial.")
      ),
      tabItem(tabName = "kpi",
              fluidRow(
                valueBox(format(round(total_ventas, 2), big.mark = ","), "Total Ventas", icon = icon("dollar-sign"), color = "green"),
                valueBox(total_clientes, "Clientes Únicos", icon = icon("users"), color = "blue"),
                valueBox(total_transacciones, "Transacciones", icon = icon("exchange-alt"), color = "yellow")
              )),
      tabItem(tabName = "graficos",
              fluidRow(
                box(title = "Ventas por Categoría", width = 6, plotOutput("graf_categoria")),
                box(title = "Participación por Departamento", width = 6, plotOutput("graf_torta"))
              )),
      tabItem(tabName = "geomarketing",
              h3("Geomarketing: Campañas Personalizadas por Región"),
              p("Este gráfico simula cómo las empresas aplican segmentación geográfica para dirigir campañas."),
              p("Ejemplo: Coca-Cola lanza campañas distintas según zonas con mayor consumo."),
              fluidRow(
                box(title = "Ventas por Departamento y Categoría", width = 12, plotOutput("graf_geomarketing"))
              )),
      tabItem(tabName = "mapa",
              box(width = 12, leafletOutput("mapa_ventas", height = 500))
      ),
      tabItem(tabName = "creditos",
              h3("Creado en la Maestria ..."),
              p("Este dashboard fue desarrollado como parte de una práctica de visualización de datos con R y Shiny."),
              p("Incluye integración con mapas geoespaciales, análisis de datos y elementos visuales.")
      )
    )
  )
)

# =======================================
# SERVER
# =======================================
server <- function(input, output) {
  
  output$graf_categoria <- renderPlot({
    datos_completos %>%
      group_by(Categoría) %>%
      summarise(Total = sum(Total), .groups = "drop") %>%
      ggplot(aes(x = reorder(Categoría, Total), y = Total, fill = Categoría)) +
      geom_col() +
      coord_flip() +
      labs(x = "Categoría", y = "Total Ventas") +
      theme_minimal()
  })
  
  output$graf_torta <- renderPlot({
    datos_completos %>%
      group_by(Departamento) %>%
      summarise(Total = sum(Total), .groups = "drop") %>%
      ggplot(aes(x = "", y = Total, fill = Departamento)) +
      geom_col(width = 1) +
      coord_polar(theta = "y") +
      labs(title = "Participación en Ventas por Departamento") +
      theme_void()
  })
  
  output$graf_geomarketing <- renderPlot({
    datos_completos %>%
      group_by(Departamento, Categoría) %>%
      summarise(Ventas = sum(Total), .groups = "drop") %>%
      ggplot(aes(x = reorder(Departamento, Ventas), y = Ventas, fill = Categoría)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Ventas por Departamento y Categoría (Segmentación)", x = "Departamento", y = "Total Ventas") +
      theme_minimal()
  })
  
  output$mapa_ventas <- renderLeaflet({
    leaflet(mapa_datos) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~paleta(Total_Ventas),
        fillOpacity = 0.8,
        color = "white", weight = 1,
        popup = popup_contenido
      ) %>%
      addLegend("bottomright", pal = paleta, values = ~Total_Ventas,
                title = "Total de Ventas", opacity = 1)
  })
}

# Iniciar app
shinyApp(ui, server)
