#import "FlutterEssentialsPlugin.h"
#import <flutter_essentials/flutter_essentials-Swift.h>

@implementation FlutterEssentialsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEssentialsPlugin registerWithRegistrar:registrar];
}
@end
