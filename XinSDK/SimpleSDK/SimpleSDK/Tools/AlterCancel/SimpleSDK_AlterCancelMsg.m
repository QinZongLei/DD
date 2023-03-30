//
//  SimpleSDK_AlterCancelMsg.m
//  SimpleSDK
//
//  Created by Mac on 2022/6/30.
//

#import "SimpleSDK_AlterCancelMsg.h"

@implementation SimpleSDK_AlterCancelMsg

+ (instancetype)manager {
    static SimpleSDK_AlterCancelMsg *myInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myInstance = [[super allocWithZone:NULL] init];
    });
    return myInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

//注销成功之后弹出提示
+ (void)func_showCancellationWithMsg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注销账号" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{

            //去登陆界面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SimpleSDK_ViewManager func_showAccountLoginView];
            });
            
        });
    }];

    [alert addAction:delAction];
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [topVC presentViewController:alert animated:YES completion:nil];
    
}
//登录弹出注销提示
+ (void)func_showLoginCancelWithMsg:(NSString *)loginCancelMsg

{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注销账号" message:loginCancelMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [topVC presentViewController:alert animated:YES completion:nil];
    });
    
}




@end
