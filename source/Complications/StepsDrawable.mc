import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

module Complicated {

    class StepsDrawable extends WatchUi.Drawable {
        private var _updater as ModelUpdater?;
        private var _leftX as Number;
        private var _y as Number;
        private var _width as Number;
        private var _color = Graphics.COLOR_YELLOW;
        private var _bg_color = Graphics.COLOR_DK_GRAY;

        public function initialize(params as { :identifier as Object, :locX as Numeric, :locY as Numeric, :width as Numeric, :height as Numeric }) {   
            _updater = new Complicated.StepsModel();
            
            _leftX = params[:locX];
            _y = params[:locY];
            _width = params[:width];

            var options = {
                :locX => params[:locX],
                :locY => params[:locY],
                :identifier => params[:identifier]
            };

            // Initialize superclass
            Drawable.initialize(options);
        }

        //! Draw the complication
        //! @param dc Draw context
        public function draw(dc as Dc) as Void {            
            if (_updater != null) {
                var model = _updater.updateModel();

                // Handle drawing the percent
                var percent = (model as PercentModel).percent;
                var percentWidth = (_width * percent) / 100;
                
                dc.setPenWidth(2);
                dc.setColor(_bg_color, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(_leftX, _y, _leftX + _width, _y);
                dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(_leftX, _y, _leftX + percentWidth, _y);
            }
        }
    }
}