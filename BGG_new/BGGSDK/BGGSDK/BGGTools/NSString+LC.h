//
//  NSString+LC.h
//  MQTTChat
//
//  Created by rochang on 2018/9/28.
//  Copyright © 2018年 Rochang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LC)
#pragma mark - 路径
/** 获取 home 路径 */
+ (NSString *)lc_homePath;

#pragma mark - APP相关
/** 获取bundleId*/
+ (NSString *)lc_bundleId;

/** 获取versionnumber */
+ (NSString *)lc_versionNumber;

/** 获取build number */
+ (NSString *)lc_buildNumber;

/** 获取手机系统 */
+ (NSString *)lc_iOSVersion;

/** 获取UUID */
+ (NSString *)lc_UUID;

#pragma mark - MD5 加密
/** MD5加密 : 32位小写 */
+ (NSString *)lc_MD5ForLower32Bate:(NSString *)str;

/** MD5加密 : 32位大写 */
+ (NSString *)lc_MD5ForUpper32Bate:(NSString *)str;

/** MD5加密 : 16为大写 */
+ (NSString *)lc_MD5ForUpper16Bate:(NSString *)str;

/** MD5加密 : 16位小写 */
+ (NSString *)lc_D5ForLower16Bate:(NSString *)str;

#pragma mark - 数据转换
/** 字典,数组转 json */
+ (NSString *)lc_jsonStrFromData:(id)data;

/** 获取当前时间戳 */
+ (NSString *)lc_timestamp;

/** 字符串叠加 */
- (NSString *)lc_addStrs:(NSArray <NSString *>*)strings;
- (NSString *)lc_addStr:(NSString *)string;

- (NSString *)add:(NSString *)string;
- (NSString *)adds:(NSArray<NSString *> *)strings;

#pragma mark - 校验
/** 校验手机号码 */
- (BOOL)lc_isPhoneNumber;
/** 全是汉字 */
- (BOOL)lc_isAllChinese;
/** 判断是否含有汉字 */
- (BOOL)lc_isIncludeChinese;

#pragma mark - 小数
- (NSString *)lc_onePoint;
- (NSString *)lc_twoPoint;

@end
