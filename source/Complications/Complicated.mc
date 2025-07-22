import Toybox.Lang;
import Toybox.Graphics;

module Complicated {
    //! Model for complications that have the following appearance:
    //! 1. An arc fill around a circle
    //! 2. A icon or number in the middle
    //! This class is the standard return value for all of them.
    class PercentModel {
        public var percent as Number;

        public function initialize(p as Number) {
            percent = p;
        }
    }

    //! Model for complications that have the following appearance
    //! 1. An identifier icon
    //! 2. A label under the icon
    class LabelModel {
        //! Label
        var label as String;
        //! Icon
        var icon as BitmapType;

        //! Constructor
        //! @param label Text label to display under icon
        //! @param icon Icon to display
        public function initialize(l as String, i as BitmapType) {
            label = l;
            icon = i;
        }
    }

    typedef Model as PercentModel or LabelModel;

    //! Interface that covers our various
    //! complication update callbacks
    typedef ModelUpdater as interface {
        //! Function that provides an updated status 
        //! for the complication
        function updateModel() as Complicated.Model;
    };
}
