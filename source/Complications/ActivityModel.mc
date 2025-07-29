import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;
import Toybox.UserProfile;

module Cyberpunk {
  class ActivityModel {
    // using the cyberpunk nomenclature to make it clear what is going on
    public var _isComplete as Boolean;
    public var _displayStoryline as String;
    public var _displayMission as String;
    public var _displayMissionDetail as String?;

    public var _trainingStatusComplicationId as Complications.Id?;

    public function initialize() {
      _isComplete = false;
      _displayStoryline = "-";
      _displayMission = "-";

      // COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE
      _trainingStatusComplicationId = new Complications.Id(
        Complications.COMPLICATION_TYPE_TRAINING_STATUS
      );
      Complications.registerComplicationChangeCallback(
        self.method(:onComplicationChanged)
      );
      Complications.subscribeToUpdates(_trainingStatusComplicationId);
    }

    public function onComplicationChanged(id as Complications.Id) as Void {
      if (id.equals(_trainingStatusComplicationId)) {
        var trainingStatus = Complications.getComplication(id).value;
        if (trainingStatus != null) {
          _displayStoryline = trainingStatus.toUpper();
        } else {
          _displayStoryline = "TRAINING";
        }
      }
    }

    public function updateModel() as Void {
      var userActivity = UserProfile.getUserActivityHistory();
      var lastActivity = userActivity.next();

      var lastActivityStartTime = lastActivity.startTime;
      _displayMission = getSportName(lastActivity.type).toUpper();
      if (lastActivityStartTime.greaterThan(Time.today())) {
        _isComplete = true;
        var miles = convertMetersToMiles(lastActivity.distance);
        _displayMission = _displayMission + " " + miles.format("0.1f");
        var milePace = calculateMilePace(lastActivity.distance, lastActivity.duration);
        _displayMissionDetail = convertSecondsToTimeString(milePace as Number);
      } else {
        _isComplete = false;
        _displayMissionDetail = null;
      }
    }
  }
}
