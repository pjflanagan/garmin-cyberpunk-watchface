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

      _dateCenter = _x + 40;
      _timeCenter = _x - 52;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    public function drawDate(dc as Dc) as Void {
      dc.setColor(Cyberpunk.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter,
        _y + 7,
        Graphics.FONT_SYSTEM_SMALL,
        _model._month,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Cyberpunk.WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter + 4,
        _y + 7,
        Graphics.FONT_SYSTEM_SMALL,
        _model._dayOfMonth,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function drawTime(dc as Dc) as Void {
      dc.setColor(Cyberpunk.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter - 5,
        _y,
        Graphics.FONT_SYSTEM_LARGE,
        _model._displayHour,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      // to make the colon blink, we only show it on even seconds
      var colonColor = Cyberpunk.DARK_BLUE;
      if (_model._secondOfMinute % 2 == 0) {
        colonColor = Cyberpunk.DARK_WHITE;
      }
      dc.setColor(colonColor, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter,
        _y + 6,
        Graphics.FONT_SYSTEM_SMALL,
        ":",
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Cyberpunk.WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter + 3,
        _y,
        Graphics.FONT_SYSTEM_LARGE,
        _model._displayMinute,
        Graphics.TEXT_JUSTIFY_LEFT
      );
      dc.setColor(Cyberpunk.DARK_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter + 38,
        _y + 16,
        Graphics.FONT_SYSTEM_XTINY,
        _model._amOrPm,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawDate(dc);
      drawTime(dc);
    }
  }
}
