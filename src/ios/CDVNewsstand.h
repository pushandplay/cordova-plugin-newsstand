#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CDVNewsstand : CDVPlugin
{}

+ (NSString*)cordovaVersion;

- (void)test:(CDVInvokedUrlCommand*)command;

@end