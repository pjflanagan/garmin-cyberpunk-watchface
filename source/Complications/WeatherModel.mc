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
    public var _high as Number?;
    public var _low as Number?;
    public var _currentTemperature as Float?;
    public var _currentConditions as Number?; // CONDITION_CLEAR, CONDITION_PARTLY_CLOUDY...

    // CONSIDER: cycle through windSpeed/windBearing, uvIndex, relativeHumidity, and precipitationChance
    public var _precipitationChance as Number?;
    // TODO: have to do wind speed and direction, (SEE screenshot near map where there is a compass)
    public var _windDirection as Number?;
    public var _windSpeed as Float?;

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

    private function updateWeather() as Void {
      var currentConditions = Weather.getCurrentConditions();
      if (currentConditions == null) {
        return;
      }

      _high = convertCelsiusToFahrenheit(currentConditions.highTemperature);
      _low = convertCelsiusToFahrenheit(currentConditions.lowTemperature);
      _currentTemperature = convertCelsiusToFahrenheit(currentConditions.feelsLikeTemperature);
      _currentConditions = currentConditions.condition;
      _precipitationChance = currentConditions.precipitationChance;

      _windDirection = convertWindBearingToAngle(currentConditions.windBearing); 
      _windSpeed = convertMetersPerSecondToMilesPerHour(currentConditions.windSpeed);
    }

    public function initialize() {
      updateWeather();
    }

    public function updateModel() as Void {
      updateWeather();
    }
  }
}
