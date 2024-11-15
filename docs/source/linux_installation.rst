.. _linux_installation:

Linux installation
============

Step by step guide 
------------------

0. Installation should take less than 1 h. Most time will be spent compiling `R` and `python` packages. Most `R` packages will have to be compiled on Linux systems.

1. Install library dependencies. We have tested this on `Ubuntu 24.04.1 LTS`. The package list might therefore vary depending on your distribution.

  .. code-block:: bash
    :caption: Install dev libraries
    
    sudo apt-get install libcurl4-openssl-dev libxml2-dev cmake libgdal-dev libmagick++-dev libudunits2-dev libharfbuzz-dev libfribidi-dev

  .. image:: _images/linux_install_devs.png
   :width: 100%

2. Install `R base for Ubuntu <https://cran.rstudio.com/bin/linux/ubuntu/>`_ and `RStudio <https://posit.co/download/rstudio-desktop/#download>`_. We tested this on R version `4.4.1`. If you use another version of R the package dependencies might not be resolved during `renv::init()`.

3. Start `RStudio` and install `renv`.

  .. code-block:: R
    :caption: Install renv
    
    install.packages("renv")
    
  .. image:: _images/linux_install_renv.png
   :width: 100%
   
4. Install package dependencies. Download the `renv.lock file <https://github.com/schienstockd/cecelia/raw/refs/heads/master/renv.lock>`_ and create the R-environment. You must set the `current working directory` to the directory where the `renv.lock` file is located. Select "1" to restore the project from the lockfile.
  
  .. tip::
    `Unix` systems have three main signs to specify directories
  
    .. code-block:: bash
      :caption: Common path directories
      
      ~ defines the home directory
      . defines the current directory
      .. defines the parent directory
      
      ~/Documents is shortform for /home/dom/Documents
  
  .. code-block:: R
    :caption: Init R-environment
    
    # An example would be
    # setwd("~/Cecelia")
    setwd("PATH/TO/RENV/LOCK/FILE")
    renv::init()
    
  .. image:: _images/linux_renv_init.png
   :width: 100%
   
5. Load the environment you have just created and install `Cecelia` package.
  
  .. code-block:: R
    :caption: Install Cecelia package
    
    renv::load()
    renv::install("schienstockd/cecelia")
    
  .. image:: _images/linux_ccia_install.png
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
    
  .. image:: _images/linux_ccia_setup.png
   :width: 100%

5. `Cecelia` depends on a `conda environment` which must be created.
    
  .. code-block:: R
    :caption: Install miniconda
    
    reticulate::install_miniconda()

  .. image:: _images/linux_miniconda_install.png
    :width: 100%
  
  .. code-block:: R
    :caption: Create conda environment
  
    cciaCondaCreate()
    
  .. image:: _images/linux_conda_create.png
    :width: 100%
  
6. Download models for deep-learning segmentation, tracking and others.

  .. code-block:: R
    :caption: Download models
    
    cciaModels()
    
  .. image:: _images/linux_ccia_models.png
    :width: 100%

7. Create `shiny app` in `base directory`.

  .. code-block:: R
    :caption: Create `shiny app`
  
    cciaCreateApp()
    
  .. image:: _images/linux_create_app.png
    :width: 100%

8. Adjust config
  You have to adjust the parameters in `/YOUR/PATH/TO/cecelia/custom.yml` to your system and download/install:

  * `bioformats2raw <https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.9.0/bioformats2raw-0.9.0.zip>`_

  .. code-block:: YAML
    :caption: Adjust config in text editor of RStudio
  
    default:
      dirs:
        bioformats2raw: "/REPLACE/PATH/TO/bioformats2raw"
        projects: "/REPLACE/PATH/TO/project/directory/"
      volumes:
        home: "~/"
        computer: "/"
      python:
        conda:
          env: "r-cecelia-env"
          source:
            env: "r-cecelia-env"
            
  .. image:: _images/linux_custom_config.png
    :width: 100%
            
9. Run the `app`.

  .. code-block:: bash
    :caption: Run `Cecelia` app
  
    /PATH/TO/CECELIA/app/cecelia-Linux.sh
    
  .. image:: _images/linux_run_app.png
    :width: 100%
   