.. _msn_skin_lymph:

Mouse skin T cell interactions with lymphatics in DTH-inflammation
==================================================================

0. Download
+++++++++++++++++

`Skin dataset <https://app.immunemap.org/experiment-public-view?id=49>`_

1. Import images
+++++++++++++++++
  .. image:: _images/msn_live_SKIN_lymph_import_images.png
     :width: 100%
     
2. Add metadata
+++++++++++++++++
  .. image:: _images/msn_live_SKIN_lymph_add_channels.png
     :width: 100%
     
3. Autofluorescence and drift correction
+++++++++++++++++
  .. image:: _images/msn_live_SKIN_lymph_correction.png
     :width: 100%
     
4. Segment cells
+++++++++++++++++
  .. image:: _images/msn_live_SKIN_lymph_seg.png
     :width: 100%
     
5. Track cells
+++++++++++++++++
  .. image:: _images/msn_live_SKIN_lymph_tracking.png
     :width: 100%
     
6. Extract behaviour
+++++++++++++++++

a. Cell contact with lymphatics
  .. image:: _images/msn_live_SKIN_lymph_contact.png
     :width: 100%

b. Hidden Markov Model (HMM)
  .. image:: _images/msn_live_SKIN_lymph_HMM.png
     :width: 100%

c. HMM state transitions
  .. image:: _images/msn_live_SKIN_lymph_HMM_transitions.png
     :width: 100%
     
d. Cluster tracks
  .. image:: _images/msn_live_SKIN_lymph_clust_tracks.png
     :width: 100%
     
7. Generate figures
+++++++++++++++++

a. UMAP
  .. image:: _images/msn_live_SKIN_lymph_figure_UMAP.png
     :width: 100%

b. Cluster frequencies
  .. image:: _images/msn_live_SKIN_lymph_figure_freq.png
     :width: 100%