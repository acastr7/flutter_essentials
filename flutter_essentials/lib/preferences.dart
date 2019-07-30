import 'package:flutter/services.dart';

class Preferences {
  static const String _methodPrefix = "Preferences.";
  final MethodChannel _channel;

  const Preferences(this._channel);

  Future<bool> containsKey(String key, [String sharedName]) async {
    var data = <String, dynamic>{"key": key, "sharedName": sharedName};
    final bool result =
        await _channel.invokeMethod('${_methodPrefix}containsKey', data);
    return result;
  }

  Future remove(String key, [String sharedName]) async {
    var data = <String, dynamic>{"key": key, "sharedName": sharedName};
    await _channel.invokeMethod('${_methodPrefix}remove', data);
  }

  Future<T> _get<T>(String key, [int defaultValue, String sharedName]) async {
    Type type = T;
    var data = <String, dynamic>{
      "key": key,
      "defaultValue": defaultValue,
      "sharedName": sharedName,
      "type": type.toString()
    };
    final result = await _channel.invokeMethod<T>('${_methodPrefix}get', data);
    return result;
  }

  Future _set<T>(String key, [int defaultValue, String sharedName]) async {
    Type type = T;
    var data = <String, dynamic>{
      "key": key,
      "defaultValue": defaultValue,
      "sharedName": sharedName,
      "type": type.toString()
    };
    await _channel.invokeMethod('${_methodPrefix}set', data);
  }

  Future<int> getInt(String key, [int defaultValue, String sharedName]) {
    return _get<int>(key, defaultValue, sharedName);
  }

  Future<String> getString(String key, [int defaultValue, String sharedName]) {
    return _get<String>(key, defaultValue, sharedName);
  }

  Future<bool> getBool(String key, [int defaultValue, String sharedName]) {
    return _get<bool>(key, defaultValue, sharedName);
  }

  Future<double> getDouble(String key, [int defaultValue, String sharedName]) {
    return _get<double>(key, defaultValue, sharedName);
  }

  Future setInt(String key, [int defaultValue, String sharedName]) {
    return _set<int>(key, defaultValue, sharedName);
  }

  Future setString(String key, [int defaultValue, String sharedName]) {
    return _set<int>(key, defaultValue, sharedName);
  }

  Future setBool(String key, [int defaultValue, String sharedName]) {
    return _set<int>(key, defaultValue, sharedName);
  }

  Future setDouble(String key, [int defaultValue, String sharedName]) {
    return _set<int>(key, defaultValue, sharedName);
  }
}
