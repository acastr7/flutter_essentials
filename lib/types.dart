class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

enum SensorSpeed {
  DEFAULT, // rate (default) suitable for screen orientation changes
  UI, // rate suitable for the user interface 
  GAME, // rate suitable for games
  FASTEST // Get sensor data as fast as possible
}

final sensorSpeedValues = EnumValues({
  "Default": SensorSpeed.DEFAULT,
  "UI": SensorSpeed.UI,
  "Game": SensorSpeed.GAME,
  "Fastest": SensorSpeed.FASTEST
});
