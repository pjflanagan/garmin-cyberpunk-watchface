import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Cyberpunk {
  class ActivityDrawable extends WatchUi.Drawable {
    private var _model as Cyberpunk.ActivityModel;

    private var _x as Number;
    private var _y as Number;
    private var _offsetX = -64;
    private var _missionOffsetX = 28;

    private var _iconWidth = _missionOffsetX - 2;
    private var _iconHeight = 16;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Cyberpunk.ActivityModel();
      _y = params[:y];
      _x = params[:x] + _offsetX;

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawStoryline(dc as Graphics.Dc) as Void {
      dc.setColor(RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _x,
        _y,
        Graphics.FONT_SYSTEM_XTINY,
        _model._displayStoryline,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    private function drawMissionIcon(dc as Graphics.Dc) as Void {
      var Y = _y + 18;

      var outlineColor = YELLOW;
      var color = DARK_YELLOW;
      if (_model._isComplete) {
        outlineColor = GREEN;
        color = DARK_GREEN;
      }
      dc.setPenWidth(1);

      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon([
        [_x + 2, Y + 2],
        [_x + 2, Y + _iconHeight - 9],
        [_x + 9, Y + _iconHeight - 2],
        [_x + _iconWidth - 2, Y + _iconHeight - 2],
        [_x + _iconWidth - 2, Y + 2],
      ]);
      dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
      Cyberpunk.drawPolygon(dc, _x, Y, [
        [0, _iconHeight - 8],
        [8, _iconHeight],
        [_iconWidth, _iconHeight],
        [_iconWidth, 0],
      ]);

      dc.setColor(BACKGROUND, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _x + _missionOffsetX / 2,
        _y + 16,
        Graphics.FONT_SYSTEM_XTINY,
        "!",
        Graphics.TEXT_JUSTIFY_CENTER
      );
    }

    private function drawMission(dc as Graphics.Dc) as Void {
      var color = YELLOW;
      if (_model._isComplete) {
        color = GREEN;
      }
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        _x + _missionOffsetX,
        _y + 14,
        Graphics.FONT_SYSTEM_XTINY,
        _model._displayMission,
        Graphics.TEXT_JUSTIFY_LEFT
      );
      if (_model._displayMissionDetail != null) {
        dc.drawText(
          _x + _missionOffsetX,
          _y + 28,
          Graphics.FONT_SYSTEM_XTINY,
          _model._displayMissionDetail,
          Graphics.TEXT_JUSTIFY_LEFT
        );
      }
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      Cyberpunk.drawLabel(dc, _x, _y, [16, 10]);
      drawStoryline(dc);
      drawMissionIcon(dc);
      drawMission(dc);
    }
  }
}
