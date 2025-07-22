import Toybox.Application;
import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

module Complicated {
    class StepsModel {
        public function initialize() {
        }

        public function updateModel() as Complicated.Model {
            var info = ActivityMonitor.getInfo();
            var stepsPercent = (info.steps.toFloat() / info.stepGoal.toFloat()) * 100;
            return new PercentModel(stepsPercent as Number);
        }
    }
}