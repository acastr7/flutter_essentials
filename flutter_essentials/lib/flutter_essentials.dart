import 'dart:async';

import 'package:flutter/services.dart';
import 'app_info.dart';

class FlutterEssentials {
  static const MethodChannel _channel =
      const MethodChannel('flutter_essentials');

  static const _appinfo = const AppInfo();

  static AppInfo get appInfo {
    return _appinfo;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
