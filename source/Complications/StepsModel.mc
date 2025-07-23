import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

module Complicated {
  class StepsModel {
    public var _percent as Number;

    public function initialize() {
      _percent = 0;
    }

    public function updateModel() as Void {
      var info = ActivityMonitor.getInfo();
      var goalPercent =
        ((info.steps.toFloat() / info.stepGoal.toFloat()) * 100) as Number;
      _percent = min(goalPercent, 100);
    }
  }
}
