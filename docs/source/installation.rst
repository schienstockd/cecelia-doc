Installation
============

This package currently only works on Unix systems because *shiny* requires this architecture.
For Windows system, or if you prefer a containerised version, we have a `Docker image <https://github.com/schienstockd/ceceliaDocker>`_.

.. attention::
  For MacOS, we recommend installing `Homebrew <https://brew.sh/>`_.
  The following programs are currently required for the `shiny app`.
  
  .. code-block:: bash
    :caption: Install required programs via Homebrew
    
    brew install pstree
    brew install openssl

1. You can install the development version of cecelia like so:

  .. code-block:: R
    :caption: Install github version
      
    if (!require("remotes", quietly = TRUE))
      install.packages("remotes")
    remotes::install_github("schienstockd/cecelia", Ncpus = 4, repos = "https://cloud.r-project.org")
    
2. After the install is finished, you must install the requirements for the *shiny app*.
  Some packages must be installed from *github* repos, hence this manual step after the main package installation.
  
  .. code-block:: R
    :caption: Install shiny app requirements
  
    library(cecelia)
    cciaAppRequirements(repos = "https://cloud.r-project.org")

3. *Cecelia* utilises a suite of flow cytometry packages, mainly from the `RGLab <https://github.com/RGLab>`_, which needs to be installed from *Bioconductor or *github*.
  
  .. code-block:: R
    :caption: Install Bioconductor requirements
    
    cciaBiocRequirements()

4. You must define a *base directory* where configuration files, models and the *shiny app* will be stored.

  .. code-block:: R
    :caption: Define base directory
    
    cciaSetup("/REPLACE/WITH/YOUR/PATH")


5. *Cecelia* depends on a *conda environment* which must be created.
  There are multiple options available depending on how you would like to use the app:
  
  * `image` For image analysis on Desktop (**default**)
  * `image-nogui` For image processing without GUI
  * `flow` For flow cytometry analysis
  
  .. tip::
    Install miniconda for Apple Metal systems, see `github issue <https://github.com/rstudio/reticulate/issues/1298#issuecomment-1310660021>`_.
    
    .. code-block:: R
      :caption: Install miniconda
      
      reticulate::install_miniconda()
  
  .. code-block:: R
    :caption: Create conda environment
  
    cciaCondaCreate(envType = "image")
  
  .. attention::
    If the previous command fails on *PyQt5* on Apple Metal systems, preinstall *napari*.
    
    ..  code-block:: R
      :caption: Preinstall napari
      
      cciaCondaCreate(preinstallNapari = TRUE)
  
6. Download models for deep-learning segmentation, tracking and others.

  .. code-block:: R
    :caption: Download models
    
    cciaModels()

7. Create *shiny app* in *base directory*.

  .. code-block:: R
    :caption: Create *shiny app*.
  
    cciaCreateApp()



Troubleshooting for Apple Metal systems
---------------

* If PyQt5 did not install successfully install Qt5 on MacOS - follow `SO answer <https://stackoverflow.com/a/71669996>`_. 
  In Terminal do the following:
  
  .. code-block:: bash
    :caption: Install and link PyQt5.
      
    brew install qt5
    brew link qt5 --force

* If PyQt5 hangs at preparing metadata. In Terminal do the following:

  .. code-block:: bash
    :caption: Install SIP and configure PyQt5
  
    brew install sip
    # The directory might be different depending on where r-miniconda is installed on your system
    . ~/Library/r-miniconda-arm64/etc/profile.d/conda.sh
    conda activate r-cecelia-env
    pip install pyqt5 --config-settings --confirm-license= --verbose

* If tensorflow fails to import with `illegal instruction` you might need to install a Mac specific version, 
  see `SO answer <https://stackoverflow.com/a/77067787>`_.

* If GPU does not work, `tensorflow-metal` will enable GPU support, see `Medium article <https://medium.com/bluetuple-ai/how-to-enable-gpu-support-for-tensorflow-or-pytorch-on-macos-4aaaad057e74>`_.

* If you get `ld: library 'crypto' not found` during `cciaBiocRequirements()`, set the following
environmental variables in `R` before trying install again (adjust program paths for your system setup).

  .. code-block:: R
    :caption: Make sure `R` knows where to look for installed libraries
    
    Sys.setenv(LIBRARY_PATH="/opt/homebrew/lib")
    Sys.setenv(LDFLAGS="-L/opt/homebrew/lib")
    Sys.setenv(CPPFLAGS="-I/opt/homebrew/include")


* MPS (`Metal Performance Shaders <https://developer.apple.com/documentation/metalperformanceshaders>` to access GPU on new Apple Metal systems) for Cellpose works but some adjustment are not in the main branch yet. Run `cciaApplyPatches` to apply patches for MPS. You need at least Ventura 13.2 and XCode 13.2 for pyTorch to work with MPS GPU in this case (`Github issue <https://github.com/pytorch/pytorch/issues/97606#issuecomment-1483901814>`_).

  .. code-block:: R
    :caption: Update Cellpose to use GPU

    cciaApplyPatches()

Troubleshooting for Python 
---------------

* `GLIBCXX_3.4.30 not found` - `SO answer <https://stackoverflow.com/a/74533050>`_

* `RuntimeError: GET was unable to find an engine to execute this computation` - `Github issue <https://github.com/haotian-liu/LLaVA/issues/123#issuecomment-1539434115>`_

  .. code-block:: bash
    :caption: Install GLIBCXX libraries for python

    conda install -c conda-forge libstdcxx-ng=12