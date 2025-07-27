import Toybox.Lang;
import Toybox.Graphics;

module Complicated {

  var BACKGROUND_RED = 0x180101;
  var RED = 0xFF003C;
  // var MED_RED = 0xAA0000; // Not used
  var DARK_RED = 0x570114; // aa0000
  var BLUE = 0x00F0FF;
  var DARK_BLUE = 0x084A4F;
  var YELLOW = 0xFCEE09;
  var DARK_YELLOW = 0x504904;
  var GREEN = 0x29F491;
  var WHITE = Graphics.COLOR_WHITE;
  var DARK_WHITE = 0xBFBFBF;


  function min(a as Number, b as Number) as Number {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  function abs(a as Number or Float) as Number or Float {
    if (a < 0) {
      return -a;
    } else {
      return a;
    }
  }
}
