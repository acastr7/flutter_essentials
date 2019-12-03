import CoreMotion
import Foundation

class Platform{
    
    static let motionManager = CMMotionManager()
    
    //Initializer access level change now
    private init(){}
    
    static func getCurrentQueue() -> OperationQueue{
        return OperationQueue.current ?? OperationQueue();
    }
}

extension String{
    var sensorSpeed: Double{
        if(self == "UI"){
            return 0.08
        }
        
        if(self == "GAME"){
            return 0.04
        }
        
        if(self == "FASTEST"){
            return 0.02
        }
        
        return 0.225
    }
}
