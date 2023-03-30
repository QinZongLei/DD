
//
//  BGGRequestUrl.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#ifndef BGGRequestUrl_h
#define BGGRequestUrl_h



#define KBaseUrl [NSString stringWithFormat:@"htt%@%@youxi.com",@"p://api.",@"jiayou"]
#define KGateWay @"/game-app-server-api/api/v1/"
#define K2GateWay @"/game-app-server-api/api/v2/"
#define KUrl     [KBaseUrl stringByAppendingString:KGateWay]
#define KUrl2     [KBaseUrl stringByAppendingString:K2GateWay]
#define isSecrect @YES


//快速注册
#define BGGFastLogin [KUrl stringByAppendingString:@"account/register/rapid"]
//账号密码登录
#define BGGAccountPasswordLogin [KUrl stringByAppendingString:@"account/login/account"]
//获取验证码
#define BGGSendSMS [KUrl stringByAppendingString:@"msg/code/send/mobile"]
//找回密码
#define BGGGetNewPWD [KUrl stringByAppendingString:@"account/user/update/password"]
//校验手机格式
#define BGGCheckMobilehh [KUrl stringByAppendingString:@"msg/code/check/mobile"]
//手机验证码登陆
#define BGGMobileCodeLogin  [KUrl stringByAppendingString:@"account/login/mobile"]
//SDK退出登陆
#define BGGSDKLogout [KUrl stringByAppendingString:@"account/logout"]
//实名认证
#define BGGSMRZ [KUrl stringByAppendingString:@"account/user/realname/auth"]
//绑定手机
#define BGGBindingMobile [KUrl stringByAppendingString:@"account/user/bind/mobile"]
//上传角色数据
#define BGGUploadRoleEventData [KUrl stringByAppendingString:@"sys/log/save/event"]
//统一创建订单
#define BGGOrderCreate [KUrl stringByAppendingString:@"pay/order/create"]
//根据token获取用户信息
#define BGGUserInfoByToken [KUrl stringByAppendingString:@"account/user/get/info"]
//获取game配置的信息
#define BGGGameConfig [KUrl stringByAppendingString:@"sys/game/config"]
//用户打开游戏记录日志
#define BGGOpenLog [KUrl stringByAppendingString:@"sys/log/app/open"]
//游戏版本控制
#define BGGVersionControl [KUrl stringByAppendingString:@"sys/version/check/ios"]
//支付结果查询
#define BGGPMResult [KUrl stringByAppendingString:@"pay/order/get/result"]
//判断手机号码是否存在
#define BGGMobileExist  [KUrl stringByAppendingString:@"account/user/exist/mobile"]
//用户心跳检测
#define BGGUserHertBeat [KUrl2 stringByAppendingString:@"account/user/line_heart"]
//苹果支付验证订单接口
#define BGGAppStore [KUrl stringByAppendingString:@"pay/app/store/verify"]
//用户打开游戏记录日志接口
#define BGGGameOpen [KUrl stringByAppendingString:@"sys/log/app/open"]
//获取地理位置
#define BGGGetLocation @"http://whois.pconline.com.cn/ipJson.jsp"
//支付结果查询
#define BGGPM1Status [KUrl stringByAppendingString:@"xxx"]
#define BGGPM2Status [KUrl stringByAppendingString:@"xxx"]

//手机号注册接口
#define BGGMobileRegister [KUrl stringByAppendingString:@"account/register/mobile"]
//获取隐私协议信息
#define BGGPrivacy [KUrl stringByAppendingString:@"sys/game/privacy/agreement"]

//账号或者手机号注销
#define BGGCancelAccountOrPhone [KUrl stringByAppendingString:@"account/user/cancellation"]


#endif /* BGGRequestUrl_h */
