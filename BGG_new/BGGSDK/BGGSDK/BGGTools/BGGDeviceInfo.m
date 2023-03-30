//
//  NEWXLS_DeviceInfo_MDFZ.m
//  NETGame
//
//  Created by admin on 2017/10/24.
//  Copyright © 2017年 sy. All rights reserved.
//

#import "BGGDeviceInfo.h"
#import "BGGPCH.h"
//#import "KeyChainStore.h"

#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>
#import <objc/runtime.h>
#import <AdSupport/AdSupport.h>
#include <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import<CoreFoundation/CoreFoundation.h>
#import<SystemConfiguration/CaptiveNetwork.h>
#import<SystemConfiguration/SystemConfiguration.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "BGGCustomDevice.h"
#import "SaveInKeyChain.h"

#define DEVICEINFO_DEV_KEY  @"NEWXLS_DeviceInfo_Dev_key"
#define DEVICEINFO_IDFA_KEY @"NEWXLS_DeviceInfo_IDFA_key"
#define DEVICEINFO_IDFV_KEY @"NEWXLS_DeviceInfo_IDFV_key"
@interface BGGDeviceInfo()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)NSString *provinces;
@property(nonatomic,strong)NSString *city;
@end
@implementation BGGDeviceInfo

+ (NSString *)localZone
{
    /* 重置手机系统的时区 */
    [NSTimeZone resetSystemTimeZone];
    NSInteger offset = [NSTimeZone localTimeZone].secondsFromGMT;
    offset = offset/3600;
    NSString *tzStr = [NSString stringWithFormat:@"%ld", (long)offset];
    
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSString *localTimeZoneStr = [NSString stringWithFormat:@"%@", localTimeZone];
    
    NSString *targetZone = @"GMT+8";
    if ([localTimeZoneStr rangeOfString:@"UTC"].location !=NSNotFound)
    {
        targetZone = [NSString stringWithFormat:@"UTC+%@", tzStr];
    }
    else if ([localTimeZoneStr rangeOfString:@"CCD"].location !=NSNotFound)
    {
        targetZone = [NSString stringWithFormat:@"CCD+%@", tzStr];
    }
    
    return targetZone;
}


+ (NSString *)getAdvertisingIdentify
{
    NSString *string = [SaveInKeyChain load:@"BGGADVER_id_1"];
    if (string && string.length > 0) {
        return string;
    }
    NSString *idfa = [self idfa];
    if ([idfa hasPrefix:@"0000"] || idfa.length <= 0) {
        
        idfa = [BGGCustomDevice customDeviceId];
    }
    NSString *resultString = [self md5HexDigest:idfa];
    [SaveInKeyChain save:@"BGGADVER_id_1" data:resultString];
    return resultString;
    //    ASIdentifierManager *idManager = [ASIdentifierManager sharedManager];
//    if (@available(iOS 14,*)) {
//
//        __block NSString *idfa = @"";
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//                idfa =  [NSString stringWithFormat:@"%@", [[idManager advertisingIdentifier] UUIDString]];
//                if ([idfa hasPrefix:@"0000"]) {
//
//                    idfa = [BGGCustomDevice customDeviceId];
//                }
//            }else{
//
//                NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
//                idfa = [BGGCustomDevice customDeviceId];
//                NSLog(idfa);
//            }
//
//        }];
//        if (idfa.length == 0){
//            idfa = [BGGCustomDevice customDeviceId];
//        }
//        return [self md5HexDigest:idfa];
//
//    }else{
//        if (!isStrEmpty([[idManager advertisingIdentifier] UUIDString]))
//        {
//            if ([[[idManager advertisingIdentifier] UUIDString] hasPrefix:@"0000"]) {
//                return [self md5HexDigest:[BGGCustomDevice customDeviceId]];
//            }
//
//            return [self md5HexDigest:[NSString stringWithFormat:@"%@", [[idManager advertisingIdentifier] UUIDString]]];
//        }
//
//        return [self md5HexDigest:[BGGCustomDevice customDeviceId]];
//    }
}

+ (NSString *)idfa
{
    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    if ([idfa hasPrefix:@"0000"]) {
        
        return @"";
    }
    return idfa;
}

+ (NSString* )md5HexDigest:(NSString* )str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)getNSUUIDString
{
    return [[NSUUID UUID] UUIDString];
}


+ (NSString *)getIDFVString
{
    NSString *idfv = @"";
    if (!isStrEmpty([[[UIDevice currentDevice] identifierForVendor] UUIDString]))
    {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return  idfv;
}

+ (NSString *)bundleIdentifier
{
    if (!isStrEmpty([[NSBundle mainBundle] bundleIdentifier]))
    {
        return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]];
    }
    return @"";
}

+ (NSString *)displayName
{
    if (!isStrEmpty([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]))
    {
        return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    return @"";
}

+ (NSString *)systemVersion
{
    if (!isStrEmpty([[UIDevice currentDevice] systemVersion]))
    {
        return [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
    }
    return @"";
}

+ (NSString *)softwareVersion
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    if (!isStrEmpty(version))
    {
        return [NSString stringWithFormat:@"%@", version];
    }
    return @"";
}

+ (NSString *)bundleName
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * name = [infoDict objectForKey:@"CFBundleName"];
    
    if (!isStrEmpty(name))
    {
        return [NSString stringWithFormat:@"%@", name];
    }
    return @"";
}


+ (NSString *)executableName
{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * name = [infoDict objectForKey:@"CFBundleExecutable"];
    
    if (!isStrEmpty(name))
    {
        return [NSString stringWithFormat:@"%@", name];
    }
    return @"";
}


//+ (NSString* )dev
//{
//    NSError * error = nil;
//    
//    NSString* mac  = @"";
//    NSString* imei = @"";
//    NSString* idfa = [NEWXLS_DeviceInfo_MDFZ getAdvertisingIdentify];
//    NSString* idfv = [NEWXLS_DeviceInfo_MDFZ getIDFVString];
//    NSString* privatekey = @"53aea7b28c16f31789540f516c73adf5";
//    
//    NSString *idfaNul = @"00000000-0000-0000-0000-000000000000";
//    NSString *idFire = idfa;
//    
//    if ([idfa isEqualToString:idfaNul] || idfa.length < idfaNul.length) {
//        idFire = idfv;
//    }
//    
//    NSString* linkStr = [NSString stringWithFormat:@"%@%@",  idFire, privatekey];
//    
//    NSString* dev = [NEWXLS_Tools_MDFZ md5:linkStr].lowercaseString;
//    
//    return dev;
//}

+ (NSString* )deviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    
    
    return platform;
}

+ (NSString* )deviceWidth
{
    return [NSString stringWithFormat:@"%.0f", [UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale];
}

+ (NSString* )deviceHeight
{
    return [NSString stringWithFormat:@"%.0f", [UIScreen mainScreen].bounds.size.height*[UIScreen mainScreen].scale];
}

+ (NSString *)networkType
{
    NSString *strNetworkType = @"WWAN";
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    if ((flags &kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        strNetworkType = @"WIFI";
    }
    
    if ( ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) !=0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) !=0 )
    {
        if ((flags &kSCNetworkReachabilityFlagsInterventionRequired) ==0)
        {
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags &kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN)
    {
        CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
        NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
        
        if (currentRadioAccessTechnology)
        {
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
            {
                strNetworkType =  @"4G";
            }
            else
            {
                strNetworkType =  @"2G/3G";
            }
        }
    }
    return strNetworkType;
}


+ (NSString *)wifi
{
    if (![[self networkType] isEqualToString:@"WIFI"]) {
        return @"";
    }
    NSArray*wiFiName=CFBridgingRelease(CNCopySupportedInterfaces());
    id info1 = nil;
    for (NSString *wfName in wiFiName) {

        info1 = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) wfName);
        if (info1 && [info1 count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info1;
    NSString*ssidName=[dic objectForKey:@"SSID"];
    return ssidName;
}

+ (NSString *)wifiMac
{
    if (![[self networkType] isEqualToString:@"WIFI"]) {
        return @"";
    }
    NSArray*wfMac=CFBridgingRelease(CNCopySupportedInterfaces());
    id info1 = nil;
    for (NSString *macName in wfMac) {
        info1 = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) macName);
        if (info1 && [info1 count]) {
            
            break;
            
        }
        
    }
    
    NSDictionary *dic = (NSDictionary *)info1;
    
    NSString *wifiMac = [dic objectForKey:@"BSSID"];
    
    return wifiMac;
}

+ (NSString *)localIP
{
    NSString *localIP = @"";
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs) == 0)
    {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}
-(void)locationService {
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精确度到米
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [self.locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
 
    
   // NSArray *array = @[self.locationManager.location];
    
    
   // [self.locationManager.delegate locationManager:self.locationManager didUpdateLocations:array];
}
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) {
            NSLog(@"访问被拒绝");
        }
        if ([error code] == kCLErrorLocationUnknown) {
            NSLog(@"无法获取位置信息");
        }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    
    CLLocation * location = locations.lastObject;
//    // 纬度
//    CLLocationDegrees latitude = location.coordinate.latitude;
//    // 经度
//    CLLocationDegrees longitude = location.coordinate.longitude;
//    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
           
            [BGGDataModel sharedInstance].provinces = placemark.administrativeArea;
            [BGGDataModel sharedInstance].city = city;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                [BGGDataModel sharedInstance].provinces = placemark.administrativeArea;
                [BGGDataModel sharedInstance].city = placemark.locality;
            }
            [BGGDataModel sharedInstance].timeZone = [NSString stringWithFormat:@"%@",placemark.timeZone];
            // 位置名
             
            
           
        }else if (error == nil && [placemarks count] == 0) {
            
        } else if (error != nil){
            
        }
    }];
    
    [_locationManager stopUpdatingLocation];

}
@end
