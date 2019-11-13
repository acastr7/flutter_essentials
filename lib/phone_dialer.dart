import 'flutter_essentials.dart';

class PhoneDialer {
  static const String _methodPrefix = "PhoneDialer.";

  static Future open(String number) async {
    var data = <String, dynamic>{"number": number};

    await SHARED_CHANNEL.invokeMethod('${_methodPrefix}open', data);
  }

  /// This will return false on a simulator
  static Future<bool> isSupported() async{
    var result = await SHARED_CHANNEL.invokeMethod('${_methodPrefix}isSupported');
    return result;
  }
}
