//
//  SimpleSDK_ViewManager.m
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import "SimpleSDK_ViewManager.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_Tools.h"
#import "SImpleSDK_DataTools.h"
#import "SimpleSDK_PermissionsView.h"
#import "SimpleSDK_PermissionsConfirmView.h"
#import "SImpleSDK_LoginChooseView.h"
#import "SimpleSDK_FastRegisteredView.h"
#import "SimpleSDK_PhoneRegisteredView.h"
#import "SimpleSDK_LoginView.h"
#import "SimpleSDK_AccountRegisteredView.h"
#import "SimpleSDK_FindPwdView.h"
#import "SimpleSDK_ScreenshotsView.h"
#import "SimpleSDK_FloatView.h"
#import "SimpleSDK_UserCenterView.h"
#import "SimpleSDK_PublicCodeView.h"
#import "SimpleSDK_MsgListView.h"
#import "SimpleSDK_AccountMenuView.h"
#import "SimpleSDK_UpdatePwdView.h"
#import "SimpleSDK_BindPhoneView.h"
#import "SimpleSDK_IdCardCertificationView.h"
#import "SimpleSDK_MsgDetailsView.h"
#import "SimpleSDK_UpdatePhonePwdView.h"
#import "SimpleSDK_WelcomeView.h"
#import "SimpleSDK_GiftFloatView.h"
#import "SimpleSDK_GiftCodeView.h"
#import "SimpleSDK_GiftCommentAlterView.h"
#import <SafariServices/SafariServices.h>

@implementation SimpleSDK_ViewManager

+ (instancetype)sharedInstance {
    static SimpleSDK_ViewManager *_instance = nil;
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

+ (void)func_showGetPermissionsView{
    NSUserDefaults *firstLaunch = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunchStr = [firstLaunch objectForKey:@"firstLaunch"];
    if (kStringIsNull(firstLaunchStr)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([view isKindOfClass:[SimpleSDK_PermissionsView class]]) {
                    [view removeFromSuperview];
                    break;
                 }
            }
            
            SimpleSDK_PermissionsView *permissionsView = [[SimpleSDK_PermissionsView alloc]  initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            [topView bringSubviewToFront:permissionsView];
            [topView addSubview:permissionsView];
        });
    }
}

+ (void)func_showPermissionsConfirmView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_PermissionsConfirmView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_PermissionsConfirmView *permissionsConfirmView = [[SimpleSDK_PermissionsConfirmView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:permissionsConfirmView];
        [topView addSubview:permissionsConfirmView];
    });
}

+ (void)func_showLoginChoonseView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_LoginChooseView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_LoginChooseView *loginChooseView = [[SimpleSDK_LoginChooseView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:loginChooseView];
        [topView addSubview:loginChooseView];
    });
}

//弹出登陆界面
+ (void)func_showLoginViewOfHandle:(void (^)(NSDictionary * _Nonnull))handle{
    if (handle) {
        [SimpleSDK_ViewManager sharedInstance].loginHandle = handle;
    }
    //弹出登陆注册界面
    NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
    NSString *waystr = [wayforlogin objectForKey:@"loginway"];
    //判断上次用户登陆方式，这次打开就显示什么登陆方式
    if ([@"phoneway" isEqualToString:waystr]) {
        if ([SimpleSDK_Tools func_timeout:waystr]) {
            //快捷登录
            [SimpleSDK_ApiManager func_phoneQuicklogin:^(BOOL status) {
                if (!status) {
                    //快捷登录失败直接返回登录界面
                    [SimpleSDK_ViewManager func_showPhoneLoginOrRegisteredView];
                }
            }];
        }else{
            //去登陆界面
            [SimpleSDK_ViewManager func_showPhoneLoginOrRegisteredView];
        }
    }else if ([@"acountway" isEqualToString:waystr]){
        if ([SimpleSDK_Tools func_timeout:waystr]) {
            //快捷登录
            [SimpleSDK_ApiManager func_accountQuicklogin:^(BOOL status) {
                if (!status) {
                    [SimpleSDK_ViewManager func_showAccountLoginView];
                }
            }];
        }else{
            //去登陆界面
            [SimpleSDK_ViewManager func_showAccountLoginView];
        }
        
    }else{
        //如果一次么有。 直接显示登陆主界面
        [self func_showLoginChoonseView];
    }
    
    //弹出权限获取界面
//    if ([@"1" isEqualToString:[SimpleSDK_DataTools manager].projcetState]) {
//        [self func_showGetPermissionsView];
//    }
    
}


+(void)func_showWelcomView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_WelcomeView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_WelcomeView *welcomeView= [[SimpleSDK_WelcomeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:welcomeView];
        [topView addSubview:welcomeView];
    });
}

+ (void)func_showFastRegisteredView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_FastRegisteredView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_FastRegisteredView *fastRegisteredView= [[SimpleSDK_FastRegisteredView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:fastRegisteredView];
        [topView addSubview:fastRegisteredView];
    });
}

+ (void)func_showPhoneLoginOrRegisteredView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_PhoneRegisteredView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_PhoneRegisteredView *phoneRegisteredView = [[SimpleSDK_PhoneRegisteredView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:phoneRegisteredView];
        [topView addSubview:phoneRegisteredView];
    });
}

+ (void)func_showAccountLoginView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_LoginView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
       
        SimpleSDK_LoginView *loginView = [[SimpleSDK_LoginView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:loginView];
        [topView addSubview:loginView];
    });
}

+ (void)func_showManagerView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_ManagerView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_ManagerView *managerView= [[SimpleSDK_ManagerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:managerView];
        [topView addSubview:managerView];
    });
}



+(void)func_showCancelAccountView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_AccountCancelView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_AccountCancelView *accountCancelView= [[SimpleSDK_AccountCancelView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:accountCancelView];
        [topView addSubview:accountCancelView];
    });
    
    
}


+(void)func_showCancelPhoneView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_PhoneCancelView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_PhoneCancelView *phoneCancelView= [[SimpleSDK_PhoneCancelView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:phoneCancelView];
        [topView addSubview:phoneCancelView];
    });
    
}

+ (void)func_showAccountRegisteredView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_AccountRegisteredView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_AccountRegisteredView *accountRegisteredView= [[SimpleSDK_AccountRegisteredView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:accountRegisteredView];
        [topView addSubview:accountRegisteredView];
    });
}

//暂时不需要
+ (void)func_showFindPwdView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_FindPwdView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_FindPwdView *findPwdView = [[SimpleSDK_FindPwdView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:findPwdView];
        [topView addSubview:findPwdView];
    });
}

+ (void)func_showScreenshotsView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_ScreenshotsView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_ScreenshotsView *screenshotsView= [[SimpleSDK_ScreenshotsView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:screenshotsView];
        [topView addSubview:screenshotsView];
    });
}

+ (void)func_showFloatView{
    NSString * buoyState= [[SimpleSDK_DataTools manager].userInfo objectForKey:@"buoyState"];
    if([@"open" isEqualToString:buoyState]){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([view isKindOfClass:[SimpleSDK_FloatView class]]) {
                    [view removeFromSuperview];
                    break;
                 }
            }
            SimpleSDK_FloatView *floatView = [[SimpleSDK_FloatView alloc] initWithFrame:CGRectMake(0, kWidth(50), kWidth(70), kWidth(70))];
            
            [[UIApplication sharedApplication].keyWindow addSubview:floatView];
        });
    }
}


+(void)func_showGiftFloatView{
    NSString *giftCodeFloatStr = [[NSUserDefaults standardUserDefaults] objectForKey:kFlagHidenGiftCodeFloat];
    NSString * giftState= [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].switchInfo objectForKey:@"display_app_store"]];

    
    if((![@"HidenGiftCodeFloat" isEqualToString:giftCodeFloatStr]) && [@"1" isEqualToString:giftState]){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([view isKindOfClass:[SimpleSDK_GiftFloatView class]]) {
                    [view removeFromSuperview];
                    break;
                 }
            }
            SimpleSDK_GiftFloatView *giftFloatView = [[SimpleSDK_GiftFloatView alloc] initWithFrame:CGRectMake(SCREENWIDTH-kWidth(120), SCREENHEIGHT - kWidth(150), kWidth(80), kWidth(80))];
            
            [[UIApplication sharedApplication].keyWindow addSubview:giftFloatView];
        });
    }
}

///  弹出好评详情
+(void)func_showGiftCommentAlterView{
    NSString *giftCodeFloatStr = [[NSUserDefaults standardUserDefaults] objectForKey:kFlagHidenGiftCodeFloat];
    NSString * giftState= [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].switchInfo objectForKey:@"display_app_store"]];

    
    if((![@"HidenGiftCodeFloat" isEqualToString:giftCodeFloatStr]) && [@"1" isEqualToString:giftState]){
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([view isKindOfClass:[SimpleSDK_GiftCommentAlterView class]]) {
                    [view removeFromSuperview];
                    break;
                 }
            }
            UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
            SimpleSDK_GiftCommentAlterView *giftCommentView = [[SimpleSDK_GiftCommentAlterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            giftCommentView.tag = 2001206;
            [topView addSubview:giftCommentView];
        });
    }
}


+(void)func_showGiftCommentAlterCodeView{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_GiftCodeView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        SimpleSDK_GiftCodeView *giftCommentView = [[SimpleSDK_GiftCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        giftCommentView.tag = 2001206;
        [topView addSubview:giftCommentView];
    });
}

+ (void)func_showUserCenterView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_UserCenterView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_UserCenterView *userCenterView= [[SimpleSDK_UserCenterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:userCenterView];
        [topView addSubview:userCenterView];
    });
}

+ (void)func_showPublicCodeView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_PublicCodeView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_PublicCodeView *publicCodeView= [[SimpleSDK_PublicCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:publicCodeView];
        [topView addSubview:publicCodeView];
    });
}

+ (void)func_showMsgListView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_MsgListView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_MsgListView *msgListView= [[SimpleSDK_MsgListView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:msgListView];
        [topView addSubview:msgListView];
    });
}

+(void)func_showMsgDetailsView:(NSMutableDictionary *)msgDic{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_MsgDetailsView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_MsgDetailsView *msgDetailsView= [[SimpleSDK_MsgDetailsView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        msgDetailsView.detailedDict = msgDic;
        [topView bringSubviewToFront:msgDetailsView];
        [topView addSubview:msgDetailsView];
    });
}

+ (void)func_showAccountMenuView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_AccountMenuView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_AccountMenuView *menuView= [[SimpleSDK_AccountMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:menuView];
        [topView addSubview:menuView];
    });
}

+ (void)func_showUpdatePwdView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_UpdatePwdView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_UpdatePwdView *updatePwdView= [[SimpleSDK_UpdatePwdView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:updatePwdView];
        [topView addSubview:updatePwdView];
    });
}

+ (void)func_showUpdatephonePwdView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_UpdatePhonePwdView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_UpdatePhonePwdView *updatePwdView= [[SimpleSDK_UpdatePhonePwdView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:updatePwdView];
        [topView addSubview:updatePwdView];
    });
}

+ (void)func_showBindPhoneView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_BindPhoneView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_BindPhoneView *bindPhoneView= [[SimpleSDK_BindPhoneView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [topView bringSubviewToFront:bindPhoneView];
        [topView addSubview:bindPhoneView];
    });
}

+ (void)func_showCertificationView:(NSString *)showType{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *topView = [SimpleSDK_Tools func_getTopViewControlle];
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_IdCardCertificationView class]]) {
                [view removeFromSuperview];
                break;
             }
        }
        SimpleSDK_IdCardCertificationView *certificationView= [[SimpleSDK_IdCardCertificationView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        certificationView.showType = showType;
        
        [topView bringSubviewToFront:certificationView];
        [topView addSubview:certificationView];
    });
}

+ (void)func_showHelpView:(NSString *)urlStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * urlEndcode= [SimpleSDK_Tools func_urlUTF8Encoding:urlStr];
        SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlEndcode]];
        UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [topVC presentViewController:safariVc animated:YES completion:nil];
    });
}

//移除登陆框
+ (void)func_renoveLoginView{
    
}

+ (void)func_removeFloatView{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_FloatView class]]) {
                [view removeFromSuperview];
            }
        }
    });
}


+ (void)func_removeCodeFloatView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([view isKindOfClass:[SimpleSDK_GiftFloatView class]]) {
                [view removeFromSuperview];
            }
        }
    });
    
}

@end
