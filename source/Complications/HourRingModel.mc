import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Position;

module Complicated {
  class HourRingModel {
    public var _hourOfDay as Number; //[0, 23]
    public var _minuteOfHour as Number; //[0, 59]

    public var _sunriseHour as Number?;
    public var _sunriseMinute as Number?;

    public var _sunsetHour as Number?;
    public var _sunsetMinute as Number?;

    private function updateSunTimes() as Void {
      var position = Position.getInfo().position;
      var now = Time.now();

      var sunriseMoment = Weather.getSunrise(position, now);
      if (sunriseMoment != null) {
        var sunriseTime = Gregorian.info(sunriseMoment, Time.FORMAT_SHORT);
        _sunriseHour = sunriseTime.hour;
        _sunriseMinute = sunriseTime.min;
      }

      var sunsetMoment = Weather.getSunset(position, now);
      if (sunsetMoment != null) {
        var sunsetTime = Gregorian.info(sunsetMoment, Time.FORMAT_SHORT);
        _sunsetHour = sunsetTime.hour;
        _sunsetMinute = sunsetTime.min;
      }
    }

    public function initialize() {
      var clockTime = System.getClockTime();
      _hourOfDay = clockTime.hour;
      _minuteOfHour = clockTime.min;

      updateSunTimes();
    }

    public function updateModel() as Void {
      var clockTime = System.getClockTime();
      _hourOfDay = clockTime.hour;
      _minuteOfHour = clockTime.min;

      updateSunTimes();
    }
  }
}
