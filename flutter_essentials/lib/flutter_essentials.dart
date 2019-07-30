import 'package:flutter/services.dart';
import 'app_info.dart';

class FlutterEssentials {
  static const MethodChannel _channel =
      const MethodChannel('flutter_essentials');

  static const _appinfo = const AppInfo(_channel);

  static AppInfo get appInfo {
    return _appinfo;
  }
}
