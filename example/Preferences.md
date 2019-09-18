# Preferences

## Using Preferences
```dart
import 'package:flutter_essentials/preferences.dart';
```
To save a value for a given key in preferences:

```dart
await Preferences.setString("my_key", "my_value");
```

To retrieve a value from preferences or a default if not set:

```dart
await Preferences.getString("my_key", "default_value");
```

To remove the key from preferences:

```dart
await Preferences.remove("my_key");
```

To remove all preferences:

```dart
await Preferences.clear();
```

In addition to these methods each take in an optional sharedName that can be used to create additional containers for preference. Read the platform implementation specifics below.

## Supported Data Types
The following data types are supported in **Preferences**:

* **bool**
* **double**
* **int**
* **string**

## Platform Implementation Specifics

## Android
All data is stored into [Shared Preferences](https://developer.android.com/training/data-storage/shared-preferences.html). If no sharedName is specified the default shared preferences are used, else the name is used to get a **private** shared preferences with the specified name.

## iOS
[NSUserDefaults](https://developer.apple.com/documentation/foundation/nsuserdefaults) is used to store values on iOS devices. If no sharedName is specified the StandardUserDefaults are used, else the name is used to create a new NSUserDefaults with the specified name used for the NSUserDefaultsType.SuiteName.

## Persistence
Uninstalling the application will cause all Preferences to be removed. There is one exception to this, which for apps that target and run on Android 6.0 (API level 23) or later that are using [Auto Backup](https://developer.android.com/guide/topics/data/autobackup). This feature is on by default and preserves app data including **Shared Preferences**, which is what the **Preferences** API utilizes. You can disable this by following Google's [documentation](https://developer.android.com/guide/topics/data/autobackup).

## Limitations
When storing a string, this API is intended to store small amounts of text. Performance may be subpar if you try to use it to store large amounts of text.