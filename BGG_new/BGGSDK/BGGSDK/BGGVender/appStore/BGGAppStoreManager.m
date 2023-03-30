//
//  DCGamePayMannger.m
//  SYSDK
//
//  Created by lx on 2020/6/2.
//  Copyright © 2020 qianhai. All rights reserved.
//

#import "BGGAppStoreManager.h"
#import <StoreKit/StoreKit.h>
#import "NSObject+BGGHUD.h"
@interface BGGAppStoreManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString           *_purchID;
    IAPCompletionHandle _handle;
}
@end
@implementation BGGAppStoreManager
+(instancetype)shareDcGamePayMannger{
    static BGGAppStoreManager *PAYManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        PAYManager = [[BGGAppStoreManager alloc] init];
    });
    return PAYManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
 
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - public
-(void)startPayWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle{
    if (purchID) {
//        [self popNotice:@"购买中..." afterTime:4];
//        [self popLoadingView:@"购买中..."];
        
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            _purchID = purchID;
            _handle = handle;
    
            
      NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self handleActionWithType:DCApplePayNotArrow data:nil tranId:nil];
        }
    }
}
#pragma mark -private
- (void)handleActionWithType:(DCApplePayType)type data:(NSData *)data tranId:(NSString *)tranId{
#if DEBUG
    switch (type) {
        case DCApplePaySuccess:
            NSLog(@"购买成功");
            break;
        case DCApplePayFailed:
            NSLog(@"购买失败");
            break;
        case DCApplePayCancle:
            NSLog(@"用户取消购买");
            break;
        case DCApplePayVerFailed:
            NSLog(@"订单校验失败");
            break;
        case DCAppkePayVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case DCApplePayNotArrow:
            NSLog(@"不允许程序内付费");
            break;
        default:
            break;
    }
#endif
    if(_handle){
        _handle(type,data,tranId);
    }
}
#pragma mark - delegate
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
      NSString * productIdentifier = transaction.payment.productIdentifier;
      if ([productIdentifier length] > 0) {
             // 向自己的服务器验证购买凭证
         }
         [self popLoadingView:@"发货中..."];
         [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];

}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
   
    if(!receipt){
        // 交易凭证为空验证失败
       // [self handleActionWithType:DCApplePayVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:DCApplePaySuccess data:receipt tranId:transaction.transactionIdentifier];
     
//    NSError *error;
//    NSDictionary *requestContents = @{
//                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
//                                      };
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
//                                                          options:0
//                                                            error:&error];
//
//    if (!requestData) { // 交易凭证为空验证失败
//        [self handleActionWithType:DCApplePayVerFailed data:nil];
//        return;
//    }
//
//    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
//    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
//
//    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
//    if (flag) {
//        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
//    }
//    NSURL *storeURL = [NSURL URLWithString:serverString];
//    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
//    [storeRequest setHTTPMethod:@"POST"];
//    [storeRequest setHTTPBody:requestData];
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               if (connectionError) {
//                                   // 无法连接服务器,购买校验失败
//                                   [self handleActionWithType:DCApplePayVerFailed data:nil];
//                               } else {
//                                   NSError *error;
//                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                   if (!jsonResponse) {
//                                       // 苹果服务器校验数据返回为空校验失败
//                                       [self handleActionWithType:DCApplePayVerFailed data:nil];
//                                   }
//
//                                   // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
//                                   NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
//                                   if (status && [status isEqualToString:@"21007"]) {
//                                       [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
//                                   }else if(status && [status isEqualToString:@"0"]){
//                                       [self handleActionWithType:DCAppkePayVerSuccess data:nil];
//                                   }
//#if DEBUG
//                                   NSLog(@"----验证结果 %@",jsonResponse);
//#endif
//                               }
//                           }];
//
//
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:DCApplePayFailed data:nil tranId:nil];
    }else{
        [self handleActionWithType:DCApplePayCancle data:nil tranId:nil];
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}



#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
//    [self popLoadingView:@"支付中..."];
 
 
    if([product count] <= 0){
#if DEBUG
        NSLog(@"--------------没有商品------------------");
#endif
        return;
    }
     
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_purchID]){
            p = pro;
            break;
        }
    }
     
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[p description]);
    NSLog(@"%@",[p localizedTitle]);
    NSLog(@"%@",[p localizedDescription]);
    NSLog(@"%@",[p price]);
    NSLog(@"%@",[p productIdentifier]);
    NSLog(@"发送购买请求");
#endif
     
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
#if DEBUG
    NSLog(@"------------------错误-----------------:%@", error);
#endif
}
 
- (void)requestDidFinish:(SKRequest *)request{
#if DEBUG
    NSLog(@"------------反馈信息结束-----------------");
#endif
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
#if DEBUG
                NSLog(@"商品添加进列表");
#endif
                break;
            case SKPaymentTransactionStateRestored:
#if DEBUG
                NSLog(@"已经购买过商品");
#endif
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}
@end
