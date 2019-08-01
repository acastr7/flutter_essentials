import 'package:flutter_essentials/app_info.dart';
import 'package:flutter_essentials/preferences.dart';

class VersionTracking {
  static const String _versionsKey = "VersionTracking.Versions";
  static const String _buildsKey = "VersionTracking.Builds";
  static String _sharedName;

  static bool _isFirstLaunchEver;
  static String _currentVersion;
  static String _currentBuild;
  static bool _isFirstLaunchForCurrentVersion;
  static bool _isFirstLaunchForCurrentBuild;

  static Map<String, List<String>> _versionTrail = Map<String, List<String>>();

  static Future init() async {
    _currentBuild = await AppInfo.buildString;
    _currentVersion = await AppInfo.versionString;
    _sharedName =
        await Preferences.getPrivatePreferencesSharedName("versiontracking");

    var key = await Preferences.containsKey(_versionsKey, _sharedName);
    var build = await Preferences.containsKey(_buildsKey, _sharedName);

    _isFirstLaunchEver = !key || !build;

    if (isFirstLaunchEver) {
      _versionTrail[_versionsKey] = List<String>();
      _versionTrail[_buildsKey] = List<String>();
    }

    _versionTrail[_versionsKey] =
        await _readHistory(_versionsKey) ?? List<String>();
    _versionTrail[_buildsKey] =
        await _readHistory(_buildsKey) ?? List<String>();

    _isFirstLaunchForCurrentVersion =
        !_versionTrail[_versionsKey].contains(currentVersion);
    if (isFirstLaunchForCurrentVersion) {
      _versionTrail[_versionsKey].add(currentVersion);
    }

    _isFirstLaunchForCurrentBuild =
        !_versionTrail[_buildsKey].contains(currentBuild);
    if (isFirstLaunchForCurrentBuild) {
      _versionTrail[_buildsKey].add(currentBuild);
    }

    if (isFirstLaunchForCurrentVersion || isFirstLaunchForCurrentBuild) {
      await _writeHistory(_versionsKey, _versionTrail[_versionsKey]);
      await _writeHistory(_buildsKey, _versionTrail[_buildsKey]);
    }
  }

  static String get currentVersion => _currentVersion;

  static String get currentBuild => _currentBuild;

  static bool get isFirstLaunchEver => _isFirstLaunchEver;

  static bool get isFirstLaunchForCurrentVersion =>
      _isFirstLaunchForCurrentVersion;

  static bool get isFirstLaunchForCurrentBuild => _isFirstLaunchForCurrentBuild;

  static String get previousVersion => _getPrevious(_versionsKey);

  static String get previousBuild => _getPrevious(_buildsKey);

  static String get firstInstalledVersion => _versionTrail[_versionsKey].first;

  static List<String> get versionHistory => _versionTrail[_versionsKey];

  static String get firstInstalledBuild => _versionTrail[_buildsKey].first;

  static List<String> get buildHistory => _versionTrail[_buildsKey];

  static bool isFirstLaunchForVersion(String version) =>
      currentVersion == version && isFirstLaunchForCurrentVersion;

  static bool isFirstLaunchForBuild(String build) =>
      currentBuild == build && isFirstLaunchForCurrentBuild;

  static Future<List<String>> _readHistory(String key) async {
    var historyString = await Preferences.getString(key, null, _sharedName);
    if (historyString == null) {
      return List<String>();
    }
    var splitHistory = historyString.split('|');
    splitHistory.removeWhere((x) => x.isEmpty);
    return splitHistory.toList();
  }

  static Future _writeHistory(String key, List<String> history) =>
      Preferences.setString(key, history.join('|'), _sharedName);

  static String _getPrevious(String key) {
    var trail = _versionTrail[key];

    if (trail.length >= 2) {
      return trail[trail.length - 2];
    }

    return null;
  }

  static String getStatus() {
    var sb = StringBuffer();
    sb.writeln();
    sb.writeln("VersionTracking");
    sb.writeln("  IsFirstLaunchEver:              $isFirstLaunchEver");
    sb.writeln(
        "  IsFirstLaunchForCurrentVersion: $isFirstLaunchForCurrentVersion");
    sb.writeln(
        "  IsFirstLaunchForCurrentBuild:   $isFirstLaunchForCurrentBuild");
    sb.writeln();
    sb.writeln("  CurrentVersion:                 ${currentVersion}");
    sb.writeln("  PreviousVersion:                ${previousVersion}");
    sb.writeln("  FirstInstalledVersion:          ${firstInstalledVersion}");
    sb.writeln("  VersionHistory:                 ${versionHistory}");
    sb.writeln();
    sb.writeln("  CurrentBuild:                   ${currentBuild}");
    sb.writeln("  PreviousBuild:                  ${previousBuild}");
    sb.writeln("  FirstInstalledBuild:            ${firstInstalledBuild}");
    sb.writeln("  BuildHistory:                   ${buildHistory}");
    return sb.toString();
  }
}
