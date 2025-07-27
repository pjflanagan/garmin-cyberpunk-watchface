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

    public var _stepCount as Number;
    public var _stepsPercent as Number;

    public function initialize() {
      _lookupTime = new Time.Duration(24 * 60 * 60);
      
      _stepCount = 0;
      _heartRateZone = 0;
      _stepsPercent = 0;
    }

    public function updateSteps() as Void {
      var info = ActivityMonitor.getInfo();
      _stepCount = info.steps;
      var goalPercent =
        ((_stepCount.toFloat() / info.stepGoal.toFloat()) * 100) as Number;
      _stepsPercent = min(goalPercent, 100);
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
