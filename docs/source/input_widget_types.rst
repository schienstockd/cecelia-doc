.. _input_widget_types:

Input widget types
============

.. list-table:: Input widget types
   :widths: 20 30 40 10
   :header-rows: 1

   * - Widget type
     - Description
     - Params
     - Example file
   * - slider
     - Slider for numeric values
     - | step: numeric value for step size
     - | Pyramid scale for `Import OME-ZARR <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/importImages/omezarr.json>`_
   * - sliderGroup
     - Slider group for numeric values
     - | list of slider definitions 
     - | Crop images in `Generate training images <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/trainModels/generateTrainingImages.json>`_
   * - group
     - Groups of input UIs
     - | visible: boolean whether checkbox is ticked
       | numItems: number of items in list
       | sortable: boolean to enable re-ordering items
     - | Model parameters in `Cellpose segmentation <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/segment/cellpose.json>`_
   * - box
     - Box with input UIs
     - | collapsible: boolean to create collapsible box
       | collapsed: boolean to create collapsed box
       | items: list of UI items in box
     - | Advanced settings in `Autofluorescence correction <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/cleanupImages/afCorrect.json>`_
   * - imageSourceSelection
     - Selection field with modified images
     - | see `selection`
     - | Source images in `Generate training images <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/trainModels/generateTrainingImages.json>`_
   * - valueNameSelection
     - Selection field with value names for a specific variable
     - | see `selection`
       | field: character to define variable type
     - | Image in `Remove images <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/importImages/remove.json>`_
   * - imageSetSelection
     - Selection field with value names for a specific variable
     - | see `selection`
     - | Image set to save images in `Generate training images <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/trainModels/generateTrainingImages.json>`_
   * - channelSelection
     - Selection field with channel names
     - | see `selection`
       | useNames: boolean to use channel names not numbers
       | addChoices: character vector to add choices to list that will always be shown independent of whether they are present in labels or not
     - | Channels to transform in `Create Gating Set <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/gatePopulations/createGatingSet.json>`_
   * - channelSelectionTypeGroup
     - Group of selection fields with channel names accoridng to type. If nuclei and membrane are segmented there will be two type: nuc (nuclei) and base (cytoplasm +/- nuclei)
     - | see `channelSelection`
     - | Channels to use for clustering in `Leiden clustering <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/clustPopulations/leidenClustering.json>`_
   * - labelPropsColsSelection
     - Selection field of label properties
     - | see `selection`
       | addChoices: character vector to add choices to list that will always be shown independent of whether they are present in labels or not
     - | Object measurements used in `Track clustering <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/behaviourAnalysis/clusterTracks.json>`_
   * - popSelection
     - Selection field of populations
     - | see `selection`
       | includeRoot: boolean to include root populations
       | tracksOnly: boolean to only show tracks
       | showAll: boolean to show all populations from all population types
       | popType: character to specify population type, otherwise it will be taken from context
       | useNames: boolean to use population names instead of IDs
     - | Populations used in `Cell cluster detection <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/spatialAnalysis/cellClusters.json>`_
   * - popTypeSelection
     - Selection field of population type
     - | see `popSelection`
     - | Population type in `Track clustering <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/behaviourAnalysis/clusterTracks.json>`_
   * - moduleFunSelection
     - Selection field of module functions from the current module
     - | see `select`
     - | Function module in `Retrieve analysis from server <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/spatialAnalysis/retrieve.json>`_
   * - selection
     - Selection field
     - | size: numeric for number of items displayed when collapsed
       | multiple: boolean to allow selection of multiple values
       | items: list of values
     - | Function selection for object filters in `Bayesian tracking <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/tracking/bayesianTracking.json>`_
   * - radioButtons
     - Radio buttons
     - | items: list of values
     - | Axis used for normalisation in `Leiden clustering <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/clustPopulations/leidenClustering.json>`_
   * - textInput
     - Text
     - | NONE
     - | Model name in `Cellpose segmentation <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/segment/cellpose.json>`_
   * - checkbox
     - Checkbox
     - | NONE
     - | Use overlapping track segments in `HMM states <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/behaviourAnalysis/hmmStates.json>`_
   * - channelGroup
     - Group of UIs for channels
     - | visible: boolean to expand all UIs by default
     - | Settings for individual channels in `Autofluorescence correction <https://github.com/schienstockd/cecelia/blob/master/inst/app/modules/inputDefinitions/cleanupImages/afCorrect.json>`_
     