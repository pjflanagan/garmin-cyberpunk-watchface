import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;

module Cyberpunk {
  class HealthBarModel {
    private var _lookupTime as Time.Duration;

    public var _maxBodyBatteryValue as Number?;
    public var _currentBodyBatteryValue as Number?;

    public var _heartRate as Number?;
    public var _heartRateZone as Number;

    public var _displayStepCount as String;
    public var _stepsPercent as Number;

    public function initialize() {
      _lookupTime = new Time.Duration(24 * 60 * 60);

      _displayStepCount = "0";
      _heartRateZone = 0;
      _stepsPercent = 0;
    }

    public function updateSteps() as Void {
      var info = ActivityMonitor.getInfo();
      var stepCount = info.steps;
      var goalPercent =
        ((stepCount.toFloat() / info.stepGoal.toFloat()) * 100.0);
      _stepsPercent = min(goalPercent as Number, 100);


      _displayStepCount = stepCount.format("%d");
      if (stepCount > 1000) {
        // TODO: this is rounding up. 4951 becomes 5.0K (and I don't like that)
        // I need to % by 100 first.
        _displayStepCount = (stepCount / 1000.0).format("%.1f") + "K";
      }
    }

    private function updateBodyBattery() as Void {
      var lookupData = {
        :period => _lookupTime,
      };
      var bodyBattery = SensorHistory.getBodyBatteryHistory(lookupData);

      var latestSample = bodyBattery.next();
      if (latestSample != null) {
        _maxBodyBatteryValue = bodyBattery.getMax() as Number;
        _currentBodyBatteryValue = latestSample.data as Number;
      }
    }

    private function updateHeartRate() as Void {
      var activityInfo = Activity.getActivityInfo();
      if (activityInfo == null) {
        return;
      }
      _heartRate = activityInfo.currentHeartRate;

      if (_heartRate == null) {
        return;
      }

      var heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);

      var currentHeartRateZone = 0;
      for (var i = 0 ; i < heartRateZones.size(); i++) {
        if (_heartRate < heartRateZones[i]) {
          break;
        }
        currentHeartRateZone = i;
      }
      _heartRateZone = currentHeartRateZone;
    }

    public function updateModel() as Void {
      updateBodyBattery();
      updateHeartRate();
      updateSteps();
    }
  }
}
