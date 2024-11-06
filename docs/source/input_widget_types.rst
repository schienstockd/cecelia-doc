.. _input_widget_types:

Input widget types
============

.. list-table:: Input widget types
   :widths: 10 10 30 50
   :header-rows: 1

   * - Widget type
     - Description
     - Params
     - Example
   * - slider
     - Slider for numeric values
     - | step: numeric value for step size
     - | "resolution": {
       |   "index": 3,
       |   "label": "Resolution",
       |   "widget:slider": {
       |     "step": 0.01
	     |   }
	     | }
   * - sliderGroup
     - Slider group for numeric values
     - | list of slider definitions 
     - | "crop": {
       |   "index": 6,
       |   "label": "Crop",
       |   "widget:sliderGroup": {
       |     "X": {"label": "X", "step": 25},
       |     "Y": {"label": "Y", "step": 25},
       |     "Z": {"label": "Z", "step": 1},
       |     "T": {"label": "T", "step": 1}
       |   }
       | }
   * - group
     - Groups of input UIs
     - | visible: boolean whether checkbox is ticked
			 | numItems: number of items in list
			 | sortable: boolean to enable re-ordering items
     - | "models": {
			 |   "index": 1,
			 |   "label": "Model parameters",
			 |   "widget:group": {
       |     "visible": false,
			 |	   "numItems": 5,
			 |	   "dynItems": true,
			 |	   "sortable": false,
  		 |		 "model": {
       |       "index": 0,
       |       "label": "Denoise Model",
       |       "widget:selection": {
       |         "size": 1,
       |         "multiple": false,
       |         "items": {
       |           "Denoise cyto3": "denoise_cyto3",
       |           "Deblur cyto3": "deblur_cyto3",
       |           "Upsample cyto3": "upsample_cyto3"
       |				 }
       |       }
       |    }
       |  }
       | }
     
     