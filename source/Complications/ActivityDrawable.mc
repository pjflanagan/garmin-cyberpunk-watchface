import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class ActivityDrawable extends WatchUi.Drawable {
    private var _model as Complicated.ActivityModel;

    private var _x as Number;
    private var _y as Number;

    public function initialize(
      params as
        {
          :identifier as Object,
          :x as Numeric,
          :y as Numeric,
          :radius as Numeric,
        }
    ) {
      _model = new Complicated.ActivityModel();
      _y = params[:y];
      _x = params[:x];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    private function drawTrainingStatus(dc as Graphics.Dc) as Void {
      var activityName = "-";
      if (_model._activityName != null) {
        activityName = _model._activityName;
      }
      dc.setColor(YELLOW, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
        _x,
        _y,
        Graphics.FONT_SYSTEM_XTINY,
        activityName,
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      drawTrainingStatus(dc);
    }
  }
}
