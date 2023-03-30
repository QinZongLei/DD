//
//  DCGamePayMannger.h
//  SYSDK
//
//  Created by lx on 2020/6/2.
//  Copyright © 2020 qianhai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    DCApplePaySuccess = 0,
    DCApplePayFailed = 1,
    DCApplePayCancle = 2,
    DCApplePayVerFailed = 3,
    DCAppkePayVerSuccess = 4,
    DCApplePayNotArrow = 5,
    
}DCApplePayType;

typedef void (^IAPCompletionHandle)(DCApplePayType type,NSData *data,NSString *transactionId);


@interface BGGAppStoreManager : NSObject
+(instancetype)shareDcGamePayMannger;
-(void)startPayWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;
@end

