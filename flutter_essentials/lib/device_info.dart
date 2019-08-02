import 'flutter_essentials.dart';

class DeviceInfo {
  static const String _methodPrefix = "DeviceInfo.";

  static Future<String> get model async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}model');
    return result;
  }

  static Future<String> get manufacturer async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}manufacturer');
    return result;
  }

  static Future<String> get name async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}name');
    return result;
  }

  static Future<String> get version async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}version');
    return result;
  }

  static Future<DeviceType> get deviceType async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}deviceType');
    return _stringToDeviceType(result);
  }

  static Future<DevicePlatform> get devicePlatform async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}devicePlatform');
    return _stringToDevicePlatform(result);
  }

  static Future<DeviceIdiom> get idiom async {
    final String result =
        await SHARED_CHANNEL.invokeMethod('${_methodPrefix}idiom');
    return _stringToDeviceIdiom(result);
  }

  static DevicePlatform _stringToDevicePlatform(String platform) {
    if (platform == "Android") {
      return DevicePlatform.Android;
    }

    if (platform == "iOS") {
      return DevicePlatform.iOS;
    }

    if (platform == "Web") {
      return DevicePlatform.Web;
    }

    return DevicePlatform.Unknown;
  }

  static DeviceType _stringToDeviceType(String type) {
    if (type == "Physical") {
      return DeviceType.Physical;
    }

    if (type == "Virtual") {
      return DeviceType.Virtual;
    }

    return DeviceType.Unknown;
  }

  static DeviceIdiom _stringToDeviceIdiom(String idiom) {
    if (idiom == "Phone") {
      return DeviceIdiom.Phone;
    }
    if (idiom == "Tablet") {
      return DeviceIdiom.Tablet;
    }
    if (idiom == "Desktop") {
      return DeviceIdiom.Desktop;
    }

    return DeviceIdiom.Unknown;
  }
}

enum DeviceType { Unknown, Physical, Virtual }
enum DevicePlatform { Android, iOS, Web, Unknown }
enum DeviceIdiom { Phone, Tablet, Desktop, Unknown }
