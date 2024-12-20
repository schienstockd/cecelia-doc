.. _access_data_rmarkdown:

Access data in RMarkdown
=========================

The data generated in `Cecelia` can be further analysed in R-Markdown for custom quantification or visualisation. The main principle is that the generated `populations` can be loaded as `data-table` which can be used for various functions. Here we make use of the results generated in :ref:`tutorial_live`.

Live cell imaging
------------

We need to activate the `renv` environment to use all packages. `Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")` must be added before loading anything as R can otherwise crash. See `Github issue <https://github.com/dmlc/xgboost/issues/1715#issuecomment-438924721>`_ for details if required.

.. code-block:: r
  :linenos:
  
  # set path to cecelia
  PATH_TO_CCIA <- "REPLACE/WITH/YOUR/PATH/TO/CECELIA"
  
  # load package environment
  setwd(PATH_TO_CCIA)
  renv::load()
  
  # load cecelia
  Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")
  library(cecelia)
  cciaUse(PATH_TO_CCIA)
  
  # for plotting and general data processing
  library(ggplot2) 
  library(tidyverse)
  
We can initialise the object with `initCciaObject`. Then we can get a list of the tracked populations with the `popPaths` function of the `cciaObj`. Tracked populations are a `filtered population`, which is why we have to set `includeFiltered = TRUE` when retrieving the `population data-table`.

.. code-block:: r
  :linenos:
  
  # set project parameters
  pID <- "REPLACE_WITH_PROJECT_ID" # this ID is found in the app 'Settings > unique ID (uID)'
  versionID <- 1
  
  # init ccia object
  cciaObj <- initCciaObject(
    pID = pID, uID = "REPLACE_WITH_IMAGE_ID", versionID = versionID, initReactivity = FALSE # Tcells
  )
  
  pops <- unname(unlist(cciaObj$popPaths(
    popType = "live", filteredOnly = TRUE, filterMeasures = c("track_id"))))
  
  popDT <- cciaObj$popDT("live", pops = c(pops), includeFiltered = TRUE)
  popDT
  
.. image:: _images/rmarkdown_pop_dt.png
   :width: 100%

.. code-block:: r
  :linenos:
  
  # plot out tracks
  ggplot(popDT, aes(centroid_x, centroid_y, group = track_id,
                    colour = pracma::rad2deg(live.cell.angle))) +
    theme_classic() +
    geom_path() +
    facet_grid(.~pop) +
    viridis::scale_colour_viridis(option = "inferno", name = "Angle (°)") 
  
.. image:: _images/rmarkdown_pop_tracks.png
   :width: 100%

Next we can plot out different track measurements for the individual populations.

.. code-block:: r
  :linenos:
  
  # get tracks measurements for each population
  tracksInfo <- cciaObj$tracksMeasures(pops)
  tracksInfo
  
.. image:: _images/rmarkdown_tracks_info.png
   :width: 100%

.. code-block:: r
  :linenos:
  
  # get columns for plotting
  colsToPivot <- colnames(tracksInfo)
  colsToPivot <- colsToPivot[!colsToPivot %in% c("cell_type", "track_id")]
  
  # pivot longer
  datToPlot <- tracksInfo %>%
    pivot_longer(cols = colsToPivot,
                 names_to = "measure", values_to = "value")
  
  # plot out
  ggplot(datToPlot, aes(cell_type, value, color = cell_type)) +
    theme_classic() +
    geom_boxplot(outlier.alpha = 0) +
    geom_jitter(position = position_jitterdodge(jitter.width = 0.10)) +
    facet_wrap(.~measure, scales = "free", nrow = 2) +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)
      ) +
    scale_color_brewer(palette = "Set1") +
    coord_flip() + xlab("") + ylab("")
  
.. image:: _images/rmarkdown_tracks_measures.png
   :width: 100%
   