.. _msn_cancer_invitro_flow:

Cancer cells in vitro flow tracks
=================================

0. Download
+++++++++++++++++

`Cancer cell migration dataset <zenodo.org/records/10539020>`_

1. Import images
+++++++++++++++++
  .. image:: _images/msn_live_cancer_flows_import_images.png
     :width: 100%
     
2. Add metadata
+++++++++++++++++
  .. image:: _images/msn_live_cancer_flows_add_channels.png
     :width: 100%
     
3. Denoise signal
+++++++++++++++++
  .. image:: _images/msn_live_cancer_flows_denoise.png
     :width: 100%
     
4. Segment cells
+++++++++++++++++
  .. image:: _images/msn_live_cancer_flows_seg.png
     :width: 100%
     
5. Track cells
+++++++++++++++++
  .. image:: _images/msn_live_cancer_flows_tracking.png
     :width: 100%
     
6. Extract behaviour
+++++++++++++++++

a. Hidden Markov Model (HMM)
  .. image:: _images/msn_live_cancer_flows_HMM.png
     :width: 100%

b. HMM state transitions
  .. image:: _images/msn_live_cancer_flows_HMM_transitions.png
     :width: 100%
     
c. Cluster tracks
  .. image:: _images/msn_live_cancer_flows_clust_tracks.png
     :width: 100%
     
d. Binarise tracks
  .. image:: _images/msn_live_cancer_flows_binarise_tracks.png
     :width: 100%
     
e. Create network branches from tracks
  .. image:: _images/msn_live_cancer_flows_tracks_branching.png
     :width: 100%
     
7. Generate figures
+++++++++++++++++

a. Track flows
  .. image:: _images/msn_live_cancer_flows_figure_flows.png
     :width: 100%

b. Cluster frequencies
  .. image:: _images/msn_live_cancer_flows_figure_freq.png
     :width: 100%