import Foundation
import Flutter

public class AppInfo : NSObject{
    static var prefix = "AppInfo."
    
    static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let range = call.method.range(of: AppInfo.prefix){
            let method = call.method[range.upperBound...]
            if method == "packageName"{
                result(getBundleValue(key: "CFBundleIdentifier"))
            }else if method == "name"{
                let name: String = getBundleValue(key: "CFBundleDisplayName") ?? getBundleValue(key: "CFBundleName")!
                result(name)
            }
            else if method == "versionString"{
                result(getBundleValue(key: "CFBundleShortVersionString"))
            }else if method == "buildString"{
                result(getBundleValue(key: "CFBundleVersion"))
            }
            else if method == "showSettingsUI"{
                platformShowSettingsUI()
                result("")
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func getBundleValue(key : String) -> String?{
        return Bundle.main.object(forInfoDictionaryKey: key) as? String;
    }
    
    static func platformShowSettingsUI(){
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        UIApplication.shared.openURL(settingsUrl)
    }
}
