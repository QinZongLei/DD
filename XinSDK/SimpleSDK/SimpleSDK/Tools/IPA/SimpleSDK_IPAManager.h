//
//  SimpleSDK_IPAManager.h
//  SimpleSDK
//
//  Created by admin on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_IPAManager : NSObject

+ (instancetype)sharedInstance;

+ (void)func_startScanLocal;

+ (void)func_startCreateOrderOfOrderInfo:(NSDictionary *)orderInfo Handle:(void (^)(BOOL status,NSString *msg))handle;

@end

NS_ASSUME_NONNULL_END
