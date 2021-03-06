#### data preparation ####
multi_to_single_data <- function(current_dataset) {
  
  sdsdata_multi <- current_dataset
  sdsdata <- sdsdata_multi[rep(row.names(sdsdata_multi), sdsdata_multi$sammel_anzahl_artefakte),]
    
  return(sdsdata)
  
}

#### Burning ####
server_plot_view_multi_proportion_burned_plot <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata_multi <- current_dataset()$data
  
  # stop if relevant variables are not available
  if (
    !all(c(
      "sammel_anzahl_unverbrannt", 
      "sammel_anzahl_verbrannt", 
      "sammel_anzahl_unbekannt_ob_verbrannt"
    ) %in% names(sdsdata_multi))
    ) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  burned <- dplyr::select_(
    sdsdata_multi,
    "sammel_anzahl_unverbrannt", 
    "sammel_anzahl_verbrannt", 
    "sammel_anzahl_unbekannt_ob_verbrannt"
  )
  
  names(burned) <- c("unburned", "burned", "unknown")

  dat <- tibble::tibble(state = names(burned), count = colSums(burned))
  
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat,
        width = 320,
        height = 320
      ),
      labels = ~state, values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h')
  )
  
  p <- plotly::config(
    p = p,
    # https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
    displaylogo = FALSE,
    collaborate = FALSE,
    # https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js
    modeBarButtonsToRemove = list(
      'sendDataToCloud',
      'autoScale2d',
      'resetScale2d',
      'hoverClosestCartesian',
      'hoverCompareCartesian',
      'select2d',
      'lasso2d',
      'toggleSpikelines'
    )
  )
  
  return(p)
  
}

#### Natural surface ####
server_plot_view_multi_proportion_natural_surface_plot <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata_multi <- current_dataset()$data
  
  # stop if relevant variables are not available
  if (
    !all(c(
      "sammel_anzahl_ohne_naturflaeche",
      "sammel_anzahl_kleinereindrittel_naturflaeche",
      "sammel_anzahl_kleinerzweidrittel_naturflaeche",
      "sammel_anzahl_groesserzweidrittel_naturflaeche",
      "sammel_anzahl_voll_naturflaeche",
      "sammel_anzahl_unbekannt_naturflaeche"
    ) %in% names(sdsdata_multi))
  ) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  natural_surface <- dplyr::select_(
    sdsdata_multi,
    "sammel_anzahl_ohne_naturflaeche",
    "sammel_anzahl_kleinereindrittel_naturflaeche",
    "sammel_anzahl_kleinerzweidrittel_naturflaeche",
    "sammel_anzahl_groesserzweidrittel_naturflaeche",
    "sammel_anzahl_voll_naturflaeche",
    "sammel_anzahl_unbekannt_naturflaeche"
  )
  
  names(natural_surface) <- c(
    "no natural surface", 
    "< 1/3 natural surface", 
    "< 2/3 natural surface",
    "> 2/3 natural surface",
    "complete natural surface",
    "unknown"
  ) 
  
  dat <- tibble::tibble(state = names(natural_surface), count = colSums(natural_surface))
  
  # dat$state <- factor(dat$state, levels = names(natural_surface))
  
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat,
        width = 320,
        height = 320
      ),
      labels = ~state, 
      sort = FALSE,
      values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h')
  )
  
  p <- plotly::config(
    p = p,
    # https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
    displaylogo = FALSE,
    collaborate = FALSE,
    # https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js
    modeBarButtonsToRemove = list(
      'sendDataToCloud',
      'autoScale2d',
      'resetScale2d',
      'hoverClosestCartesian',
      'hoverCompareCartesian',
      'select2d',
      'lasso2d',
      'toggleSpikelines'
    )
  )
  
  return(p)
  
}
