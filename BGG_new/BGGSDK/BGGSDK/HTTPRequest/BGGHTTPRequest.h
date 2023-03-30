//
//  BGGHTTPRequest.h
//  SYSDK
//
//  Created by 黄晓丹 on 2017/11/30.
//  Copyright © 2017年 qianhai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGGPCH.h"
#import "BGGRoleData.h"
#import "BGGPMData.h"

typedef void(^SuccessBlock)(NSInteger returnCode, NSString *returnMsg, id data);
typedef void(^SuccessPageBlock)(NSInteger returnCode, NSString *returnMsg, id data, NSInteger totalPage);
typedef void(^FailBlock)(NSError *error);
typedef void (^ErrorCodeBlock) (NSInteger errorCode,NSString *returnMsg);
typedef void(^ReturnValueBlock)(id returnValue);

@interface BGGHTTPRequest : NSObject


/**
*  手机号码注册
*/
+(void)BGGMobileAndCodeRegister:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;

/**
*  获取验证码
*/
+(void)BGGSendSMSWithMobile:(NSString *)mobile successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;


/**
*  快速注册
*/
+(void)BGGGetFastLoginAccountAndPassSsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
*  账号密码登录
*/
+(void)BGGAccountPasswordLoginWithAccount:(NSString *)account password:(NSString *)password SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;


/**
 账号或手机号注销
 */
+(void)BGGCancleWithAccountOrPhone:(NSString *)accountOrPhone password:(NSString *)password SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;

/**
 *  找回密码
 */
+(void)BGGGetNewPWDWithMobile:(NSString *)mobile code:(NSString *)code newPWD:(NSString *)newPWD SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *  校验手机格式
 */
+(void)BGGCheckMobile:(NSString *)mobile SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *  手机验证码登陆
 */
+(void)BGGMobileAndCodeLogin:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *  SDK退出登陆
 */
+(void)BGGSDKLogoutSsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *  实名认证
 */
+(void)BGGrealNameAuthWithName:(NSString *)name IDCard:(NSString *)idCard SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;

/**
 * 绑定手机
 */
+(void)BGGBindingMobileWithMobile:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 * 上传角色数据
 */
+(void)BGGUploadRoleDataWith:(BGGRoleData *)roleData SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 * 统一创建订单
 */
+(void)BGGCreateOrderWith:(BGGPMData *)PMData successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 * 根据token获取用户信息
 */
+(void)BGGGetUserInfoByTokensuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 * 获取game配置的信息
 */
+(void)BGGGetGameConfigsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 * 游戏版本控制
 */
+(void)BGGGameVersionCOntrolWithSDKVersion:(NSString *)sdkVersion gameVersion:(NSString *)gameVersion successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *支付结果查询
 */
+(void)BGGGetPMResultRecordNumber:(NSString *)recordNumber rechargeType:(NSString *)rechargeType successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *判断手机号码是否存在
 */
+(void)BGGPanDuanMobileExistMobile:(NSString *)mobile successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *用户心跳检测
 */
+(void)BGGHeartBeatsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *苹果支付验证订单接口
 */
+(void)BGGAppStoreWithpayRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *用户打开游戏记录日志接口
 */
+(void)BGGOpenGameUpLoadsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *获取地理位置
 */

+(void)BGGLocationsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *支付结果查询
 */
+(void)BGGPM1WithRecordNUmber:(NSString *)recordNumber successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
+(void)BGGPM2WithRecordNUmber:(NSString *)recordNumber successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
/**
 *获取隐私协议信息
 */
+(void)BGGPrivacysuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock;
@end
