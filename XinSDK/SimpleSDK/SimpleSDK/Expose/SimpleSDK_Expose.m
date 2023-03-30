//
//  SimpleSDK_Expose.m
//  SimpleSDK
//
//  Created by XYL on 2021/12/1.
//

#import "SimpleSDK_Expose.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Network.h"
#import "SimpleSDK_ViewManager.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_IPAManager.h"
#import "SimpleSDK_AlterCancelMsg.h"


@interface SimpleSDK_Expose ()


/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SimpleSDK_Expose

+ (instancetype)sharedInstance {
    static SimpleSDK_Expose *_instance = nil;
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


-(void)func_startIdfaWithBlock:(UIApplication * )application{
    if (@available(iOS 14, *)) {
           // iOS14及以上版本需要先请求权限
           [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
               // 获取到权限后，依然使用老方法获取idfa
               switch (status) {
                   case ATTrackingManagerAuthorizationStatusNotDetermined:
                       
                       break;
                   case ATTrackingManagerAuthorizationStatusRestricted:
                       
                       break;
                   case ATTrackingManagerAuthorizationStatusDenied:
                       
                       break;
                   case ATTrackingManagerAuthorizationStatusAuthorized:
                       break;
               }
           }];
       }
       else
       {
           if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
               NSString *idfas = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
               
           } else {
          
           }
       }
}


-(void) func_startInitWithBlock:(void(^)(BOOL status, NSString *msg,NSString *isAudit))block{
    [SimpleSDK_Expose sharedInstance].initHandle = block;
    if(kDictNotNull([SimpleSDK_DataTools manager].appInfo)){
        if(block){
            NSString * isAudit = [[SimpleSDK_DataTools manager].appInfo objectForKey:@"isAudit"];
            block(YES,@"初始化成功",isAudit);
        }
        return;
    }
    [SimpleSDK_ApiManager func_sdkInit];
}



- (void)func_startLoginWithBlock:(void (^)(BOOL, NSString * _Nonnull, NSDictionary * _Nonnull))handlelogin HandleLogout:(void (^)(BOOL, NSString * _Nonnull))handleLgout{
    [SimpleSDK_Expose sharedInstance].loginHandle = handlelogin;
    [SimpleSDK_Expose sharedInstance].logoutHandle = handleLgout;
    
    //如果初始化参数为空，再次初始化
    if(!kDictNotNull([SimpleSDK_DataTools manager].appInfo)){
        if([SimpleSDK_Expose sharedInstance].initHandle){
            [[SimpleSDK_Expose sharedInstance] func_startInitWithBlock:[SimpleSDK_Expose sharedInstance].initHandle];
            return;
        }
        [SimpleSDK_Toast showToast:@"SDK 未初始化！" location:@"center" showTime:2.5];
        return;
    }
    
    [SimpleSDK_ViewManager func_showLoginViewOfHandle:^(NSDictionary * _Nonnull loginData) {
        
        [SimpleSDK_DataTools.manager func_setUserInfo:loginData];
        //封装登陆数据返回给cp
        NSMutableDictionary *tempData = [NSMutableDictionary new];
        if (kDictNotNull(loginData)) {
            [tempData setValue:kGameId forKey:@"appid"];
            [tempData setValue:[loginData valueForKey:@"sid"] forKey:@"token"];
            [tempData setValue:[loginData valueForKey:@"uid"] forKey:@"uid"];
            [tempData setValue:[loginData valueForKey:@"user_name"] forKey:@"username"];
            [tempData setValue:[SimpleSDK_Tools func_getTimesTamp] forKey:@"time"];
        }
        if (handlelogin) {
            handlelogin(YES,@"Success",tempData);
        }
        //弹出登录成功欢迎界面
        [SimpleSDK_ViewManager func_showWelcomView];
        
        //处理掉单问题
        [SimpleSDK_IPAManager func_startScanLocal];
    
        //拉取好评
        [SimpleSDK_ApiManager func_getReviewMsg:loginData];
        //启动心跳
        NSString *heartBeat  = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"heart_beat"];
        if (heartBeat.intValue ==1) {
            [SimpleSDK_ApiManager func_startHeartbeat];
        }
      
        //判断是否显示悬浮球
        [SimpleSDK_ViewManager func_showFloatView];
        
        //判断注销后重新登录提示取消注销
        NSString *cancelLoginStr = [NSString stringWithFormat:@"%@",[loginData objectForKey:@"cancel_undo_text"]];
        
        if (!kStringIsNull(cancelLoginStr)) {
            
            [SimpleSDK_AlterCancelMsg func_showLoginCancelWithMsg:cancelLoginStr];
        }
       
        NSString *trueNameSwitchStr  = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"trueNameSwitch"];
        NSString *fcm = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"fcm"];
        //判断是否弹出实名  1，弹出不可关闭实名。 2，弹出可以关闭实名。 0，不弹出实名
        if (![@"0" isEqualToString:trueNameSwitchStr]) {
            if(fcm.intValue == 0){
                //没有认证过的弹出来
                [SimpleSDK_ViewManager func_showCertificationView:trueNameSwitchStr];
            }else{
                //如果不实名直接弹出
                [SimpleSDK_ViewManager func_showGiftFloatView];
            }
        }else{
            //如果不实名直接弹出
            [SimpleSDK_ViewManager func_showGiftFloatView];
        }
    }];
    
}

- (void)func_startReportWithBlock:(NSString *)uploadType UploadDic:(NSDictionary *)dic FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    
    if (!kDictNotNull([SimpleSDK_DataTools manager].userInfo)) {
        [SimpleSDK_Toast showToast:@"账号未登录！" location:@"center" showTime:2.5];
        return;
    }
    [SimpleSDK_ApiManager func_uploadMsgDic:uploadType params:dic FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
        block(status,msg);
    }];
}

- (void)func_startCreateOrderWithBlcok:(NSDictionary *)helpDic FuncBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    
    if (!kDictNotNull([SimpleSDK_DataTools manager].userInfo)) {
        [SimpleSDK_Toast showToast:@"账号未登录！" location:@"center" showTime:2.5];
        return;
    }
    [SimpleSDK_ApiManager func_createOrder:helpDic FuncBlock:^(BOOL status, NSString * _Nonnull msg) {
        block(status,msg);
    }];
    
}

- (void)func_startLogoutWithBlock:(void (^)(BOOL, NSString * _Nonnull))block{
    if (!kDictNotNull([SimpleSDK_DataTools manager].userInfo)) {
        [SimpleSDK_Toast showToast:@"账号未登录！" location:@"center" showTime:2.5];
        return;
    }
    //首先移除掉悬浮球
    [SimpleSDK_ViewManager func_removeFloatView];
    //移除礼包悬浮球
    [SimpleSDK_ViewManager func_removeCodeFloatView];
    [SimpleSDK_ApiManager func_logout:^(BOOL status) {
        if (status) {
            block(YES,@"退出成功！");
        }
    }];
}

@end
