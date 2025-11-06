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
      self$initLog()
      self$writeLog("Calculate HMM for cells")
      
      # get object
      cciaObj <- self$cciaTaskObject()
      
      popType <- self$funParams()$popType
      pops <- self$funParams()$pops
      
      self$writeLog("Get population DT")
      
      # get labels for populations from images
      # must get the whole data.table to save values back to labels
      popDT <- cciaObj$popDT(
        popType = popType,
        pops = pops,
        includeFiltered = TRUE
      )
      
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
      
      # DONE
      self$writeLog("Done")
      self$exitLog()
      
      # update image information
      self$updateImageInfo()
      
      TRUE
    }
  )
)
