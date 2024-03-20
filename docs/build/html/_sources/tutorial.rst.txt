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

Users familiar with `R Markdown <https://rmarkdown.rstudio.com/>`_ can also process and analyse data using more customised methods. Throughout the tutorial there will be examples on how to do that.

Static image
------------

We will analyse `M3c-Arm1_5-XCR1_Venus-B220_PB-LCMV_AF594-P14_CTDR-CD3e_AF700-1_Unmixing-crop.tif` which is a cropped version of a cross-section from XCR1-Venus (dendritic cells) reporter mice after virus (LCMV) infection.

#. Import the image 

.. image:: _images/tutorial/static/import_images.png
   :width: 600

