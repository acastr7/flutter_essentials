# Version Tracking

## Using Version Tracking
```dart
import 'package:flutter_essentials/version_tracking.dart';
```

The first time you use the VersionTracking class it will start tracking the current version. You must call Track early only in your application each time it is loaded to ensure the current version information is tracked:

```dart
VersionTracking.init();
```

After the initial Track is called version information can be read:

```dart
// First time ever launched application
var firstLaunch = await VersionTracking.isFirstLaunchEver;

// First time launching current version
var firstLaunchCurrent = await VersionTracking.isFirstLaunchForCurrentVersion;

// First time launching current build
var firstLaunchBuild = await VersionTracking.isFirstLaunchForCurrentBuild;

// Current app version (2.0.0)
var currentVersion = await VersionTracking.currentVersion;

// Current build (2)
var currentBuild = await VersionTracking.currentBuild;

// Previous app version (1.0.0)
var previousVersion = await VersionTracking.previousVersion;

// Previous app build (1)
var previousBuild = await VersionTracking.previousBuild;

// First version of app installed (1.0.0)
var firstVersion = await VersionTracking.firstInstalledVersion;

// First build of app installed (1)
var firstBuild = await VersionTracking.firstInstalledBuild;

// List of versions installed (1.0.0, 2.0.0)
var versionHistory = await VersionTracking.versionHistory;

// List of builds installed (1, 2)
var buildHistory = await VersionTracking.buildHistory;
```
## Platform Implementation Specifics

All version information is stored using the Preferences API in flutter_essentials and is stored with a filename of [YOUR-APP-PACKAGE-ID].flutteressentials.versiontracking and follows the same data persistence outlined in the [Preferences](Preferences) documentation.