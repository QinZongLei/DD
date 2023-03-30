//
//  SimpleSDK_AlterCancelMsg.h
//  SimpleSDK
//
//  Created by Mac on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_AlterCancelMsg : NSObject

+ (instancetype)manager;

//注销成功之后弹出提示
+ (void)func_showCancellationWithMsg:(NSString *)msg;
//登录弹出注销提示
+ (void)func_showLoginCancelWithMsg:(NSString *)loginCancelMsg;

@end

NS_ASSUME_NONNULL_END
