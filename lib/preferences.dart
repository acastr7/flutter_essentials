import 'package:flutter_essentials/app_info.dart';
import 'package:flutter_essentials/flutter_essentials.dart';

class Preferences {
  static const String _methodPrefix = "Preferences.";

  const Preferences();

  static Future<String> getPrivatePreferencesSharedName(String feature) async {
    var packageName = await AppInfo.packageName;
    return "$packageName.flutteressentials.$feature";
  }

  static Future<bool> containsKey(String key, [String sharedName]) async {
    var data = <String, dynamic>{"key": key, "sharedName": sharedName};
    final bool result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}containsKey', data);
    return result;
  }

  static Future remove(String key, [String sharedName]) async {
    var data = <String, dynamic>{"key": key, "sharedName": sharedName};
    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}remove', data);
  }

  static Future clear([String sharedName]) async {
    var data = <String, dynamic>{"sharedName": sharedName};
    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}clear', data);
  }

  static Future<T> _get<T>(String key,
      [T defaultValue, String sharedName]) async {
    Type type = T;
    var data = <String, dynamic>{
      "key": key,
      "defaultValue": defaultValue,
      "sharedName": sharedName,
      "type": type.toString()
    };
    final result =
        await SHARED_CHANNEL.invokeMethod<T>('${_methodPrefix}get', data);
    return result;
  }

  static Future _set<T>(String key, T value, [String sharedName]) async {
    Type type = T;
    var data = <String, dynamic>{
      "key": key,
      "value": value,
      "sharedName": sharedName,
      "type": type.toString()
    };
    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}set', data);
  }

  static Future<int> getInt(String key, int defaultValue, [String sharedName]) {
    return _get<int>(key, defaultValue, sharedName);
  }

  static Future<String> getString(String key, String defaultValue,
      [String sharedName]) {
    return _get<String>(key, defaultValue, sharedName);
  }

  static Future<bool> getBool(String key, bool defaultValue,
      [String sharedName]) {
    return _get<bool>(key, defaultValue, sharedName);
  }

  static Future<double> getDouble(String key, double defaultValue,
      [String sharedName]) {
    return _get<double>(key, defaultValue, sharedName);
  }

  static Future setInt(String key, int value, [String sharedName]) {
    return _set<int>(key, value, sharedName);
  }

  static Future setString(String key, String value, [String sharedName]) {
    return _set<String>(key, value, sharedName);
  }

  static Future setBool(String key, bool value, [String sharedName]) {
    return _set<bool>(key, value, sharedName);
  }

  static Future setDouble(String key, double value, [String sharedName]) {
    return _set<double>(key, value, sharedName);
  }
}
