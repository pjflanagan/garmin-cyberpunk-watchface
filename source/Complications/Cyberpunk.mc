import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Time;

module Cyberpunk {
  var BACKGROUND = 0x180101;
  var RED = 0xff003c;
  var MED_RED = 0xaa0000;
  var DARK_RED = 0x570114;
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
    dc.setColor(MED_RED, Graphics.COLOR_TRANSPARENT);

    for (var i = 0; i < segments.size(); i++) {
      var segmentLength = segments[i];
      dc.drawLine(currentX, y, currentX + segmentLength, y);
      currentX = currentX + segmentLength + 2; // 2 pixel gap
    }
  }

  const SportNameMap = [
    "Workout",
    "Run",
    "Cycle",
    "Transition",
    "Gym",
    "Swim",
    "Basketball",
    "Soccer",
    "Tennis",
    "Football",
    "Training",
    "Walk",
    "XC Ski",
    "Ski",
    "Snowboard",
    "Row",
    "Mountaineering",
    "Hike",
    "Multisport",
    "Paddle",
    "Flying",
    "eBike",
    "Ride", // Motorcycling
    "Boating",
    "Drive",
    "Golf",
    "Hang Glide",
    "Horseback Ride",
    "Hunt",
    "Fish",
    "Skate",
    "Climb",
    "Sail",
    "Ice Skate",
    "Sky Dive",
    "Snowshoe",
    "Snowmobile",
    "Paddleboard",
    "Surf",
    "Wakeboard",
    "Water Ski",
    "Kayak",
    "Raft",
    "Windsurf",
    "Kitesurf",
  ];

  function getSportName(sport as Number) as String {
    if (sport < 0 || sport >= SportNameMap.size()) {
      return "Workout";
    }
    return SportNameMap[sport];
  }

  // TODO: move convert temperature to here

  function convertMetersToMiles(meters as Number) as Float {
    return meters / 1609.34; // 1 mile = 1609.34 meters
  }

  // returns seconds per mile
  function calculateMilePace(
    distance as Number, // in meters
    duration as Time.Duration // in seconds
  ) as Float {
    return (duration.value() / convertMetersToMiles(distance));
  }

  function convertSecondsToTimeString(seconds as Number) as String {
    var hours = seconds / 3600;
    var minutes = (seconds % 3600) / 60;
    var secs = seconds % 60;

    var time = minutes.format("00") + ":" + secs.format("00");
    if (hours > 0) {
      time = hours + ":" + time;
    }
    return time;
  }
}
