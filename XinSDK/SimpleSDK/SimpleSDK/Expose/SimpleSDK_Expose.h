//
//  SimpleSDK_Expose.h
//  SimpleSDK
//
//  Created by XYL on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_Expose : NSObject

@property (nonatomic, copy) void (^initHandle)(BOOL status, NSString *msg,NSString *isAudit);

@property (nonatomic, copy) void (^loginHandle)(BOOL status, NSString *msg, NSDictionary *loginData);

@property (nonatomic, copy) void (^logoutHandle)(BOOL status, NSString *msg);

+ (instancetype)sharedInstance;

//idfa 授权
-(void)func_startIdfaWithBlock:(UIApplication *)application;
//SDK初始化
-(void)func_startInitWithBlock:(void(^)(BOOL status, NSString *msg,NSString *isAudit))block;
//SDK调起登陆
-(void)func_startLoginWithBlock:(void(^)(BOOL status, NSString *msg, NSDictionary *dicData))handlelogin HandleLogout:(void(^)(BOOL status, NSString *msg))handleLgout;
//SDK数据上报
-(void)func_startReportWithBlock:(NSString *)uploadType UploadDic:(NSDictionary *)dic FuncBlock:(void(^)(BOOL status, NSString *msg))block;
//SDK调起内购
- (void)func_startCreateOrderWithBlcok:(NSDictionary *)helpDic FuncBlock:(void(^)(BOOL status, NSString *msg))block;
//SDK退出登陆
- (void)func_startLogoutWithBlock:(void(^)(BOOL status, NSString *msg))block;



@end

NS_ASSUME_NONNULL_END
