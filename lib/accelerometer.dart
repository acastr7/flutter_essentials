import 'package:flutter_essentials/exceptions.dart';
import 'package:flutter_essentials/types.dart';

import 'flutter_essentials.dart';

class Accelerometer {
  static const String _methodPrefix = "AppInfo.";
  static const double accelerationThreshold = 169;
  static const double gravity = 9.81;
  static bool _isMonitoring = false;
  static bool get isMonitoring => _isMonitoring;

  static Future<bool> get isSupported async {
    final bool isSupported =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}isSupported');
    return isSupported;
  }

  static Future start(SensorSpeed sensorSpeed) async {
    if (!await isSupported) {
      throw FeatureNotSupportedException();
    }

    if (isMonitoring) {
      throw Exception("Accelerometer has already been started.");
    }

    _isMonitoring = true;

    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}start');
  }

  static Future stop() async {
    if (!await isSupported) {
      throw FeatureNotSupportedException();
    }

    if (!isMonitoring) {
      return;
    }

    _isMonitoring = false;

    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}stop');
  }
}

class AccelerometerData {
  final Vector3 acceleration;

  AccelerometerData(double x, double, y, double z)
      : this.fromVector(Vector3(x, y, z));

  AccelerometerData.fromVector(this.acceleration);

  @override
  String toString() {
    return "{Acceleration.X}: ${acceleration.x}, " +
        "{Acceleration.Y}: ${acceleration.y}, " +
        "{Acceleration.Z}: ${acceleration.z}";
  }
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  Vector3(this.x, this.y, this.z);
}
