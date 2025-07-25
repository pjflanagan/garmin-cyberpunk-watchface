import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class DateTimeDrawable extends WatchUi.Drawable {
    private var _model as Complicated.DateTimeModel;

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
      _model = new Complicated.DateTimeModel();
      _y = params[:y];
      _x = params[:x];

      _dateCenter = _x + 60;
      _timeCenter = _x - 90;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    public function drawDate(dc as Dc) as Void {
      dc.setColor(Complicated.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter,
        _y,
        Graphics.FONT_SYSTEM_SMALL,
        _model._month,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Complicated.WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _dateCenter + 2,
        _y,
        Graphics.FONT_SYSTEM_SMALL,
        _model._dayOfMonth,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function drawTime(dc as Dc) as Void {
      dc.setColor(Complicated.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter,
        _y,
        Graphics.FONT_SYSTEM_MEDIUM,
        _model._hour,
        Graphics.TEXT_JUSTIFY_RIGHT
      );
      dc.setColor(Complicated.DARK_BLUE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _timeCenter + 2,
        _y,
        Graphics.FONT_SYSTEM_MEDIUM,
        _model._minuteOfHour,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawDate(dc);
    }
  }
}
