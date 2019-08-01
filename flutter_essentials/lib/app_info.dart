import 'package:flutter_essentials/flutter_essentials.dart';

class AppInfo {
  static const String _methodPrefix = "AppInfo.";

  static Future<String> get packageName async {
    final String version = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}packageName');
    return version;
  }

  static Future<String> get name async {
    final String version = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}name');
    return version;
  }

  static Future<String> get versionString async {
    final String version = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}versionString');
    return version;
  }

  static Future<String> get buildString async {
    final String version = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}buildString');
    return version;
  }

  static Future get showSettingsUI async {
    final String version = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}showSettingsUI');
    return version;
  }
}
