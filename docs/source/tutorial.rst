Tutorial
========

All data for the tutorial can be found `here <https://unimelbcloud-my.sharepoint.com/:f:/g/personal/schienstock_d_unimelb_edu_au/EldU3lqBWk5JsvpZ0PfsUokBdEfBAssas9eL7S4P40wIWg?e=YV82bQ>`_.
`Cecelia` was designed to process `static` and `live` cell images.
Both approaches follow a similar workflow to process and analyse images:

#. Importing images as `OME-ZARR <https://doi.org/10.1007/s00418-023-02209-1>`_

#. Cleaning up images

#. Segmenting cells and structures

#. Creating populations

#. Extracting spatial properties

#. Creating figures

Static image
------------

We will analyse `M3c-Arm1_5-XCR1_Venus-B220_PB-LCMV_AF594-P14_CTDR-CD3e_AF700-1_Unmixing-crop.tif` which is a cropped version of a cross-section from XCR1-Venus (dendritic cells) reporter mice after virus (LCMV) infection.

1. Create a project
+++++++++++++++++

  .. image:: _images/tutorial/static/create_project.png
     :width: 100%

2. Import the image
+++++++++++++++++

  .. image:: _images/tutorial/static/import_images.png
     :width: 100%

3. Define channel names
+++++++++++++++++

  The channels can be assigned one-by-one or as a list. 
  
  * B220-PB
  * XCR1-Venus
  * LCMV-AF594
  * P14-CTDR
  * CD3e-AF700
  * AF

  .. image:: _images/tutorial/static/add_channels.png
     :width: 100%

4. Correct autofluorescence
+++++++++++++++++

  .. image:: _images/tutorial/static/pre_cleanup.png
     :width: 100%
  
  Two-photon imaging often requires correction for autofluorescence and drift due to tissue movement. In `Cecelia` we implemented these methods individually but also in combination.

  .. image:: _images/tutorial/static/post_cleanup.png
     :width: 100%

5. Segment cells
+++++++++++++++++

In `Cecelia` we can combine the segmentations of these different levels into one result to extract populations. To this end, the user has to ensure that all cells and structures are segmented as expected. We therefore recommend to first segment inidividual channels before combining these. `Cellpose <http://www.cellpose.org/>`_ is the main segmentation method utilised in `Cecelia`. Each segmentation must be given a Name. The name `default` must be given for the final segmentation while intermediate segmentation tests can have anu name.

  T and B cells have a similar size, roundish shape and are closely packed. These can be segmented using the `cyto2` model and a relatively small diameter of 5 μm.
  
  .. image:: _images/tutorial/static/seg_t-bcells.png
     :width: 100%
     
  XCR1\ :sup:`+` dendritic cells have very different shapes and contain a cytoplasmic reporter rather than a membrane binding antibody. We have trained a `Cellpose` model, `ccia Fluorescent`, which was trained on overlapping T cells with a fluorescent reporter from 2-photon imaging. This model can also segment irregularly shaped dendritic cells.
  
  .. image:: _images/tutorial/static/seg_XCR1.png
     :width: 100%
     
  The virus particles are also difficult to segment as they appear as separated yet closely cohesive patches of fluorescent signal. As these particles are so fragmented, we check `Merge labels` to merge touching segmentation labels.
  
  .. image:: _images/tutorial/static/seg_LCMV.png
     :width: 100%
     
  LCMV specific T cells were labelled with a cytoplasmic dye. Although these are technically T cells, it is better to segment them separately to capture all cells. As this signal is very bright, we can use the standard `cyto2` model.
  
  .. image:: _images/tutorial/static/seg_P14.png
     :width: 100%
     
6. Define populations
+++++++++++++++++

  Cell populations can be defined in various ways. One way is use `sequential gating`. Create a `GatingSet`.

  .. image:: _images/tutorial/static/create_gating_set.png
     :width: 100%

  Segmentation is not perfect, we can gate out objects that are small or have odd shapes by plotting `volume` vs `surface-to-volume`. After that, it depends on the specific context. There will be spillover between cells due to their proximity. It is therefore important to gate any populations that are sparse and closely associated with other cells first. The last population can be cells that are more abundant.
  
  .. image:: _images/tutorial/static/gating_pops.png
     :width: 100%
  
  The complete gating hierarchy can be visualised in the `Flow Gating` section of `Plot canvas`.
  
  .. image:: _images/tutorial/static/gating_plot.png
     :width: 100%
     
7. Extract spatial interactions
+++++++++++++++++

  In this example, we were interested in T cell clustering. In the `Spatial analysis` section are different methods to extract spatial interactions. We can utilise `Cell clusters` to extract LCMV specific cell clusters.

  .. image:: _images/tutorial/static/cluster_detection.png
     :width: 100%
     
  The abundance of these clusters can then be visualised in the `Population plots` section.
   
  .. image:: _images/tutorial/static/cluster_plot.png
     :width: 100%
     
     
Live image
------------

We will analyse `M1-1-B6-naive-gBT-uGFP-OTI-CTV-P14-ubTomato-z300_0004-1.tif` which is a two-photon movie of naive T cells within a mouse lymph node.

1. Create a project
+++++++++++++++++

  .. image:: _images/tutorial/static/create_project.png
     :width: 100%
     
2. Import the image
+++++++++++++++++

  .. image:: _images/tutorial/static/import_images.png
     :width: 100%

3. Define channel names
+++++++++++++++++

  The channels can be assigned one-by-one or as a list. 
  
  * AF
  * P14-ubTomato
  * gBT-uGFP
  * OTI-CTV

  .. image:: _images/tutorial/static/add_channels.png
     :width: 100%

4. Correct autofluorescence
+++++++++++++++++
  
  Autofluor
  
  .. vimeo:: 925711847
    :height: 400px
  
  .. image:: _images/tutorial/static/post_cleanup.png
     :width: 100%

5. Segment cells
+++++++++++++++++

In `Cecelia` we can combine the segmentations of these different levels into one result to extract populations. To this end, the user has to ensure that all cells and structures are segmented as expected. We therefore recommend to first segment inidividual channels before combining these. `Cellpose <http://www.cellpose.org/>`_ is the main segmentation method utilised in `Cecelia`. Each segmentation must be given a Name. The name `default` must be given for the final segmentation while intermediate segmentation tests can have anu name.

  T and B cells have a similar size, roundish shape and are closely packed. These can be segmented using the `cyto2` model and a relatively small diameter of 5 μm.
  
  .. image:: _images/tutorial/static/seg_t-bcells.png
     :width: 100%
     
  XCR1\ :sup:`+` dendritic cells have very different shapes and contain a cytoplasmic reporter rather than a membrane binding antibody. We have trained a `Cellpose` model, `ccia Fluorescent`, which was trained on overlapping T cells with a fluorescent reporter from 2-photon imaging. This model can also segment irregularly shaped dendritic cells.
  
  .. image:: _images/tutorial/static/seg_XCR1.png
     :width: 100%
     
  The virus particles are also difficult to segment as they appear as separated yet closely cohesive patches of fluorescent signal. As these particles are so fragmented, we check `Merge labels` to merge touching segmentation labels.
  
  .. image:: _images/tutorial/static/seg_LCMV.png
     :width: 100%
     
  LCMV specific T cells were labelled with a cytoplasmic dye. Although these are technically T cells, it is better to segment them separately to capture all cells. As this signal is very bright, we can use the standard `cyto2` model.
  
  .. image:: _images/tutorial/static/seg_P14.png
     :width: 100%
     
6. Define populations
+++++++++++++++++

  Cell populations can be defined in various ways. One way is use `sequential gating`. Create a `GatingSet`.

  .. image:: _images/tutorial/static/create_gating_set.png
     :width: 100%

  Segmentation is not perfect, we can gate out objects that are small or have odd shapes by plotting `volume` vs `surface-to-volume`. After that, it depends on the specific context. There will be spillover between cells due to their proximity. It is therefore important to gate any populations that are sparse and closely associated with other cells first. The last population can be cells that are more abundant.
  
  .. image:: _images/tutorial/static/gating_pops.png
     :width: 100%
  
  The complete gating hierarchy can be visualised in the `Flow Gating` section of `Plot canvas`.
  
  .. image:: _images/tutorial/static/gating_plot.png
     :width: 100%
     
7. Extract spatial interactions
+++++++++++++++++

  In this example, we were interested in T cell clustering. In the `Spatial analysis` section are different methods to extract spatial interactions. We can utilise `Cell clusters` to extract LCMV specific cell clusters.

  .. image:: _images/tutorial/static/cluster_detection.png
     :width: 100%
     
  The abundance of these clusters can then be visualised in the `Population plots` section.
   
  .. image:: _images/tutorial/static/cluster_plot.png
     :width: 100%
