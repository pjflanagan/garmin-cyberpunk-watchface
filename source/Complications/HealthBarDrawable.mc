import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class HealthBarDrawable extends WatchUi.Drawable {
    private var _model as Complicated.HealthBarModel;

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

    private var _iconWidth = 8;
    private var _textWidth = 12;

    private var _gap = 2;

    private var _fullWidth =
      _iconWidth + _heartRateWidth + _barWidth + 2 * _textWidth + 4 * _gap;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
        }
    ) {
      _model = new Complicated.HealthBarModel();

      var centerX = params[:x];
      _y = params[:y];
      _x = centerX - _fullWidth / 2;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawLabel(dc as Dc) as Void {
      // TODO: make all of these X and Y values properties and set them in the initialize function
      var X = _x + _iconWidth + _gap;
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        X,
        _y - 10,
        Graphics.FONT_AUX1,
        "Health Indication",
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    private function drawSteps(dc as Dc) as Void {
      var X = _x + _iconWidth + _heartRateWidth + 2 * _gap;

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
      var X = _x + _iconWidth + _heartRateWidth + 2 * _gap;
      var Y = _y + _stepHeight + _gap;

      var percent = _model._currentBodyBatteryPercent;
      var percentWidth = (_barWidth * percent) / 100;

      dc.setColor(DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, Y, _barWidth, _bodyBatteryHeight);
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, Y, percentWidth, _bodyBatteryHeight);
    }

    private function drawHeartRateSlots(dc as Dc) as Void {
      var X = _x + _iconWidth + _heartRateWidth + 2 * _gap;
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
      var X = _x + _iconWidth + _gap;

      dc.setColor(DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(X, _y, _heartRateWidth, _heartRateWidth);
      dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_heartRateStrokeWidth);
      dc.drawRectangle(X, _y, _heartRateWidth, _heartRateWidth);

      var heartRate = _model._heartRate;
      if (heartRate != null) {
        dc.setColor(BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
          X + _heartRateWidth / 2,
          _y + _heartRateWidth / 2,
          Graphics.FONT_MEDIUM,
          heartRate,
          Graphics.TEXT_JUSTIFY_CENTER
        );
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawLabel(dc);
      drawHeartRate(dc);
      drawSteps(dc);
      drawBodyBattery(dc);
      drawHeartRateSlots(dc);
    }
  }
}
