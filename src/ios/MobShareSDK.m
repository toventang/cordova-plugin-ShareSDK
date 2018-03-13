/********* MobCDVShareSDK.m Cordova Plugin Implementation *******/
#import "MobCDVShareSDK.h"

#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation MobCDVShareSDK

- (void)share:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* args = [command.arguments objectAtIndex:0];

    if (args != nil && [args length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:args];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)pluginInitialize {
    
    NSString* appKey = [[self.commandDelegate settings] objectForKey:@"appkey"];
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* qqAppId = [[self.commandDelegate settings] objectForKey:@"qqappid"];
    NSString* qqAppKey = [[self.commandDelegate settings] objectForKey:@"qqappkey"];

}

@end
