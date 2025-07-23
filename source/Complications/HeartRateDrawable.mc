import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class HeartRateDrawable extends WatchUi.Drawable {
    private var _model as Complicated.HeartRateModel;
    private var _leftX as Number;
    private var _y as Number;
    private var _slotWidth as Number;
    private var _height as Number;
    private var _color = Graphics.COLOR_BLUE;
    private var _bg_color = Graphics.COLOR_DK_BLUE;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :slotWidth as Numeric,
          :height as Numeric,
        }
    ) {
      _model = new Complicated.HeartRateModel();

      _leftX = params[:x];
      _y = params[:y];
      _slotWidth = params[:slotWidth];
      _height = params[:height];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();

      // var percent = _model._heartRate;
      var heartRateZone = _model._heartRateZone;

      // there will always be 5 heart rate zones
      for (var i = 0; i < 5; i++) {
        var gap = i * 2;
        var x = _leftX + i * _slotWidth + gap;
        var color = _color;
        if (i > heartRateZone) {
          color = _bg_color;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, _y, _slotWidth, _height);
      }
    }
  }
}
