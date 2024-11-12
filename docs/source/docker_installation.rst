.. _docker_installation:

Windows/Docker installation
===================

Step by step guide 
------------------

1. Install the latest `Docker <https://www.docker.com/>`_ version.
  
  .. tip::
    For Windows, Docker uses `WSL 2` (`Windows Subsystem for Linux <https://learn.microsoft.com/en-us/windows/wsl/about>`_). By default all containers will be stored on `C:` drive. To change the location, you must execute the following commands in `Command prompt` as outlined in this `Stack Overflow <https://stackoverflow.com/a/63752264>`_ post:
  
    Make sure that `Docker Desktop` is shut down. 
    
    .. code-block:: bash
      :caption: Check WSL state
      
      wsl --list -v
    
    .. code-block:: bash
      :caption: Make sure the services are STOPPED
      
        NAME                   STATE           VERSION
      * docker-desktop         Stopped         2
        docker-desktop-data    Stopped         2
    
    Export `docker-desktop-data` to a file.
    
    .. code-block:: bash
      :caption: Export Docker Desktop data
      
      wsl --export docker-desktop-data "D:\Docker\wsl\data\docker-desktop-data.tar"
      
    Unregister `docker-desktop-data`.
    
    .. code-block:: bash
      :caption: Unregister Docker Desktop data
      
      wsl --unregister docker-desktop-data
    
    Import the data into `a new location` where your Docker containers will be stored. You must create the new location first before submitting this command.
    
    .. code-block:: bash
      :caption: Import Docker Desktop data into new location
      
      wsl --import docker-desktop-data "D:\Docker\wsl\data" "D:\Docker\wsl\data\docker-desktop-data.tar" --version 2
    
    After this you can start `Docker Desktop` and all containers should now be saved in the new location. You can now delete the `.tar` file.
    
  .. attention::
    For Windows, you need either at least Windows 11 or at least the `19044.1200 (21H2) Windows 10 Insider Preview Build <https://blogs.windows.com/windows-insider/2021/08/18/announcing-windows-10-insider-preview-build-19044-1198-21h2/>`_ for GPU support. You can sign up `here <https://insider.windows.com/en-us/register>`_ for the Windows insider program.

2. Install the latest `Miniconda <https://docs.anaconda.com/miniconda/miniconda-install/>`_ version.

3. Retrieve the `CeceliaDocker` project. Either `Download <https://github.com/schienstockd/ceceliaDocker/archive/refs/heads/master.zip>`_ or clone the `CeceliaDocker repository <https://github.com/schienstockd/ceceliaDocker>`_

  .. code-block:: bash
    :caption: Clone repository with git
    
    git clone https://github.com/schienstockd/ceceliaDocker.git
  
  .. image:: _images/docker_git_clone.png
   :width: 100%

4. Create `conda` environment for `napari` to run.
On Windows, you might want to use `Anaconda Prompt` to initialise the conda toolkit. `Anaconda Prompt` has to be used only to initialise the `conda` environment. It is not needed after this step is done.

  .. code-block:: bash
    :caption: Create conda environment
    
    conda env create --file=conda-gui-env.yml

  .. attention::
    On Windows, if the conda environment fails to build due to missing compiler wou might need to install `Microsoft Visual C++ >= 14.0 <https://visualstudio.microsoft.com/visual-cpp-build-tools/>`_ with Microsoft C++ Build Tools.

  .. image:: _images/docker_conda_create.png
     :width: 100%

5. Adjust config files

  You must adjust the filepaths in `docker-compose.yml` and `datashare/docker.yml`. This will tell Docker where your projects are stored and the data location that you can use to import data. We also must tell `Shiny` to use the host directory to open images as they are opened outside of the container within the napari environment.

  .. code-block:: yaml
    :caption: Windows example docker-compose.yml

    services:
      app:
        volumes:
          - D:\Public\Cecelia\GIT\ceceliaDocker\datashare:/home/shiny/local
          - D:\Public\Cecelia\PROJECTS:/cecelia/projects
          - D:\Public\Cecelia\DATA:/cecelia/data
          
  .. code-block:: yaml
    :caption: Windows example datashare/docker.yml

    default:
      docker:
        useDocker: TRUE
        pathMapping:
          home:
            from: "/home/shiny/local/cecelia"
            to: "D:\\Public\\Cecelia\\GIT\\ceceliaDocker\\datashare\\cecelia"
          projects:
            from: "/cecelia/projects"
            to: "D:\\Public\\Cecelia\\PROJECTS"

  .. image:: _images/docker_edit_config_files.png
   :width: 100%

6. Start `Docker Desktop` and retrieve `Cecelia` container.
  Run (or build) the Docker container with `cecelia-MacOSX-docker.command` (Mac) or `cecelia-Windows-docker.bat` (Windows). This will start the local napari environment, retrieve the Docker container during the first run and start the app. There are two Dockerfiles. The default one pulls the current Docker image from Dockerhub. Dockerfile.build will build the container if you wish to do that.
  
  .. attention::
    If you installed `Miniconda` in a custom location, ie/ not your user account, you must specify that directory in the `.command` or `.bat` file.

    .. image:: _images/docker_edit_bat.png
     :width: 100%
     
  .. image:: _images/docker_container.png
    :width: 100%
    
  .. image:: _images/docker_startup.png
    :width: 100%
