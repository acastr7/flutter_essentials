import 'package:flutter_essentials/app_info.dart';
import 'package:flutter_essentials/flutter_essentials.dart';
import 'package:flutter_essentials/preferences.dart';

class VersionTracking{
  static const String _versionTrailKey = "VersionTracking.Trail";
  static const String _versionsKey = "VersionTracking.Versions";
  static const String _buildsKey = "VersionTracking.Builds";

  static Future<String> _sharedName = Preferences.getPrivatePreferencesSharedName("versiontracking");

  static Future<String> currentVersion() => AppInfo.versionString;
  static Future<String> currentBuild() => AppInfo.buildString;

}