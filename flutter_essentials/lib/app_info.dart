import 'package:flutter/services.dart';

class AppInfo {
  static const String _methodPrefix = "AppInfo.";

  final MethodChannel _channel;

  const AppInfo(this._channel);

  Future<String> get packageName async {
    final String version = await _channel.invokeMethod('${_methodPrefix}packageName');
    return version;
  }

  Future<String> get name async {
    final String version = await _channel.invokeMethod('${_methodPrefix}name');
    return version;
  }

  Future<String> get versionString async {
    final String version = await _channel.invokeMethod('${_methodPrefix}versionString');
    return version;
  }

  Future<String> get buildString async {
    final String version = await _channel.invokeMethod('${_methodPrefix}buildString');
    return version;
  }

  Future get showSettingsUI async {
    final String version = await _channel.invokeMethod('${_methodPrefix}showSettingsUI');
    return version;
  }
}
