import 'package:flutter/services.dart';

class AppInfo {
  static const MethodChannel _channel =  const MethodChannel('flutter_essentials.AppInfo');

  const AppInfo();

  Future<String> get packageName async {
    final String version = await _channel.invokeMethod('packageName');
    return version;
  }

  static Future<String> get name async {
    final String version = await _channel.invokeMethod('name');
    return version;
  }

  static Future<String> get versionString async {
    final String version = await _channel.invokeMethod('versionString');
    return version;
  }

  static Future<String> get buildString async {
    final String version = await _channel.invokeMethod('buildString');
    return version;
  }

  static Future get showSettingsUI async {
    final String version = await _channel.invokeMethod('showSettingsUI');
    return version;
  }
}
