# Device Info

## Using App Info
```dart
import 'package:flutter_essentials/device_info.dart';
```

The following information is exposed through the API:

```dart
// Device Model (SMG-950U, iPhone10,6)
var device = await DeviceInfo.model;

// Manufacturer (Samsung)
var manufacturer = await DeviceInfo.manufacturer;

// Device Name (Motz's iPhone)
var deviceName = await DeviceInfo.name;

// Operating System Version Number (7.0)
var version = await DeviceInfo.versionString;

// Platform (Android)
var platform = await DeviceInfo.platform;

// Idiom (Phone)
var idiom = await DeviceInfo.idiom;

// Device Type (Physical)
var deviceType = await DeviceInfo.deviceType;
```

## Platform Implementation Specifics

## iOS
iOS does not expose an API for developers to get the name of the specific iOS device. Instead a hardware identifier is returned such as iPhone10,6 which refers to the iPhone X. A mapping of these identifers are not provided by Apple, but can be found on The iPhone Wiki (a non-official source).