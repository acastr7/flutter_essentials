import Flutter
import UIKit

public class SwiftFlutterEssentialsPlugin: NSObject, FlutterPlugin {
  static var accelerometer : Accelerometer?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_essentials", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterEssentialsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    SwiftFlutterEssentialsPlugin.accelerometer = Accelerometer(messenger: registrar.messenger())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method.starts(with: AppInfo.prefix){
        AppInfo.handle(call, result: result)
    }
    else if call.method.starts(with: DeviceInfo.prefix){
        DeviceInfo.handle(call, result: result)
    }
    else if call.method.starts(with: AppPreferences.prefix){
        AppPreferences.handle(call, result: result)
    }
    else if call.method.starts(with: PhoneDialer.prefix){
        PhoneDialer.handle(call, result: result)
    }
    else if call.method.starts(with: Accelerometer.prefix){
        SwiftFlutterEssentialsPlugin.accelerometer?.handle(call, result: result)
    }
    else{
        result(FlutterMethodNotImplemented)
    }
  }
}
