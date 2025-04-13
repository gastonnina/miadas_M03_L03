<!-- omit in toc -->
#  📊  PRÁCTICA INTEGRADA DE VISUALIZACIÓN GEOESPACIAL Y DE MARKETING EN "R"

Este proyecto desarrolla un **dashboard interactivo** utilizando **R y RStudio** a partir de datos reales de marketing, combinando visualizaciones estadísticas y geoespaciales para explorar patrones de ventas y rutas comerciales dentro de Bolivia.

> 😎 por **Gaston Nina Sossa**

<!-- omit in toc -->
## 🗂️ Tabla de Contenidos

- [🎯 Objetivo General](#-objetivo-general)
- [🗂️ Archivos Proporcionados](#️-archivos-proporcionados)
- [🛠️ Requisitos](#️-requisitos)
- [⚙️ Instalación](#️-instalación)
- [📁 Estructura de Archivos](#-estructura-de-archivos)
- [🚀 Ejecución](#-ejecución)
- [📊 Resultados](#-resultados)


## 🎯 Objetivo General

Desarrollar un dashboard interactivo en **R** que permita:
- Analizar indicadores clave.
- Mostrar visualizaciones interactivas.
- Dibujar rutas turísticas y comerciales dentro del territorio boliviano.

---

## 🗂️ Archivos Proporcionados

- `marketing_campañas.csv`
- `marketing_clientes.csv`
- `marketing_servicios.csv`
- `marketing_transacciones.csv`
- `bolivia_departamentos_dos.geojson`

📄 **Resultados generados:** Se pueden ver localmente en el `index.html` o en línea aquí: [🌐 Proyecto en GitHub Pages](https://gastonnina.github.io/miadas_M03_L03)

---

## 🛠️ Requisitos

- **R** (≥ 4.0.0): [📥 Descargar R](https://cran.r-project.org/)
- **RStudio** (opcional, pero recomendado): [📥 Descargar RStudio](https://posit.co/download/rstudio-desktop/)

- **Librerías de R:** `httr`, `dplyr`, `wbstats`

## ⚙️ Instalación

1. Clonar el repositorio 🧑‍💻:

   ```bash
   git clone https://github.com/gastonnina/miadas_M03_L03.git
   cd miadas_M03_L03
   ```

2. Instalar librerías en R 📦:

   ```r
   install.packages(c("dplyr", "stringr"))
   ```

## 📁 Estructura de Archivos

```

├── README.md                    # 📄 Archivo con instrucciones del proyecto
├── index.Rmd                    # 🔢 Código principal en R Markdown
├── _fig/                        # 🖼️ graficas auxiliares del proyecto
├── _data/                       # 📂 Resultados guardados
│   └── datos_consolidado.RData  # 💾 Base de datos consolidada
```

## 🚀 Ejecución

1. Abre `index.Rmd` en RStudio. 🖥️
2. Ejecuta las siguientes secciones del archivo en orden correlativo: 🛠️

## 📊 Resultados

📁 **El archivo de datos consolidado se guardará en:**
`_data/datos_consolidado.RData`.

Este archivo contendrá información del proyecto **3500 registros**.

🔍 Los resultados generados se pueden ver localmente en el `index.html` o en línea aquí: [🌐 Proyecto en GitHub Pages](https://gastonnina.github.io/miadas_M03_L03)
