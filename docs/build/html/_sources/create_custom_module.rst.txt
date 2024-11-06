.. _create_custom_module:

Create custom module
=========================

We can create custom `modules` and respective `input definitions` by creatting an `R6` class and a `JSON` file respectively. As an example we take the analysis from :ref:`access_data_rmarkdown`. 

Live cell imaging
------------

R Markdown
++++++

To start off, we can design the functionality we want as `R Markdown`. In this example we are modifying the way in which the angle and speed of cell tracks is calculated. By default, the angle for each object is defined by the previous two timepoints. That is, you will have three points and the two lines between those define the angle. You could increase the distance between these two lines and measure the angle between the first and last segment of a given track. This would give you a coarser measurement of the angle and could be used to classify behaviour differently. We will illustrate this by applying a Hidden Markov Model on these modified measurements.

.. attention::
  Please complete the previous tutorial (:ref:`access_data_rmarkdown`) to follow the steps.

To calculate angles, we must get tracks. Tracks can be obtained by using their `population` (eg/ cell_typeA/tracked) or `value` (eg/ cell_typeA) names. A `value` name is the name of the segmentation that the populations are derived from, ie/ the filename for the segmentation.

.. code-block:: r
  :linenos:
  
  # get value names from populations
  valueNames <- sapply(pops, .flowPopParent, USE.NAMES = FALSE)
  names(valueNames) <- valueNames
  
  # get tracks for populations
  tracks <- lapply(valueNames, function(x) cciaObj$tracks(x))
  tracks
  
.. image:: _images/create_module_tracks.png
   :width: 100%

To get the angle between the first and the last segment of a track we can use the `overallAngle` function from the `celltrackR` package. `steps.subtracks` defines the length of the sub segments that we can split the track up into. These segments are overlapping by default. You could pass  the argument `steps.overlap = 0` to make them non-overlapping. `tracks.measure.fun` is a convenience function from `Cecelia` to process tracks from multiple sources. In this case we have three cell types: OTI, gBT and P14.

We can call this convenience function which will generate another `data-table` of tracks with the given angle measurement. This `tracks data-table` can be merged to the original `population data-table` based on `value name`, `track ID` and `cell ID` (which is the cell number within a given track).

.. code-block:: r
  :linenos:
  
  # get cumulative change of direction for each track
  sumLength <- 8
  
  popDT[
    tracks.measure.fun(
      tracks, celltrackR::overallAngle, "live.cell.sumChange",
      steps.subtracks = sumLength, idcol = "value_name",
      increment.cell.id = TRUE),
    on = .(value_name, track_id, cell_id),
    live.cell.sumChange := .(live.cell.sumChange)
  ]
  
We can the compare this modified angle with the default angle of a given track.

.. code-block:: r
  :linenos:

  # plot out and compare
  track_to_show <- 43
  
  # https://stackoverflow.com/a/21538521
  myPalette <- colorRampPalette(rev(RColorBrewer::brewer.pal(11, "Spectral")))
  sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(1, 180), name = "Angle (°)")
  
  ggplot(popDT[value_name == "P14" & track_id == track_to_show],
         aes(centroid_x, centroid_y, group = track_id,
             colour = pracma::rad2deg(live.cell.sumChange))) +
    theme_classic() +
    geom_path() +
    # facet_grid(.~pop) +
    # scale_color_brewer(palette = "spectral", name = "Sum (°)") +
    sc +
    ggtitle("Cumulative change") +
    coord_fixed() +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
    ) 

.. code-block:: r
  :linenos:

  ggplot(popDT[value_name == "P14" & track_id == track_to_show],
         aes(centroid_x, centroid_y, group = track_id,
             colour = pracma::rad2deg(live.cell.angle))) +
    theme_classic() +
    geom_path() +
    # facet_grid(.~pop) +
    # scale_color_brewer(palette = "spectral", name = "Angle (°)") +
    sc + 
    ggtitle("Angle") +
    coord_fixed() +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.line = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
    ) 
    
.. image:: _images/create_module_angle.png
   :width: 48%
   
.. image:: _images/create_module_sumChange.png
   :width: 48%

Creating a module
++++++

To look at this measurement, apply it to other images and to use it for other purposes it is easiest to create custom module. Every module is an `R6 <https://r6.r-lib.org/articles/Introduction.html>`_ class. You can add this module to the GUI by providing an `input definition` that will be read by the `Input manager` and displayed on the defined modules page. Custom modules can be added to the base directory that you used to install `Cecelia`. Create a folder `modules` and the sub-folders `sources` and `inputDefinitions`. Every category in `Cecelia` is a module with a `function name`. You can find the categories and their function names here: :ref:`module_function_names`.

In this case we will put the calculation of the modified angle into `Cell Behaviour`. Create a folder in `sources` and `inputDefinitions` named `behaviourAnalysis`. In the `sources/behaviourAnalysis` folder, crate a file named `cumulativeChange.R` and in the `inputDefinitions/behaviourAnalysis` a file named `cumulativeChange.json`.

.. image:: _images/create_module_folders.png
   :width: 100%

The following is the `backbone` for every module function. The key parts are that the class name corresponds to the function name. The class inherits from the main module, in this case `BehaviourAnalysis`. The function can then be called with `behaviourAnalysis.cumulativeChange`. The main logic is in the `run` function. We will fill in this function step by step.

.. code-block:: r
  :linenos:

  CumulativeChange <- R6::R6Class(
    "CumulativeChange",
    inherit = BehaviourAnalysis,
    
    private = list(
    ),
    
    public = list(
      # function name
      funName = function() {
        paste(
          super$funName(),
          "cumulativeChange",
          sep = cecelia:::CCID_CLASS_SEP
        )
      },
      
      # run
      run = function() {
      }
    )
  )
  
Place all code that follows into the `run` function. Every task has a log file associated with it. This file will be located in the directory of the `image` or `image set` that the function is running on. `self$initLog()` initialises the logfile and `self$writeLog()` will write the output. Every task is run on an `image` or `image set`. We can work with this object by calling `self$cciaTaskObject()`. All parameters that are passed to the function call are available through `self$funParams()`. In this first section, we initialise the log, get the task object and get the function parameters.

.. code-block:: r
  :linenos:

  self$initLog()
  self$writeLog("Calculate HMM for cells")
  
  # get object
  cciaObj <- self$cciaTaskObject()
  
  popType <- self$funParams()$popType
  pops <- self$funParams()$pops

To save the new measurement, we need the `population data-table`. We can retrieve this with `cciaObj$popDT()` and passing the population names and type. The population type (:ref:`population_types`) refers to the method how these were derived.

.. code-block:: r
  :linenos:

  self$writeLog("Get population DT")
      
  # get labels for populations from images
  # must get the whole data.table to save values back to labels
  popDT <- cciaObj$popDT(
    popType = popType,
    pops = pops,
    includeFiltered = TRUE
  )

We can get the tracks by their population name, eg/ `P14/tracked`, or by their `value name`, eg/ `P14`. And then again apply the summary functions to extract the angle between the first and the last segment of the track segments. We can do the same quantification for `speed` of the cells, ie/ to consider the distance between points with a gap. This will also give us a more coarse expression of the cellular movement. This is the same logi as we have applied in the `R Markdown` example above.

.. code-block:: r
  :linenos:

  # get value names for pops
  valueNames <- sapply(pops, .flowPopParent, USE.NAMES = FALSE)
  names(valueNames) <- valueNames
  
  # get tracks for populations
  tracks <- lapply(valueNames, function(x) cciaObj$tracks(x))
  
  # get cumulative change of direction for each track
  popDT[
    tracks.measure.fun(
      tracks, celltrackR::overallAngle, "live.cell.sumDirChange",
      steps.subtracks = self$funParams()$sumLength, idcol = "value_name",
      increment.cell.id = TRUE),
    on = .(value_name, track_id, cell_id),
    live.cell.sumDirChange := .(live.cell.sumDirChange)
  ]
  
  # get cumulative change of speed for each track
  popDT[
    tracks.measure.fun(
      tracks, celltrackR::speed, "live.cell.sumSpeedChange",
      steps.subtracks = self$funParams()$sumLength, idcol = "value_name",
      increment.cell.id = TRUE),
    on = .(value_name, track_id, cell_id),
    live.cell.sumSpeedChange := .(live.cell.sumSpeedChange)
  ]

We now must save these measurements back to the original labels data. Every segmentation is a different labels file. We must therefore go through the individual `value names` separately. `cciaObj$labelProps()` will give us the labels as a `View on Anndata`. This is a python class called `LabelPropsView` that has convenience functions to work with `Anndata` in the context of this package. We can merge the measurements to the existing labels and then use `labels$add_obs()` to add these back as a list. `labels$save()` will save the labels and the measurements are now available to view in napari and can be used for further processing.

.. code-block:: r
  :linenos:

  # go through value names
  for (j in unique(popDT$value_name)) {
    self$writeLog(sprintf("> %s", j))
    
    # save back to labels
    labels <- cciaObj$labelProps(valueName = j)
    
    # merge to existing labels
    mergedDT <- popDT[value_name == j, c(
      "track_id", "cell_id",
      "live.cell.sumDirChange", "live.cell.sumSpeedChange"
    )][
      as.data.table(labels$values_obs()), 
      on = .(track_id, cell_id)
    ]
      
    # push back to labels
    labels$add_obs(
      as.list(mergedDT[, c("live.cell.sumDirChange", "live.cell.sumSpeedChange")])
    )
    
    labels$save()
    labels$close()
  }

Then we can close the logfile and we are done. The whole file is available :download:`here <_doc/cumulativeChange.R>`

.. code-block:: r
  :linenos:
  
  # DONE
  self$writeLog("Done")
  self$exitLog()

Testing the module
++++++

The module can be tested from R Markdown. you can place a `browser()` command anywhere in the `run` function for debugging purposes. We must define the function parameters as a `named list`. Functions can then be run with `cciaObj$runTask()`. The function name must be passed along with the parameters, the running environment, whether it should run in place as a separate process as well as the task ID number that will be assigned to the running task. Processes can run in parallel when using separate processes - just make sure that each process has a unique task ID otherwise they might interfere with each other.

.. code-block:: r
  :linenos:

  # run task
  funParams <- list(
    popType = "live",
    pops = c("OTI/tracked", "P14/tracked", "gBT/tracked"),
    sumLength = 8
  )
  
  # run task
  task <- cciaObj$runTask(
    funName = "behaviourAnalysis.cumulativeChange",
    funParams = funParams,
    env = "local",
    runInplace = TRUE,
    taskID = 1
  )

Add the module to the GUI
++++++

We must create a `JSON` file to integrate the function and expose the parameters in the main GUI. Start editing the `cumulativeChange.json` file that we created earlier within the `inputDefinitions` folder. The backbone of the input definition looks like the following. In `fun` we must provide the function name `cumulativeChange` and give it a category under which it will be listed in the function selection and a label. Functions can run locally or on an `HPC` system. For our use case we focus on the `local` environment only. This format was inspired by `Zeiss' module specification <https://docs.arivis.cloud/create-modules/hello-world>`_.

.. code-block:: json
  :linenos:

  {
    "fun": {
      "cumulativeChange": {
        "category": "Module functions",
        "label": "Cumulative change",
        "env": ["local"]
      }
    },
    "spec": {
      "inputs": {
      },
      "outputs": {}
    },
    "ui": {
      "inputs": {
      },
      "outputs": {}
    }
  }
  
In `spec` we define the data types for each parameter. Populations are a `list` and the length of the summation is an `integer` with min, max and default values.

.. code-block:: json
  :linenos:

  "spec": {
    "inputs": {
      "pops": {
        "type:list": {}
      },
      "sumLength": {
        "type:integer": {
          "min": 0,
          "max": 20,
          "default": 4
        }
      }
    },
    "outputs": {}
  },
  
In `ui` we define the GUI elements for the parameters. For populations, there is a predefined population selection widget that we can utilise. For the summation length we can use a slider. Here is a list of all supported widgets: :ref:`input_widget_types`. The complete JSON file is :download:`here <_doc/cumulativeChange.json>`.

.. code-block:: json
  :linenos:

  "ui": {
    "inputs": {
      "pops": {
        "index": 0,
        "label": "Populations",
        "widget:popSelection": {
          "size": 1,
          "multiple": true
      }
    },
    "sumLength": {
      "index": 1,
        "label": "Summation length",
        "widget:slider": {
          "step": 1
        }
      }
    },
    "outputs": {}
  }


Comparing the output of the function
++++++

We can now use this new function to compare its impact on the behaviour extraction from cells. In the GUI under `Cell Behaviour`, select our newly created `Cumulative change` function. Select all tracked populations and set the `summation length` to 8. Run the function. 

.. image:: _images/create_module_fun_in_gui.png
   :width: 48%
   
Then extract 3 `HMM` states with the default `live.cell.speed` and `live.cell.angle` and our new measurements of `live.cell.sumDirChange` and `live.cell.sumSpeedChange`.
 
.. image:: _images/create_module_hmm_default.png
   :width: 48%

.. image:: _images/create_module_hmm_new.png
   :width: 48%

Now you can open up the image and compare the `HMM state` results from these two approaches. The behaviour extracted with our new measurements is a bit coarser than the default one and might be useful for certain settings where you want to simplify results.