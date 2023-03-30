//
//  SimpleSDK_Toast.h
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_Toast : NSObject

/********************************/

//显示菊花
+ (void)showToastAction;
//隐藏菊花
+ (void)hiddenToastAction;

/********************************/
/********************************/

//显示消息-->default center
+ (void)showToastAction:(NSString *)message;

/**
 * 显示消息Toast
 *
 * @param message       显示的信息
 * @param aLocationStr  显示的位置：@"top",@"center",@"bottom",传入字符串，默认center
 * @param aShowTime     显示的时间
 *
 */
+ (void)showToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime;

+ (void)showToastCenter:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime;

/********************************/
/********************************/

//显示(带菊花的消息)-->default center
+ (void)showIndicatorToastAction:(NSString *)message;

/**
 * 显示(带菊花的消息)
 *
 * @param message       显示的信息
 * @param aLocationStr  显示的位置：@"top",@"center",@"bottom",传入字符串，默认center
 * @param aShowTime     显示的时间
 *
 */
+ (void)showIndicatorToast:(NSString *)message location:(NSString *)aLocationStr showTime:(float)aShowTime;

//隐藏(带菊花的消息)
+ (void)hiddenIndicatorToastAction;
/********************************/

@end

NS_ASSUME_NONNULL_END
