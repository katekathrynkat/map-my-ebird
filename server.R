# Conditional function for filtering
con <- function(fun){
  function(..., execute) {
    if (execute) fun(...) else ..1
  }
}

#### Drop-down elements ####

# # Species group
# list_sppgroup <- dat_all %>%
#   pull(species_group) %>%
#   unique()
# list_sppgroup <- c("", list_sppgroup)
# 
# # Species
# list_spp <- dat_all %>%
#   filter(species_group=="Waterfowl") %>% # FILTER BY PREVIOUS
#   pull(common_name) %>%
#   unique()
# list_spp <- c("", list_spp)
# 
# # Country
# list_country <- dat_all %>%
#   pull(country) %>%
#   unique() %>%
#   str_sort()
# 
# # Province
# list_province <- dat_all %>%
#   filter(country=="United States") %>% # FILTER BY PREVIOUS
#   pull(province) %>%
#   unique() %>%
#   str_sort()
# 
# # Year
# list_year <- dat_all %>%
#   pull(year) %>%
#   unique() %>%
#   str_sort()

server <- function(input, output, session) {
  
  # Reactive drop-down menus

    species_group <- reactive({
    filter(dat_all, species_group==input$species_group)
  })
  observeEvent(species_group(), {
    choices <- unique(species_group()$common_name)
    # freezeReactiveValue(input, "species")
    updateSelectInput(inputId = "species", choices = choices)
  })
  
  # # Filter data based on inputs
  # dat <- dat_sf %>% 
  #   # Species group
  #   con(filter)(species_group==input$group,
  #               execute = input$group!="") %>%
  #   # Species
  #   con(filter)(common_name==input$species,
  #               execute = input$species!="")
  #   # Country
  #   # Providence
    

  #### Map ####
  output$map <- renderLeaflet({
    leaflet()
  })

  # output$map <- renderLeaflet({
  #   dat_sf %>%
  #     # Data wrangling
  #     group_by(submission_id, location, geometry) %>%
  #     summarise() %>%
  #     group_by(location, geometry) %>%
  #     summarise(n = length(location)) %>%
  #     arrange(-n) %>%
  #     ungroup() %>%
  #     mutate(loggedn = ifelse(n==1, 0.2/log(max(n),10), # change n=1 obs
  #                             log(n,10)/log(max(n),10))) %>%
  #     arrange(-n) %>%
  #     # Make map
  #     leaflet() %>%
  #     con(addProviderTiles)(providers$Esri.WorldGrayCanvas,
  #                           execute = input$tiles=="Esri.WorldGrayCanvas") %>%
  #     con(addProviderTiles)(providers$Esri.WorldStreetMap,
  #                           execute = input$tiles=="Esri.WorldStreetMap") %>%
  #     con(addProviderTiles)(providers$Esri.WorldImagery,
  #                           execute = input$tiles=="Esri.WorldImagery") %>%
  #     con(addProviderTiles)(providers$Esri.WorldPhysical,
  #                           execute = input$tiles=="Esri.WorldPhysical") %>%
  #     con(addProviderTiles)(providers$Esri.WorldShadedRelief,
  #                           execute =
  #                             input$tiles=="Esri.WorldShadedRelief") %>%
  #     addCircleMarkers(
  #       radius = ~loggedn*10+3,
  #       stroke = FALSE, fillOpacity = 0.5,
  #       label = ~location,
  #       popup = ~paste0(location,"<br>Checklists: ",n)
  #     )
  # })

  #  Update input options
  #
  # observe(
  #   updateSelectInput(session, "spp",
  #                     choices = c("test", "yay", "fun"))
  # )
  #
  # list_spp <- dat_all %>%
  #   filter(species_group=="Waterfowl") %>% # FILTER BY PREVIOUS
  #   pull(common_name) %>%
  #   unique()
  # list_spp <- c("", list_spp)

}