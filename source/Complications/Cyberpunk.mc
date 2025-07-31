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
  var YELLOW = 0xffaa00;
  var DARK_YELLOW = 0xaa5500;
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

  public function convertCelsiusToFahrenheit(
    celsius as Number or Float
  ) as Number or Float {
    return (celsius * 9) / 5 + 32;
  }

  function convertMetersToMiles(meters as Number) as Float {
    return meters / 1609.34; // 1 mile = 1609.34 meters
  }

  // returns seconds per mile
  function calculateMilePace(
    distance as Number, // in meters
    duration as Time.Duration // in seconds
  ) as Float {
    return duration.value() / convertMetersToMiles(distance);
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

  function normalizeDegrees(degrees as Number) as Number {
    if (degrees < 0) {
      return degrees + 360;
    } else if (degrees >= 360) {
      return degrees - 360;
    }
    return degrees;
  }

  function convertMetersPerSecondToMilesPerHour(
    metersPerSecond as Float
  ) as Float {
    return metersPerSecond * 2.23694; // 1 m/s = 2.23694 mph
  }

  enum WeatherCondition {
    CLEAR,
    CLOUDY,
    RAIN,
    SNOW,
    WINDY,
    THUNDERSTORM,
    SMOKE,
    FOG,
    HAIL,
    UNKNOWN,
  }

  const WeatherConditionMap = [
    CLEAR, // CONDITION_CLEAR
    CLOUDY, // CONDITION_PARTLY_CLOUDY
    CLOUDY, // CONDITION_MOSTLY_CLOUDY
    RAIN, // CONDITION_RAIN
    SNOW, // CONDITION_SNOW
    WINDY, // CONDITION_WINDY
    THUNDERSTORM, // CONDITION_THUNDERSTORM
    SNOW, // CONDITION_WINTRY_MIX
    FOG, // CONDITION_FOG
    WINDY, // CONDITION_HAZY
    HAIL, // CONDITION_HAIL
    RAIN, // CONDITION_SCATTERED_SHOWERS
    THUNDERSTORM, // CONDITION_SCATTERED_THUNDERSTORMS
    UNKNOWN, // CONDITION_UNKNOWN_PRECIPITATION
    RAIN, // CONDITION_LIGHT_RAIN
    RAIN, // CONDITION_HEAVY_RAIN
    SNOW, // CONDITION_LIGHT_SNOW
    SNOW, // CONDITION_HEAVY_SNOW
    SNOW, // CONDITION_LIGHT_RAIN_SNOW
    SNOW, // CONDITION_HEAVY_RAIN_SNOW
    CLOUDY, // CONDITION_CLOUDY
    SNOW, // CONDITION_RAIN_SNOW
    CLEAR, // CONDITION_PARTLY_CLEAR
    CLEAR, // CONDITION_MOSTLY_CLEAR
    RAIN, // CONDITION_LIGHT_SHOWERS
    RAIN, // CONDITION_SHOWERS
    RAIN, // CONDITION_HEAVY_SHOWERS
    RAIN, // CONDITION_CHANCE_OF_SHOWERS
    THUNDERSTORM, // CONDITION_CHANCE_OF_THUNDERSTORMS
    FOG, // CONDITION_MIST
    SMOKE, // CONDITION_DUST
    RAIN, // CONDITION_DRIZZLE
    WINDY, // CONDITION_TORNADO
    SMOKE, // CONDITION_SMOKE
    SNOW, // CONDITION_ICE
    SMOKE, // CONDITION_SAND
    WINDY, // CONDITION_SQUALL
    SMOKE, // CONDITION_SANDSTORM
    SMOKE, // CONDITION_VOLCANIC_ASH
    SMOKE, // CONDITION_HAZE
    CLEAR, // CONDITION_FAIR
    WINDY, // CONDITION_HURRICANE
    RAIN, // CONDITION_TROPICAL_STORM
    SNOW, // CONDITION_CHANCE_OF_SNOW
    SNOW, // CONDITION_CHANCE_OF_RAIN_SNOW
    RAIN, // CONDITION_CLOUDY_CHANCE_OF_RAIN
    SNOW, // CONDITION_CLOUDY_CHANCE_OF_SNOW
    SNOW, // CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW
    SNOW, // CONDITION_FLURRIES
    RAIN, // CONDITION_FREEZING_RAIN
    HAIL, // CONDITION_SLEET
    HAIL, // CONDITION_ICE_SNOW
    CLOUDY, // CONDITION_THIN_CLOUDS
    UNKNOWN, // CONDITION_UNKNOWN
  ];

  function getMappedWeatherCondition(condition as Number) as WeatherCondition {
    if (condition < 0 || condition >= WeatherConditionMap.size()) {
      return UNKNOWN;
    }
    return WeatherConditionMap[condition];
  }

  // x and y are the base coordinates, all other coordinates are relative to this
  function drawPolygon(
    dc as Graphics.Dc,
    x as Number,
    y as Number,
    pointDeltas as Array<Array<Number> >
  ) as Void {
    var lastPoint = [x, y];
    for (var i = 0; i < pointDeltas.size(); i++) {
      var dx = pointDeltas[i][0];
      var dy = pointDeltas[i][1];
      var newX = x + dx;
      var newY = y + dy;
      dc.drawLine(lastPoint[0], lastPoint[1], newX, newY);
      lastPoint = [newX, newY];
    }
    // close the polygon
    dc.drawLine(lastPoint[0], lastPoint[1], x, y);
  }

  function fillPolygon(
    dc as Graphics.Dc,
    x as Number,
    y as Number,
    pointDeltas as Array<Array<Number> >
  ) as Void {
    var points = new [pointDeltas.size() + 1];
    for (var i = 0; i < pointDeltas.size(); i++) {
      var dx = pointDeltas[i][0];
      var dy = pointDeltas[i][1];
      points[i] = [x + dx, y + dy];
    }
    // close the polygon
    points[pointDeltas.size()] = [x, y];
    dc.fillPolygon(points);
  }
}
