import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Position;

module Cyberpunk {
  class WeatherModel {
    public var _currentTemperature as Float?;
    public var _high as Number?;
    public var _low as Number?;

    public var _currentCondition = WeatherIcon_Unknown; // See WeatherIconMap

    public var _precipitationChance as Number = 0;
    public var _humidityPercent as Number = 0;
    public var _uvIndex as Float = 0.0; // [1, 10], 0 means unknown

    public var _windDirection as Number?; // in unit circle degrees
    public var _windSpeed as Float?; // in mph

    public var _weatherIsActionable = false; // raining, high uv, ...

    // Cardinal = windBearing > windDirection
    // North = 0 > 90
    // East  = 90 > 0
    // South = 180 > 270
    // West  = 270 > 180
    private function convertWindBearingToAngle(
      windBearing as Number
    ) as Number {
      return normalizeDegrees(-1 * windBearing + 90);
    }

    private function resetWeather() {
        _currentTemperature = null;
        _high = null;
        _low = null;
        _currentCondition = WeatherIcon_Unknown;
        _precipitationChance = 0;
        _humidityPercent = 0;
        _uvIndex = 0.0;
        _windDirection = null;
        _windSpeed = null;
        _weatherIsActionable = false;

    }

    private function updateWeather() as Void {
      var currentConditions = Weather.getCurrentConditions();
      if (currentConditions == null) {
        resetWeather();
        return;
      }

      _currentTemperature = convertCelsiusToFahrenheit(currentConditions.feelsLikeTemperature);
      _high = convertCelsiusToFahrenheit(currentConditions.highTemperature);
      _low = convertCelsiusToFahrenheit(currentConditions.lowTemperature);

      // TODO: this needs to know if it is day or night
      _currentCondition = getConditionIcon(currentConditions.condition, true);

      _precipitationChance = currentConditions.precipitationChance;
      _humidityPercent = currentConditions.relativeHumidity;
      _uvIndex = currentConditions.uvIndex;

      _windDirection = convertWindBearingToAngle(currentConditions.windBearing); 
      _windSpeed = convertMetersPerSecondToMilesPerHour(currentConditions.windSpeed);

      if (_precipitationChance != null && _precipitationChance >= 40) {
        _weatherIsActionable = true;
      } else if (
        _currentCondition == WeatherIcon_Thunderstorm ||
        _currentCondition == WeatherIcon_Hail ||
        _currentCondition == WeatherIcon_Smoke
      ) {
        _weatherIsActionable = true;
      } else if (_uvIndex != null && _uvIndex >= 3) {
        _weatherIsActionable = true;
      } else {
        _weatherIsActionable = false;
      }
    }

    public function initialize() {
      resetWeather();
    }

    public function updateModel() as Void {
      updateWeather();
    }
  }
}
