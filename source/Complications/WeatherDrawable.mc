import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class WeatherDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.WeatherModel;

    // furthest left point
    private var _x as Number;
    private var _y as Number;

    private var _iconWidth = 30;
    private var _barWidth = 62;
    private var _humidityBarHeight = 2;
    private var _precipitationBarHeight = 8;
    private var _temperatureWidth = 32;
    private var _temperatureHeight = 24;
    private var _gap = 3;

    private var _slotWidth = 3;
    private var _slotHeight = 8;
    private var _windSpeedRadius = 9;

    private var _fullWidth =
      _iconWidth + _barWidth + _temperatureWidth + _gap * 3;

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

      _x = params[:x] - _fullWidth / 2 + 6;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawTemperature(dc as Graphics.Dc) as Void {
      var X = _x + _fullWidth - _temperatureWidth;
      var centerX = X + _temperatureWidth / 2;


      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(1);
      Cyberpunk.drawPolygon(dc, X, _y, [
        [0, _temperatureHeight],
        [_temperatureWidth, _temperatureHeight],
        [_temperatureWidth, 8],
        [_temperatureWidth - 8, 0]
      ]);
      var temperature = "--°";
      if (_model._currentTemperature != null) {
        temperature = _model._currentTemperature.format("%d") + "°";
      }
      dc.drawText(
        centerX,
        _y + 2,
        Graphics.FONT_SYSTEM_XTINY,
        temperature,
        Graphics.TEXT_JUSTIFY_CENTER
      );

      var high = "-";
      if (_model._high != null) {
        high = _model._high.format("%d");
      }
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        centerX - 1,
        _y + _temperatureHeight,
        Graphics.FONT_SYSTEM_XTINY,
        high,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      var low = "-";
      if (_model._low != null) {
        low = _model._low.format("%d");
      }
      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        centerX + 1,
        _y + _temperatureHeight,
        Graphics.FONT_SYSTEM_XTINY,
        low,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    private function drawHumidityAndPrecipitationChance(dc as Dc) {
      var X = _x + _iconWidth + _gap;

      var humidityPercentWidth = _barWidth * _model._humidityPercent / 100;
      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, _barWidth, _humidityBarHeight);
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, humidityPercentWidth, _humidityBarHeight);

      var precipitationPercentWidth = _barWidth * _model._precipitationChance / 100;
      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y + _humidityBarHeight + _gap, _barWidth, _precipitationBarHeight);
      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y + _humidityBarHeight + _gap, precipitationPercentWidth, _precipitationBarHeight);
    }

    private function drawUVIndexSlots(dc as Dc) as Void {
      var Y = _y + _humidityBarHeight + _precipitationBarHeight + 5 * _gap;

      var color = RED;
      var darkColor = DARK_RED;
      if (_model._uvIndexIsActionable) {
        color = YELLOW;
        darkColor = DARK_YELLOW;
      }

      for (var i = 1; i <= 10; i++) {
        var slotX = _x + i * (_slotWidth + 2);
        if (i <= _model._uvIndex) {
          dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        } else {
          dc.setColor(darkColor, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(slotX, Y, _slotWidth, _slotHeight);
      }
    }

    private function drawWind(dc as Dc) as Void {
      var X = _x + _iconWidth + _barWidth + 2 * _gap - _windSpeedRadius - _gap; // center
      var Y = _y + _humidityBarHeight + _precipitationBarHeight + 3 * _gap + _windSpeedRadius; // center

      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(2);
      dc.drawCircle(X, Y, _windSpeedRadius);
      var windSpeed = "-";
      if (_model._windSpeed != null) {
        windSpeed = _model._windSpeed.format("%d");
      }
      dc.drawText(
        X - _windSpeedRadius - _gap,
        Y - _windSpeedRadius,
        Graphics.FONT_SYSTEM_XTINY,
        windSpeed,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(dc, _x, _y - 2 * _gap, [12, 18]);
      drawHumidityAndPrecipitationChance(dc);
      drawTemperature(dc);
      drawUVIndexSlots(dc);
      drawWind(dc);
    }
  }
}
