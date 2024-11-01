.. _access_data_rmarkdown:

Access data in RMarkdown
=========================

The data generated in `Cecelia` can be further analysed in R-Markdown for custom quantification or visualisation. The main principle is that the generated `populations` can be loaded as `data-table` which can be used for various functions. Here we make use of the results generated in :ref:`tutorial_live`.

Live cell imaging
------------

We need to activate the `renv` environment to use all packages. `Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")` must be added before loading anything as R can otherwise crash. See `Github issue <https://github.com/dmlc/xgboost/issues/1715#issuecomment-438924721>`_ for details if required.

.. code-block:: r
  :linenos:
  
  Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")
  library(cecelia)
  cciaUse("REPLACE/WITH/YOUR/PATH/TO/CECELIA")
  
  # for plotting and general data processing
  library(ggplot2) 
  library(tidyverse)
  
We can initialise the object with `initCciaObject`.

.. code-block:: r
  :linenos:
  
  # set project parameters
pID <- "Co3HDh" # this ID is found in the app 'Settings > unique ID (uID)'
versionID <- 1

devtools::load_all("../")
cciaUse("~/cecelia/dev", initConda = FALSE)

# init ccia object
cciaObj <- initCciaObject(
  pID = pID, uID = "lWinrY", versionID = versionID, initReactivity = FALSE # Tcells
)

popsList <- cciaObj$popPaths(popType = "live", filteredOnly = TRUE, filterMeasures = c("track_id"))

# popDT <- cciaObj$popDT("live", pops = c(popsTracked[[3]]), includeFiltered = TRUE)
popDT <- cciaObj$popDT("live", pops = c(popsList), includeFiltered = TRUE)
  

    
.. image:: _images/others_spiat_NjumBK_map.png
   :width: 100%
   