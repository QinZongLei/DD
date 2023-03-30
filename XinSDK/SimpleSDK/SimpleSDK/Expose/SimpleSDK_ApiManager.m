//
//  SimpleSDK_ApiManager.m
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_Expose.h"
#import "SimpleSDK_Network.h"
#import "SimpleSDK_DataTools.h"
#import <iAd/iAd.h>
#import <AdServices/AdServices.h>
#import "SimpleSDK_IPAManager.h"
#import "SAMKeychain.h"

@interface SimpleSDK_ApiManager()
@property (nonatomic, strong) dispatch_source_t heartbeatTimer;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation SimpleSDK_ApiManager

+ (instancetype)sharedInstance {
    static SimpleSDK_ApiManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
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

+ (void)func_sdkInit{
    
   //初始化处理归因问题
    [self func_getInfoOfASSndIAD];
    //获取实名认证文本
    [self func_getTrueNameText];
    //获取协议开关
    [self func_controlSdkSwitch];
    //拉取客服链接
    [self func_getCustomerService];
    
    NSDictionary *dict = [NSDictionary new];
    //拉取消息列表
    [SimpleSDK_ApiManager func_getMsgList:dict];

    //拉去公众号信息
    [SimpleSDK_ApiManager func_getPublicCode];
    
    static NSInteger number = 0 ;
    NSDictionary *initDict = [SimpleSDK_Tools func_InitParams];
    [SimpleSDK_Network func_request:kApiHost  params:initDict FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if(status){
            //保存初始化数据到缓存
            [SimpleSDK_DataTools.manager func_setAppInfo:data];
            
            //如果登陆回调，退出回调不为空直接弹出登陆
            if([SimpleSDK_Expose sharedInstance].loginHandle&&[SimpleSDK_Expose sharedInstance].logoutHandle){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SimpleSDK_Expose sharedInstance] func_startLoginWithBlock:[SimpleSDK_Expose sharedInstance].loginHandle HandleLogout:[SimpleSDK_Expose sharedInstance].logoutHandle];
                });
            }
            if ([SimpleSDK_ApiManager  sharedInstance].timer) {
                dispatch_source_cancel([SimpleSDK_ApiManager  sharedInstance].timer);
            }
            [SimpleSDK_Expose sharedInstance].initHandle(status,@"初始化成功！",[[SimpleSDK_DataTools manager].appInfo objectForKey:@"isAudit"]);
        }else{
//            if ([@"The Internet connection appears to be offline." isEqualToString:msg]) {
                //如果网络状态没有打开。  请求三次
            
                number ++ ;
                //循环初始化
                if (number >= 15) {
                    //弹出用户去打开网络权限
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲爱的玩家，游戏网络暂时出问题，请退出后再进入。" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //不同意   直接退出游戏
                                exit(0);
                            });
                        }];
                        [alert addAction:delAction];
                        UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                        [topVC presentViewController:alert animated:YES completion:nil];
                    });
                    /*取消计时器*/
                    dispatch_source_cancel([SimpleSDK_ApiManager  sharedInstance].timer);
                    [SimpleSDK_Toast showToast:@"SDK 初始化失败！" location:@"center" showTime:2.5];
                    return;
                }
                /** 获取一个全局的线程来运行计时器*/
                dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    /** 创建一个计时器*/
                [SimpleSDK_ApiManager sharedInstance].timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue2);
                dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
                uint64_t interval = (uint64_t)(5.0 * NSEC_PER_SEC);
                dispatch_source_set_timer([SimpleSDK_ApiManager sharedInstance].timer, start, interval, 0);
                    /** 设置计时器的里操作事件*/
                dispatch_source_set_event_handler([SimpleSDK_ApiManager sharedInstance].timer, ^{
                       //do you want....
                    [[SimpleSDK_Expose sharedInstance] func_startInitWithBlock:[SimpleSDK_Expose sharedInstance].initHandle];
                });
                dispatch_resume([SimpleSDK_ApiManager  sharedInstance].timer);
                return;
//            }
//            [SimpleSDK_Toast showToast:@"SDK 初始化失败！" location:@"center" showTime:2.5];
        }
    }];
}

//归因问题
+(void)func_getInfoOfASSndIAD{
    __block NSString *token = nil;
    if (@available(iOS 14.3, *)) {
        //连续请求三次，如果一直失败则直接忽略
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSString *appAttributionToken = [AAAttribution attributionTokenWithError:&error];
            if (!error) {
                token = appAttributionToken;
                //上传归因token
                [SimpleSDK_Network func_requestGetAttributionWithToken:token FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                    if (status) {
                       
                        [SimpleSDK_ApiManager func_uploadASAAndIADInfo:data];
                        dispatch_semaphore_signal(semaphore);
                    }
                }];
            }
        });
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 *NSEC_PER_MSEC)));
        if (kStringIsNull(token)) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error;
                NSString *appAttributionToken = [AAAttribution attributionTokenWithError:&error];
                if (!error) {
                    token = appAttributionToken;
                    //上传归因token
                    [SimpleSDK_Network func_requestGetAttributionWithToken:token FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                        if (status) {
                            [SimpleSDK_ApiManager func_uploadASAAndIADInfo:data];
                            dispatch_semaphore_signal(semaphore);
                        }
                    }];
                }
             });

            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 *NSEC_PER_MSEC)));
            if (kStringIsNull(token)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    NSString *appAttributionToken = [AAAttribution attributionTokenWithError:&error];
                    if (!error) {
                        token = appAttributionToken;
                    //上传归因token
                        [SimpleSDK_Network func_requestGetAttributionWithToken:token FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                            if (status) {
                                [SimpleSDK_ApiManager func_uploadASAAndIADInfo:data];
                                dispatch_semaphore_signal(semaphore);
                            }
                        }];
                    }
                });
                
               dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 *NSEC_PER_MSEC)));
               if (kStringIsNull(token)) {
                    return;
               }
           }
       }
    }else{
        if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
            [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary<NSString *,NSObject *> * _Nullable attributionDetails, NSError * _Nullable error) {
                if(!error) {
                    if (kDictNotNull(attributionDetails)) {
                        [SimpleSDK_ApiManager func_uploadASAAndIADInfo:attributionDetails];
                        return;
                    }
                }
                if (error.code == ADClientErrorLimitAdTracking ) {
                    return;
                }
                if(error) {
                    [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary<NSString *,NSObject *> * _Nullable attributionDetails, NSError * _Nullable error) {
                        if (!error) {
                            if (kDictNotNull(attributionDetails)) {
                                [SimpleSDK_ApiManager func_uploadASAAndIADInfo:attributionDetails];
                            }
                        }
                    }];
                }
            }];
        }
    }
}



+ (void)func_uploadASAAndIADInfo:(NSDictionary *)dic{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkGetASAApiLogService forKey:@"service"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *ZNWinObj_dataParams = [NSMutableDictionary dictionaryWithDictionary:dic];

    [ZNWinObj_dataParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [ZNWinObj_dataParams setValue: [SimpleSDK_DataTools manager].userAgentstr forKey:@"userAgent"];

    [ZNWinObj_dataParams setValue:kChannelId forKey:@"channel"];
    [ZNWinObj_dataParams setValue:[SimpleSDK_Tools func_getUUIDString] forKey:@"idfv"];
    [ZNWinObj_dataParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [ZNWinObj_dataParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    [ZNWinObj_dataParams setValue:[SimpleSDK_Tools func_getTimesTamp] forKey:@"time"];
    [ZNWinObj_dataParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:ZNWinObj_dataParams] forKey:@"data"];

    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:ZNWinObj_dataParams]];

    NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetASAApiLogService,dataStr,kProductKey];
   [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        
    }];
}

+(void)func_cancelAccounOrPhone:(NSString *)accountOrPhone passwordOrCodeStr:(NSString *)pwdOrCodeStr typeStr:(NSString *)type FuncBlock: (void(^)(BOOL status, NSString *msg,NSDictionary * dic))block
{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    NSString *md5udidStr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *MHFMFun_loginParams = [[NSMutableDictionary alloc] init];
    
    if ([type isEqualToString:@"1"]) {
        
        [MHFMFun_loginParams setValue:accountOrPhone forKey:@"username"];
        [MHFMFun_loginParams setValue:pwdOrCodeStr forKey:@"passwd"];
    } else {
        [MHFMFun_loginParams setValue:accountOrPhone forKey:@"mobile"];
        [MHFMFun_loginParams setValue:pwdOrCodeStr forKey:@"code"];
    }
    
    [MHFMFun_loginParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidStr] forKey:@"udid"];
    [MHFMFun_loginParams setValue:kChannelId forKey:@"channel"];
    [MHFMFun_loginParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [MHFMFun_loginParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [MHFMFun_loginParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
   
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_loginParams] forKey:@"data"];
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_loginParams]];
    
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkCancelAccountOrPhone forKey:@"service"];
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkCancelAccountOrPhone,dataStr,kProductKey];
    
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5Str] forKey:@"sign"];

    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        
        if (status) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(status,msg,data);
            });
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"注销失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
    
    
    
}

+ (void)func_accountLogin:(NSString *)accountStr passwordStr:(NSString *)pwdStr FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    NSString *md5udidStr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *MHFMFun_loginParams = [[NSMutableDictionary alloc] init];
    [MHFMFun_loginParams setValue:accountStr forKey:@"username"];
    [MHFMFun_loginParams setValue:pwdStr forKey:@"passwd"];
    [MHFMFun_loginParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidStr] forKey:@"udid"];
    [MHFMFun_loginParams setValue:kChannelId forKey:@"channel"];
    [MHFMFun_loginParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [MHFMFun_loginParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [MHFMFun_loginParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
   
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_loginParams] forKey:@"data"];
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_loginParams]];
    
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkLogin forKey:@"service"];
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkLogin,dataStr,kProductKey];
    
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5Str] forKey:@"sign"];
    
    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //保存数据  关闭当前界面
                if ([SimpleSDK_ViewManager sharedInstance].loginHandle) {
                    [SimpleSDK_ViewManager sharedInstance].loginHandle(data);
                }
                //缓存
                [SimpleSDK_DataTools func_saveAccountOfPhone:accountStr password:pwdStr type:@"1"];
                //保存登陆方式以及登陆时间
                NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
                [wayforlogin setObject:@"acountway" forKey:@"loginway"];
                NSString *timelogin= [SimpleSDK_Tools func_getTimesTamp];
                NSUserDefaults *timeoutstr = [NSUserDefaults standardUserDefaults];
                [timeoutstr setValue:timelogin forKey:@"timeoutforacount"];
                block(YES);
            });
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"登陆失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
    
}


+ (void)func_getTrueNameText {
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkGetRealNameService forKey:@"service"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
        
    
    NSMutableDictionary *RealNameDefaultBizParams = [[NSMutableDictionary alloc] init];
    [RealNameDefaultBizParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [RealNameDefaultBizParams setValue:kChannelId forKey:@"channel"];
    [RealNameDefaultBizParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [RealNameDefaultBizParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [RealNameDefaultBizParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
    [mParams setValue:[SimpleSDK_Tools  func_dictionaryToJsonOfParams:RealNameDefaultBizParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:RealNameDefaultBizParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetRealNameService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                
        if (status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SimpleSDK_DataTools manager].nameTextStr = [NSString stringWithFormat:@"%@",data[@"real_name_text"]];
                
            });
        }
            
    }];
    
}


+ (void)func_getCustomerService {
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkCustomerService forKey:@"service"];
   
    NSMutableDictionary *YYLTS_customerParams = [[NSMutableDictionary alloc] init];
    [YYLTS_customerParams setValue:kChannelId forKey:@"channel"];
    [YYLTS_customerParams setValue:[[SimpleSDK_DataTools manager].userInfo objectForKey:@"uid"]  forKey:@"uid"];
    [YYLTS_customerParams setValue:[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"] forKey:@"username"];
    [YYLTS_customerParams setValue:@" " forKey:@"serverid"];
    [YYLTS_customerParams setValue:@" " forKey:@"servername"];
    [YYLTS_customerParams setValue:@" " forKey:@"roleid"];
    [YYLTS_customerParams setValue:@" " forKey:@"rolename"];
    [YYLTS_customerParams setValue:@" " forKey:@"rolelevel"];
    [YYLTS_customerParams setValue:kSDKVersion forKey:@"ios_version"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_customerParams] forKey:@"data"];
   
     //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_customerParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkCustomerService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
               
                    //保存开关数据到缓存
                [SimpleSDK_DataTools.manager func_setCustomerInfo:data];
  
            });
          }
    }];
}


+ (void)func_accountRegistered:(NSString *)accountStr passwordStr:(NSString *)pwdStr FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *MHFMFun_registerParams = [[NSMutableDictionary alloc] init];
    [MHFMFun_registerParams setValue:accountStr forKey:@"username"];
    [MHFMFun_registerParams setValue:pwdStr forKey:@"passwd"];
    [MHFMFun_registerParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [MHFMFun_registerParams setValue:kChannelId forKey:@"channel"];
    [MHFMFun_registerParams setValue: [SimpleSDK_DataTools manager].userAgentstr forKey:@"userAgent"];
    [MHFMFun_registerParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [MHFMFun_registerParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [MHFMFun_registerParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
   
    [mParams setValue:[SimpleSDK_Tools  func_dictionaryToJsonOfParams:MHFMFun_registerParams] forKey:@"data"];
    
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkRegister forKey:@"service"];
    
   NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_registerParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkRegister,dataStr,kProductKey];
    
  [mParams setValue:[SimpleSDK_Tools func_getStrMD5:md5str ] forKey:@"sign"];
    
   
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SimpleSDK_Toast showToast:@"注册成功" location:@"cennter" showTime:2.5f];
                [SimpleSDK_DataTools.manager func_setUserInfo:data];
//                [SimpleSDK_ViewManager sharedInstance].loginHandle(data);
                //将用户信息保存
                [SimpleSDK_DataTools func_saveAccountOfPhone:accountStr password:pwdStr type:@"1"];
                NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
                [wayforlogin setObject:@"acountway" forKey:@"loginway"];
                
                block(YES);
            });
        }else{

            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"注册失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
  
}


+ (void)func_controlSdkSwitch {
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkPrivacySwithService forKey:@"service"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
        
    NSMutableDictionary *PrivacySwithDefaultBizParams = [[NSMutableDictionary alloc] init];
    [PrivacySwithDefaultBizParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [PrivacySwithDefaultBizParams setValue:kChannelId forKey:@"channel"];
    [PrivacySwithDefaultBizParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [PrivacySwithDefaultBizParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [PrivacySwithDefaultBizParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:PrivacySwithDefaultBizParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:PrivacySwithDefaultBizParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkPrivacySwithService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
               
                    //保存开关数据到缓存
                [SimpleSDK_DataTools.manager func_setSwitchInfo:data];
  
            });
          }
    }];
    
}


+ (void)func_phoneloginOrRegistered:(NSString *)phoneStr codeStr:(NSString *)codeStr FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *MHFMFun_phoneLoginParams = [[NSMutableDictionary alloc] init];
    [MHFMFun_phoneLoginParams setValue:phoneStr forKey:@"mobile"];
    [MHFMFun_phoneLoginParams setValue:codeStr forKey:@"code"];
    [MHFMFun_phoneLoginParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [MHFMFun_phoneLoginParams setValue:kChannelId forKey:@"channel"];
    
    [MHFMFun_phoneLoginParams setValue:[SimpleSDK_DataTools manager].userAgentstr forKey:@"userAgent"];
    [MHFMFun_phoneLoginParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [MHFMFun_phoneLoginParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [MHFMFun_phoneLoginParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];

    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_phoneLoginParams] forKey:@"data"];

     [mParams setValue:kNetworkmobileLogin forKey:@"service"];

    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_phoneLoginParams]];

       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkmobileLogin,dataStr,kProductKey];
    
   [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //保存数据  关闭当前界面
                if ([SimpleSDK_ViewManager sharedInstance].loginHandle) {
                    [SimpleSDK_ViewManager sharedInstance].loginHandle(data);
                }
                
                NSUserDefaults *phonenum = [NSUserDefaults standardUserDefaults];
                [phonenum setValue:phoneStr forKey:@"phonenum"];
                
                NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
                [wayforlogin setObject:@"phoneway" forKey:@"loginway"];
                NSString *timelogin= [SimpleSDK_Tools func_getTimesTamp];
                NSUserDefaults *timeoutstr = [NSUserDefaults standardUserDefaults];
                [timeoutstr setValue:timelogin forKey:@"timeoutforacount"];
                block(YES);
            });
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"登陆失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
    
   
}

+ (void)func_getPhoneCode:(NSString *)phoneStr type:(NSString *)type FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    
    if ([type isEqualToString:@"get_phone_login_code"]) {
        
        NSMutableDictionary *MHFMFun_phoneLoginParams = [[NSMutableDictionary alloc] init];
        [MHFMFun_phoneLoginParams setValue:phoneStr forKey:@"mobile"];
        
       [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_phoneLoginParams] forKey:@"data"];
        
        [mParams setValue:kNetworkGetPhoneLoginCode forKey:@"service"];
        
       NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_phoneLoginParams]];
         
          NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetPhoneLoginCode,dataStr,kProductKey];
        [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
       
    }
    
    if ([type isEqualToString:@"bind_phone_code"]) {
        
        NSMutableDictionary *MHFMFun_bindphonecodeParams = [[NSMutableDictionary alloc] init];
        [MHFMFun_bindphonecodeParams setValue:phoneStr forKey:@"mobile"];
        
       [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_bindphonecodeParams] forKey:@"data"];
        
        [mParams setValue:kNetworkGetPhoneLoginCode forKey:@"service"];
        
       NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_bindphonecodeParams]];
         
          NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetPhoneLoginCode,dataStr,kProductKey];
      [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    }
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status) {
                [SimpleSDK_Toast showToast:@"验证码已发送到您手机" location:@"center" showTime:2.5f];
                block(YES);
            }else{
                block(NO);
                if (kStringIsNull(msg)) {
                    [SimpleSDK_Toast showToast:@"验证码发送失败" location:@"center" showTime:2.5f];
                }else {
                    [SimpleSDK_Toast showToast:msg location:@"center" showTime:2.5f];
                }
            }
        });
    }];
}

+ (void)func_phoneQuicklogin:(void (^)(BOOL))block{
    NSUserDefaults *phonenum = [NSUserDefaults standardUserDefaults];
    NSString *phonestr = [phonenum objectForKey:@"phonenum"];
    NSString *md5str = [NSString stringWithFormat:@"%@%@%@",phonestr,kChannelId,@"lcobes56wfi4g7zv"];
    NSString *md5finnal = [SimpleSDK_Tools func_getStrMD5:md5str];
    //延迟五秒登录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
        [mParams setValue:kGameId forKey:@"appid"];
        [mParams setValue:@"IOS" forKey:@"platform"];
        NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
        NSMutableDictionary *wxYKFunc_phoneLoginParams = [[NSMutableDictionary alloc] init];
        [wxYKFunc_phoneLoginParams setValue:phonestr forKey:@"mobile"];
        [wxYKFunc_phoneLoginParams setValue:md5finnal forKey:@"checkCode"];
        [wxYKFunc_phoneLoginParams setValue:[SimpleSDK_Tools func_getStrMD5:md5udidstr] forKey:@"udid"];
        [wxYKFunc_phoneLoginParams setValue:kChannelId forKey:@"channel"];
        [wxYKFunc_phoneLoginParams setValue:kSDKVersion forKey:@"sdkVersion"];
        [wxYKFunc_phoneLoginParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
        NSString *userAgentStr= [SimpleSDK_DataTools manager].userAgentstr;
        
        [wxYKFunc_phoneLoginParams setValue:userAgentStr forKey:@"userAgent"];
        [wxYKFunc_phoneLoginParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];

        [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:wxYKFunc_phoneLoginParams] forKey:@"data"];

         [mParams setValue:kNetworkmobileLogin forKey:@"service"];

        NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:wxYKFunc_phoneLoginParams]];

           NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkmobileLogin,dataStr,kProductKey];
        
        
       [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
        
        
        [SimpleSDK_Network func_request: kApiHost  params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            if (status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //保存数据  关闭当前界面
                    if ([SimpleSDK_ViewManager sharedInstance].loginHandle) {
                        [SimpleSDK_ViewManager sharedInstance].loginHandle(data);
                    }
                    block(YES);
                });
            }else{
                block(NO);
                if (kStringIsNull(msg)) {
                    [SimpleSDK_Toast showToast:@"登陆失败" location:@"cennter" showTime:2.5f];
                }else{
                    [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
                }
            }
        }];
    });
}

+ (void)func_accountQuicklogin:(void (^)(BOOL))block{
    NSDictionary *userAccount = [[SimpleSDK_DataTools func_getAllAccount] lastObject];
    NSString *account = @"";
    NSString *password = @"";
    account = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"account"]];
    password = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"password"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
        
        [mParams setValue:kGameId forKey:@"appid"];
        NSString *md5udidStr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
        NSMutableDictionary *wxYKFunc_loginParams = [[NSMutableDictionary alloc] init];
        [wxYKFunc_loginParams setValue:account forKey:@"username"];
        [wxYKFunc_loginParams setValue:password forKey:@"passwd"];
        [wxYKFunc_loginParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidStr] forKey:@"udid"];
        [wxYKFunc_loginParams setValue:kChannelId forKey:@"channel"];
        [wxYKFunc_loginParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
        [wxYKFunc_loginParams setValue:kSDKVersion forKey:@"sdkVersion"];
        [wxYKFunc_loginParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
        
       
        [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:wxYKFunc_loginParams] forKey:@"data"];
        NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:wxYKFunc_loginParams]];
        
        [mParams setValue:@"IOS" forKey:@"platform"];
        [mParams setValue:kNetworkLogin forKey:@"service"];
        
        NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkLogin,dataStr,kProductKey];
        
        [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5Str] forKey:@"sign"];
        
        [SimpleSDK_Network func_request: kApiHost  params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            if (status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //保存数据  关闭当前界面
                    if ([SimpleSDK_ViewManager sharedInstance].loginHandle) {
                        [SimpleSDK_ViewManager sharedInstance].loginHandle(data);
                    }
                    //缓存
                    [SimpleSDK_DataTools func_saveAccountOfPhone:account password:password type:@"1"];
                    //保存登陆方式以及登陆时间
                    NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
                    [wayforlogin setObject:@"acountway" forKey:@"loginway"];
                    NSString *timelogin= [SimpleSDK_Tools func_getTimesTamp];
                    NSUserDefaults *timeoutstr = [NSUserDefaults standardUserDefaults];
                    [timeoutstr setValue:timelogin forKey:@"timeoutforacount"];
                    block(YES);
                });
            }else{
                if (kStringIsNull(msg)) {
                    [SimpleSDK_Toast showToast:@"登陆失败" location:@"cennter" showTime:2.5f];
                }else{
                    [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
                }
                block(NO);
            }
            
        }];
    });
}


+ (void)func_getMsgList:(NSDictionary *)dic{
    
    //拉取消息列表
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkGetGameNewsService forKey:@"service"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
        
    NSMutableDictionary *NoticeDefaultBizParams = [[NSMutableDictionary alloc] init];
    [NoticeDefaultBizParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [NoticeDefaultBizParams setValue:kChannelId forKey:@"channel"];
    [NoticeDefaultBizParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [NoticeDefaultBizParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [NoticeDefaultBizParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:NoticeDefaultBizParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:NoticeDefaultBizParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetGameNewsService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            
            //将消息列表保存到本地
            [SimpleSDK_DataTools.manager func_setMsgInfo:data];
        }
    }];
}



+(void)func_getReviewMsg:(NSDictionary *)dic{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkGetgetGiftCodeService forKey:@"service"];
   
    NSMutableDictionary *giftCodeParams = [[NSMutableDictionary alloc] init];
    [giftCodeParams setValue:kGameId forKey:@"appid"];

   [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:giftCodeParams] forKey:@"data"];
   
     //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:giftCodeParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGetgetGiftCodeService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            
            //将消息列表保存到本地
            [SimpleSDK_DataTools.manager func_setReviewInfo:data];
        }
    }];
}

+ (void)func_getPublicCode{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetWorkGetWxInfoService forKey:@"service"];
   
    NSMutableDictionary *YYLTS_customerParams = [[NSMutableDictionary alloc] init];
    [YYLTS_customerParams setValue:kGameId forKey:@"appid"];
    
    
   [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_customerParams] forKey:@"data"];
   
     //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_customerParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetWorkGetWxInfoService,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
           
            [SimpleSDK_DataTools.manager func_setPublicCodeInfo:data];
        }
    }];
}

+ (void)func_updatapwd:(NSString *)oldPwd newPwd:(NSString *)newPwd FuncBlock:(void (^)(BOOL))block{
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *MHFMFun_changeParams = [[NSMutableDictionary alloc] init];
    
    [MHFMFun_changeParams setValue:accountStr forKey:@"username"];
    [MHFMFun_changeParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [MHFMFun_changeParams setValue:kChannelId forKey:@"channel"];
    [MHFMFun_changeParams setValue:newPwd forKey:@"newpassword"];

    [MHFMFun_changeParams setValue:oldPwd forKey:@"oldpassword"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_changeParams] forKey:@"data"];
     
     [mParams setValue:kNetworkUserCenterUpdatePwd forKey:@"service"];
     
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_changeParams]];

       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkUserCenterUpdatePwd,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            //成功。 将新的密码保存到本地。
            [SimpleSDK_DataTools func_saveAccountOfPhone:accountStr password:newPwd type:@"1"];
            block(YES);
          
        }else{
            block(NO);
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"修改密码失败！" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
}

+ (void)func_bindPhone:(NSString *)phoneStr codeStr:(NSString *)codeStr FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
   
         [mParams setValue:kGameId forKey:@"appid"];
         [mParams setValue:@"IOS" forKey:@"platform"];
         
    NSMutableDictionary *MHFMFun_bindphoneParams = [[NSMutableDictionary alloc] init];
    NSString *usernameStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    [MHFMFun_bindphoneParams setValue:usernameStr forKey:@"username"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    [MHFMFun_bindphoneParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
         [MHFMFun_bindphoneParams setValue:kChannelId forKey:@"channel"];
         [MHFMFun_bindphoneParams setValue:codeStr forKey:@"code"];
         [MHFMFun_bindphoneParams setValue:phoneStr forKey:@"mobile"];
     
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:MHFMFun_bindphoneParams] forKey:@"data"];
          
          [mParams setValue:kNetworkBindPhone forKey:@"service"];
          
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:MHFMFun_bindphoneParams]];
         
         
    NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkBindPhone,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];

    [SimpleSDK_Network func_request:kApiHost  params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //保存数据，更新本地用户数据
                NSDictionary *userDic= [SimpleSDK_DataTools manager].userInfo;
                NSMutableDictionary *newUserDic = [NSMutableDictionary new];
                [newUserDic addEntriesFromDictionary:userDic];
                [newUserDic removeObjectForKey:@"isBindMobile"];
                [newUserDic removeObjectForKey:@"mobile"];
                [newUserDic setValue:phoneStr forKey:@"mobile"];
                [newUserDic setValue:@"1" forKey:@"isBindMobile"];
                [SimpleSDK_DataTools.manager func_setUserInfo:newUserDic];
                

                block(YES);
            });
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"绑定手机失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
    
  
}

+ (void)func_realNameAuthentication:(NSString *)nickName idCard:(NSString *)idCard FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkSetIDCard forKey:@"service"];
   
    NSMutableDictionary *YYLTS_fcmInfoParams = [[NSMutableDictionary alloc] init];
    NSString *usernameStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    [YYLTS_fcmInfoParams setValue:usernameStr forKey:@"username"];
    [YYLTS_fcmInfoParams setValue:nickName forKey:@"truename"];
    [YYLTS_fcmInfoParams setValue:idCard forKey:@"idcard"];
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_fcmInfoParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_fcmInfoParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkSetIDCard,dataStr,kProductKey];
  
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost  params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            NSDictionary *userDic= [SimpleSDK_DataTools manager].userInfo;
            NSMutableDictionary *newUserDic = [NSMutableDictionary new];
            [newUserDic addEntriesFromDictionary:userDic];
            [newUserDic removeObjectForKey:@"fcm"];
            [newUserDic removeObjectForKey:@"trueName"];
            [newUserDic removeObjectForKey:@"idCard"];
            [newUserDic setValue:nickName forKey:@"trueName"];
            [newUserDic setValue:@"1" forKey:@"fcm"];
            [newUserDic setValue:idCard forKey:@"idcard"];
            [SimpleSDK_DataTools.manager func_setUserInfo:newUserDic];
            [SimpleSDK_Toast showToast:@"实名认证成功！" location:@"cennter" showTime:2.5f];
            block(YES);
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"实名认证失败！" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
}

+ (void)func_uploadMsgDic:(NSString *)actiontype params:(NSDictionary *)params FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    if (!kDictNotNull(params)) {
        [SimpleSDK_Toast showToast:@"上报数据不能为空！" location:@"cennter" showTime:2.5f];
        return;
    }
    if (kStringIsNull(actiontype)) {
        [SimpleSDK_Toast showToast:@"上报数据类型不能为空" location:@"cennter" showTime:2.5f];
        return;
    }
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkGameEventService forKey:@"service"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *YYLTS_dataParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *userStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"uid"]];
    [YYLTS_dataParams setValue:actiontype forKey:@"type"];
    [YYLTS_dataParams setValue:userStr forKey:@"username"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [YYLTS_dataParams setValue:uidStr forKey:@"uid"];
    [YYLTS_dataParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];


    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkGameEventService,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            block(YES,@"数据上报成功");
        }else{
            block(NO,@"数据上报失败");
        }
    }];
}

+ (void)func_checkUserMobileCode:(NSString *)accountStr phoneStr:(NSString *)phone phoneCode:(NSString *)code FuncBlock:(void (^)(BOOL))block
{

    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *YYLTS_mobileCodeParams = [[NSMutableDictionary alloc] init];
    [YYLTS_mobileCodeParams setValue:accountStr forKey:@"username"];
    [YYLTS_mobileCodeParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [YYLTS_mobileCodeParams setValue:kChannelId forKey:@"channel"];
    [YYLTS_mobileCodeParams setValue:code forKey:@"code"];
    [YYLTS_mobileCodeParams setValue:phone forKey:@"mobile"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_mobileCodeParams] forKey:@"data"];
     
     [mParams setValue:kNetworkcheckUserMobileCodeservice forKey:@"service"];
     
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_mobileCodeParams]];
      
       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkcheckUserMobileCodeservice,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    [SimpleSDK_Network func_request:kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
 
        if (status) {
            
            block(YES);
            
        } else {
           
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"请输入正确的手机号和验证码" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
    
}

+ (void)func_findPwd:(NSString *)accountStr PhoneStr:(NSString *)phoneStr CodeStr:(NSString *)codeStr PasswordStr:(NSString *)pwdStr FuncBlock:(void (^)(BOOL))block{
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    
    NSMutableDictionary *YYLTS_updatePwdParams = [[NSMutableDictionary alloc] init];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    [YYLTS_updatePwdParams setValue:accountStr forKey:@"username"];
    [YYLTS_updatePwdParams setValue:[SimpleSDK_Tools  func_getStrMD5: md5udidstr] forKey:@"udid"];
    [YYLTS_updatePwdParams setValue:kChannelId forKey:@"channel"];
    [YYLTS_updatePwdParams setValue:pwdStr forKey:@"passwd"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_updatePwdParams] forKey:@"data"];
     
     [mParams setValue:kNetworkFindPwd forKey:@"service"];
     
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_updatePwdParams]];
      
       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkFindPwd,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost  params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        if (status) {
            //成功。 将新的密码保存到本地。
            [SimpleSDK_Toast showToast:@"密码重置成功" location:@"cennter" showTime:2.5f];
            [SimpleSDK_DataTools func_saveAccountOfPhone:accountStr password:pwdStr type:@"1"];
            //跳转到登陆界面
            block(YES);
        }else{
            if (kStringIsNull(msg)) {
                [SimpleSDK_Toast showToast:@"重置密码失败" location:@"cennter" showTime:2.5f];
            }else{
                [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
            }
        }
    }];
}

+ (void)func_startHeartbeat{
    //心跳时间
    NSString *delayRealName  = @"60";
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    [SimpleSDK_ApiManager sharedInstance].heartbeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(delayRealName.intValue * NSEC_PER_SEC);
    dispatch_source_set_timer([SimpleSDK_ApiManager sharedInstance].heartbeatTimer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler([SimpleSDK_ApiManager sharedInstance].heartbeatTimer, ^{
        [self func_uploadHearbeat];//心跳接口
    });
    // 启动定时器
    dispatch_resume([SimpleSDK_ApiManager sharedInstance].heartbeatTimer);
}

//心跳上报
+(void)func_uploadHearbeat{
    NSMutableDictionary *mParams = [NSMutableDictionary new];
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"] ;
    
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkcheckUserTimeoutService forKey:@"service"];
    NSMutableDictionary *YYLTS_dataParams = [[NSMutableDictionary alloc] init];
    [YYLTS_dataParams setValue:accountStr forKey:@"username"];
    [YYLTS_dataParams setValue:kChannelId forKey:@"channel"];
    
//    [YYLTS_dataParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    
    NSString *str32Bite  =  [SAMKeychain passwordForService:@"20001" account:@"idfaString"];;
    if (kStringIsNull(str32Bite)) {
        if ([[SimpleSDK_DataTools manager].idfaStr isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            NSString *str = [self func_random:32];
            [YYLTS_dataParams setValue:str forKey:@"idfa"];
                        
           [SAMKeychain setPassword:str forService:@"20001" account:@"idfaString"];
            
        } else {
            
            
            if ([[SimpleSDK_DataTools manager].idfaStr isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
                
                [YYLTS_dataParams setValue:str32Bite forKey:@"idfa"];
                
            } else{
           
            [YYLTS_dataParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
            }
        }
    }else{
        
        if ([[SimpleSDK_DataTools manager].idfaStr isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            [YYLTS_dataParams setValue:str32Bite forKey:@"idfa"];
            
        } else {
        
        [YYLTS_dataParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
        }
    }
    
  
    [YYLTS_dataParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
    
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkcheckUserTimeoutService,dataStr,kProductKey];
    
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
       
        if (status) {
            NSString *timeoutStr = [NSString stringWithFormat:@"%@",[data objectForKey:@"timeout"]];
            NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
            
            //timeoutStr。等于1  如果用户没有实名认证，直接跳转到实名认证界面。已经实名认证，直接退出登录。返回掉登录界面
            if (timeoutStr.intValue ==1) {
                NSString *trueName = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"fcm"];
                if (trueName.intValue != 1) {
                    //如果为空直接跳转认证界面
                    NSString *trueNameSwitchStr  = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"trueNameSwitch"];
                    //判断是否弹出实名  1，弹出不可关闭实名。 2，弹出可以关闭实名。 0，不弹出实名
                    if (trueNameSwitchStr.intValue != 0 ) {
                        [SimpleSDK_ViewManager func_showCertificationView:trueNameSwitchStr];
                    }
                }else {
                    //已经认证过。 就直接退出
                    [SimpleSDK_Toast showToast:message location:@"cennter" showTime:2.5f];
                    [SimpleSDK_ApiManager func_logout:^(BOOL status) {
                        if (status) {
                            [[SimpleSDK_Expose sharedInstance] func_startLoginWithBlock:[SimpleSDK_Expose sharedInstance].loginHandle HandleLogout:[SimpleSDK_Expose sharedInstance].logoutHandle];
                        }
                    }];
                }
            }
        }
        
    }];
}


// 随机生成字符串(由大小写字母、数字组成)
+ (NSString *)func_random:(int)len {
    
        char ch[len];
        for (int index=0; index<len; index++) {
            int num = arc4random_uniform(75)+48;
            if (num>57 && num<65) { num = num%57+48; }
            else if (num>90 && num<97) { num = num%90+65; }
            ch[index] = num;
        }
     return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}


+ (void)func_createOrder:(NSDictionary *)params FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    if (!kDictNotNull(params)) {
        if (block) {
            block(NO, @"未传入订单信息");
        }
        return;
    }
    
    NSString *tempProductId = [NSString stringWithFormat:@"%@", [params valueForKey:@"goodsID"]];
    if (kStringIsNull(tempProductId)) {
        if (block) {
            block(NO, @"内购订单ID为空！");
        }
        return;
    }
    
    //首先判断是否开启强制实名
    NSString *trueNameSwitchStr  = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"trueNameSwitch"];
    NSString *trueName = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"fcm"];
    
    if (trueNameSwitchStr.intValue == 1 || trueNameSwitchStr.intValue == 2) {
        if (trueName.intValue == 0) {
            //开启了实名认证。 用户没有认证直接弹出认证界面
            [SimpleSDK_ViewManager func_showCertificationView:trueNameSwitchStr];
            return;
        }
    }
    //没有开启实名，或者已经实名过的。直接下单即可
    [SimpleSDK_Toast showIndicatorToastAction:@"正在发起支付,请等待"];
    [SimpleSDK_IPAManager func_startCreateOrderOfOrderInfo:params Handle:^(BOOL status, NSString * _Nonnull msg) {
        [SimpleSDK_Toast hiddenIndicatorToastAction];
        [SimpleSDK_Toast showToast:msg location:@"cennter" showTime:2.5f];
        block(status,msg);
    }];
   
}


+ (void)func_logout:(void (^)(BOOL))block{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary* defaults = [defs dictionaryRepresentation];
    //清除掉登录时间数据
    for (id key in defaults) {
        if ([key isEqualToString:@"timeoutforacount"]) {
                [defs removeObjectForKey:key];
                [defs synchronize];
        } else {
            
        }
    }
    
    [SimpleSDK_ViewManager func_removeCodeFloatView];
    
    if ([SimpleSDK_Expose sharedInstance].logoutHandle) {
        [SimpleSDK_Expose sharedInstance].logoutHandle(YES,@"账号退出成功！");
    }
    @try {
        //退出登录。停掉心跳
        if (![SimpleSDK_ApiManager sharedInstance].heartbeatTimer) {
            dispatch_queue_t queue = dispatch_get_main_queue();
            [SimpleSDK_ApiManager sharedInstance].heartbeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_cancel([SimpleSDK_ApiManager sharedInstance].heartbeatTimer);
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
  
   //清空本地用户数据
    [SimpleSDK_DataTools.manager func_setUserInfo:@{}];
    block(YES);
}

+ (void)func_getPyState:(NSString *)price roleLevel:(NSString *)roleLevel roleID:(NSString *)roleID FuncBlock:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkgGetPayments forKey:@"service"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
  
    NSMutableDictionary *YYLTS_dataParams = [[NSMutableDictionary alloc] init];
    [YYLTS_dataParams setValue:accountStr forKey:@"username"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [YYLTS_dataParams setValue:roleLevel forKey:@"roleLevel"];
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkgGetPayments,dataStr,kProductKey];
    
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        block(status,msg,data);
    }];
}

+ (void)func_uploadOrder:(NSDictionary *)orderDic FuncBlock:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))block{
    
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"sid"]];
    NSMutableDictionary *mParams = [NSMutableDictionary new];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkCreateOrderService forKey:@"service"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *YYLTS_dataParams = [NSMutableDictionary dictionaryWithDictionary:orderDic];
    [YYLTS_dataParams setValue:accountStr forKey:@"username"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];
    [YYLTS_dataParams setValue:kChannelId forKey:@"channel"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getUUIDString] forKey:@"idfv"];
    [YYLTS_dataParams setValue:sidStr forKey:@"sid"];
    [YYLTS_dataParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];

    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];

    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

       NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkCreateOrderService,dataStr,kProductKey];
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];

    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        block(status,msg,data);
    }];
}


+ (void)func_verifyOrder:(NSDictionary *)orderDic cost:(NSString *)cost receiptData:(NSString *)receiptData FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:receiptData forKey:@"receipt_data"];
    [mParams setValue:cost forKey:@"cost"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkApplePayService forKey:@"service"];
    
     NSMutableDictionary *YYLTS_dataParams = [NSMutableDictionary dictionaryWithDictionary:orderDic];
        [YYLTS_dataParams setValue:accountStr forKey:@"username"];
        [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getUUIDString] forKey:@"idfv"];
        [YYLTS_dataParams setValue:[SimpleSDK_Tools func_getOSVersion] forKey:@"version"];
        [YYLTS_dataParams setValue:kSDKVersion forKey:@"sdkVersion"];
       
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];

    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

        NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkApplePayService,dataStr,kProductKey];
        
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str ] forKey:@"sign"];
 
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        block(status,msg);
    }];
}

+ (void)func_uploadOrderState:(NSDictionary *)params FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block {
    NSString *accountStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"]];
    NSMutableDictionary *mParams = [NSMutableDictionary new];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkPayOrderStatuesService forKey:@"service"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    NSMutableDictionary *YYLTS_dataParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [YYLTS_dataParams setValue:accountStr forKey:@"username"];
    [YYLTS_dataParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5udidstr] forKey:@"udid"];

    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:YYLTS_dataParams] forKey:@"data"];
        
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:YYLTS_dataParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkPayOrderStatuesService,dataStr,kProductKey];
    
    [mParams setValue:[SimpleSDK_Tools  func_getStrMD5:md5str] forKey:@"sign"];
    
    [SimpleSDK_Network func_request: kApiHost params:mParams FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
        block(status,msg);
    }];
}
@end
