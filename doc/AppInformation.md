# App Info

## Using App Info
```dart
import 'package:flutter_essentials/app_info.dart';
```

## Obtaining Application Information
```dart
// Application Name
var appName = await AppInfo.name;

// Package Name/Application Identifier (com.microsoft.testapp)
var packageName = await AppInfo.packageName;

// Application Version (1.0.0)
var appVersion = await AppInfo.versionString;

// Application Build Number (1)
var build = await AppInfo.buildString;
```

## Displaying Application Settings
```dart
// Display settings page
await AppInfo.showSettingsUI();
```

## Platform Implementation Specifics

## iOS

App information is taken from the Info.plist for the following fields:

* **Build** – CFBundleVersion
* **Name** - CFBundleDisplayName if set, else CFBundleName
* **PackageName** - CFBundleIdentifier
* **VersionString** – CFBundleShortVersionString

## Android

App information is taken from the AndroidManifest.xml for the following fields:

* **Build** – android:versionCode in manifest node
* **Name** - android:label in the application node
* **PackageName** - package in the manifest node
* **VersionString** – android:versionName in the application node