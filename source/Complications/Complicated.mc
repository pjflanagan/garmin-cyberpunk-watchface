import Toybox.Lang;
import Toybox.Graphics;

module Complicated {
  function min(a as Number, b as Number) as Number {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }
}
