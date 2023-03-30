//
//  SimpleSDK_IPAManager.m
//  SimpleSDK
//
//  Created by admin on 2021/12/29.
//

#import "SimpleSDK_IPAManager.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_DataTools.h"
#import <StoreKit/StoreKit.h>

@interface SimpleSDK_IPAManager()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic, copy) void (^iapHandle)(BOOL status,NSString *msg);
@property (nonatomic, strong) NSString *tempOrderId;
@property (nonatomic, strong) NSString *currentProductId;
@property (nonatomic, strong) NSString *deviceid;
@property (nonatomic, strong) NSString *currencytype;
@property (nonatomic, strong) NSString *currencyamount;
@property (nonatomic, strong) NSString *paymenttype;
@property (nonatomic, strong) NSString *hotKey;
@property (nonatomic, strong) NSString *dataeyeid;
@property (nonatomic, strong) NSString *roleLevel;

@end

@implementation SimpleSDK_IPAManager

+ (instancetype)sharedInstance {
    static SimpleSDK_IPAManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_instance];
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (void)func_startCreateOrderOfOrderInfo:(NSDictionary *)orderInfo Handle:(void (^)(BOOL, NSString * _Nonnull))handle{
    if (handle) {
        [SimpleSDK_IPAManager sharedInstance].iapHandle = handle;
    }
    NSString *price = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"cost"]];
    NSString *roleID = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"roleID"]];
    
    NSString *tempProductId = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"goodsID"]];
    NSString *deviceid = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"deviceid"]];
    NSString *currentType = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"currentType"]];
    NSString *currencyAmount = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"currencyAmount"]];
    NSString *paymentType = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"paymentType"]];
    NSString *hotKey = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"hotKey"]];
    NSString *dataeyeid = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"dataeyeid"]];
    NSString *roleLevel = [NSString stringWithFormat:@"%@", [orderInfo valueForKey:@"roleLevel"]];
   
    if (kStringIsNull(tempProductId)) {
        if (handle) {
            handle(NO,@"商品ID不存在！");
        }
        return;
    }
    NSMutableDictionary *mOrderInfo = [NSMutableDictionary dictionaryWithDictionary:orderInfo];
    
    [SimpleSDK_ApiManager func_getPyState:price roleLevel:roleLevel roleID:roleID FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dic) {
        if (status) {
            
            //调用接口成功的
            NSString *pyStateStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payState"]];
            NSString *pay_toast_str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ios_wx_pay_toast_str"]];
            if ([@"1" isEqualToString:pyStateStr]) {
                [SimpleSDK_ApiManager func_uploadOrder:mOrderInfo FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dic) {
                    if (status) {
                        NSString *tempOrderId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"order_id"]];
                        if (kStringIsNull(tempOrderId)) {
                            if (handle) {
                                handle(NO,@"订单不存在！");
                            }
                            return;
                        }
                        //调用内购
                        [SimpleSDK_IPAManager sharedInstance].currentProductId = tempProductId;
                        [SimpleSDK_IPAManager sharedInstance].tempOrderId = tempOrderId;
                        [SimpleSDK_IPAManager sharedInstance].deviceid = deviceid;
                        [SimpleSDK_IPAManager sharedInstance].currencytype = currentType;
                        [SimpleSDK_IPAManager sharedInstance].currencyamount = price;
                        [SimpleSDK_IPAManager sharedInstance].paymenttype = paymentType;
                        [SimpleSDK_IPAManager sharedInstance].hotKey = hotKey;
                        [SimpleSDK_IPAManager sharedInstance].dataeyeid = dataeyeid;
                        [SimpleSDK_IPAManager sharedInstance].roleLevel = roleLevel;
                        NSArray *YYJLObj_Products = [NSArray arrayWithObjects:[SimpleSDK_IPAManager sharedInstance].currentProductId, nil];
                        NSSet *YYJLObj_ProductSet = [NSSet setWithArray:YYJLObj_Products];
                        SKProductsRequest *YYJLObj_ProductRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:YYJLObj_ProductSet];
                        YYJLObj_ProductRequest.delegate = [SimpleSDK_IPAManager sharedInstance];
                        [YYJLObj_ProductRequest start];
                        
                    }else{
                        if (handle) {
                            
                            if (!kStringIsNull(msg)) {
                                
                                handle(NO,msg);
                                
                            } else {
                                
                                handle(NO,@"支付失败！");
                            }
                            
                        }
                    }
                }];
            }else if([@"2" isEqualToString:pyStateStr]){
                [SimpleSDK_ApiManager func_uploadOrder:mOrderInfo FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dic) {
                    if (status) {
                        NSString *tempOrderId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"pay_url"]];
                        if (kStringIsNull(tempOrderId)) {
                            if (handle) {
                                handle(NO,@"订单不存在！");
                            }
                            return;
                        }
                        [SimpleSDK_Toast hiddenIndicatorToastAction];
                        //跳转帮助界面
                        [SimpleSDK_ViewManager func_showHelpView:tempOrderId];
                        
                    }else{
                        if (handle) {
                            
                            if (!kStringIsNull(msg)) {
                                
                                handle(NO,msg);
                            } else {
                                
                                handle(NO,@"支付失败！");
                            }
                            
                        }
                    }
                }];
                //弹窗
            } else if ([@"3" isEqualToString:pyStateStr]) {
                
                if (handle) {
                    
                    [SimpleSDK_Toast showToast:pay_toast_str location:@"cennter" showTime:5.5f];
                    handle(NO,@"");
                }
                
            }
            
        }else{
            //调用失败
            if (handle) {
                
                if (!kStringIsNull(msg)) {
                    
                    handle(NO,msg);
                    
                } else {
                    
                    handle(NO,@"支付失败！");
                }
                
 
            }
        }
    }];
    
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if (products.count < 1) {
        if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
            [SimpleSDK_IPAManager sharedInstance].iapHandle(NO,@"购买商品不存在！");
        }
        return;
    }
    SKProduct *currentProduct = nil;
    for (SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString:[SimpleSDK_IPAManager sharedInstance].currentProductId]) {
            currentProduct = product;
        }
    }
    
    NSMutableDictionary *YYJLObj_localInfo = [[NSMutableDictionary alloc] init];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].tempOrderId forKey:@"orderid"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].deviceid forKey:@"deviceid"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].currencytype forKey:@"currencytype"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].currencyamount forKey:@"currencyamount"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].paymenttype forKey:@"paymenttype"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].hotKey forKey:@"hotKey"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].dataeyeid forKey:@"dataeyeid"];
    [YYJLObj_localInfo setValue:[SimpleSDK_IPAManager sharedInstance].currencyamount forKey:@"cost"];
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    [YYJLObj_localInfo setValue:accountStr forKey:@"username"];
    [YYJLObj_localInfo setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfv"];
    NSMutableDictionary *YYJLObj_SaveInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
    [YYJLObj_SaveInfo setValue:YYJLObj_localInfo forKey:[SimpleSDK_IPAManager sharedInstance].tempOrderId];
    [[NSUserDefaults standardUserDefaults] setValue:YYJLObj_SaveInfo forKey:kSaveOrderInfo];
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"isUsername"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (currentProduct) {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:currentProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                NSString *receiptData = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                NSString *payId = transaction.transactionIdentifier;
                if (kStringIsNull(receiptData)) {
                    if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
                        [SimpleSDK_IPAManager sharedInstance].iapHandle(NO,@"支付失败了，请联系客服！");
                    }
                    return;
                }
                NSString *YYJLObj_localKey = [NSString stringWithFormat:@"%@",[SimpleSDK_IPAManager sharedInstance].tempOrderId];
                [SimpleSDK_IPAManager JLYXFunc_UpdateReceiptDataOfOrderId:YYJLObj_localKey JLYXSimple_ReceiptData:receiptData JLYXSimple_Transactionid:payId];
                [SimpleSDK_IPAManager JLYXFunc_UploadOrderOfOrderId:YYJLObj_localKey JLYXSimple_ReceiptData:receiptData];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateRestored: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
                    [SimpleSDK_IPAManager sharedInstance].iapHandle(NO,@"支付失败！");
                }
                }
                break;
            case SKPaymentTransactionStateFailed: {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
                        [SimpleSDK_IPAManager sharedInstance].iapHandle(NO,@"您取消了本次支付！");
                      }
                } else{
                if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
                    [SimpleSDK_IPAManager sharedInstance].iapHandle(NO,@"支付失败！");
                  }
                }
            }
                break;
            default:
                break;
        }
   
    }
    
}

+ (void)JLYXFunc_UpdateReceiptDataOfOrderId:(NSString *)params JLYXSimple_ReceiptData:(NSString *)receiptData JLYXSimple_Transactionid:(NSString *)transactionid{
    
    NSMutableDictionary *YYJLObj_LocalInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
    if ([[YYJLObj_LocalInfo allKeys] containsObject:params]) {
        NSMutableDictionary *mOrderInfo = [NSMutableDictionary dictionaryWithDictionary:[YYJLObj_LocalInfo valueForKey:params]];
        [mOrderInfo setValue:receiptData forKey:@"payload"];
        [mOrderInfo setValue:transactionid forKey:@"transactionid"];
        [YYJLObj_LocalInfo setValue:mOrderInfo forKey:params];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:YYJLObj_LocalInfo forKey:kSaveOrderInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)JLYXFunc_UploadOrderOfOrderId:(NSString *)orderid JLYXSimple_ReceiptData:(NSString *)receiptData {
    dispatch_async(dispatch_get_main_queue(), ^{
                
        NSMutableDictionary *YYJLObj_LocalInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
        
        if ([[YYJLObj_LocalInfo allKeys] containsObject:orderid]) {
            NSMutableDictionary *mOrderInfo = [NSMutableDictionary dictionaryWithDictionary:[YYJLObj_LocalInfo valueForKey:orderid]];
            
            NSString *costStr = [NSString stringWithFormat:@"%@",[mOrderInfo valueForKey:@"cost"]];
            [mOrderInfo removeObjectForKey:@"cost"];
            [mOrderInfo removeObjectForKey:@"payload"];
            [mOrderInfo removeObjectForKey:@"idfv"];
            [mOrderInfo removeObjectForKey:@"username"];
            
            [SimpleSDK_ApiManager func_verifyOrder:mOrderInfo cost:costStr receiptData:receiptData FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
                if (status) {
                   
                    [[SimpleSDK_IPAManager sharedInstance] YYJLObj_ReportDataWith:orderid RoleLevel:[SimpleSDK_IPAManager sharedInstance].roleLevel];
                    
                    NSMutableDictionary *YYJLObj_TempInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
                    
                    [YYJLObj_TempInfo removeObjectForKey:orderid];
                    [[NSUserDefaults standardUserDefaults] setValue:YYJLObj_TempInfo forKey:kSaveOrderInfo];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                if ([SimpleSDK_IPAManager sharedInstance].iapHandle) {
                    if (kStringIsNull(msg)) {
                        [SimpleSDK_IPAManager sharedInstance].iapHandle(status,@"支付成功");
                    } else {
                        
                        [SimpleSDK_IPAManager sharedInstance].iapHandle(status,msg);
                    }
                    
                }
            }];
        }
    });
}


- (void)YYJLObj_ReportDataWith:(NSString *)orderID RoleLevel:(NSString *)roleLevel {
    
    NSMutableDictionary *YYJLObj_PayQueryParams = [[NSMutableDictionary alloc] init];
    [YYJLObj_PayQueryParams setValue:orderID forKey:@"order_id"];
    [YYJLObj_PayQueryParams setValue:roleLevel forKey:@"roleLevel"];
    
    [SimpleSDK_ApiManager func_uploadOrderState:YYJLObj_PayQueryParams FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
        //不做处理
        
    }];


}


//补单
+ (void)func_startScanLocal{
    NSMutableDictionary *localInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
    if (!kDictNotNull(localInfo)) {
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    for (NSDictionary *orderInfo in [localInfo allValues]) {
        dispatch_group_enter(group);
        NSMutableDictionary *mOrderInfo = [NSMutableDictionary dictionaryWithDictionary:orderInfo];
        NSString *orderId = [NSString stringWithFormat:@"%@",[orderInfo valueForKey:@"orderid"]];
        NSString *receipt = [NSString stringWithFormat:@"%@",[orderInfo valueForKey:@"payload"]];
        if (kStringIsNull(receipt) || kStringIsNull(orderId)) {
            dispatch_group_leave(group);
            continue;
        }
        NSString *costStr = [NSString stringWithFormat:@"%@",[orderInfo valueForKey:@"cost"]];
        [mOrderInfo removeObjectForKey:@"cost"];
        [mOrderInfo removeObjectForKey:@"payload"];

        [SimpleSDK_ApiManager func_verifyOrder:mOrderInfo cost:costStr receiptData:receipt FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
            if (status) {
                
                NSMutableDictionary *tempInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveOrderInfo]];
                [tempInfo removeObjectForKey:orderId];
                [[NSUserDefaults standardUserDefaults] setValue:tempInfo forKey:kSaveOrderInfo];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}



@end
