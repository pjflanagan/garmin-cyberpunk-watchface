import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class HealthBarDrawable extends WatchUi.Drawable {
    private var _model as Complicated.HealthBarModel;

    private var _x as Number;
    private var _y as Number;

    private var _stepHeight = 3;
    private var _bodyBatteryHeight = 24;
    private var _gap = 2;
    private var _barWidth = 120;
    private var _slotHeight = 28;
    private var _slotWidth = 6;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
        }
    ) {
      _model = new Complicated.HealthBarModel();

      _x = params[:x];
      _y = params[:y];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawBodyBattery(dc as Dc) as Void {
      var percent = _model._currentBodyBatteryPercent;
      var percentWidth = (_barWidth * percent) / 100;

      dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(_x, _y, _barWidth, _bodyBatteryHeight);
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(_x, _y, percentWidth, _bodyBatteryHeight);
    }

    private function drawHeartRate(dc as Dc) as Void {
      // var percent = _model._heartRate;
      var heartRateZone = _model._heartRateZone;

      // there will always be 5 heart rate zones
      for (var i = 0; i < 10; i++) {
        var gap = i * 2;
        var x = _x + i * _slotWidth + gap;

        // 0 1 2 3 4 5 6 7 8 9
        // 4 4 3 3 2 2 1 1 0 0
        var slotHeartRateZone = 4 - Math.floor(i / 2);
        var color = Graphics.COLOR_DK_BLUE;
        if (slotHeartRateZone >= heartRateZone) {
          color = Graphics.COLOR_BLUE;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, _y, _slotWidth, _slotHeight);
      }
    }

    public function drawSteps(dc as Dc) as Void {

      var percent = _model._stepsPercent;
      var percentWidth = (_barWidth * percent) / 100;
      var color = Graphics.COLOR_YELLOW;
      if (percent >= 100) {
        color = Graphics.COLOR_GREEN;
      }

      dc.setPenWidth(2);
      dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.drawLine(_x, _y, _x + _barWidth, _y);
      dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
      dc.drawLine(_x, _y, _x + percentWidth, _y);
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawBodyBattery(dc);
      drawHeartRate(dc);
      drawSteps(dc);
    }
  }
}
