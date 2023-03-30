//
//  SimpleSDK_ApiManager.h
//  SimpleSDK
//
//  Created by admin on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_ApiManager : NSObject

+ (instancetype)sharedInstance;

//初始化
+(void)func_sdkInit;

//实名认证文本
+(void)func_getTrueNameText;

//sdk后台开关
+(void)func_controlSdkSwitch;

//获取客服链接
+(void)func_getCustomerService;

//账号登陆
+(void)func_accountLogin:(NSString *)accountStr passwordStr:(NSString *)pwdStr FuncBlock: (void(^)(BOOL status))block;

//账号or手机号注销
+(void)func_cancelAccounOrPhone:(NSString *)accountOrPhone passwordOrCodeStr:(NSString *)pwdOrCodeStr typeStr:(NSString *)type FuncBlock: (void(^)(BOOL status, NSString *msg,NSDictionary * dic))block;

//注册
+(void)func_accountRegistered:(NSString *)accountStr passwordStr:(NSString *)pwdStr FuncBlock: (void(^)(BOOL status))block;

//手机注册以及登陆
+(void)func_phoneloginOrRegistered:(NSString *)phoneStr codeStr:(NSString *)codeStr FuncBlock: (void(^)(BOOL status))block;

//手机号快捷登录
+(void)func_phoneQuicklogin:(void(^)(BOOL status))block;

//账号快捷登录
+(void)func_accountQuicklogin:(void(^)(BOOL status))block;

//绑定手机
+(void)func_bindPhone:(NSString *)phoneStr codeStr:(NSString *)codeStr FuncBlock: (void(^)(BOOL status))block;

//找回密码
+(void)func_findPwd:(NSString *)accountStr PhoneStr:(NSString *)phoneStr CodeStr:(NSString *)codeStr PasswordStr:(NSString *)pwdStr FuncBlock: (void(^)(BOOL status))block;

//修改密码
+(void)func_updatapwd:(NSString *)oldPwd newPwd:(NSString *) newPwd FuncBlock:(void(^)(BOOL status))block;

//手机登录修改密码(验证手机号和验证码)
+(void)func_checkUserMobileCode:(NSString *)accountStr phoneStr:(NSString *)phone phoneCode:(NSString *) code FuncBlock:(void(^)(BOOL status))block;

//获取验证码
+(void)func_getPhoneCode:(NSString *)phoneStr type:(NSString *) type FuncBlock: (void(^)(BOOL status))block;

//实名认证
+(void)func_realNameAuthentication:(NSString *)nickName idCard:(NSString *) idCard FuncBlock: (void(^)(BOOL status))block;

//数据上报
+(void)func_uploadMsgDic:(NSString *)actiontype params:(NSDictionary *)params  FuncBlock:(void(^)(BOOL status , NSString *msg))block;

//退出登录
+(void)func_logout:(void(^)(BOOL status))block;

//获取消息列表
+(void)func_getMsgList:(NSDictionary *)dic;

//获好评信息
+(void)func_getReviewMsg:(NSDictionary *)dic;

//拉去公众号信息
+(void)func_getPublicCode;

//归因数据上传
+(void)func_uploadASAAndIADInfo:(NSDictionary *)dic;

//启动心跳接口
+(void)func_startHeartbeat;

//调起支付
+(void)func_createOrder:(NSDictionary *)params  FuncBlock:(void(^)(BOOL status , NSString *msg))block;

//获取支付方式
+(void)func_getPyState:(NSString *)price roleLevel:(NSString *)roleLevel  roleID:(NSString *)roleID FuncBlock:(void(^)(BOOL status, NSString *msg,NSDictionary * dic))block;

//提交订单信息
+(void)func_uploadOrder:(NSDictionary  *)orderDic FuncBlock:(void(^)(BOOL status, NSString *msg,NSDictionary * dic))block;

//验证单
+(void)func_verifyOrder:(NSDictionary  *)orderDic cost:(NSString *)cost receiptData:(NSString *)receiptData FuncBlock:(void(^)(BOOL status, NSString *msg))block;

//上报支付状态
+(void)func_uploadOrderState:(NSDictionary *)params FuncBlock:(void(^)(BOOL status, NSString *msg))block;

@end

NS_ASSUME_NONNULL_END
