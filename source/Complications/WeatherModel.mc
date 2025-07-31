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

    // public var _isDaytime = true; // TODO: CONSIDER: do I need to hold onto this?

    public var _currentCondition = UNKNOWN; // See WeatherIconMap
    public var _conditionIsActionable = false;

    public var _precipitationChance as Number = 0;
    public var _precipitationIsActionable = false;
    public var _humidityPercent as Number = 0;
    public var _uvIndex as Float = 0.0; // [1, 10], 0 means unknown
    public var _uvIndexIsActionable = false; // raining, high uv, ...

    public var _windDirection as Number?; // in unit circle degrees
    public var _windSpeed as Float?; // in mph

    public const DANGEROUS_UV_INDEX_LOWER_BOUND = 3;
    public const ACTIONABLE_PRECIPITATION_CHANCE = 30;

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
      _currentCondition = UNKNOWN;
      _precipitationChance = 0;
      _humidityPercent = 0;
      _uvIndex = 0.0;
      _windDirection = null;
      _windSpeed = null;
      _conditionIsActionable = false;
      _uvIndexIsActionable = false;
    }

    private function updateWeather() as Void {
      // TODO: make this calculated somehow
      var isDaytime = true;

      var currentConditions = Weather.getCurrentConditions();
      if (currentConditions == null) {
        resetWeather();
        return;
      }

      _currentTemperature = convertCelsiusToFahrenheit(
        currentConditions.feelsLikeTemperature
      );
      _high = convertCelsiusToFahrenheit(currentConditions.highTemperature);
      _low = convertCelsiusToFahrenheit(currentConditions.lowTemperature);

      // maps the condition returned in SDK to one we have an icon for
      _currentCondition = getMappedWeatherCondition(
        currentConditions.condition
      );

      _humidityPercent = currentConditions.relativeHumidity;

      _precipitationChance = currentConditions.precipitationChance;
      if (
        _precipitationChance != null &&
        _precipitationChance >= ACTIONABLE_PRECIPITATION_CHANCE
      ) {
        _precipitationIsActionable = true;
      } else { 
        _precipitationIsActionable = false;
      }

      // TODO: the UV index is 0 at night, make sure we check the time
      _uvIndex = currentConditions.uvIndex;
      if (
        _uvIndex != null &&
        _uvIndex >= DANGEROUS_UV_INDEX_LOWER_BOUND &&
        isDaytime
      ) {
        _uvIndexIsActionable = true;
      } else {
        _uvIndexIsActionable = false;
      }

      if (
        _currentCondition == THUNDERSTORM ||
        _currentCondition == HAIL ||
        _currentCondition == SMOKE
      ) {
        _conditionIsActionable = true;
      } else {
        // if the weather is not actionable on its own, set it to
        // whatever the UV index is
        _conditionIsActionable = _uvIndexIsActionable || 
          _precipitationIsActionable;
      }

      _windDirection = convertWindBearingToAngle(currentConditions.windBearing);
      _windSpeed = convertMetersPerSecondToMilesPerHour(
        currentConditions.windSpeed
      );
    }

    public function initialize() {
      resetWeather();
    }

    public function updateModel() as Void {
      updateWeather();
    }
  }
}
