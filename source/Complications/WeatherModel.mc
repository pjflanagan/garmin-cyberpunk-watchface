import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Position;

module Complicated {
  class WeatherModel {
    public var _high as Number?;
    public var _low as Number?;
    public var _currentTemperature as Float?;
    public var _currentConditions as Number?; // CONDITION_CLEAR, CONDITION_PARTLY_CLOUDY...

    // CONSIDER: cycle through windSpeed/windBearing, uvIndex, relativeHumidity, and precipitationChance
    public var _precipitationChance as Number?;

    private function convertCelsiusToFahrenheit(
      celsius as Number or Float
    ) as Number or Float {
      return (celsius * 9) / 5 + 32;
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
    }

    public function initialize() {
      updateWeather();
    }

    public function updateModel() as Void {
      updateWeather();
    }
  }
}
