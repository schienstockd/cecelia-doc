.. _others:

Connecting other packages
=========================

We can utilise the data generate in `Cecelia` with other packages for further
detailed downstream analysis. Many of these will be specialised R/python packages.
The idea behind this is that the user can define and verify all their populations
within the GUI while an analyst might want to delve deeper into the structure
and components of these populations.

We have tried to create functions that the conversion between `Cecelia` populations
and other packages is relatively straightforward. These detailed analysis steps
could then be integrated within the `Cecelia` GUI to make them available to
people without scripting/programming knowledge. In this sense we envision that
the package will grow to fit the needs of their users.

R packages
------------

SPIAT
+++++++++++++++++
`SPIAT <https://github.com/TrigosTeam/SPIAT>`_ is an R-package that simplifies
commonly used spatial analysis methods for multiplex imaging. Here, we use the 
example :ref:`msn_spleen_lcmv_confocal` to look at populations from conventional
confocal images.

.. code-block:: r
  :linenos:
  
  library(cecelia)
  cciaUse("~/cecelia")
  
  # init ccia object
  cciaObj <- initCciaObject(
    pID = pID, uID = "6QzZsl", versionID = versionID, initReactivity = FALSE
  )
  
  uIDs <- names(cciaObj$cciaObjects())
  
  # get pops
  pops <- cciaObj$popPaths(popType = "flow", includeFiltered = FALSE, uIDs = uIDs[1])
  
  # exclude 'O' pops
  pops <- pops[is.na(str_match(pops, "/O[0-9]*$"))]
  pops <- pops[is.na(str_match(pops, "/nonDebris$"))]
  
  spe <- cciaObj$spe(popType = "flow", pops = pops, uIDs = uIDs)
  
.. code-block:: r
  :linenos:
  
  # get reference object to show image from set
  x <- cciaObj$cciaObjects(uIDs = c("NjumBK"))[[1]]
  imPopMap <- x$imPopMap(popType = "flow", includeFiltered = TRUE)
  popColours <- sapply(imPopMap, function(x) {x$colour})
  names(popColours) <- sapply(imPopMap, function(x) {x$path})
  
  phenotypes <- unique(spe[[1]]$Phenotype)
  popColours <- popColours[names(popColours) %in% phenotypes]
  
  # plot populations
  SPIAT::plot_cell_categories(spe$NjumBK, pops, popColours, "Phenotype") +
    facet_wrap(.~Phenotype)
    
.. image:: _images/others_spiat_NjumBK_map.png
   :width: 100%
    
.. code-block:: r
  :linenos:
  
  # get entropies
  gradient_pos <- seq(20, 300, 20) # radii

  spiat.entropies <- lapply(spe[names(spe) == "NjumBK"], function(x) {
    as.data.table(SPIAT::entropy_gradient_aggregated(
      x, cell_types_of_interest = pops,
      feature_colname = "Phenotype", radii = gradient_pos)$gradient_df)
  })
  
  entropiesDT <- rbindlist(spiat.entropies, idcol = "uID")

.. code-block:: r
  :linenos:
  
  datToPlot <- entropiesDT %>%
    pivot_longer(
      cols = starts_with("Pos_"),
      names_to = "radius",
      names_pattern = ".*_(.*)",
      values_to = "value") %>%
    mutate(radius = as.numeric(radius))
  
  ggplot(datToPlot, aes(radius, value, color = Celltype2, fill = Celltype2, group = Celltype2)) +
    theme_classic() +
    geom_line(size = 1.5) +
    # geom_smooth() +
    facet_grid(uID~Celltype1) +
    scale_color_brewer(palette = "Set1") +
    scale_fill_brewer(palette = "Set1")
    
.. image:: _images/others_spiat_NjumBK_entropy.png
   :width: 100%
   
.. code-block:: r
  :linenos:
  
  # Normalized mixing score (NMS)
  target_pops <- pops[pops != "/nonDebris/P14"]
  spiat.nms <- lapply(target_pops, function(x) {
    nsm <- lapply(spe, function(y) {
      as.data.table(SPIAT::mixing_score_summary(
        spe_object = y, 
        reference_celltype = "/nonDebris/P14",
        target_celltype = x,
        feature_colname = "Phenotype"))
    })
    
    rbindlist(nsm, idcol = "uID")
  })
  names(spiat.nms) <- target_pops
  spiat.nmsDT <- rbindlist(spiat.nms, idcol = "target")
  
  ggplot(spiat.nmsDT, aes(target, Normalised_mixing_score)) +
    theme_classic() +
    geom_boxplot(outlier.alpha = 0) +
    geom_jitter(
      # position = position_jitterdodge(jitter.width = 0.10), alpha = 1.0) +
      width = 0.2, alpha = 1.0) +
    coord_flip()
    
.. image:: _images/others_spiat_nms.png
   :width: 50%
     
.. code-block:: r
  :linenos:
  
  # Cross-K AUC
  spiat.auc <- lapply(target_pops, function(x) {
    auc <- lapply(spe, function(y) {
      SPIAT::AUC_of_cross_function(SPIAT::calculate_cross_functions(
        spe_object = y, 
        method = "Kcross", cell_types_of_interest = c("/nonDebris/P14", x),
        dist = 100,
        feature_colname = "Phenotype"))
    })
    
    DT <- as.data.table(as.data.frame(unlist(auc)) %>% rownames_to_column())
    colnames(DT) <- c("uID", "value")
    DT
  })
  names(spiat.auc) <- target_pops
  spiat.aucDT <- rbindlist(spiat.auc, idcol = "target")
  
  ggplot(spiat.aucDT, aes(target, value)) +
    theme_classic() +
    geom_boxplot(outlier.alpha = 0) +
    geom_jitter(
      # position = position_jitterdodge(jitter.width = 0.10), alpha = 1.0) +
      width = 0.2, alpha = 1.0) +
    coord_flip()
    
.. image:: _images/others_spiat_auc.png
   :width: 50%
   
spatstat
+++++++++++++++++
`spatstat <https://github.com/spatstat/spatstat>`_ is a collection of R-packages that enable
complex analysis of spatial patterns. To illustrate how to work with this package
we are using the same dataset as for `SPIAT` above.

.. code-block:: r
  :linenos:
  
  library(cecelia)
  cciaUse("~/cecelia")
  
  # init ccia object
  cciaObj <- initCciaObject(
    pID = pID, uID = "6QzZsl", versionID = versionID, initReactivity = FALSE
  )
  
  exp.info <- as.data.table(cciaObj$summary(withSelf = FALSE, fields = c("Attr")))
  uIDs <- exp.info$uID
  
  # get pops
  pops <- cciaObj$popPaths(popType = "flow", includeFiltered = FALSE, uIDs = uIDs[1])
  
  # # exclude 'O' pops
  pops <- pops[is.na(str_match(pops, "/O[0-9]*$"))]
  pops <- pops[is.na(str_match(pops, "/nonDebris$"))]
  windowPops <- c("root")
  
  # get ppp for all populations
  popPPP <- lapply(pops, function(x) {
    cciaObj$ppp(
      popType = "flow", pops = x, uIDs = uIDs, usePhysicalScale = FALSE, windowPops = windowPops)
  })
  names(popPPP) <- pops

.. code-block:: r
  :linenos:
  
  # plot populations out
  layout(matrix(1:5, ncol = 5))
  plot(popPPP$`/nonDebris/O/B220`$NjumBK, main = "B220")
  plot(popPPP$`/nonDebris/O/O1/CD3`$NjumBK, main = "CD3")
  plot(popPPP$`/nonDebris/O/LCMV`$NjumBK, main = "LCMV")
  plot(popPPP$`/nonDebris/XCR1`$NjumBK, main = "XCR1")
  plot(popPPP$`/nonDebris/P14`$NjumBK, main = "P14")
    
.. image:: _images/others_spat_NjumBK_maps.png
  :width: 100%
   
.. code-block:: r
  :linenos:
   
  # test for spatial randomness
  ce.results <- list()
  for (i in names(popPPP)) {
    message(paste(">> Test CSR for", i))
    # test for randomness
    ce.results[[i]] <- unlist(parallel::mclapply(popPPP[[i]], function(x) {
      spatstat.explore::clarkevans.test(x, method = "MonteCarlo", nsim = 99)$statistic
    }))
  }
     
.. code-block:: r
  :linenos:
  
  # plot out
  cdDF <- as.data.frame(ce.results)
  colnames(cdDF) <- stringr::str_extract(colnames(cdDF), "(?<=\\.)[^\\.]*$")
  rownames(cdDF) <- stringr::str_extract(rownames(cdDF), ".+(?=\\.R)")
  
  ggplot(cdDF %>% pivot_longer(cols = everything(), names_to = "pop", values_to = "ce"),
         aes(pop, ce)) +
    theme_classic() +
    geom_boxplot(outlier.alpha = 0) +
    geom_jitter(width = 0.2, alpha = 1.0) +
    expand_limits(y = 0) + geom_hline(yintercept = 1)
    
.. image:: _images/others_spat_ce_results.png
  :width: 40%
  
     
celltrackR
+++++++++++++++++
`celltrackR <https://github.com/ingewortel/celltrackR>`_ is an R-package to facilitate
analysis of cell tracks. Here we are using the :ref:`msn_ln_HSV` dataset to
illustrate its basic usage in the context of `Cecelia`.
  
.. code-block:: r
  :linenos:
  
  library(cecelia)
  cciaUse("~/cecelia")
  
  # init ccia object
  cciaObj <- initCciaObject(
    pID = pID, uID = "rXctjl", versionID = versionID, initReactivity = FALSE
  )
  
  # get experimental info
  exp.info <- as.data.table(cciaObj$summary(
    withSelf = FALSE, fields = c("Attr")
  ))
  
  uIDs <- exp.info[Cells == "gDT_gBT" & Include == "Y"]$uID
  
  # get tracks for analysis
  tracks.list <- lapply(
    list(gBT = "gBT", gDT = "gDT"), function(x) cciaObj$tracks(pop = x, uIDs = uIDs))
    
.. code-block:: r
  :linenos:
  
  # plot out tracks
  layout(matrix(1:6, ncol = 3))
  plot(tracks.list$gBT$fizPPH, col = 1, main = "Uninf gBT") # Uninf
  plot(tracks.list$gDT$fizPPH, col = 1, main = "Uninf gDT") # Uninf
  plot(tracks.list$gBT$`2nFwDR`, col = 1, main = "1 dpi gBT") # dpi 1
  plot(tracks.list$gDT$`2nFwDR`, col = 1, main = "1 dpi gDT") # dpi 1
  plot(tracks.list$gBT$LfVNe6, col = 1, main = "2 dpi gBT") # dpi 2
  plot(tracks.list$gDT$LfVNe6, col = 1, main = "2 dpi gDT") # dpi 2
    
.. image:: _images/others_celltrackR_tracks.png
  :width: 100%
    
.. code-block:: r
  :linenos:
  
  # get normalised tracks to plot
  tracks.DT.norm <- tracks.combine.dt(lapply(
    tracks.list, function(x) tracks.apply.fun(x, celltrackR::normalizeTracks)
  ))
  
  ggplot(tracks.DT.norm %>% left_join(exp.info),
         aes(x, y, group = interaction(uID, track_id))) +
    # geom_point(size = 0.5) +
    geom_path(size = 0.1, colour = "black") +
    theme_classic() +
    facet_grid(cell_type~dpi) +
    theme(
      legend.position = "none",
      legend.title = element_blank(),
      legend.text = element_text(size = 12),
      axis.text.y = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks = element_blank(),
      strip.background = element_blank(),
      # strip.text.x = element_blank(),
      axis.line = element_blank()
    ) + xlab("") + ylab("") + coord_fixed(ratio = 1)
    
.. image:: _images/others_celltrackR_stars.png
  :width: 100%
    
.. code-block:: r
  :linenos:
  
  # compare msd on plot
  tracks.DT.msd <- tracks.combine.dt(lapply(
    tracks.list, function(x) tracks.aggregate.fun(
      x, celltrackR::squareDisplacement,
      summary.FUN = "mean.se", add.time.delta = TRUE,
      subtracks.i = 10
      )
  ))
  
  # focus specific images
  plot.uIDs <- c("LfVNe6", "2nFwDR", "fizPPH")
  
  # plot
  ggplot(tracks.DT.msd[uID %in% plot.uIDs] %>% left_join(exp.info),
         aes(x = i, y = mean, color = cell_type, fill = cell_type)) +
    geom_ribbon(aes(ymin = lower, ymax = upper),
                alpha = 0.2) +
    geom_line() +
    labs(
      x = expression(paste(Delta, "t (steps)")),
      y = "MSD"
    ) +
    theme_classic() +
    facet_wrap(~dpi) +
    scale_color_brewer(palette = "Set2") +
    scale_fill_brewer(palette = "Set2") +
    theme(
      legend.title = element_blank(),
      strip.background = element_blank()
    )
    
.. image:: _images/others_celltrackR_msd.png
  :width: 100%
  