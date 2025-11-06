.. _msn_ln_HSV_types:

Mouse lymph node HSV infection with cell types
==============================================

1. Import images
+++++++++++++++++
  .. image:: _images/msn_live_LN_HSV_types_import_images.png
     :width: 100%
     
2. Add metadata
+++++++++++++++++
  .. image:: _images/msn_live_LN_HSV_types_add_channels.png
     :width: 100%
     
3. Autofluorescence and drift correction
+++++++++++++++++
  .. image:: _images/msn_live_LN_HSV_types_correction.png
     :width: 100%
     
4. Segment cells
+++++++++++++++++
  .. image:: _images/msn_live_LN_HSV_types_seg.png
     :width: 100%
     
5. Track cells
+++++++++++++++++
  .. image:: _images/msn_live_LN_HSV_types_tracking.png
     :width: 100%
     
6. Extract behaviour
+++++++++++++++++

b. Cell aggregates
  .. image:: _images/msn_live_LN_HSV_types_aggregates.png
     :width: 100%

b. Hidden Markov Model (HMM)
  .. image:: _images/msn_live_LN_HSV_types_HMM.png
     :width: 100%

c. HMM state transitions
  .. image:: _images/msn_live_LN_HSV_types_HMM_transitions.png
     :width: 100%
     
d. Cluster tracks
  .. image:: _images/msn_live_LN_HSV_types_clust_tracks.png
     :width: 100%
     
7. Generate figures
+++++++++++++++++

a. UMAP
  .. image:: _images/msn_live_LN_HSV_types_figure_UMAP.png
     :width: 100%

b. Cluster frequencies
  .. image:: _images/msn_live_LN_HSV_types_figure_freq.png
     :width: 100%