#import <Cordova/CDV.h>
#import "CDVNewsstand.h"


@interface CDVNewsstand () {}
@end

@implementation CDVNewsstand

- (void)test:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];



	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (NSString*)cordovaVersion
{
    return CDV_VERSION;
}

@end