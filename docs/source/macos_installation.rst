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
    brew install cmake
    
You will also most likely need `Xcode <https://developer.apple.com/xcode/>`_ to compile packages in `R` and `Python`. Follow the installation instructions on `Mac App Store <https://apps.apple.com/us/app/xcode/id497799835>`_.

2. Install `R base for MacOS <https://cran.r-project.org/bin/macosx/>`_ and `RStudio <https://posit.co/download/rstudio-desktop/#download>`_. We tested this on R version `4.4.1`. If you use another version of R the package dependencies might not be resolved during `renv::init()`.

3. Start `RStudio` and install `renv`.

  .. code-block:: R
    :caption: Install renv
    
    install.packages("renv")
   
4. Install package dependencies. Create a folder under `Applications` named `cecelia`. Within the `cecelia` folder create a directory `projects` where all projects data will be stored. Download the `renv.lock file <https://github.com/schienstockd/cecelia/raw/refs/heads/master/renv.lock>`_ (save as `renv.lock` NOT `renv.lock.txt`) into `/Applications/cecelia`. Then, create the R-environment. You must set the `current working directory` to the directory where the `renv.lock` file is located. Select "1" to restore the project from the lockfile.
  
  .. tip::
    We are going to use the path `/Applications/cecelia` throughout this manual. You can place it anywhere else if you want.
  
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
    setwd("/Applications/cecelia")
    renv::init()
    
  .. attention::
    If you run into issues that `R` cannot compile a package with `gfortran`, such as `make: /opt/gfortran/bin/gfortran: No such file or directory`, it might be that the path cannot be found because `gfortran` is now packaged into `gcc` and `R` might be looking in the wrong spot. To change this location follow the instructions as outlined in this `Stackoverflow post <https://stackoverflow.com/a/72997915>`_. In `Terminal` install `gcc`:
    
    .. code-block:: bash
      :caption: Install gcc
      
      brew install gcc
    
    Check your `gcc` version with:
    
    .. code-block:: bash
      :caption: Check gcc version
      
      ls /opt/homebrew/Cellar/gcc/
    
    Create a file `~/.R/Makevars` and enter the following. You need to change the `gcc` version for your version number.
    
    .. code-block:: bash
      :caption: Change Fortran paths
      
      FC = /opt/homebrew/Cellar/gcc/11.3.0_2/bin/gfortran
      F77 = /opt/homebrew/Cellar/gcc/11.3.0_2/bin/gfortran
      FLIBS = -L/opt/homebrew/Cellar/gcc/11.3.0_2/lib/gcc/11
    
  .. attention::
    If there are further errors that packages cannot be compiled because header files are not found, such as `fatal error: 'cstlib' file not found`, it might be that `RStudio` is modifying the `PATH` variable when using `renv`, see `Github issue <https://github.com/rstudio/renv/issues/1845>`_. If that happens, do the installation in `Terminal` NOT `RStudio`. Open `Terminal` and type in `R` and follow the same instructions.
    
  .. attention::
    If you still run into compiler issues, please remove and re-install `Xcode <https://developer.apple.com/xcode/>`_.
    
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
    cciaSetup("/Applications/cecelia")
  
  In case you get stuck at any point and have to restart R, you need to redefine the path you are working on
  
  .. code-block:: R
    :caption: Restart Cecelia
    
    Sys.setenv(KMP_DUPLICATE_LIB_OK = "TRUE")
    library(cecelia)
    cciaUse("/Applications/cecelia")
    
  .. image:: _images/macos_ccia_setup.png
   :width: 100%

5. `Cecelia` depends on a `conda environment` which must be created.
    
  .. code-block:: R
    :caption: Install miniconda
    
    reticulate::install_miniconda()

  .. image:: _images/macos_miniconda_install.png
    :width: 100%
  
  .. attention::
    For Apple Silicon systems (M1-3), you `must` pre-create the conda environment in `Terminal` otherwise it will use the wrong platform type. You must source `conda` first with the following commands.
    `reticulate::miniconda_path()` will give you the conda path that you need to put into the following command.
    
    ..  code-block:: bash
      :caption: Pre-create conda environment in `Terminal`
      
      . /REPLACE/WITH/PATH/TO/MINICONDA/etc/profile.d/conda.sh
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
  You have to adjust the parameters in `/Applications/cecelia/custom.yml` to your system and download/install:

  * Download `bioformats2raw <https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.9.0/bioformats2raw-0.9.0.zip>`_ and place it into the `/Applications` folder

  .. code-block:: YAML
    :caption: Adjust config in text editor of RStudio
  
    default:
      dirs:
        bioformats2raw: "/Applications/bioformats2raw"
        projects: "/Applications/cecelia/projects"
      volumes:
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
  
  To start the application, double click `cecelia-macOSX.command` located in `/Applications/cecelia/app/`.
  
  .. code-block:: bash
    :caption: Run `Cecelia` app
  
    /Applications/cecelia/app/cecelia-macOSX.command
    
  .. image:: _images/macos_run_app.png
    :width: 100%
   