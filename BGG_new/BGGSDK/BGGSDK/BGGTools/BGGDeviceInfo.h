//
//  NEWXLS_DeviceInfo_MDFZ.h
//  NETGame
//
//  Created by admin on 2017/10/24.
//  Copyright © 2017年 sy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
/**
 *  @brief 设备信息获取工具
 */
@interface BGGDeviceInfo : NSObject


+ (NSString *)localZone;

/**
 *  获得广告标志位
 *
 *  @return 返回广告标志位
 */
+ (NSString *)getAdvertisingIdentify;

/**
 *  获取 NSUUID 6.0
 *
 *  @return 返回NSUUID
 */
+ (NSString *)getNSUUIDString;

/**
 *  获取 IDFV 6.0
 *
 *  @return 返回IDFV
 */
+ (NSString *)getIDFVString;

///**
// *  获取 IDFV 6.0
// *
// *  @return 返回Keychain中保存的IDFA
// */
//+ (NSString *)getKeychainAdvertisingIdentify;
//
///**
// *  获取 IDFV 6.0
// *
// *  @return 返回Keychain中保存的IDFV
// */
//
//+ (NSString *)getKeychainIDFVString;

/**
 *  获取底层包名
 *
 *  @return 底层包名
 */
+ (NSString *)bundleIdentifier;

+ (NSString *)displayName;

/**
 *  获取系统版本
 *
 *  @return 系统版本号
 */
+ (NSString *)systemVersion;

/**
 *  获取软件版本
 *
 *  @return 软件版本
 */
+ (NSString *)softwareVersion;

/**
 *  进程名
 *
 *  @return 进程名
 */
+ (NSString *)bundleName;

/**
 *  进程名
 *
 *  @return 进程名
 */
+ (NSString *)executableName;

/**
 *  默认device参数
 *
 *  @return device参数加密串
 */
//+ (NSString* )dev;

/**
 *  获得设备型号
 *
 *  @return 设备型号
 */
+ (NSString* )deviceModel;

/**
 *  获得设备屏幕宽
 *
 *  @return 设备屏幕宽
 */
+ (NSString* )deviceWidth;

/**
 *  获得设备屏幕高
 *
 *  @return 设备屏幕高
 */
+ (NSString* )deviceHeight;

+ (NSString *)wifi;

+ (NSString *)wifiMac;

+ (NSString *)networkType;

+ (NSString *)localIP;

+ (NSString *)idfa;

-(void)locationService;
@end
