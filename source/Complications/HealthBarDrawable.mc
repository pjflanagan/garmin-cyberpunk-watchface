import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class HealthBarDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.HealthBarModel;

    // _x is the left most point
    private var _x as Number;
    private var _y as Number;

    private var _stepHeight = 3;
    private var _bodyBatteryHeight = 3 * 3;
    private var _barWidth = 120;

    private var _slotHeight = 3 * 4;
    private var _slotWidth = 4;

    private var _heartRateWidth =
      _stepHeight + _bodyBatteryHeight + _slotHeight;
    private var _heartRateStrokeWidth = 1;

    private var _stepsLabelWidth = 16;
    private var _bodyBatteryLabelsWidth = 16;

    private var _gap = 2;

    private var _fullWidth =
      _stepsLabelWidth +
      _heartRateWidth +
      _barWidth +
      2 * _bodyBatteryLabelsWidth +
      4 * _gap;
    private var _opticalCentering = 8;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
        }
    ) {
      _model = new Cyberpunk.HealthBarModel();

      var centerX = params[:x];
      _y = params[:y];
      _x = centerX - _fullWidth / 2 + _opticalCentering;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawStepsLabel(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth - _gap;

      var color = YELLOW;
      if (_model._stepsPercent >= 100) {
        color = GREEN;
      }

      var displayText = _model._stepCount.format("%d");
      if (_model._stepCount > 1000) {
        displayText = (_model._stepCount / 1000.0).format("%.1f") + "K";
      }

      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y + _heartRateWidth / 2 - 10,
        Graphics.FONT_SYSTEM_XTINY,
        displayText,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
    }

    private function drawSteps(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth + _heartRateWidth + 2 * _gap;

      var percent = _model._stepsPercent;
      var percentWidth = (_barWidth * percent) / 100;
      var color = YELLOW;
      if (percent >= 100) {
        color = GREEN;
      }

      dc.setColor(DARK_YELLOW, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, _barWidth, _stepHeight);
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, percentWidth, _stepHeight);
    }

    private function drawBodyBattery(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth + _heartRateWidth + 2 * _gap;
      var Y = _y + _stepHeight + _gap;

      var percent = _model._currentBodyBatteryValue;
      var percentWidth = (_barWidth * percent) / 100;

      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon([
        [X, Y],
        [X, Y + _bodyBatteryHeight],
        [X + _barWidth - 3, Y + _bodyBatteryHeight],
        [X + _barWidth, Y + _bodyBatteryHeight - 3],
        [X + _barWidth, Y],
      ]);
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon([
        [X, Y],
        [X, Y + _bodyBatteryHeight],
        [X + percentWidth - 3, Y + _bodyBatteryHeight],
        [X + percentWidth, Y + _bodyBatteryHeight - 3],
        [X + percentWidth, Y],
      ]);
    }

    private function drawBodyBatteryLabel(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth + _heartRateWidth + _barWidth + 3 * _gap;

      var bodyBattery = "-";
      if (_model._currentBodyBatteryValue != null) {
        bodyBattery = _model._currentBodyBatteryValue.format("%d");
      }
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y,
        Graphics.FONT_SYSTEM_XTINY,
        bodyBattery,
        Graphics.TEXT_JUSTIFY_LEFT
      );

      var maxBodyBattery = "-";
      if (_model._maxBodyBatteryValue != null) {
        maxBodyBattery = _model._maxBodyBatteryValue.format("%d");
      }
      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X + _gap + _bodyBatteryLabelsWidth,
        _y,
        Graphics.FONT_SYSTEM_XTINY,
        maxBodyBattery,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    private function drawHeartRateSlots(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth + _heartRateWidth + 2 * _gap;
      var Y = _y + _stepHeight + _gap + _bodyBatteryHeight + _gap;

      // var percent = _model._heartRate;
      var heartRateZone = _model._heartRateZone;

      // there will always be 5 heart rate zones
      for (var i = 0; i < 10; i++) {
        var gap = i * 2;
        var slotX = X + i * _slotWidth + gap;

        // 0 1 2 3 4 5 6 7 8 9
        // 4 4 3 3 2 2 1 1 0 0
        var slotHeartRateZone = 4 - Math.floor(i / 2);
        var color = DARK_BLUE;
        if (slotHeartRateZone >= heartRateZone) {
          color = BLUE;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(slotX, Y, _slotWidth, _slotHeight);
      }
    }

    private function drawHeartRate(dc as Dc) as Void {
      var X = _x + _stepsLabelWidth + _gap;

      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, _heartRateWidth, _heartRateWidth);
      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_heartRateStrokeWidth);
      dc.drawRectangle(X, _y, _heartRateWidth, _heartRateWidth);

      var heartRate = "-";
      if (_model._heartRate != null) {
        heartRate = _model._heartRate.format("%d");
      }
      dc.drawText(
        X + _heartRateWidth / 2,
        _y + _heartRateWidth / 2 - 10,
        Graphics.FONT_SYSTEM_XTINY,
        heartRate,
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(
        dc,
        _x + _stepsLabelWidth + _gap,
        _y - 2 * _gap,
        [12, 18]
      );
      drawStepsLabel(dc);
      drawHeartRate(dc);
      drawSteps(dc);
      drawBodyBattery(dc);
      drawBodyBatteryLabel(dc);
      drawHeartRateSlots(dc);
    }
  }
}
