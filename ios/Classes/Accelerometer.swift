
import Foundation
class Accelerometer: NSObject, FlutterStreamHandler{
    private var eventSink:  FlutterEventSink?
    
    init(messenger : FlutterBinaryMessenger){
        super.init()
        let channel = FlutterEventChannel(name: "flutter_essentials.Accelerometer", binaryMessenger: messenger)
        channel.setStreamHandler(self)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    static var prefix = "Accelerometer."
    private static var knownArgumentKeyStart = "startSpeed"
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let range = call.method.range(of: Accelerometer.prefix){
            let method = call.method[range.upperBound...]
            if method == "isSupported"{
                result(isSupported())
            }else if method == "start"{
                if let args = call.arguments as? Dictionary<String, Any>, let key = args[Accelerometer.knownArgumentKeyStart] as? String{
                    start(startSpeed: key);
                    result(nil);
                }else{
                    result(FlutterError.init(code: "NullArgumentException", message: "Missing  Arguments", details: call.arguments))
                }
            }
            else if method == "stop"{
                Platform.motionManager.stopAccelerometerUpdates()
                result(nil)
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
     func start(startSpeed: String){
        let sensorSpeed = startSpeed.sensorSpeed;
        let manager = Platform.motionManager;
        manager.accelerometerUpdateInterval = sensorSpeed;
        manager.startAccelerometerUpdates(to: Platform.getCurrentQueue()) { (data, error) in
            guard let data = data else {
                 return
            }
            
            guard let eventSink = self.eventSink else {
                 return
            }
            
            let field = data.acceleration
            let values: [Double] = [field.x * -1, field.y * -1,  field.z * -1]
            eventSink(values)
        }
    }
    
    
    
    func isSupported() -> Bool{
        return Platform.motionManager.isAccelerometerAvailable
    }
}
