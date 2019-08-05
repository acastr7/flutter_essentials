import Foundation
import Flutter
class DeviceInfo : NSObject{
    static var prefix = "DeviceInfo."
    
    static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let range = call.method.range(of: DeviceInfo.prefix){
            let method = call.method[range.upperBound...]
            if method == "model"{
                do{
                    let model = try platform();
                    result(model)
                }catch{
                    result(UIDevice.current.model)
                }
            }else if method == "manufacturer"{
                result("Apple")
            }
            else if method == "name"{
                result(UIDevice.current.name)
            }
            else if method == "version"{
                result(UIDevice.current.systemVersion)
            }
            else if method == "deviceType"{
                #if targetEnvironment(simulator)
                result("Virtual")
                #else
                result("Physical")
                #endif
            }
            else if method == "devicePlatform"{
                result("iOS")
            }
            else if method == "idiom"{
                switch(UIDevice.current.userInterfaceIdiom){
                case .phone:
                    result("Phone")
                case .pad:
                    result("Tablet")
                case .tv:
                    result("TV")
                case .carPlay, .unspecified:
                    result("Unknown")
                }
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
        
    }
    
    static func platform() throws -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
