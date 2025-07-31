import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class HourRingDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.HourRingModel;

    // _x and _y should be set to the center of the watch
    private var _x as Number;
    private var _y as Number;
    private var _radius as Number;

    // NOTE: half of this goes off screen, do double the visible width
    private const _segmentWidthSecond = 2;
    private const _segmentWidthHour = 10;
    private const _segmentWidthCurrentHour = 16;
    private const _segmentWidthSunTime = 20; // sunrise/sunset

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Cyberpunk.HourRingModel();
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

    private function getSecondOfMinuteAngle(seconds as Number) as Number {
      var degrees = (seconds * -90) / 15 + 270;
      return normalizeDegrees(degrees);
    }

    private function getSecondOfDayAngle(seconds as Number) as Number {
      var degrees = (seconds * -90) / (6 * 3600) + 270;
      return normalizeDegrees(degrees);
    }

    private function getHourMinuteAngle(
      hour as Number,
      minutes as Number
    ) as Number {
      return getSecondOfDayAngle(hour * 3600 + minutes * 60) as Number;
    }

    private function getHourAngle(hour as Number) as Number {
      return getSecondOfDayAngle(hour * 3600) as Number;
    }

    public function drawHourDividers(dc as Dc) as Void {
      dc.setColor(Cyberpunk.BACKGROUND, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_segmentWidthCurrentHour + 2); // wider to ensure we block everything
      for (var hour = 0; hour < 24; hour++) {
        var angle = getHourAngle(hour);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          angle + 1,
          angle - 1
        );
      }
    }

    private function drawSunriseAndSunsetMarkers(dc as Dc) as Void {
        dc.setColor(Cyberpunk.YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidthSunTime);
      if (_model._sunriseSeconds != null) {
        var sunriseAngle = getSecondOfDayAngle(_model._sunriseSeconds);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          sunriseAngle + 1,
          sunriseAngle - 1
        );
      }
      if (_model._sunsetSeconds != null) {
        var sunsetAngle = getSecondOfDayAngle(_model._sunsetSeconds);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          sunsetAngle + 0.5,
          sunsetAngle - 0.5
        );
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();

      // dark red ring
      dc.setColor(Cyberpunk.DARK_RED, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_segmentWidthHour);
      dc.drawArc(_x, _y, _radius, Graphics.ARC_CLOCKWISE, 0, 360);

      // dark blue hour ring
      var nextHourAngle = getHourAngle(_model._hourOfDay + 1);
      var currentHourAngle = getHourAngle(_model._hourOfDay);
      dc.setColor(Cyberpunk.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_segmentWidthCurrentHour);
      dc.drawArc(
        _x,
        _y,
        _radius,
        Graphics.ARC_CLOCKWISE,
        currentHourAngle,
        nextHourAngle
      );

      // blue minute ring
      var minuteAngle = getHourMinuteAngle(
        _model._hourOfDay,
        _model._minuteOfHour
      );
      // don't draw if minute angle is too small, it will draw backward
      if (abs(minuteAngle - currentHourAngle) > 1) {
        dc.setColor(Cyberpunk.BLUE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_segmentWidthCurrentHour);
        dc.drawArc(
          _x,
          _y,
          _radius,
          Graphics.ARC_CLOCKWISE,
          currentHourAngle,
          minuteAngle
        );
      }

      // second ring
      var secondAngle = getSecondOfMinuteAngle(_model._secondOfMinute);
      dc.setColor(Cyberpunk.RED, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(_segmentWidthSecond);
      dc.drawArc(_x, _y, _radius, Graphics.ARC_CLOCKWISE, 270, secondAngle);

      // last we draw the hour dividers
      drawHourDividers(dc);

      // draw sunrise and sunset markers
      drawSunriseAndSunsetMarkers(dc);
    }
  }
}
