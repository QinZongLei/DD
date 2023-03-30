//
//  SimpleSDK_Tools.m
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import "SimpleSDK_Tools.h"
#import "SimpleSDK_DataTools.h"
#import "sys/utsname.h"
#import "SAMKeychain.h"
#import <CommonCrypto/CommonDigest.h>
#import "RSA.h"
#import "AES.h"

@implementation SimpleSDK_Tools

+ (instancetype)manager {
    static SimpleSDK_Tools *myInstance = nil;
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

+ (bool)func_judgeUIimageForNil:(UIImage *)image{
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
        if (cim == nil && cgref == NULL){
            return NO;
        } else {
            return YES;
        }
}

+(NSString *)func_getOSVersion{
    return [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] systemVersion]];;
}

+ (NSDictionary *)func_InitParams {
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    [mParams setValue:kGameId forKey:@"appid"];
    [mParams setValue:@"IOS" forKey:@"platform"];
    [mParams setValue:kNetworkInit forKey:@"service"];
    NSString *md5udidstr = [NSString stringWithFormat:@"%@%@",[SimpleSDK_DataTools manager].idfaStr,[SimpleSDK_Tools func_getUUIDString]];
    
    NSMutableDictionary *InitDefaultBizParams = [[NSMutableDictionary alloc] init];
    [InitDefaultBizParams setValue:[SimpleSDK_Tools func_getStrMD5:md5udidstr] forKey:@"udid"];
    [InitDefaultBizParams setValue: [SimpleSDK_DataTools manager].userAgentstr  forKey:@"userAgent"];
    [InitDefaultBizParams setValue:kChannelId forKey:@"channel"];
    [InitDefaultBizParams setValue:[SimpleSDK_DataTools manager].idfaStr forKey:@"idfa"];
    [InitDefaultBizParams setValue:kSDKVersion forKey:@"sdkVersion"];
    [InitDefaultBizParams setValue:[SimpleSDK_Tools func_getOSVersion]  forKey:@"version"];
    
    [mParams setValue:[SimpleSDK_Tools func_dictionaryToJsonOfParams:InitDefaultBizParams] forKey:@"data"];
    
    //对data字典排序,正序
    NSString *dataStr = [NSString stringWithFormat:@"%@",[SimpleSDK_Tools func_sortOfDictionary:InitDefaultBizParams]];

      NSString *md5str = [NSString stringWithFormat:@"%@%@%@%@",kGameId,kNetworkInit,dataStr,kProductKey];
   
    [mParams setValue:[SimpleSDK_Tools func_getStrMD5:md5str ] forKey:@"sign"];
    return mParams;
}




+ (NSString *)func_getUUIDString{
    NSString * uuidStr =  [SAMKeychain passwordForService:@"20001" account:@"udidString"];
    if (kStringIsNull(uuidStr)) {
            uuidStr = kUUID;
            [SAMKeychain setPassword:uuidStr forService:@"20001" account:@"udidString"];
    }
    return uuidStr;
}

+ (NSString *)func_getDeviceString{
    // 需要#import "sys/utsname.h"
        struct utsname systemInfo;
        uname(&systemInfo);
        // 获取设备标识Identifier
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        // iPhone
        if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
        if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE 1";
        if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
        if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
        if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS MAX";
        if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
        if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
        if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
        if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
        if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
        if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2";
        if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
        if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
        if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
        if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
        if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
        if ([platform isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
        if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
        if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
        
        // iPod
        if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1";
        if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2";
        if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3";
        if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4";
        if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5";
        if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6";
        if ([platform isEqualToString:@"iPod9,1"])  return @"iPod Touch 7";
        
        // iPad
        if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1";
        if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1";
        if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1";
        if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1";
        if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
        if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,4"])  return @"iPad mini 2";
        if ([platform isEqualToString:@"iPad4,5"])  return @"iPad mini 2";
        if ([platform isEqualToString:@"iPad4,6"])  return @"iPad mini 2";
        if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
        if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
        if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
        if ([platform isEqualToString:@"iPad5,1"])  return @"iPad mini 4";
        if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
        if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
        if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
        if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro (9.7-inch)";
        if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro (9.7-inch)";
        if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro (12.9-inch)";
        if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro (12.9-inch)";
        if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
        if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
        if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
        if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
        if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
        if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
        if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
        if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
        if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
        if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
        if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
        if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
        if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
        if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
        if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad8,9"])  return @"iPad Pro 2 (11-inch) ";
        if ([platform isEqualToString:@"iPad8,10"])  return @"iPad Pro 2 (11-inch) ";
        if ([platform isEqualToString:@"iPad8,11"])  return @"iPad Pro 4 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad8,12"])  return @"iPad Pro 4 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
        if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
        if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
        if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
        if ([platform isEqualToString:@"iPad11,6"])  return @"iPad 8";
        if ([platform isEqualToString:@"iPad11,7"])  return @"iPad 8";
        if ([platform isEqualToString:@"iPad12,1"])  return @"iPad 9";
        if ([platform isEqualToString:@"iPad12,2"])  return @"iPad 9";
        if ([platform isEqualToString:@"iPad13,1"])  return @"iPad Air 4";
        if ([platform isEqualToString:@"iPad13,2"])  return @"iPad Air 4";
        if ([platform isEqualToString:@"iPad13,4"])  return @"iPad Pro 4 (11-inch) ";
        if ([platform isEqualToString:@"iPad13,5"])  return @"iPad Pro 4 (11-inch) ";
        if ([platform isEqualToString:@"iPad13,6"])  return @"iPad Pro 4 (11-inch) ";
        if ([platform isEqualToString:@"iPad13,7"])  return @"iPad Pro 4 (11-inch) ";
        if ([platform isEqualToString:@"iPad13,8"])  return @"iPad Pro 5 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad13,9"])  return @"iPad Pro 5 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad13,10"])  return @"iPad Pro 5 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad13,11"])  return @"iPad Pro 5 (12.9-inch) ";
        if ([platform isEqualToString:@"iPad14,1"])  return @"iPad mini 6";
        if ([platform isEqualToString:@"iPad14,2"])  return @"iPad mini 6";
        
        // 其他
        if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
        if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
        
        return platform;
}


+ (NSString *)func_getTimesTamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)func_get32BitStr{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

+ (NSString *)func_set256HashValue:(NSString *)sha256Str{
    const char* str = [sha256Str UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}

+(NSString *)func_getMd5_16BitStr:(NSString *)str{
    NSString * strMD5 = [self func_getStrMD5:str];
    return  [strMD5 substringWithRange:NSMakeRange(8, 16)];
}

+ (NSString *)func_getStrMD5:(NSString *)str{
    //32位(小写)
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+(NSString*)encodeStr:(NSString*)unencodedString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                    (CFStringRef)unencodedString,
                     NULL,
                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                     kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (NSString *)func_sortOfDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
        
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];//正序
    }];
    
    NSString *str = @"";
    
    for (NSString *categoryId in sortedArray) {
        id value = [dictionary objectForKey:categoryId];
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [self func_sortOfDictionary:value];
        }
        if ([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
    }
    return str;
}

+ (NSDictionary *)func_jsonToDictionaryOfJsonString:(NSString *)jsonString{
    if (!jsonString) {
        return @{};
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *passerError;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&passerError];
    if(passerError) {
        return @{};
    }
    return dicJson;
}

+ (NSString *)func_dictionaryToJsonOfParams:(NSDictionary *)params{
    if (![NSJSONSerialization isValidJSONObject:params]) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&parseError];
    if (parseError) {
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



+ (NSMutableAttributedString *)func_strAddUnderline:(NSString *)contentStr UnderLineColor:(UIColor *)lineColor{
    NSRange userRange = [contentStr rangeOfString:contentStr];
    NSMutableAttributedString *lineStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [lineStr addAttribute:NSForegroundColorAttributeName value:lineColor range:userRange];

    [lineStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:userRange];
        
        return lineStr;
}

//对一个字符串进行base解码
+(NSString *)base64decodeString:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}


+ (NSString *)func_getRandomStrWithNum:(NSInteger)nubr{
    //定义一个包含数字，大小写字母的字符串
        NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        //定义一个结果
        NSString * result = [[NSMutableString alloc]initWithCapacity:nubr];
        for (int i = 0; i < nubr; i++)
        {
            //获取随机数
            NSInteger index = arc4random() % (strAll.length-1);
            char tempStr = [strAll characterAtIndex:index];
            result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
        }
        return [result lowercaseString];
}

+ (NSString *)func_validationInputText:(NSString *)str{
    for (int i = 0; i < [str length]; i++) {
        
        int isChinesePwdInt = [str characterAtIndex:i];
        
        if (isChinesePwdInt > 0x4e00 && isChinesePwdInt < 0x9fff) {
            
            return @"格式错误，存在中文！";
        }
    }
    //提示标签不能输入特殊字符
    NSString *regularStr =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    if (![emailTest evaluateWithObject:str]) {
        return @"格式错误，不能含有特殊符号！";
    }
    return nil;
}

+ (BOOL)func_isMobileNumber:(NSString *)phoneStr{
    //正则表达式
    NSString *mobile = @"^1\\d{10}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if ([regextestMobile evaluateWithObject:phoneStr] == YES) {
        return  YES;
    }else {
        return  NO;
    }
}

+ (BOOL)func_isVaildRealName:(NSString *)realName{
    if ([self func_checkEmptyString:realName]) return NO;
    
    NSRange range1 = [realName rangeOfString:@"·"];
       NSRange range2 = [realName rangeOfString:@"•"];
       if(range1.location != NSNotFound ||   // 中文 ·
          range2.location != NSNotFound )    // 英文 •
       {
           //一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
           if ([realName length] < 2 || [realName length] > 15){
               return NO;
           }
           NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
           NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
           NSUInteger count = [match numberOfRanges];
           return count == 1;
       }else{
           //一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
           if ([realName length] < 2 || [realName length] > 8) {
               return NO;
           }
           NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
           NSTextCheckingResult *match = [regex firstMatchInString:realName options:0 range:NSMakeRange(0, [realName length])];
           NSUInteger count = [match numberOfRanges];
           return count == 1;
       }

}

+ (BOOL)func_verifyIDCard:(NSString *)idCard{
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCard];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCard substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCard.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

+ (BOOL)func_checkEmptyString:(NSString *) string {
    if (string == nil) return string == nil;
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [newStr isEqualToString:@""];
}


+ (BOOL)func_timeout:(NSString *)loginType;{
    
    NSUserDefaults *timeforphone = [NSUserDefaults standardUserDefaults];
    NSString *loginTimeStr = [timeforphone objectForKey:@"timeoutforacount"];
  
    if (loginTimeStr == nil) {
        return  NO;
    }
    
    int loginTime =[loginTimeStr intValue];
    
    int currentTime = [[SimpleSDK_Tools func_getTimesTamp] intValue];
    if (loginTime - currentTime < 2592000  ) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)func_urlUTF8Encoding:(NSString *)urlstr{
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0){
        return [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    }else{
        return [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

+ (UIWindow *)func_getTopViewControlle{
    UIWindow * topView =  [[UIApplication sharedApplication].windows objectAtIndex:0];
    return  topView;
}
@end
