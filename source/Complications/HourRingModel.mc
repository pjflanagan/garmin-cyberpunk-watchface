import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;

module Complicated {
  class HourRingModel {
    public var _hourOfDay as Number; //[0, 23]
    public var _percentOfHour as Float;

    public function initialize() {
        var clockTime = System.getClockTime();
        _hourOfDay = clockTime.hour;
        _percentOfHour = clockTime.min / 60.0;
    }
    
    public function updateModel() as Void {
        var clockTime = System.getClockTime();
        _hourOfDay = clockTime.hour;
        _percentOfHour = clockTime.min / 60.0;
    }
  }
}
