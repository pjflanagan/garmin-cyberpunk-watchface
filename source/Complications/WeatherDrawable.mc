import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {
  class WeatherDrawable extends WatchUi.Drawable {
    private var _model as Complicated.WeatherModel;

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
      _model = new Complicated.WeatherModel();
      _y = params[:y];
      _x = params[:x];

      var options = {
        :x => params[:x],
        :y => params[:y],
        :identifier => params[:identifier],
      };

      Drawable.initialize(options);
    }

    public function draw(dc as Dc) as Void {
      _model.updateModel();
      // basically just output the weather data
    }
  }
}
