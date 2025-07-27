import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class WeatherDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.WeatherModel;

    private var _x as Number;
    private var _y as Number;
    private var _temperatureCenterMarginRight = 36;
    private var _halfGap = 1;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Cyberpunk.WeatherModel();
      _y = params[:y];
      _x = params[:x];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawTemperature(dc as Graphics.Dc) as Void {
      var X = _x + _temperatureCenterMarginRight - _halfGap;

      var temperature = "-°";
      if (_model._currentTemperature != null) {
        temperature = _model._currentTemperature.format("%d") + "°";
      }
      dc.setColor(WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y,
        Graphics.FONT_SYSTEM_SMALL,
        temperature,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
    }

    private function drawHighLow(dc as Graphics.Dc) as Void {
      var X = _x + _temperatureCenterMarginRight + _halfGap;
      var high = "-";
      if (_model._high != null) {
        high = _model._high.format("%d");
      }
      var low = "-";
      if (_model._low != null) {
        low = _model._low.format("%d");
      }
      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y,
        Graphics.FONT_SYSTEM_XTINY,
        high,
        Graphics.TEXT_JUSTIFY_LEFT
      );
      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y + 14,
        Graphics.FONT_SYSTEM_XTINY,
        low,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(dc, _x, _y, [12, 18]);
      drawTemperature(dc);
      drawHighLow(dc);
    }
  }
}
