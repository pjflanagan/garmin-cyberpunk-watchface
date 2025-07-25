import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Position;

module Complicated {
  class DateTimeModel {
    public var _hour as String; //[1, 12]
    public var _minuteOfHour as String; //[00, 59]
    public var _secondOfMinute as String; //[00, 59]
    public var _amOrPm as String; // "AM" or "PM"

    public var _month as String; // JAN
    public var _dayOfMonth as String; //[01, 31]

    public function initialize() {
      var clockTime = System.getClockTime();
      var hour = clockTime.hour;
      _amOrPm = hour < 12 ? "AM" : "PM";
      if (hour > 12) {
        hour = hour - 12;
      }
      _hour = hour.format("%02d");
      _minuteOfHour = clockTime.min.format("%02d");
      _secondOfMinute = clockTime.sec.format("%02d");

      var now = Time.now();
      var info = Gregorian.info(now, Time.FORMAT_MEDIUM);
      _month = info.month.toUpper();
      _dayOfMonth = info.day.format("%02d");
    }

    public function updateModel() as Void {
      initialize();
    }
  }
}
