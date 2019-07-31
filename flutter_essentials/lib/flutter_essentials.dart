import 'package:flutter/services.dart';
import 'package:flutter_essentials/preferences.dart';
import 'app_info.dart';

class FlutterEssentials {
  static const MethodChannel _channel =
      const MethodChannel('flutter_essentials');

  static const _appinfo = const AppInfo(_channel);

  static const _preferences = const Preferences(_channel);

  static AppInfo get appInfo {
    return _appinfo;
  }

  static Preferences get preferences {
    return _preferences;
  }
}
