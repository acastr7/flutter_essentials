//
//  PhoneDialer.swift
//  flutter_essentials
//
//  Created by Dev Ops on 11/13/19.
//

import Foundation
public class PhoneDialer : NSObject{
    static var prefix = "PhoneDialer."
    static var noNetworkProviderCode = "65535";
    static var knownArgumentKey: String = "number"
    
    static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let range = call.method.range(of: PhoneDialer.prefix){
            let method = call.method[range.upperBound...]
            if method == "open"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[knownArgumentKey] as? String{
                    let nsUrl = createNsUrl(number: key)
                    UIApplication.shared.openURL(nsUrl)
                    result(nil)
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing  Arguments", details: call.arguments))
                }
            }
            else if method == "isSupported"{
                result(isSupported())
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func isSupported() -> Bool{
        return UIApplication.shared.canOpenURL(createNsUrl(number: "0000000000"));
    }
    
    static func createNsUrl(number: String) -> URL{
        return URL.init(string: "tel:\(number)")!
    }
}
