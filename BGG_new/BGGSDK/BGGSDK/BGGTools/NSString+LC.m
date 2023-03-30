//
//  NSString+LC.m
//  MQTTChat
//
//  Created by rochang on 2018/9/28.
//  Copyright © 2018年 Rochang. All rights reserved.
//

#import "NSString+LC.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LC)

+ (NSString *)lc_homePath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)lc_iOSVersion {
    return [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
}

+ (NSString *)lc_UUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)lc_buildNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)lc_versionNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)lc_bundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)lc_MD5ForLower32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

#pragma mark - 32位 大写
+ (NSString *)lc_MD5ForUpper32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

+ (NSString *)lc_MD5ForUpper16Bate:(NSString *)str{
    NSString *md5Str = [self lc_MD5ForUpper32Bate:str];
    NSString *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+ (NSString *)lc_D5ForLower16Bate:(NSString *)str {
    NSString *md5Str = [self lc_MD5ForLower32Bate:str];
    NSString *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

+ (NSString *)lc_jsonStrFromData:(id)data {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = nil;
    if (!jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)lc_timestamp {
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000]; // 毫秒
}

- (NSString *)add:(NSString *)string {
    return [self lc_addStr:string];
}

- (NSString *)lc_addStr:(NSString *)string {
    if (!string.length) {
        return self;
    }
    NSString *str = [self stringByAppendingString:string];
    return str;
}

- (NSString *)lc_addStrs:(NSArray<NSString *> *)strings {
    NSString *result = self;
    for (NSString *str in strings) {
         result = [result lc_addStr:str];
    }
    return result;
}

- (NSString *)adds:(NSArray<NSString *> *)strings {
    return [self lc_addStrs:strings];
}

#pragma mark - 校验
- (BOOL)lc_isPhoneNumber {
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:self] == YES)
       || ([regextestcm evaluateWithObject:self] == YES)
       || ([regextestct evaluateWithObject:self] == YES)
       || ([regextestcu evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)lc_isAllChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)lc_isIncludeChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

#pragma mark - 小数
- (NSString *)lc_onePoint {
    return [NSString stringWithFormat:@"%.1f", self.floatValue];
}

- (NSString *)lc_twoPoint {
    return [NSString stringWithFormat:@"%.2f", self.floatValue];
}
@end
