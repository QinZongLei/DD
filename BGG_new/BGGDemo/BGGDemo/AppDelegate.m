//
//  AppDelegate.m
//  BGGDemo
//
//  Created by lisheng on 2021/5/24.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <BGGSDK/BGGSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setRootViewController:[[ViewController alloc]init]];
        [self.window makeKeyAndVisible];
    //注册初始化通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BGGInitNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BGGInitCallback:) name:BGGInitNotify object:nil];
    //初始化
    [self initClick];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
     
    return  [[BGGAPI sharedAPIManeger] handleApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
 
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [[BGGAPI sharedAPIManeger] handleApplication:app openURL:url
                  sourceApplication:[options valueForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"]
                         annotation:[options valueForKey:@"UIApplicationOpenURLOptionsAnnotationKey"]];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}



#pragma mark - ==== 初始化 ====
-(void)initClick{
    [[BGGAPI sharedAPIManeger] BGGInit];
}
#pragma mark - ==== 初始化回调 ====
-(void)BGGInitCallback:(NSNotification *)notify{
    if (notify.object == BGGSuccessResult) {
        NSLog(@"初始化成功");
    }else{
        NSLog(@"初始化失败");
        [[BGGAPI sharedAPIManeger] BGGInit];
    }
}

@end
