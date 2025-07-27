import Toybox.Lang;
import Toybox.Graphics;

module Cyberpunk {
  var BACKGROUND_RED = 0x180101;
  var RED = 0xff003c;
  // var MED_RED = 0xAA0000; // Not used
  var DARK_RED = 0x570114; // aa0000
  var BLUE = 0x00f0ff;
  var DARK_BLUE = 0x084a4f;
  var YELLOW = 0xfcee09;
  var DARK_YELLOW = 0x504904;
  var GREEN = 0x29f491;
  var DARK_GREEN = 0x005555;
  var WHITE = Graphics.COLOR_WHITE;
  var DARK_WHITE = 0xbfbfbf;

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

  function drawLabel(
    dc as Dc,
    x as Number,
    y as Number,
    segments as Array<Number>
  ) as Void {
    var currentX = x;

    dc.setPenWidth(1);
    dc.setColor(RED, Graphics.COLOR_TRANSPARENT);

    for (var i = 0; i < segments.size(); i++) {
      var segmentLength = segments[i];
      dc.drawLine(currentX, y, currentX + segmentLength, y);
      currentX = currentX + segmentLength + 2; // 2 pixel gap
    }
  }
}
