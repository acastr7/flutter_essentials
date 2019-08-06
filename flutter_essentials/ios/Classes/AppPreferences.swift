import Foundation
import Flutter
class AppPreferences: NSObject{
    static var prefix = "Preferences."
    static var knownArgumentKey: String = "key"
    static var knownArgumentDefaultValue: String = "defaultValue"
    static var knownArgumentSharedName: String = "sharedName"
    static var knownArgumentType: String = "type"
    static var knownArgumentValue: String = "value"
    
    static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let range = call.method.range(of: AppPreferences.prefix){
            let method = call.method[range.upperBound...]
            if method == "clear"{
                let args = call.arguments as? Dictionary<String, Any>;
                let sharedName = args?[knownArgumentSharedName];
                PlatformClear(sharedName: sharedName as? String);
                result(nil)
            }else if method == "remove"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[knownArgumentKey] as? String{
                    let sharedName = args[knownArgumentSharedName] as? String;
                    PlatformRemove(key: key, sharedName : sharedName);
                    result(nil);
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing  Arguments", details: call.arguments))
                }
            }
            else if method == "containsKey"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[knownArgumentKey] as? String{
                    let sharedName = args[knownArgumentSharedName] as? String;
                    let contains = PlatformContainsKey(key: key, sharedName : sharedName);
                    result(contains);
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing  Arguments", details: call.arguments))
                }
            }
            else if method == "get"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[knownArgumentKey] as? String, let type = args[knownArgumentType] as? String{
                    let sharedName = args[knownArgumentSharedName] as? String;
                    switch type{
                    case "int":
                        let defaultVal = args[knownArgumentDefaultValue] as? Int;
                        result(PlatformGet(key: key, defaultValue: defaultVal, sharedName: sharedName));
                        break;
                    case "double":
                        let defaultVal = args[knownArgumentDefaultValue] as? Double;
                        result(PlatformGet(key: key, defaultValue: defaultVal, sharedName: sharedName));
                        break;
                    case "String":
                        let defaultVal = args[knownArgumentDefaultValue] as? String;
                        result(PlatformGet(key: key, defaultValue: defaultVal, sharedName: sharedName));
                        break;
                    case "bool":
                        let defaultVal = args[knownArgumentDefaultValue] as? Bool;
                        result(PlatformGet(key: key, defaultValue: defaultVal, sharedName: sharedName));
                        break;
                    default:
                        result(FlutterError.init(code: "NullArgumentException", message: "Type isn't supported", details: call.arguments))
                    }
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing Arguments", details: call.arguments))
                }
            }
            else if method == "set"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[knownArgumentKey] as? String, let type = args[knownArgumentType] as? String{
                    let sharedName = args[knownArgumentSharedName] as? String;
                    switch type{
                    case "int":
                        let value = args[knownArgumentValue] as? Int;
                        PlatformSet(key: key, value:value, sharedName: sharedName);
                        result(nil);
                        break;
                    case "double":
                        let value = args[knownArgumentValue] as? Double;
                        PlatformSet(key: key, value:value, sharedName: sharedName);
                        result(nil);
                        break;
                    case "String":
                        let value = args[knownArgumentValue] as? String;
                        PlatformSet(key: key, value:value, sharedName: sharedName);
                        result(nil);
                        break;
                    case "bool":
                        let value = args[knownArgumentValue] as? Bool;
                        PlatformSet(key: key, value:value, sharedName: sharedName);
                        result(nil);
                        break;
                    default:
                        result(FlutterError.init(code: "NullArgumentException", message: "Type isn't supported", details: call.arguments))
                    }
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing Arguments", details: call.arguments))
                }
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func PlatformGet<T>(key: String, defaultValue : T, sharedName : String?) -> T{
        let userDefaults = GetUserDefaults(sharedName: sharedName);
        
        if(userDefaults.object(forKey: key) == nil){
            return defaultValue;
        }

        switch defaultValue.self {
        case is String.Type:
            return userDefaults.string(forKey: key) as! T;
        case is Int.Type:
            return userDefaults.integer(forKey: key) as! T;
        case is Bool.Type:
            return userDefaults.bool(forKey: key) as! T;
        case is Double.Type:
            return userDefaults.double(forKey: key) as! T;
        default:
            return userDefaults.object(forKey: key) as! T;
        }
    }
    
    static func PlatformSet<T>(key: String, value : T?, sharedName : String?){
        let userDefaults = GetUserDefaults(sharedName: sharedName);
        
        if(value == nil){
            if(userDefaults.object(forKey: key) != nil){
                userDefaults.removeObject(forKey: key);
                return;
            }
        }

        userDefaults.set(value, forKey: key);
    }
    
    static func PlatformContainsKey(key : String, sharedName : String?) -> Bool{
        return GetUserDefaults(sharedName: sharedName).object(forKey: key) != nil;
    }
    
    static func PlatformClear(sharedName :String?){
        let userDefaults = GetUserDefaults(sharedName: sharedName);
        
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
    
    static func PlatformRemove(key : String, sharedName :String?){
        let userDefaults = GetUserDefaults(sharedName: sharedName);
        
        if(userDefaults.object(forKey: key) != nil){
            userDefaults.removeObject(forKey: key);
        }
    }
    
    static func GetUserDefaults(sharedName : String?) -> UserDefaults{
        if(sharedName?.isEmpty ?? false){
            return UserDefaults(suiteName: sharedName)!;
        }
        
        return UserDefaults.standard;
    }
}
