import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;

module Complicated {
    class BodyBatteryModel {
        private var _lookupTime as Time.Duration;
        public var _maxValue as Number;
        public var _currentValue as Number;
        public var _percent as Number;

        public function initialize() {
            _lookupTime = new Time.Duration(24 * 60 * 60);
            _maxValue = 0;
            _currentValue = 0;
            _percent = 0;
        }

        public function updateModel() as Void {
            // var lookupData = {
            //     :period => _lookupTime
            // };
            // var bodyBattery = SensorHistory.getBodyBatteryHistory(lookupData);

            // var latestSample = bodyBattery.next();
            // if (latestSample != null) {
            //     _maxValue = bodyBattery.getMax() as Number;
            //     _currentValue = latestSample.data as Number;
            //     _percent = _currentValue / 100 as Number;
            // }
        }
    }
}