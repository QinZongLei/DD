//
//  SimpleSDK_ViewManager.h
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_ViewManager : NSObject

@property (nonatomic, strong) void (^logoutHandle) (NSDictionary *logoutData);

@property (nonatomic, copy) void (^loginHandle) (NSDictionary *loginData);

+ (instancetype)sharedInstance;

#pragma mark ---- Show View ----
//弹出获取权限协议界面
+(void)func_showGetPermissionsView;

//权限申请确认框
+(void)func_showPermissionsConfirmView;

//弹出登陆选择界面
+(void)func_showLoginChoonseView;

//账号管理界面
+(void)func_showManagerView;

//账号注销界面
+(void)func_showCancelAccountView;

//手机号注销界面
+(void)func_showCancelPhoneView;

//跳转快速注册界面
+(void)func_showFastRegisteredView;

//弹出手机登陆Or 手机注册界面
+(void)func_showPhoneLoginOrRegisteredView;

//弹出账号注册界面
+(void)func_showAccountRegisteredView;

//弹出登陆界面
+(void)func_showAccountLoginView;

//弹出找回密码界面
+(void)func_showFindPwdView;

//弹出实名认证界面
+(void)func_showCertificationView:(NSString *)showType;

//弹出绑定手机界面
+(void)func_showBindPhoneView;

//弹出修改密码界面
+(void)func_showUpdatePwdView;

//去手机修改密码界面
+(void)func_showUpdatephonePwdView;

//弹出我的界面
+(void)func_showAccountMenuView;

//弹出消息列表界面
+(void)func_showMsgListView;

//弹出消息详情界面
+(void)func_showMsgDetailsView:(NSMutableDictionary *)msgDic;

//弹出公众号界面
+(void)func_showPublicCodeView;

//弹出截图界面
+(void)func_showScreenshotsView;

//弹出悬浮球
+(void)func_showFloatView;

//弹出好评图标
+(void)func_showGiftFloatView;

//弹出好评详细
+(void)func_showGiftCommentAlterView;

//弹出好评二维码
+(void)func_showGiftCommentAlterCodeView;

//弹出用户中心
+(void)func_showUserCenterView;

//弹出欢迎界面
+(void)func_showWelcomView;

//弹出H5界面
+(void)func_showHelpView:(NSString *)urlStr;

//弹出登陆界面
+(void)func_showLoginViewOfHandle:(void(^)(NSDictionary *loginData))handle;

#pragma mark ---- remove View ----
//移除登陆框
+(void)func_renoveLoginView;

//移除悬浮球
+(void)func_removeFloatView;

//移除礼包码
+(void)func_removeCodeFloatView;

@end

NS_ASSUME_NONNULL_END
