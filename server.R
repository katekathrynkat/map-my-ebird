# Conditional function for filtering
con <- function(fun){
  function(..., execute) {
    if (execute) fun(...) else ..1
  }
}

server <- function(input, output, session) {
  
  

  # Reactive drop-down menus
  
  # species_group <- reactive({
  #   filter(dat_all, species_group==input$species_group)
  # })
  
  # observeEvent(species_group(), {
  #   choices <- unique(species_group()$common_name)
  #   # freezeReactiveValue(input, "species")
  #   updateSelectInput(inputId = "species", choices = choices)
  # }
  
  # # Filter data based on inputs
  # dat <- dat_sf %>%
  #   # Species group
  #   con(filter)(species_group==input$species_group,
  #               execute = input$species_group!="") %>%
  #   # Species
  #   con(filter)(common_name==input$species,
  #               execute = input$species!="")
  
  
  # Subset data
  dat_subset <- reactive({
    req(input$species_group)
    dat_sf %>% 
      filter(species_group == input$species_group) %>% 
      filter(common_name == input$species) %>% 
      group_by(submission_id, location, geometry) %>%
      summarise() %>%
      group_by(location, geometry) %>%
      summarise(n = length(location)) %>%
      arrange(-n) %>%
      ungroup() %>%
      mutate(loggedn = ifelse(n==1, 0.2/log(max(n),10), # change n=1 obs
                              log(n,10)/log(max(n),10))) %>%
      arrange(-n)
  })
  
  
  #### Map ####

  # JUST FOR TESTING
  # output$map <- renderLeaflet({leaflet()})

  output$map <- renderLeaflet({
    leaflet(dat_subset) %>%
      con(addProviderTiles)(providers$Esri.WorldGrayCanvas,
                            execute = input$tiles=="Esri.WorldGrayCanvas") %>%
      con(addProviderTiles)(providers$Esri.WorldStreetMap,
                            execute = input$tiles=="Esri.WorldStreetMap") %>%
      con(addProviderTiles)(providers$Esri.WorldImagery,
                            execute = input$tiles=="Esri.WorldImagery") %>%
      con(addProviderTiles)(providers$Esri.WorldPhysical,
                            execute = input$tiles=="Esri.WorldPhysical") %>%
      con(addProviderTiles)(providers$Esri.WorldShadedRelief,
                            execute =
                              input$tiles=="Esri.WorldShadedRelief") %>%
      addCircleMarkers(
        radius = ~loggedn*10+3,
        stroke = FALSE, fillOpacity = 0.5,
        label = ~location,
        popup = ~paste0(location,"<br>Checklists: ",n)
      )
  })

}