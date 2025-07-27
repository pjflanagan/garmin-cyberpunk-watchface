import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Position;

module Cyberpunk {
  class DateTimeModel {
    public var _displayHour as String; //[1, 12]
    public var _displayMinute as String; //[00, 59]
    public var _secondOfMinute as Number;
    public var _displaySecond as String; //[00, 59]
    public var _amOrPm as String; // "A" or "P"

    public var _month as String; // JAN
    public var _dayOfMonth as String; //[01, 31]
    public var _dayOfWeek as Number; // 0-6, 0 is Sunday

    private const MonthMap = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    ];

    public function initialize() {
      var clockTime = System.getClockTime();
      var hour = clockTime.hour;
      _amOrPm = hour < 12 ? "A" : "P";
      if (hour == 0) {
        hour = 12; // Midnight case
      } else if (hour > 12) {
        hour = hour - 12;
      }
      _displayHour = hour.format("%02d");
      _displayMinute = clockTime.min.format("%02d");
      _secondOfMinute = clockTime.sec;
      _displaySecond = _secondOfMinute.format("%02d");

      var now = Time.now();
      var info = Gregorian.info(now, Time.FORMAT_SHORT);
      _month = MonthMap[(info.month as Number) - 1];
      _dayOfMonth = info.day.format("%02d");
      _dayOfWeek = info.day_of_week - 1;
    }

    public function updateModel() as Void {
      initialize();
    }
  }
}
