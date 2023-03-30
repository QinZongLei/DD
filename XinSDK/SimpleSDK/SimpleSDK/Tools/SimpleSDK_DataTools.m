//
//  SimpleSDK_DataTools.m
//  SimpleSDK
//
//  Created by mac on 2021/12/13.
//

#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Tools.h"
#import "SAMKeychain.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface SimpleSDK_DataTools ()

@property (nonatomic, readwrite, strong) NSDictionary *userInfo;

@end

@implementation SimpleSDK_DataTools

+ (instancetype)manager {
    static SimpleSDK_DataTools *myInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myInstance = [[super allocWithZone:NULL] init];
    });
    return myInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

-(void)func_setReviewInfo:(NSDictionary *)dic{
    _reviewInfo = dic;
}

- (void)func_setAppInfo:(NSDictionary *)dic{
    _appInfo = [NSDictionary dictionaryWithDictionary:dic];
}


- (void)func_setSwitchInfo:(NSDictionary *)dic {
    
    _switchInfo = [NSDictionary dictionaryWithDictionary:dic];
}

- (void)func_setCustomerInfo:(NSDictionary *)dict {
    
    
    _customerInfo = [NSDictionary dictionaryWithDictionary:dict];
}

- (void)func_setUserInfo:(NSDictionary *)dic{
    _userInfo  = [NSDictionary dictionaryWithDictionary:dic];
    
    NSString *userStr=[SimpleSDK_Tools func_dictionaryToJsonOfParams:dic];
    [[NSUserDefaults standardUserDefaults] setValue:userStr forKey:[SimpleSDK_DataTools manager].userkey];
}

- (void)func_setMsgInfo:(NSDictionary *)arr{
    _msgInfo = arr;
}

-(void)func_setPublicCodeInfo:(NSDictionary *)dic{
    _publicCodeInfo = dic;
}

- (NSDictionary *)userInfo{
    if (kDictNotNull(_userInfo)) {
        NSString *str= [[NSUserDefaults standardUserDefaults] valueForKey:[SimpleSDK_DataTools manager].userkey];
        NSDictionary *dicUser = [NSDictionary dictionaryWithDictionary:[SimpleSDK_Tools func_jsonToDictionaryOfJsonString:str]];
        return dicUser;
    }else{
        return _userInfo;
    }
}

- (NSString *)idfaStr{
    if (@available(iOS 14, *)) {
           [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
               if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                   NSString *idfaString = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                   self->_idfaStr=idfaString;
               }
           }];
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            
            _idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
        }
    }
    
    if (kStringIsNull(_idfaStr)) {
        
        return  _idfaStr = @"00000000-0000-0000-0000-000000000000";
        
    } else {
       
        return  _idfaStr;
    }
}



- (NSString *)userkey{
    return  [NSString stringWithFormat:@"%@.%@.user", kBundleId, kProductKey];
}

- (NSString *)projcetState{
    NSString * str =  [NSString stringWithFormat:@"%@", [[SimpleSDK_DataTools manager].appInfo objectForKey:@"projcet_msg_state"]];
    return  str;
}

- (NSString *)userAgentstr{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_DataTools manager].webview = [[WKWebView alloc] initWithFrame:CGRectZero];
        [[SimpleSDK_DataTools manager].webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id obj, NSError * _Nullable error) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:obj forKey:@"userAgent"];
            [userDefault synchronize];
            
        }];
     });
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userAgentstr = [userDefault objectForKey:@"userAgent"];
        
        if (kStringIsNull(userAgentstr)) {
            //定个默认值
            NSString *oldAgentStr = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion]];
            NSRange range = {0,oldAgentStr.length};
            NSMutableString *mutStr = [NSMutableString stringWithString:oldAgentStr];
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            
            return mutStr;
        }else{
            NSRange range = {0,userAgentstr.length};
            NSMutableString *mutStr = [NSMutableString stringWithString:userAgentstr];
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            return mutStr;
        }
    
}

+ (void)func_saveAccountOfPhone:(NSString *)account password:(NSString *)password type:(NSString *)type{
    if (!account || !password) {
        return;
    }
    NSMutableArray *allAccount = [NSMutableArray arrayWithArray:[self func_getAllAccount]];
    for (NSDictionary *tempAccount in allAccount) {
        NSString *oldName = [NSString stringWithFormat:@"%@", [tempAccount valueForKey:@"account"]];
        if ([oldName isEqualToString:account]) {
            [allAccount removeObject:tempAccount];
            break;
        }
    }
    NSDictionary *curruntAccount = @{@"account": account, @"password": password, @"type": type};
    [allAccount addObject:curruntAccount];
    [[NSUserDefaults standardUserDefaults] setValue:allAccount forKey:kSaveAllAccount];
    // 保存当前账号
    [[NSUserDefaults standardUserDefaults] setValue:curruntAccount forKey:kSaveCurrentAccount];
}

+ (NSArray *)func_getAllAccount{
    NSArray *allAccount = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveAllAccount]];
    return allAccount;
}

+ (void)func_deleteAccount:(NSString *)account{
    NSMutableArray *allAccount = [NSMutableArray arrayWithArray:[self func_getAllAccount]];
    for (NSDictionary *tempAccount in allAccount) {
        NSString *oldName = [NSString stringWithFormat:@"%@", [tempAccount valueForKey:@"account"]];
        if ([oldName isEqualToString:account]) {
            [allAccount removeObject:tempAccount];
            break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:allAccount forKey:kSaveAllAccount];
}

+(NSMutableArray *)func_getUserCenter{
    NSMutableArray *userModuleList  = [NSMutableArray new];
    //我的消息填充数据
    NSMutableDictionary *messageDict= [NSMutableDictionary dictionary];
    [messageDict setValue:@"公告" forKey:@"name"];
    
    //判断是否显示红色图标
    if ([SimpleSDK_DataTools func_isMsgRed]) {
        [messageDict setValue:msgRedImg forKey:@"img"];
    }else{
        [messageDict setValue:msgImg forKey:@"img"];
    }
    [userModuleList addObject:messageDict];
    //我的账号填充数据
    NSMutableDictionary *accountDict= [NSMutableDictionary dictionary];
    [accountDict setValue:@"账号" forKey:@"name"];
    
    NSString * oneClickStr = @"oneClick";
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    
    NSString *newsAccountID = [NSString stringWithFormat:@"%@%@",oneClickStr,accountStr];
    NSUserDefaults *wayforloginAccount = [NSUserDefaults standardUserDefaults];
    NSString *openStateAccount = [wayforloginAccount objectForKey:newsAccountID];
    
    NSString * trueName = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"fcm"];
    NSString * bindphone = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"isBindMobile"];
    if ((trueName.intValue ==1 && bindphone.intValue ==1)||[@"openAccountMenu" isEqualToString:openStateAccount]) {
        [accountDict setValue:accountNormalImg forKey:@"img"];
    }else{
        [accountDict setValue:accountRedImg forKey:@"img"];
    }
    [userModuleList addObject:accountDict];
    //公众号填充数据
    NSMutableDictionary *publicCodeDict= [NSMutableDictionary dictionary];
    [publicCodeDict setValue:@"公众号" forKey:@"name"];
    
    NSString *codeNameStr = [[SimpleSDK_DataTools manager].publicCodeInfo objectForKey:@"wx_public_name"];
    
    NSString *newsID = [NSString stringWithFormat:@"%@%@",codeNameStr,accountStr];
    NSUserDefaults *wayforlogin = [NSUserDefaults standardUserDefaults];
    NSString *openState = [wayforlogin objectForKey:newsID];
    
    if ([@"openPublicCode" isEqualToString:openState]) {
        [publicCodeDict setValue:publicCodeImg forKey:@"img"];
    }else{
        [publicCodeDict setValue:publicCodeRedImg forKey:@"img"];
    }
    [userModuleList addObject:publicCodeDict];
    //客服
    NSMutableDictionary *serviceDict = [NSMutableDictionary dictionary];
    [serviceDict setValue:@"联系客服" forKey:@"name"];
    [serviceDict setValue:serviceImg forKey:@"img"];
    [userModuleList addObject:serviceDict];
    return userModuleList;
}


+ (NSMutableArray *)func_getMenuList{
    NSMutableArray *moduleList  = [NSMutableArray new];
    
    NSMutableDictionary *updatePwdDict= [NSMutableDictionary dictionary];
    [updatePwdDict setObject:@"修改密码" forKey:@"name"];
    [updatePwdDict setObject:menuPwdImg forKey:@"icon"];
    [updatePwdDict setObject:@"" forKey:@"prompt"];
    [updatePwdDict setObject:menuChangePwdBtn forKey:@"type"];
    [moduleList addObject: updatePwdDict];
    
    NSString * trueName = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"fcm"];
    NSString * bindphone = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"isBindMobile"];
    NSMutableDictionary *bingPhonehDict = [NSMutableDictionary dictionary];
    [bingPhonehDict setObject:@"绑定手机" forKey:@"name"];
    [bingPhonehDict setObject:menuBindPhoneImg forKey:@"icon"];

    if (bindphone.intValue == 1) {
        [bingPhonehDict setObject:@"(手机已绑定)" forKey:@"prompt"];
        [bingPhonehDict setObject:menuAlreadyBindPhoneBtn forKey:@"type"];
    }else{
        [bingPhonehDict setObject:@"(手机未绑定)" forKey:@"prompt"];
        [bingPhonehDict setObject:menuBindPhoneBtn forKey:@"type"];
    }
    [moduleList addObject: bingPhonehDict];
    
   
    NSMutableDictionary *realNameDict = [NSMutableDictionary  dictionary];
    [realNameDict setObject:@"实名认证" forKey:@"name"];
    [realNameDict setObject:menuRealnameImg forKey:@"icon"];
 
    if (trueName.intValue == 1) {
        [realNameDict setObject:@"(已实名认证)" forKey:@"prompt"];
        [realNameDict setObject:menuAlreadyRealnameBtn forKey:@"type"];
    }else{
        [realNameDict setObject:@"(未实名认证)" forKey:@"prompt"];
        [realNameDict setObject:menuRealnameBtn forKey:@"type"];
    }
    [moduleList addObject: realNameDict];
    

   
    return  moduleList;
}

+ (BOOL)func_isMsgRed{
    NSMutableArray *msgDic = [SimpleSDK_DataTools manager].msgInfo;
    if ( msgDic.count > 0) {
        NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
        NSMutableArray *discardedItems = [NSMutableArray array];
        for (NSDictionary * dic in msgDic)
        {
            NSString * idStr = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"id"],accountStr];
            NSString *redHiddenStr = [[NSUserDefaults standardUserDefaults] objectForKey:idStr];
            if ([@"redIshidden" isEqualToString:redHiddenStr]) {
                [discardedItems addObject:dic];
            }
        }
     
        if (msgDic.count == discardedItems.count) {
            return  NO;//已经阅读完毕不现实红点
        }else{
            return YES;//没有阅读完 照样现实
        }
    }else{
        return NO;//没有消息不现实
    }
}

@end
