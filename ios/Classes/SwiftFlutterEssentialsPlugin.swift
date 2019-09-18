import Flutter
import UIKit

public class SwiftFlutterEssentialsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_essentials", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterEssentialsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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
    else{
        result(FlutterMethodNotImplemented)
    }
  }
}
