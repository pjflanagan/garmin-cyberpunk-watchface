import Toybox.Application;
import Toybox.SensorHistory;
import Toybox.Lang;
import Toybox.System;
import Toybox.Complications;

module Complicated {
  class ActivityModel {
    public var _isComplete as Boolean;
    public var _eventName as String?;
    public var _activityName as String?;

    public var _trainingStatusComplicationId as Complications.Id?;

    public function initialize() {
      _isComplete = false;

      _trainingStatusComplicationId = new Complications.Id(
        Complications.COMPLICATION_TYPE_TRAINING_STATUS
      );
      Complications.getComplication(_trainingStatusComplicationId);
      Complications.registerComplicationChangeCallback(
        self.method(:onComplicationChanged)
      );
      Complications.subscribeToUpdates(_trainingStatusComplicationId);
    }

    public function onComplicationChanged(id as Complications.Id) as Void {
      if (id.equals(_trainingStatusComplicationId)) {
        _activityName = Complications.getComplication(id).value;
      }
    }

    public function updateModel() as Void {}
  }
}
