import Toybox.Application;
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.UserProfile;
import Toybox.Activity;

module Complicated {

  // TODO: this should be one single model called HealthBarModel
  class HeartRateModel {
    public var _heartRate as Number or Null;
    public var _heartRateZone as Number;

    public function initialize() {
      _heartRate = 0;
      _heartRateZone = 2;
    }

    private function updateHeartRate() as Void {
      var activityInfo = Activity.getActivityInfo();
      if (activityInfo == null) {
        _heartRate = null;
        _heartRateZone = 2;
        return;
      }
      _heartRate = activityInfo.currentHeartRate;

      // var heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);

      // var currentZone = 0;
      // var heartRateZone = 0;
      // while (currentZone < heartRateZones.size() && _heartRate > heartRateZones[currentZone]) {
      //   heartRateZone = currentZone;
      //   currentZone += 1;
      // }
      // _heartRateZone = heartRateZone;

    }

    public function updateModel() as Void {
      updateHeartRate();
    }
  }
}
