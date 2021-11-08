#import "LinkfivePurchasesPlugin.h"
#if __has_include(<linkfive_purchases/linkfive_purchases-Swift.h>)
#import <linkfive_purchases/linkfive_purchases-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "linkfive_purchases-Swift.h"
#endif

@implementation LinkfivePurchasesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLinkfivePurchasesPlugin registerWithRegistrar:registrar];
}
@end
