//
//  AppDelegate.m
//  支付包demo
//
//  Created by xing on 15/7/26.
//  Copyright (c) 2015年 ljx. All rights reserved.
//

#import "AppDelegate.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  当从其他应用跳转到当前应用时,就会调用这个方法 ,以下是集成支付宝的代码片段
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    AlixPayResult * result = nil;
    if (url != nil && [[url host] compare:@"safepay"] == 0) {
        NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
        result = [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
        result = [[AlixPayResult alloc] initWithString:query];
#endif
    }
    
    if (result.statusCode == 9000) {
        /*
         *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
         */
        id<DataVerifier> verifier = CreateRSADataVerifier(AlipayPubKey);
        if ([verifier verifyString:result.resultString withSign:result.signString]) {
            //验证签名成功，交易结果无篡改
            //交易成功
            
        } else { // 失败
            
        }
    } else {
        // 失败
        
    }
    return  YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
