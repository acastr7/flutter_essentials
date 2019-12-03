import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_essentials/exceptions.dart';
import 'package:flutter_essentials/types.dart';

import 'flutter_essentials.dart';

class Accelerometer {
  static const channel = EventChannel('flutter_essentials.Accelerometer');

  static const String _methodPrefix = "Accelerometer.";
  static const double _accelerationThreshold = 169;
  static const double _gravity = 9.81;
  static bool get isMonitoring => _streamSubscription != null;
  static var accelerometerDataController =
      StreamController<AccelerometerData>.broadcast();
  static StreamController<bool> shakeDetectedController =
      StreamController<bool>.broadcast();
  static _AccelerometerQueue _queue = new _AccelerometerQueue();

  static StreamSubscription<dynamic> _streamSubscription;

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

    _streamSubscription =
        channel.receiveBroadcastStream().listen((dynamic event) async {
      double x = event[0];
      double y = event[1];
      double z = event[2];
      var vector = _Vector3(x, y, z);
      _processShakeEvent(vector);
      var data = AccelerometerData.fromVector(vector);
      accelerometerDataController.sink.add(data);
      print('Received event: $event');
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
      accelerometerDataController.addError(error);
    });

    var data = <String, dynamic>{"startSpeed": sensorSpeed.toString()};

    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}start', data);
  }

  static Future stop() async {
    if (!await isSupported) {
      throw FeatureNotSupportedException();
    }

    if (!isMonitoring) {
      print('Nothing to stop, no Accelerometer running');
      return;
    }

    _streamSubscription?.cancel();
    _streamSubscription = null;

    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}stop');
  }

  static void _processShakeEvent(_Vector3 acceleration) {
    int timestamp = DateTime.now().toUtc().microsecondsSinceEpoch * 1000;
    var x = acceleration.x * _gravity;
    var y = acceleration.y * _gravity;
    var z = acceleration.z * _gravity;

    var g = (x * x) + (y * y) + (z * z);
    print('g = $g');
    var accelerating = g > _accelerationThreshold;
    print('Assing Timestamp : $timestamp -- Accelerating: $accelerating');
    _queue.add(timestamp, accelerating);
    if (_queue.isShaking) {
      _queue.clear();
      shakeDetectedController.sink.add(true);
    } else {
      shakeDetectedController.sink.add(false);
    }
  }
}

class AccelerometerData {
  final _Vector3 acceleration;

  AccelerometerData(double x, double y, double z)
      : this.fromVector(_Vector3(x, y, z));

  AccelerometerData.fromVector(this.acceleration);

  @override
  int get hashCode => acceleration.hashCode;

  @override
  String toString() {
    return "{Acceleration.X}: ${acceleration.x}, " +
        "{Acceleration.Y}: ${acceleration.y}, " +
        "{Acceleration.Z}: ${acceleration.z}";
  }
}

class _Vector3 {
  final double x;
  final double y;
  final double z;

  _Vector3(this.x, this.y, this.z);
}

class _AccelerometerQueue {
  AccelerometerDataPool pool = new AccelerometerDataPool();
  int maxWindowSize = 500000000;
  int minWindowSize = 250000000;
  int minQueueSize = 4;
  _AccelerometerSample oldest;
  _AccelerometerSample newest;
  int sampleCount = 0;
  int acceleratingCount = 0;

  bool get isShaking {
    return newest != null &&
        oldest != null &&
        newest.timestamp - oldest.timestamp >= minWindowSize &&
        acceleratingCount >= (sampleCount >> 1) + (sampleCount >> 2);
    ;
  }

  void add(int timestamp, bool accelerating) {
    purge(timestamp - maxWindowSize);
    var added = pool.acquire();
    added.timestamp = timestamp;
    added.isAccelerating = accelerating;
    added.next = null;

    if (newest != null) newest.next = added;

    newest = added;

    if (oldest == null) oldest = added;

    sampleCount++;

    if (accelerating) acceleratingCount++;
  }

  void clear() {
    while (oldest != null) {
      var removed = oldest;
      oldest = removed.next;
      pool.release(removed);
    }
    newest = null;
    sampleCount = 0;
    acceleratingCount = 0;
  }

  purge(int cutoff) {
    while (sampleCount >= minQueueSize &&
        oldest != null &&
        cutoff - oldest.timestamp > 0) {
      var removed = oldest;
      if (removed.isAccelerating) acceleratingCount--;

      sampleCount--;
      oldest = removed.next;

      if (oldest == null) newest = null;

      pool.release(removed);
    }
  }
}

class _AccelerometerSample {
  int timestamp;
  bool isAccelerating;
  _AccelerometerSample next;
}

class AccelerometerDataPool {
  _AccelerometerSample head;
  _AccelerometerSample acquire() {
    var aquired = head;
    if (aquired == null)
      aquired = new _AccelerometerSample();
    else
      head = aquired.next;

    return aquired;
  }

  void release(_AccelerometerSample sample) {
    sample.next = head;
    head = sample;
  }
}
