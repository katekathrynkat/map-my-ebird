ui <- fluidPage(
  # theme = bs_theme(bootswatch = "darkly"),

  titlePanel("Map my eBird"),

  sidebarLayout(

    sidebarPanel(

      selectInput("species_group", "Species group",
                  choices = c("", unique(dat_all$species_group))),
      selectInput("species", "Species",
                  choices = c("", unique(dat_all$common_name))),

      br(),

      radioButtons("tiles", "Map base layer",
                   choices = c(
                     "Gray canvas" = "Esri.WorldGrayCanvas",
                     "Street map" = "Esri.WorldStreetMap",
                     "Satellite imagery" = "Esri.WorldImagery",
                     "Physical features" = "Esri.WorldPhysical",
                     "Shaded relief" = "Esri.WorldShadedRelief"))
    ),

    mainPanel(

      leafletOutput("map")
    )
  )
)
