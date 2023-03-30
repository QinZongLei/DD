//
//  AppDelegate.m
//  Demo
//
//  Created by CCYQ on 2021/4/19.
//

#import "AppDelegate.h"
#import <SimpleSDK/SimpleSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[SimpleSDK_Expose sharedInstance] func_startInitWithBlock:^(BOOL status, NSString * _Nonnull msg, NSString * _Nonnull isAudit) {
           NSLog(@"---- 初始化状态 ----");
           NSLog(@"status ---- %@", [NSNumber numberWithBool:status]);
           NSLog(@"msg ------- %@", msg);
           NSLog(@"isAudit ------- %@", isAudit);
           NSLog(@"---- -------- ----");
           NSLog(@"\n\n");
       }];
    
    return YES;
}

//处理15.1 不弹出获取idfa授权界面问题。
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SimpleSDK_Expose sharedInstance] func_startIdfaWithBlock:application];

}

@end
