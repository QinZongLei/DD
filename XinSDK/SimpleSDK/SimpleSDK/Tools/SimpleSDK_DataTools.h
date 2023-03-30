//
//  SimpleSDK_DataTools.h
//  SimpleSDK
//
//  Created by mac on 2021/12/13.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_DataTools : NSObject

//初始化
@property (nonatomic,readonly, strong) NSDictionary  *appInfo;
//开关
@property (nonatomic,readonly, strong) NSDictionary  *switchInfo;
//登录成功
@property (nonatomic, readonly, strong) NSDictionary *userInfo;
//信息
@property (nonatomic, readonly, strong) NSMutableArray *msgInfo;
//礼包码
@property (nonatomic, readonly, strong) NSDictionary *reviewInfo;
//公从号
@property (nonatomic, readonly, strong) NSDictionary *publicCodeInfo;
//客服链接
@property (nonatomic, readonly, strong) NSDictionary *customerInfo;

@property (nonatomic, copy) NSString *userkey;

@property (nonatomic, copy) NSString *userAgentstr;

@property (nonatomic, copy) NSString *idfaStr;

@property (nonatomic, strong) WKWebView *webview;

@property (nonatomic, copy) NSString *projcetState;

@property (nonatomic ,copy) NSString *nameTextStr;

+ (instancetype)manager;

-(void)func_setAppInfo:(NSDictionary *) dic;

- (void)func_setSwitchInfo:(NSDictionary *)dic;

-(void)func_setUserInfo:(NSDictionary *) dic;

-(void)func_setMsgInfo:(NSDictionary *) dic;

-(void)func_setReviewInfo:(NSDictionary *)dic;

-(void)func_setPublicCodeInfo:(NSDictionary *) dic;

- (void)func_setCustomerInfo:(NSDictionary *)dict;

//保存账号
//@param account 账号
//@param password 密码
// @param type 类型。1-账号。 2-手机号
+ (void)func_saveAccountOfPhone:(NSString *)account password:(NSString *)password type:(NSString *)type;

///获取所有的账号
+ (NSArray *)func_getAllAccount;

//删除某个账号
+ (void)func_deleteAccount:(NSString *)account;

//获取用户中心数据
+(NSMutableArray *)func_getUserCenter;

//获取用户中心数据
+(NSMutableArray *)func_getMenuList;

//判断是否有消息并且已经阅读
+(BOOL)func_isMsgRed;
@end

NS_ASSUME_NONNULL_END
