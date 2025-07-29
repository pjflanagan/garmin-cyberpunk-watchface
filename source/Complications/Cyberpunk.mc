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

  const WeatherIcon_Clear = "clear"; // NOTE: _moon and _sun need to be appended to this
  const WeatherIcon_Cloudy = "cloudy";
  const WeatherIcon_Rain = "rain";
  const WeatherIcon_Snow = "snow";
  const WeatherIcon_Windy = "windy";
  const WeatherIcon_Thunderstorm = "thunderstorm";
  const WeatherIcon_Smoke = "smoke";
  const WeatherIcon_Fog = "fog";
  const WeatherIcon_Hail = "hail";
  const WeatherIcon_Unknown = "unknown";

  const WeatherIconMap = [
    WeatherIcon_Clear, // CONDITION_CLEAR
    WeatherIcon_Cloudy, // CONDITION_PARTLY_CLOUDY
    WeatherIcon_Cloudy, // CONDITION_MOSTLY_CLOUDY
    WeatherIcon_Rain, // CONDITION_RAIN
    WeatherIcon_Snow, // CONDITION_SNOW
    WeatherIcon_Windy, // CONDITION_WINDY
    WeatherIcon_Thunderstorm, // CONDITION_THUNDERSTORM
    WeatherIcon_Snow, // CONDITION_WINTRY_MIX
    WeatherIcon_Fog, // CONDITION_FOG
    WeatherIcon_Windy, // CONDITION_HAZY
    WeatherIcon_Hail, // CONDITION_HAIL
    WeatherIcon_Rain, // CONDITION_SCATTERED_SHOWERS
    WeatherIcon_Thunderstorm, // CONDITION_SCATTERED_THUNDERSTORMS
    WeatherIcon_Unknown, // CONDITION_UNKNOWN_PRECIPITATION
    WeatherIcon_Rain, // CONDITION_LIGHT_RAIN
    WeatherIcon_Rain, // CONDITION_HEAVY_RAIN
    WeatherIcon_Snow, // CONDITION_LIGHT_SNOW
    WeatherIcon_Snow, // CONDITION_HEAVY_SNOW
    WeatherIcon_Snow, // CONDITION_LIGHT_RAIN_SNOW
    WeatherIcon_Snow, // CONDITION_HEAVY_RAIN_SNOW
    WeatherIcon_Cloudy, // CONDITION_CLOUDY
    WeatherIcon_Snow, // CONDITION_RAIN_SNOW
    WeatherIcon_Clear, // CONDITION_PARTLY_CLEAR
    WeatherIcon_Clear, // CONDITION_MOSTLY_CLEAR
    WeatherIcon_Rain, // CONDITION_LIGHT_SHOWERS
    WeatherIcon_Rain,// CONDITION_SHOWERS
    WeatherIcon_Rain, // CONDITION_HEAVY_SHOWERS
    WeatherIcon_Rain, // CONDITION_CHANCE_OF_SHOWERS
    WeatherIcon_Thunderstorm, // CONDITION_CHANCE_OF_THUNDERSTORMS
    WeatherIcon_Fog, // CONDITION_MIST
    WeatherIcon_Smoke, // CONDITION_DUST
    WeatherIcon_Rain, // CONDITION_DRIZZLE
    WeatherIcon_Windy, // CONDITION_TORNADO
    WeatherIcon_Smoke, // CONDITION_SMOKE
    WeatherIcon_Snow, // CONDITION_ICE
    WeatherIcon_Smoke, // CONDITION_SAND
    WeatherIcon_Windy, // CONDITION_SQUALL
    WeatherIcon_Smoke, // CONDITION_SANDSTORM
    WeatherIcon_Smoke, // CONDITION_VOLCANIC_ASH
    WeatherIcon_Smoke, // CONDITION_HAZE
    WeatherIcon_Clear, // CONDITION_FAIR
    WeatherIcon_Windy, // CONDITION_HURRICANE
    WeatherIcon_Rain, // CONDITION_TROPICAL_STORM
    WeatherIcon_Snow, // CONDITION_CHANCE_OF_SNOW
    WeatherIcon_Snow, // CONDITION_CHANCE_OF_RAIN_SNOW
    WeatherIcon_Rain, // CONDITION_CLOUDY_CHANCE_OF_RAIN
    WeatherIcon_Snow, // CONDITION_CLOUDY_CHANCE_OF_SNOW
    WeatherIcon_Snow, // CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW
    WeatherIcon_Snow, // CONDITION_FLURRIES
    WeatherIcon_Rain, // CONDITION_FREEZING_RAIN
    WeatherIcon_Hail, // CONDITION_SLEET
    WeatherIcon_Hail, // CONDITION_ICE_SNOW
    WeatherIcon_Cloudy, // CONDITION_THIN_CLOUDS
    WeatherIcon_Unknown, // CONDITION_UNKNOWN
  ];

  // x and y are the base coordinates, all other coordinates are relative to this
  function drawPolygon(dc as Graphics.Dc, x as Number, y as Number, pointDeltas as Array<Array<Number>>) as Void {
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
}
