import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {

    class BodyBatteryDrawable extends WatchUi.Drawable {
        private var _model as Complicated.BodyBatteryModel;
        private var _leftX as Number;
        private var _y as Number;
        private var _width as Number;
        private var _height as Number;
        private var _color = Graphics.COLOR_RED;
        private var _bg_color = Graphics.COLOR_DK_RED;

        public function initialize(params as { :identifier as Object, :x as Numeric, :y as Numeric, :width as Numeric, :height as Numeric }) {   
            _model = new Complicated.BodyBatteryModel();

            _leftX = params[:x];
            _y = params[:y];
            _width = params[:width];
            _height = params[:height];

            var options = {
                :x => params[:x],
                :y => params[:y],
                :identifier => params[:identifier]
            };

            Drawable.initialize(options);
        }

        public function draw(dc as Dc) as Void {            
                _model.updateModel();

                // var percent = _model._percent;
                // var percentWidth = (_width * percent) / 100;
                
                // dc.setFill(_bg_color);
                // dc.drawRectangle(_leftX, _y, _width, _height);
                // dc.setFill(_color);
                // dc.drawRectangle(_leftX, _y, percentWidth, _height);
        }
    }
}