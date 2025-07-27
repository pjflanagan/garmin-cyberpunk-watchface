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
    private const _segmentWidth = 3;
    private const _segmentFullWidth = 6;

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

    private function getSecondsAngle(seconds as Number) as Number {
      var degrees = (seconds * -90) / (6 * 3600) + 270;
      if (degrees < 0) {
        return degrees + 360;
      }
      return degrees;
    }

    private function getHourAngle(hour as Number) as Number {
      return getSecondsAngle(hour * 3600) as Number;
    }

    // NOTE: this is a bad way of doing this, change this to just use the seconds math
    private function getMinuteAngle(
      hourStartAngle as Number,
      hourEndAngle as Number,
      minute as Number
    ) as Number {
      var percentOfHour = minute / 60.0;
      if (percentOfHour == 0) {
        return hourStartAngle;
      }

      if (hourStartAngle < 0) {
        hourStartAngle = hourStartAngle + 360;
      }

      var segmentDegrees = Complicated.abs(hourStartAngle - hourEndAngle);
      var minuteDegrees = segmentDegrees * percentOfHour;
      return (hourStartAngle - minuteDegrees) as Number;
    }

    private function drawRingSegment(dc as Dc, hour as Number) as Void {
      var startAngle = getHourAngle(hour) - _gapDegrees / 2;
      var endAngle = getHourAngle(hour + 1) + _gapDegrees / 2;

      // draw a thick line for every hour of the day
      dc.setPenWidth(_segmentFullWidth * 2); // use the current hour segment width, again multiply by 2
      dc.setColor(Complicated.DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.drawArc(_x, _y, _radius, Graphics.ARC_CLOCKWISE, startAngle, endAngle);

      // draw a past hour with a thin red line
      if (hour < _model._hourOfDay) {
        dc.setColor(Complicated.RED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidth * 2); // half ends up off the display, so multiply by 2
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          endAngle
        );
        return;
      }

      // draw the current hour in blue
      if (hour == _model._hourOfDay) {
        dc.setColor(Complicated.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentFullWidth * 2); // use the current hour segment width, again multiply by 2
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          endAngle
        );

        var minuteEndAngle = getMinuteAngle(
          startAngle,
          endAngle,
          _model._minuteOfHour
        );
        if (minuteEndAngle == startAngle) {
          // no minutes to draw, just return
          return;
        }

        dc.setColor(Complicated.BLUE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidth * 2); // half ends up off the display, so multiply by 2
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          startAngle,
          minuteEndAngle
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
      if (_model._sunriseSeconds != null) {
        var sunriseAngle = getSecondsAngle(_model._sunriseSeconds);
        dc.setColor(Complicated.YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidth * 2);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          sunriseAngle + 1,
          sunriseAngle - 1
        );
      }
    }

    private function drawSunsetMarker(dc as Dc) as Void {
      if (_model._sunsetSeconds != null) {
        var sunsetAngle = getSecondsAngle(_model._sunsetSeconds);
        dc.setColor(Complicated.YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidth * 2);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          sunsetAngle + 1,
          sunsetAngle - 1
        );
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawRing(dc);
      drawSunriseMarker(dc);
      drawSunsetMarker(dc);
    }
  }
}
