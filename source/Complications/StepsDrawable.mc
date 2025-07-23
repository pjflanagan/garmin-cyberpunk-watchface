import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {

    class StepsDrawable extends WatchUi.Drawable {
        private var _model as Complicated.StepsModel;
        private var _leftX as Number;
        private var _y as Number;
        private var _width as Number;

        private var _color = Graphics.COLOR_YELLOW;
        private var _bg_color = Graphics.COLOR_DK_GRAY;
        private var _complete_color = Graphics.COLOR_GREEN;

        public function initialize(params as { :identifier as Object, :x as Numeric, :y as Numeric, :width as Numeric, :height as Numeric }) {   
            _model = new Complicated.StepsModel();
            
            _leftX = params[:x];
            _y = params[:y];
            _width = params[:width];

            var options = {
                :x => params[:x],
                :y => params[:y],
                :identifier => params[:identifier]
            };

            // Initialize superclass
            Drawable.initialize(options);
        }

        //! Draw the complication
        //! @param dc Draw context
        public function draw(dc as Dc) as Void {            
                _model.updateModel();

                var percent = _model._percent;
                var percentWidth = (_width * percent) / 100;
                var color = _color;
                if (percent >= 100) {
                    color = _complete_color;
                }
                
                dc.setPenWidth(2);
                dc.setColor(_bg_color, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(_leftX, _y, _leftX + _width, _y);
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(_leftX, _y, _leftX + percentWidth, _y);
        }
    }
}