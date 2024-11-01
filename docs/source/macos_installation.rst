.. _macos_installation:

MacOS installation
============

Step by step guide 
------------------

1. Install library dependencies. We recommend using `Homebrew <https://brew.sh/>`_ to install the necessary dependencies. Type the following into `Terminal`.

  .. code-block:: bash
    :caption: Install required programs via Homebrew
    
    brew install pstree
    brew install openssl
    brew install gdal # Dependency for SPIAT package
    brew install cmake # If you don't have Xcode

2. Install `R base for MacOS <https://cran.r-project.org/bin/macosx/>`_ and `RStudio <https://posit.co/download/rstudio-desktop/#download>`_. We tested this on R version `4.4.1`. If you use another version of R the package dependencies might not be resolved during `renv::init()`.

3. Start `RStudio` and install `renv`.

  .. code-block:: R
    :caption: Install renv
    
    install.packages("renv")
   
4. Install package dependencies. Download the `renv.lock file <https://github.com/schienstockd/cecelia/raw/refs/heads/master/renv.lock>`_ (save as `renv.lock` NOT `renv.lock.txt`) and create the R-environment. You must set the `current working directory` to the directory where the `renv.lock` file is located. Select "1" to restore the project from the lockfile.
  
  .. tip::
    `Unix` systems have three main signs to specify directories
  
    .. code-block:: bash
      :caption: Common path directories
      
      ~ defines the home directory
      . defines the current directory
      .. defines the parent directory
      
      ~/Documents is shortform for /Users/dom/Documents
  
  .. code-block:: R
    :caption: Init R-environment
    
    # An example would be
    # setwd("~/Cecelia")
    setwd("PATH/TO/RENV/LOCK/FILE")
    renv::init()
    
  .. image:: _images/macos_install_renv.png
   :width: 100%
   
5. Load the environment you have just created and install `Cecelia` package.
  
  .. code-block:: R
    :caption: Install Cecelia package
    
    renv::load()
    renv::install("schienstockd/cecelia")
    
  .. image:: _images/macos_ccia_install.png
   :width: 100%
   
6. You must define a `base directory` where configuration files, models and the `shiny app` will be stored.

  .. code-block:: R
    :caption: Define base directory
    
    library(cecelia)
    cciaSetup("/REPLACE/WITH/YOUR/PATH")
  
  In case you get stuck at any point and have to restart R, you need to redefine the path you are working on
  
  .. code-block:: R
    :caption: Restart Cecelia
    
    Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")
    library(cecelia)
    cciaUse("/REPLACE/WITH/YOUR/PATH")
    
  .. image:: _images/macos_ccia_setup.png
   :width: 100%

5. `Cecelia` depends on a `conda environment` which must be created.
    
  .. code-block:: R
    :caption: Install miniconda
    
    reticulate::install_miniconda()

  .. image:: _images/macos_miniconda_install.png
    :width: 100%
  
  .. attention::
    For Apple Metal systems, you need to pre-create the conda environment in `Terminal` otherwise it will use the wrong platform type. You might have to source conda first if the command cannot be found.
    `reticulate::miniconda_path()` will give you the conda path.
    
    ..  code-block:: bash
      :caption: Pre-create conda environment
      
      # if the conda command is not found
      . /PATH/TO/MINICONDA/etc/profile.d/conda.sh
      CONDA_SUBDIR=osx-arm64 conda create -n r-cecelia-env python=3.9
    
    .. image:: _images/macos_arm_conda_create.png
      :width: 100%
    
  .. code-block:: R
    :caption: Create conda environment
  
    cciaCondaCreate()
    
  .. image:: _images/macos_conda_create.png
    :width: 100%
  
6. Download models for deep-learning segmentation, tracking and others.

  .. code-block:: R
    :caption: Download models
    
    cciaModels()
    
  .. image:: _images/macos_ccia_models.png
    :width: 100%

7. Create `shiny app` in `base directory`.

  .. code-block:: R
    :caption: Create `shiny app`
  
    cciaCreateApp()
    
  .. image:: _images/macos_create_app.png
    :width: 100%

8. Adjust config
  You have to adjust the parameters in `~/path/to/cecelia/custom.yml` to your system and download/install:

  * `bioformats2raw <https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.8.0/bioformats2raw-0.8.0.zip>`_

  .. code-block:: YAML
    :caption: Adjust config
  
    default:
      dirs:
        bioformats2raw: "/path/to/bioformats2raw"
        projects: "/your/project/directory/"
      volumes:
        SSD: "/your/ssd/directory/"
        home: "~/"
        computer: "/"
      python:
        conda:
          env: "r-cecelia-env"
          source:
            env: "r-cecelia-env"
            
  .. image:: _images/macos_custom_config.png
    :width: 100%
            
9. Run the `app`.

  .. code-block:: bash
    :caption: Run `Cecelia` app
  
    ./PATH/TO/CECELIA/app/cecelia-macOSX.command
    
  .. image:: _images/macos_run_app.png
    :width: 100%
   