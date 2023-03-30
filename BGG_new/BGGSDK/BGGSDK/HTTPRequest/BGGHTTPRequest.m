
#import "BGGHTTPRequest.h"
#import "BGGBaseRequest.h"
#import "BGGRequestUrl.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "BGGDataModel.h"

@implementation BGGHTTPRequest


#pragma mark - ==== 获取验证码 ====
+(void)BGGSendSMSWithMobile:(NSString *)mobile successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"mobile"] = mobile;
    dict[@"phoneKey"] = [BGGDeviceInfo getAdvertisingIdentify];
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGSendSMS parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        
        SuccessBlock(returnCode,returnMsg,data);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}


#pragma mark - ==== 快速注册 ====
+(void)BGGGetFastLoginAccountAndPassSsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"simulator"] = [NSNumber numberWithBool:NO];
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"deviceType"] = @"Ios";
    dict[@"timeZone"] = [BGGDataModel sharedInstance].timeZone;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
  
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGFastLogin parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark - ==== 账号密码登录 ====
+(void)BGGAccountPasswordLoginWithAccount:(NSString *)account password:(NSString *)password SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    
    dict[@"simulator"] = [NSNumber numberWithBool:NO];
    dict[@"simulator"] = [NSNumber numberWithBool:NO];
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"deviceType"] = @"Ios";
    dict[@"timeZone"] = [BGGDataModel sharedInstance].timeZone;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    dict[@"userName"] = account;
    dict[@"password"] = password;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGAccountPasswordLogin parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark - ====账号或手机号注销 ====
+(void)BGGCancleWithAccountOrPhone:(NSString *)accountOrPhone password:(NSString *)password SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"username"] = accountOrPhone;
    dict[@"password"] = password;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGCancelAccountOrPhone parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
    
    
    
}

#pragma mark - ==== 找回密码 ====
+(void)BGGGetNewPWDWithMobile:(NSString *)mobile code:(NSString *)code newPWD:(NSString *)newPWD SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile;
    dict[@"code"] = code;
    dict[@"newPassword"] = newPWD;
    
   
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGGetNewPWD parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark - ==== 校验手机格式 ====
+(void)BGGCheckMobile:(NSString *)mobile SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile;



    [[BGGBaseRequest sharedManager]  BBGPOST:BGGCheckMobilehh parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 手机号码注册 ====
+(void)BGGMobileAndCodeRegister:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    
    dict[@"simulator"] = [NSNumber numberWithBool:NO];
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"deviceType"] = @"Ios";
    dict[@"timeZone"] = [BGGDataModel sharedInstance].timeZone;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    dict[@"mobile"] = mobile;
    dict[@"code"] = code;

    [[BGGBaseRequest sharedManager]  BBGPOST:BGGMobileRegister parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 手机验证码登陆 ====
+(void)BGGMobileAndCodeLogin:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"simulator"] = [NSNumber numberWithBool:NO];
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"deviceType"] = @"Ios";
    dict[@"timeZone"] = [BGGDataModel sharedInstance].timeZone;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    dict[@"mobile"] = mobile;
    dict[@"code"] = code;



    [[BGGBaseRequest sharedManager]  BBGPOST:BGGMobileCodeLogin parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}

#pragma mark - ==== SDK退出登陆 ====
+(void)BGGSDKLogoutSsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [BGGDataModel sharedInstance].sdkUserToken;
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGSDKLogout parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 实名认证 ====
+(void)BGGrealNameAuthWithName:(NSString *)name IDCard:(NSString *)idCard SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"realName"] = name;
    dict[@"idCard"] = idCard;
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGSMRZ parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 绑定手机 ====
+(void)BGGBindingMobileWithMobile:(NSString *)mobile code:(NSString *)code SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    
    dict[@"mobile"] = mobile;
    dict[@"code"] = code;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGBindingMobile parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 上传角色数据 ====
+(void)BGGUploadRoleDataWith:(BGGRoleData *)roleData SsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"dsId"] = roleData.serverId;
    dict[@"dsName"] = roleData.serverName;
    dict[@"drId"] = roleData.roleId;
    dict[@"drName"] = roleData.roleName;
    dict[@"drLevel"] = [NSNumber numberWithInteger:roleData.roleLevel];
    dict[@"drBalance"] = [NSNumber numberWithInteger:roleData.roleBalance];
    dict[@"drVip"] = roleData.roleVip;
    dict[@"dCountry"] = roleData.dCountry;
    dict[@"dParty"] = roleData.dParty;
    dict[@"roleCtime"] = roleData.roleCreateTime;
    dict[@"roleLevelTime"] = roleData.roleLevelUpTime;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    
//    ROLEEVENT_CREATE_ROLE = 1,
//    ROLEEVENT_ENTER_GAME,
//    ROLEEVENT_ROLE_LEVELUP
    
    if (roleData.eventType == ROLEEVENT_CREATE_ROLE) {
        dict[@"eId"] = [NSNumber numberWithInteger:31];
    }
    if (roleData.eventType == ROLEEVENT_ENTER_GAME) {
        dict[@"eId"] = [NSNumber numberWithInteger:32];
    }
    if (roleData.eventType == ROLEEVENT_ROLE_LEVELUP) {
        dict[@"eId"] = [NSNumber numberWithInteger:35];
    }
    
    dict[@"dext"] = roleData.dext;
    dict[@"deviceType"] = @"Ios";
    

    [[BGGBaseRequest sharedManager]  BBGPOST:BGGUploadRoleEventData parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 统一创建订单 ====
+(void)BGGCreateOrderWith:(BGGPMData *)PMData successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"doId"] = PMData.CPOrderId;
    dict[@"dsId"] = PMData.serverId;
    dict[@"dsName"] = PMData.serverName;
    dict[@"drId"] = PMData.roleId;
    dict[@"drName"] = PMData.roleName;
    dict[@"drLevel"] = [NSNumber numberWithInteger:PMData.roleLevel];
    dict[@"dradio"] = PMData.dradio;
    dict[@"dunit"] = PMData.dunit;
    dict[@"dmoney"] = [NSNumber numberWithInteger:PMData.pm];
    dict[@"dext"] = PMData.dext;
    dict[@"appStorePriceNumber"] = PMData.appStoreProductId;
    dict[@"deviceType"] = @"Ios";
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGOrderCreate parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];
        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 根据token获取用户信息 ====
+(void)BGGGetUserInfoByTokensuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   [[BGGBaseRequest sharedManager]  BBGPOST:BGGUserInfoByToken parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 获取game配置的信息 ====
+(void)BGGGetGameConfigsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"gameVersion"] = [BGGDataModel sharedInstance].gameVersion;
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    
    
    dict[@"simulator"] = [NSNumber numberWithInt:0];
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"deviceType"] = @"Ios";
    dict[@"timeZone"] = [BGGDataModel sharedInstance].timeZone;
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGGameConfig parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
    
}
#pragma mark - ==== 游戏版本控制 ====
+(void)BGGGameVersionCOntrolWithSDKVersion:(NSString *)sdkVersion gameVersion:(NSString *)gameVersion successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"sdkVersionName"] = @"1";
    dict[@"gameVersionName"] = @"1";
   [[BGGBaseRequest sharedManager]  BBGPOST:BGGVersionControl parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma  mark - ==== 支付结果查询 ====
+(void)BGGGetPMResultRecordNumber:(NSString *)recordNumber rechargeType:(NSString *)rechargeType successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"payRecordNumber"] = recordNumber;
    dict[@"rechargeType"] = rechargeType;
   
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGPMResult parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma  mark - ==== 判断手机号码是否已经注册 ====
+(void)BGGPanDuanMobileExistMobile:(NSString *)mobile successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGMobileExist parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma  mark - ==== 用户心跳检测 ====
+(void)BGGHeartBeatsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"timeInterval"] = [BGGDataModel sharedInstance].heartInterval;
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGUserHertBeat parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 苹果支付验证订单接口 ====
+(void)BGGAppStoreWithpayRecordNumber:(NSString *)payRecordNumber appStorePriceNumber:(NSString *)appStorePriceNumber tranNum:(NSString *)tranNum receipt:(NSString *)receipt successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"payRecordNumber"] = payRecordNumber;
    dict[@"appStorePriceNumber"] = appStorePriceNumber;
    dict[@"tranNum"] = tranNum;
    
    dict[@"receipt"] = receipt;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGAppStore parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}

#pragma mark - ==== 用户打开游戏记录日志接口 ====
+(void)BGGOpenGameUpLoadsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
    dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
    dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
    dict[@"number"] = [BGGDataModel sharedInstance].number;
    dict[@"deviceCode"] = [BGGDeviceInfo getAdvertisingIdentify];
    dict[@"mac"] = @"00:00:00:00:00:00";
    dict[@"wifiMac"] = [BGGDeviceInfo wifiMac];
    dict[@"deviceType"] = @"Ios";
    dict[@"idfv"] = [BGGDeviceInfo getIDFVString];
    dict[@"idfa"] = [BGGDeviceInfo idfa];
    dict[@"deviceModel"] = [BGGDeviceInfo deviceModel];
    dict[@"deviceWidth"] = [BGGDeviceInfo deviceWidth];
    dict[@"deviceHeight"] = [BGGDeviceInfo deviceHeight];
    dict[@"systemVersion"] = [BGGDeviceInfo systemVersion];
    dict[@"appVersion"] = [BGGDeviceInfo softwareVersion];
    dict[@"sdkVersion"] = @"1.0";
    dict[@"processNumber"] = [BGGDeviceInfo executableName];
    dict[@"packageName"] = [BGGDeviceInfo bundleIdentifier];
    dict[@"gameName"] = [BGGDeviceInfo displayName];
    dict[@"localNetIp"] = [BGGDeviceInfo localIP];
    dict[@"wifiName"] = [BGGDeviceInfo wifi];
    dict[@"netType"] = [BGGDeviceInfo networkType];
    dict[@"timeZone"] = [BGGDeviceInfo localZone];
    dict[@"provinces"] = [BGGDataModel sharedInstance].provinces;
    dict[@"city"] = [BGGDataModel sharedInstance].city;
    dict[@"deviceCompany"] = @"APPLE";
    dict[@"mainHost"] = KBaseUrl;
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGGameOpen parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 支付结果查询 ====
+(void)BGGPM1WithRecordNUmber:(NSString *)recordNumber successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"payRecordNumber"] = recordNumber;
    
    //BGGPM1Status
    NSArray *arr = @[@"sun",@"is",@"x",@"smilling",@"girl",@"p",@"y",@"w",@"ha",@"t"];
    NSString *string = [arr objectAtIndex:5];
    string = [string stringByAppendingString:@"a"];
    string = [string stringByAppendingString:[arr objectAtIndex:6]];
    string = [string stringByAppendingString:@"/"];
    string = [string stringByAppendingString:[arr objectAtIndex:7]];
    string = [string stringByAppendingString:@"ec"];
    string = [string stringByAppendingString:[arr objectAtIndex:8]];
    string = [string stringByAppendingString:@"t/"];
    string = [string stringByAppendingString:@"get/result"];
    
    [[BGGBaseRequest sharedManager]  BBGPOST:[KUrl stringByAppendingString:string] parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
+(void)BGGPM2WithRecordNUmber:(NSString *)recordNumber successBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"payRecordNumber"] = recordNumber;
    
    
    //BGGPM2Status
    NSMutableString * ka = [NSMutableString stringWithString:@"p"];
    NSString * stt = @"p";
    stt = [stt stringByAppendingString:@"a"];
    
    NSArray *arr = @[@"sun",@"is",@"a",@"smilling",@"girl",@"y",@"al",@"i",@"y",@"a",@"p"];
    
    stt = [stt stringByAppendingString:[arr objectAtIndex:5]];
    stt = [stt stringByAppendingString:@"/"];
    
    stt = [stt stringByAppendingString:[arr objectAtIndex:6]];
    stt = [stt stringByAppendingString:[arr objectAtIndex:7]];
    stt = [stt stringByAppendingString:[arr objectAtIndex:10]];
    stt = [stt stringByAppendingString:[arr objectAtIndex:9]];
    stt = [stt stringByAppendingString:[arr objectAtIndex:8]];
    
    stt = [stt stringByAppendingString:@"/trade/qu"];
    stt = [stt stringByAppendingString:@"ery"];
    
    
    [[BGGBaseRequest sharedManager]  BBGPOST:[KUrl stringByAppendingString:stt] parameters:dict success:^(NSURLSessionDataTask *operation, id responseObject) {
      
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
#pragma mark - ==== 获取地理位置 ====
+(void)BGGLocationsuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
    [[BGGBaseRequest sharedManager] GET:BGGGetLocation parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {

               
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

       NSString *strdata = [[NSString alloc]initWithData:responseObject encoding:enc];
        
        
        NSArray *array = [strdata componentsSeparatedByString:@","];
       
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = obj;
            if ([str containsString:@"pro"] && ![str containsString:@"proCode"]) {
                [BGGDataModel sharedInstance].provinces = [[[str componentsSeparatedByString:@":"] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            if ([str containsString:@"city"] && ![str containsString:@"cityCode"]) {
                [BGGDataModel sharedInstance].city = [[[str componentsSeparatedByString:@":"] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""] ;
            }
        }];


//               NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
//               NSString *returnMsg  = [responseObject objectForKey:@"msg"];
//               NSDictionary *data   = [responseObject objectForKey:@"data"];
        if ([BGGDataModel sharedInstance].provinces.length) {
            SuccessBlock(0,@"位置获取成功",nil);
        }else{
            SuccessBlock(400,@"位置获取失败",nil);
        }
              
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failBlock(error);
    }];
}
#pragma mark - ==== 获取隐私协议信息 ====
+(void)BGGPrivacysuccessBlock:(SuccessBlock)SuccessBlock failBlock:(FailBlock)failBlock{
   
    
    [[BGGBaseRequest sharedManager]  BBGPOST:BGGPrivacy parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger  returnCode = [[responseObject objectForKey:@"code"] integerValue];
        NSString *returnMsg  = [responseObject objectForKey:@"msg"];
        NSDictionary *data   = [responseObject objectForKey:@"data"];

        SuccessBlock(returnCode,returnMsg,data);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {

    }];
}
@end

