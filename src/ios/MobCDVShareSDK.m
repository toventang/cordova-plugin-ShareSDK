/********* MobCDVShareSDK.m Cordova Plugin Implementation *******/
#import "MobCDVShareSDK.h"

#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation MobCDVShareSDK

- (void)share:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSDictionary* args = [command.arguments objectAtIndex:0];

    if (args != nil && [args length] > 0) {

        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[args objectForKey:@"text"]
                                            images:[args objectForKey:@"image"]
                                            url:[args objectForKey:@"url"]
                                            title:[args objectForKey:@"title"]
                                            type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                            items:nil
                        shareParams:shareParams
                onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                                delegate:nil
                                                                        cancelButtonTitle:@"确定"
                                                                        otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                message:[NSString stringWithFormat:@"%@",error]
                                                                                delegate:nil
                                                                        cancelButtonTitle:@"OK"
                                                                        otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }
        ];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:"SUCCESS"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark "API"
- (void)pluginInitialize {
    
    NSString* appKey = [[self.commandDelegate settings] objectForKey:@"appkey"];
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* qqAppId = [[self.commandDelegate settings] objectForKey:@"qqappid"];
    NSString* qqAppKey = [[self.commandDelegate settings] objectForKey:@"qqappkey"];

    [ShareSDK registerActivePlatforms:@[
        @(SSDKPlatformTypeWechat),
        @(SSDKPlatformTypeQQ)
    ]
        onImport:^(SSDKPlatformType platformType)
        {
            switch (platformType)
            {
                case SSDKPlatformTypeWechat:
                    [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
                case SSDKPlatformTypeQQ:
                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
                default:
                break;
            }
        }
        onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
        {

            switch (platformType)
            {
                case SSDKPlatformTypeWechat:
                    [appInfo SSDKSetupWeChatByAppId:wechatAppId
                        appSecret:wechatAppSecret];
                break;
                case SSDKPlatformTypeQQ:
                    [appInfo SSDKSetupQQByAppId:qqAppId
                        appKey:qqAppKey
                        authType:SSDKAuthTypeBoth];
                break;
                default:
                break;
            }
        }];

}

@end
