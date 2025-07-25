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
    private const _segmentWidth = 4;
    private const _currentHourSegmentWidth = 8;

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
      var percentOfHour = _model._minuteOfHour / 60.0;

      dc.setPenWidth(_segmentWidth * 2); // half ends up off the display, so multiply by 2
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
      } else if (hour == _model._hourOfDay) {
        dc.setPenWidth(_currentHourSegmentWidth * 2); // use the current hour segment width, again multiply by 2
        var angleDiff = (endAngle - startAngle) * percentOfHour;

        dc.setColor(Complicated.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          endAngle
        );
        // do not display if the angle is a positive number, it will draw backward
        if (angleDiff < -0.01) {
          var minuteEndAngle = startAngle + angleDiff;
          dc.setColor(Complicated.BLUE, Graphics.COLOR_TRANSPARENT);
          dc.drawArc(
            _x,
            _y,
            _radius,
            Graphics.ARC_CLOCKWISE,
            startAngle,
            minuteEndAngle
          );
        }
      } else {
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

    // NOTE: if we ever remove the current hour segment being a different color or width,
    // then we can simplify this by just drawing one dark ring as a base
    // one light red ring on top of it that represents the % of the day
    // then draw a bunch of little black dividers
    private function drawRing(dc as Dc) as Void {
      for (var hour = 0; hour <= 23; hour++) {
        drawRingSegment(dc, hour);
      }
    }

    private function drawSunriseMarker(dc as Dc) as Void {
      if (_model._sunriseHour != null && _model._sunriseMinute != null) {
        var angle = getHourAngle(_model._sunriseHour);
        var x = _x + Math.cos((angle * Math.PI) / 180) * _radius;
        var y = _y + Math.sin((angle * Math.PI) / 180) * _radius;

        dc.setColor(Complicated.YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, 6);
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawRing(dc);
      drawSunriseMarker(dc);
    }
  }
}
