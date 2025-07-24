import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class HourRingDrawable extends WatchUi.Drawable {
    private var _model as Complicated.HourRingModel;

    // _x and _y should be set to the center of the watch
    private var _x as Number;
    private var _y as Number;
    private var _radius as Number;

    private const _gapDegrees = 2;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Complicated.HourRingModel();
      _y = params[:y];
      _x = params[:x];
      _radius = params[:radius];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function getHourAngle(hour as Number) as Number {
      var degrees = (hour * -90) / 6 + 270;
      if (degrees < 0) {
        return degrees + 360;
      }
      return degrees;
    }

    private function drawRingSegment(dc as Dc, hour as Number) as Void {
      var startAngle = getHourAngle(hour) - _gapDegrees / 2;
      var endAngle = getHourAngle(hour + 1) + _gapDegrees / 2;

      dc.setPenWidth(6);
      if (hour < _model._hourOfDay) {
        dc.setColor(Complicated.RED, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          endAngle
        );
      } 
      else if (hour == _model._hourOfDay) {
        var angleDiff = (endAngle - startAngle) * _model._percentOfHour;
        dc.setColor(Complicated.RED, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          startAngle + angleDiff
        );
        dc.setColor(Complicated.DARK_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle + angleDiff,
          endAngle
        );
      } 
      else {
        dc.setColor(Complicated.DARK_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          endAngle
        );
      }
    }

    private function drawRing(dc as Dc) as Void {
      for (var hour = 0; hour <= 23; hour++) {
        drawRingSegment(dc, hour);
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawRing(dc);
    }
  }
}
