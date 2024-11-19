.. _macos_installation:

MacOS installation
============

Step by step guide 
------------------

0. Installation should take less than 1 h. Most time will be spent compiling `R` and `python` packages where binaries are not available. `DISCLAIMER`: While we aimed to make this installation process as simple as possible, a basic knowledge of `running commands in Terminal <https://support.apple.com/en-au/guide/terminal/apdb66b5242-0d18-49fc-9c47-a2498b7c91d5/2.14/mac/15.0>`_ and `installing packages R <https://www.datacamp.com/tutorial/r-packages-guide>`_ is helpful.

1. Install library dependencies. We recommend using `Homebrew <https://brew.sh/>`_ to install the necessary dependencies. If you do not have Homebrew, install it by typing or pasting the following into `Terminal`:
  
  .. code-block:: bash
    :caption: Install Homebrew
  
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  .. attention::
    If you are running on `Apple Silicon` (Mx) make sure that Homebrew is recognising the correct machine architecture. In `Terminal` run `brew config`. The output should look something like the following. The important information is that `macOS` should be `arm64`, `Rosetta 2` should be `false` and `HOMEBREW_PREFIX` should be `/opt/homebrew`.
    
    .. code-block:: bash
      :caption: Expected output of `brew config`
    
      HOMEBREW_VERSION: 4.4.5
      ORIGIN: https://github.com/Homebrew/brew
      HEAD: 254bf3fe9d8fa2e1b2fb55dbcf535b2d870180c4
      Last commit: 8 days ago
      Core tap JSON: 18 Nov 05:40 UTC
      Core cask tap JSON: 18 Nov 05:40 UTC
      HOMEBREW_PREFIX: /opt/homebrew
      HOMEBREW_CASK_OPTS: []
      HOMEBREW_MAKE_JOBS: 24
      Homebrew Ruby: 3.3.6 => /opt/homebrew/Library/Homebrew/vendor/portable-ruby/3.3.6/bin/ruby
      CPU: 24-core 64-bit arm_blizzard_avalanche
      Clang: 16.0.0 build 1600
      Git: 2.39.5 => /Applications/Xcode.app/Contents/Developer/usr/bin/git
      Curl: 8.7.1 => /usr/bin/curl
      macOS: 15.1-arm64
      CLT: 16.1.0.0.1.1729049160
      Xcode: 16.1
      Rosetta 2: false
          
    If `HOMEBREW_PREFIX` is `/usr/local` and the other parameters also do not match, you might have to check that `Terminal` is running in the correct mode. Do the following is based on this `Stackoverflow post <https://stackoverflow.com/a/71666623>`_. Go to: `Finder` -> `Applications` -> `Utilities` -> `Terminal`. Right click on Terminal and select `Get Info`. Uncheck checkbox: 'Open using Rosetta'. Quit Terminal Application. Restart Terminal and check your machine arhictecture:
    
    .. code-block:: bash
      :caption: Check machine architecture
      
      uname -m # should return arm64 NOT x86_64
    
    Then, `remove Homebrew <https://docs.brew.sh/FAQ#how-do-i-uninstall-homebrew>`_ and `install <https://docs.brew.sh/Installation>`_ again.

Then install the required programs using Homebrew via `Terminal`:

  .. code-block:: bash
    :caption: Install required programs via Homebrew
    
    brew install pstree openssl gdal cmake
    
2. You will also most likely need `Xcode <https://developer.apple.com/xcode/>`_ to compile packages in `R` and `Python`. Follow the installation instructions on `Mac App Store <https://apps.apple.com/us/app/xcode/id497799835>`_.

3. Install `R base for MacOS <https://cran.r-project.org/bin/macosx/>`_ and `RStudio <https://posit.co/download/rstudio-desktop/#download>`_. We tested this on R version `4.4.1`. If you use an older version of `R` the package dependencies might not be resolved during `renv::init()`.

4. Start `RStudio` and install `renv` in the `R` console.

  .. code-block:: R
    :caption: Install renv
    
    install.packages("renv")
   
5. Install package dependencies.
  * Create a folder under `Applications` named `cecelia`.
  * Within the `cecelia` folder create a directory `projects` where all projects data will be stored.
  * Download the `renv.lock file <https://github.com/schienstockd/cecelia/raw/refs/heads/master/renv.lock>`_ into ``/Applications/cecelia``. `Important`: save this as renv.lock NOT renv.lock.txt. Remove `.txt` if this is appended during the download.
  * Then in `RStudio`, create the R-environment using the example below. To do this, you must set the current working directory to the directory where the renv.lock file is located. 
  * When prompted during the process, Select “1” to restore the project from the lockfile.
  
  .. tip::
    We are going to use the path ``/Applications/cecelia`` throughout this manual. You can place it anywhere else if you want.
  
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
      
      ls /opt/homebrew/Cellar/gcc/ # for Apple Silicon
      ls /usr/local/Cellar/gcc/ # for macOS Intel
    
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
  
6. Load the environment you have just created and install `Cecelia` package.
  
  .. code-block:: R
    :caption: Install Cecelia package
    
    renv::load()
    renv::install("schienstockd/cecelia")
    
  .. image:: _images/macos_ccia_install.png
   :width: 100%
   
7. You must define a `base directory` where configuration files, models and the `shiny app` will be stored.

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

8. `Cecelia` depends on a `conda environment` which must be created.
    
  .. code-block:: R
    :caption: Install miniconda
    
    reticulate::install_miniconda()

  .. image:: _images/macos_miniconda_install.png
    :width: 100%
  
9. For Apple Silicon systems (Mx), you `must` pre-create the conda environment in `Terminal` otherwise it will use the wrong platform type.
    
  You must source `conda` first with the following commands. `reticulate::miniconda_path()` will give you the conda path that you must put into the following command.
    
  ..  code-block:: bash
    :caption: Pre-create conda environment in `Terminal`
    
    . /REPLACE_ME/etc/profile.d/conda.sh
    CONDA_SUBDIR=osx-arm64 conda create -n r-cecelia-env python=3.9
  
  .. image:: _images/macos_arm_conda_create.png
    :width: 100%
  
10. Then, back in Rstudio, Create conda environment¶
  
  .. code-block:: R
    :caption: Create conda environment
  
    cciaCondaCreate()
    
  .. image:: _images/macos_conda_create.png
    :width: 100%
  
11. Download models for deep-learning segmentation, tracking and others.

  .. code-block:: R
    :caption: Download models
    
    cciaModels()
    
  .. image:: _images/macos_ccia_models.png
    :width: 100%

12. Create `shiny app` in `base directory`.

  .. code-block:: R
    :caption: Create `shiny app`
  
    cciaCreateApp()
    
  .. image:: _images/macos_create_app.png
    :width: 100%

13. Adjust the config file.
  If you want to adjust where your projects are located, you must adjust the parameters in ``/Applications/cecelia/custom.yml`` to your system and download `bioformats2raw`:

  * Download `bioformats2raw <https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.9.0/bioformats2raw-0.9.0.zip>`_ and place it into the ``/Applications`` folder

  .. code-block:: YAML
    :caption: Adjust config in text editor of RStudio
  
    default:
      dirs:
        bioformats2raw: "/Applications/bioformats2raw-0.9.0/"
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
            
14. Run the `app`.
  
  To start the application, double click `cecelia-macOSX.command` located in ``/Applications/cecelia/app/``.
  
  .. code-block:: bash
    :caption: Run `Cecelia` app
  
    /Applications/cecelia/app/cecelia-macOSX.command
    
  .. image:: _images/macos_run_app.png
    :width: 100%
   