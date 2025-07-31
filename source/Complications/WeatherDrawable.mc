import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;

module Cyberpunk {
  class WeatherDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.WeatherModel;

    // furthest left point
    private var _x as Number;
    private var _y as Number;

    private var _gap = 3;

    private var _iconWidth = 30;

    private var _barWidth = 74;
    private var _uvSlotWidth = (_barWidth - 9) / 10; // 10 slots, 9 gaps of 1px
    private var _uvSlotHeight = 2;
    private var _humidityBarHeight = 2;
    private var _humidityBarWidth = _barWidth - 2 * _windSpeedRadius - _gap;
    private var _precipitationBarHeight = 8;

    private var _temperatureWidth = 34;
    private var _temperatureHeight = 21;

    private var _windSpeedRadius = 9;

    private var _fullWidth =
      _iconWidth + _barWidth + _temperatureWidth + _gap * 3;
    private const _opticalCenter = 4;

    private var _icons as Array<BitmapType>;
    private var _actionableIcons as Array<BitmapType>;
    private var _iconClearDay as BitmapType;
    private var _iconActionableClearDay as BitmapType;
    private var _iconClearNight as BitmapType;

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

      _x = params[:x] - _fullWidth / 2 + _opticalCenter;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      _iconClearDay = Application.loadResource(Rez.Drawables.weatherClearDay);
      _iconActionableClearDay = Application.loadResource(
        Rez.Drawables.actionableWeatherClearDay
      );
      _iconClearNight = Application.loadResource(
        Rez.Drawables.weatherClearNight
      );

      _icons = new Array<BitmapType>[UNKNOWN]; // the last of the enum is UNKNOWN
      _icons[CLOUDY] = Application.loadResource(Rez.Drawables.weatherCloudy);
      _icons[RAIN] = Application.loadResource(Rez.Drawables.weatherRain);
      _icons[SNOW] = Application.loadResource(Rez.Drawables.weatherSnow);
      _icons[WINDY] = Application.loadResource(Rez.Drawables.weatherWindy);
      _icons[FOG] = Application.loadResource(Rez.Drawables.weatherFog);
      _icons[SMOKE] = Application.loadResource(Rez.Drawables.weatherSmoke);
      _icons[HAIL] = Application.loadResource(Rez.Drawables.weatherHail);
      _icons[THUNDERSTORM] = Application.loadResource(
        Rez.Drawables.weatherThunderstorm
      );

      _actionableIcons = new Array<BitmapType>[UNKNOWN]; // the last of the enum is UNKNOWN
      _actionableIcons[CLOUDY] = Application.loadResource(
        Rez.Drawables.actionableWeatherCloudy
      );
      _actionableIcons[RAIN] = Application.loadResource(
        Rez.Drawables.actionableWeatherRain
      );
      _actionableIcons[SNOW] = Application.loadResource(
        Rez.Drawables.actionableWeatherSnow
      );
      _actionableIcons[WINDY] = Application.loadResource(
        Rez.Drawables.actionableWeatherWindy
      );
      _actionableIcons[FOG] = Application.loadResource(
        Rez.Drawables.actionableWeatherFog
      );
      _actionableIcons[SMOKE] = Application.loadResource(
        Rez.Drawables.actionableWeatherSmoke
      );
      _actionableIcons[HAIL] = Application.loadResource(
        Rez.Drawables.actionableWeatherHail
      );
      _actionableIcons[THUNDERSTORM] = Application.loadResource(
        Rez.Drawables.actionableWeatherThunderstorm
      );

      Drawable.initialize(options);
    }

    private function getConditionIcon(
      condition as Number,
      isDaytime as Boolean,
      isActionable as Boolean
    ) as BitmapType {
      if (condition < 0 || condition >= WeatherConditionMap.size()) {
        return isActionable ? _actionableIcons[UNKNOWN] : _icons[UNKNOWN];
      } else if (condition == CLEAR) {
        if (isDaytime) {
          return isActionable ? _iconActionableClearDay : _iconClearDay;
        } else {
          return _iconClearNight;
        }
      }
      return isActionable ? _actionableIcons[condition] : _icons[condition];
    }

    private function drawTemperature(dc as Graphics.Dc) as Void {
      var X = _x + _fullWidth - _temperatureWidth;
      var centerX = X + _temperatureWidth / 2;

      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(1);
      Cyberpunk.drawPolygon(dc, X, _y, [
        [0, _temperatureHeight],
        [_temperatureWidth, _temperatureHeight],
        [_temperatureWidth, 8],
        [_temperatureWidth - 8, 0],
      ]);
      var temperature = "--°";
      if (_model._currentTemperature != null) {
        temperature = _model._currentTemperature.format("%d") + "°";
      }
      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        centerX,
        _y + 1,
        Graphics.FONT_SYSTEM_XTINY,
        temperature,
        Graphics.TEXT_JUSTIFY_CENTER
      );

      var high = "-";
      if (_model._high != null) {
        high = _model._high.format("%d");
        if (_model._high >= 100) {
          // shift to the right if it is 100 or more
          centerX = centerX + 8;
        }
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
        centerX + 2,
        _y + _temperatureHeight,
        Graphics.FONT_SYSTEM_XTINY,
        low,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    private function drawUVIndexSlots(dc as Dc) as Void {
      var X = _x + _iconWidth + _gap;
      var Y = _y;

      var color = RED;
      var darkColor = DARK_RED;
      if (_model._uvIndexIsActionable) {
        color = YELLOW;
        darkColor = DARK_YELLOW;
      }

      for (var i = 1; i <= 10; i++) {
        var slotX = X + (i - 1) * (_uvSlotWidth + 1);
        if (i <= _model._uvIndex) {
          dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        } else {
          dc.setColor(darkColor, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(slotX, Y, _uvSlotWidth, _uvSlotHeight);
      }
    }

    private function drawPrecipitationChance(dc as Dc) {
      var X = _x + _iconWidth + _gap;
      var Y = _y + _uvSlotHeight + _gap;

      // TODO: if close to 100% switch and make the background blue and the bar yellow
      // because this is more serious
      var precipitationColor = BLUE;
      var precipitationColorBack = DARK_BLUE;
      if (_model._precipitationIsActionable) {
        // precipitationColor = YELLOW;
        precipitationColorBack = DARK_YELLOW;
      }
      var precipitationPercentWidth =
        (_barWidth * _model._precipitationChance) / 100;

      dc.setColor(precipitationColorBack, Graphics.COLOR_TRANSPARENT);
      Cyberpunk.fillPolygon(dc, X, Y, [
        [0, _precipitationBarHeight],
        [_barWidth - 3, _precipitationBarHeight],
        [_barWidth, _precipitationBarHeight - 3],
        [_barWidth, 0],
      ]);
      dc.setColor(precipitationColor, Graphics.COLOR_TRANSPARENT);
      if (precipitationPercentWidth < 20) {
        // draw as a rectangle if it is too small
        dc.fillRectangle(
          X,
          Y,
          precipitationPercentWidth,
          _precipitationBarHeight
        );
      } else {
        Cyberpunk.fillPolygon(dc, X, Y, [
          [0, _precipitationBarHeight],
          [precipitationPercentWidth - 3, _precipitationBarHeight],
          [precipitationPercentWidth, _precipitationBarHeight - 3],
          [precipitationPercentWidth, 0],
        ]);
      }
    }

    private function drawHumidity(dc as Dc) {
      var X = _x + _iconWidth + _gap;
      var Y = _y + _uvSlotHeight + _precipitationBarHeight + 2 * _gap + 1;

      var humidityPercentWidth =
        (_humidityBarWidth * _model._humidityPercent) / 100;
      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, Y, _humidityBarWidth, _humidityBarHeight);
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, Y, humidityPercentWidth, _humidityBarHeight);
    }

    private function drawWind(dc as Dc) as Void {
      var X = _x + _iconWidth + _humidityBarWidth + 2 * _gap + _windSpeedRadius + 1; // center
      var Y =
        _y +
        _uvSlotHeight +
        _precipitationBarHeight +
        2 * _gap +
        _windSpeedRadius +
        1; // center

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

    private function drawCondition(dc as Dc) as Void {
      // TODO: use if it is daytime
      var icon = getConditionIcon(
        _model._currentCondition,
        true,
        _model._conditionIsActionable
      );
      dc.drawBitmap(_x + 3, _y, icon);
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(dc, _x, _y - 2 * _gap, [12, 18]);
      drawHumidity(dc);
      drawPrecipitationChance(dc);
      drawTemperature(dc);
      drawUVIndexSlots(dc);
      drawWind(dc);
      drawCondition(dc);
    }
  }
}
