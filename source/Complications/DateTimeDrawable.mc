import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class DateTimeDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.DateTimeModel;

    private var _x as Number;
    private var _y as Number;

    private var _dateCenter as Number;
    private var _timeCenter as Number;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Cyberpunk.DateTimeModel();
      _y = params[:y];
      _x = params[:x];

      _dateCenter = _x + 48;
      _timeCenter = _x - 56;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    public function drawDate(dc as Dc) as Void {
      var Y = _y + 17;

      dc.setColor(Cyberpunk.BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter,
        Y,
        Graphics.FONT_SYSTEM_SMALL,
        _model._month,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Cyberpunk.WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter + 4,
        Y,
        Graphics.FONT_SYSTEM_SMALL,
        _model._dayOfMonth,
        Graphics.TEXT_JUSTIFY_LEFT
      );
      for (var day = 0; day < 7; day++) {
        var barColor = Cyberpunk.DARK_RED;
        var addedHeight = 0;
        if (day == _model._dayOfWeek) {
          barColor = Cyberpunk.BLUE;
          addedHeight = 1;
        }
        dc.setColor(barColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(
          _dateCenter - 40 + (day * 10) + 3,
          Y - addedHeight,
          8,
          3 + addedHeight
        );
      }
    }

    public function drawTime(dc as Dc) as Void {
      dc.setColor(Cyberpunk.BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter - 2,
        _y,
        Graphics.FONT_SYSTEM_NUMBER_MEDIUM,
        _model._displayHour,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Cyberpunk.WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter + 1,
        _y,
        Graphics.FONT_SYSTEM_NUMBER_MEDIUM,
        _model._displayMinute,
        Graphics.TEXT_JUSTIFY_LEFT
      );
      dc.setColor(Cyberpunk.DARK_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter + 46,
        _y + 8,
        Graphics.FONT_SYSTEM_XTINY,
        _model._amOrPm,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(dc, _timeCenter - 34, _y + 4, [8, 6, 8]);
      drawDate(dc);
      drawTime(dc);
    }
  }
}
