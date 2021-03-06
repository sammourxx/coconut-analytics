'use strict';



var fullScreenControl = L.Control.Fullscreen.extend({
  onAdd: function (map) {
    var container = L.DomUtil.create('div', 'leaflet-control-fullscreen-mdl leaflet-bar-mdl'),
        options = this.options,
        button = this._createMaterialButton('leaflet-fullscreen-mdl', 'fullscreen', options.title['false'], container);

    this._map = map;
    this._map.on('fullscreenchange', this._toggleTitle, this);
    this._toggleTitle();

    L.DomEvent.on(button, 'click', this._click, this);

    return container;
  },

  _toggleTitle: function () {
    var fullScreenIcon = {
      'false': 'fullscreen',
      'true': 'fullscreen_exit'
    };
    
      
    this._materialButton.title = this.options.title[this._map.isFullscreen()];
    this._materialIcon.innerHTML = fullScreenIcon[this._map.isFullscreen()];
//    console.log ("this._materialButton.title: " + this._materialButton.title);
//    console.log ("fullSCreenIcon: " + JSON.stringify(fullScreenIcon));
    var screenState = this._materialButton.title == "Exit Fullscreen" ? "Fullscreen" : "Screen";    
//    console.log("screenState: "+screenState);
    var event = new CustomEvent('fullScreenChange', { 'detail': { 
            screenState: screenState 
        }
    });   
    window.dispatchEvent(event);
    if (this._materialToolTip) {
      this._materialToolTip.innerHTML = this.options.title[this._map.isFullscreen()];
      this._materialButton.removeAttribute('title');
    }
  }
});

//module.exports.fullScreenControl = fullScreenControl;
//
//module.exports.materialFullscreenControl = function(options) {
//  return new MaterialFullscreenControl(options);
//};