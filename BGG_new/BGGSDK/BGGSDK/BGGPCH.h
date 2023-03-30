
//
//  BGGPCH.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#ifndef BGGPCH_h
#define BGGPCH_h
#import "UIColor+LC.h"
#import "UIImage+BGG.h"
#import "Masonry.h"
#import "BGGButton.h"
#import "BGGView.h"
#import "BGGHTTPRequest.h"
#import "NSObject+BGGHUD.h"
#import "BGGDataModel.h"
#import "BGGPMData.h"
#import "BGGSDK.h"
#import "BGGDeviceInfo.h"

static NSInteger CUTDOWNTIME = 60;/**验证码倒计时时间<*/
static CGFloat SYPopAnimationTIME = 0;/**页面跳转时间<*/

// Weak
#define SYWeakObject(obj)__weak typeof((obj)) weak_##obj = (obj);
// Strong
#define SYStrongObject(obj,weak_Object)__strong typeof((obj)) strong_##obj = (weak_Object);

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark - ====判断横竖屏====
#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define kRealScale(sizeparam) (sizeparam*[PublicFun phoneHeightScale]) //布局的比例适配
#define kFontScale(sizeparam) (sizeparam*[PublicFun phoneFontScale]) //文字大小适配
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define KBGGLoginRect     IsPortrait ? CGRectMake(0, 0,SCREEN_WIDTH-40 , 280) : CGRectMake(0, 0,SCREEN_HEIGHT-40 , 280)
#define KBGGMenuRect      IsPortrait ? CGRectMake(0, 0,SCREEN_WIDTH-78 , 260) : CGRectMake(0, 0,SCREEN_HEIGHT-78 , 260)
#define KBGGForgetPWD     IsPortrait ? CGRectMake(0, 0,SCREEN_WIDTH-40 , 300) : CGRectMake(0, 0,SCREEN_HEIGHT-40 , 300)
#define KBGGAutoLoginRect   CGRectMake(0, 0,300 , 55)
#define KBGGNoticeRect       IsPortrait ? CGRectMake(0, 0,SCREEN_WIDTH-40 , 200) : CGRectMake(0, 0,SCREEN_HEIGHT-40 , 200)
#define KBGGSMRZRect       CGRectMake(0, 0,300 , 340)
#define KBGGRuleRect       CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT)
#define KBGGUserCenterRect  CGRectMake(0, 0,400 , 600)
#define KBGGGongGaoRect  IsPortrait ? CGRectMake(0, 0,SCREEN_WIDTH-50 , SCREEN_HEIGHT-80) :  CGRectMake(0, 0,SCREEN_WIDTH-80 , SCREEN_HEIGHT-80)
#define KBGGPrivacyRect  CGRectMake(0, 0,320 , 190) 

#pragma mark - ====文字大小====
#define Font(size)                  [UIFont systemFontOfSize:(size)]
#define MFont(fontSize)             [UIFont fontWithName:@".PingFangSC-Medium" size:(fontSize)]
#define BoldFont(size)              [UIFont boldSystemFontOfSize:(size)]
#define DefaultWidth                375.0
#define ScreenScale                 SCREEN_WIDTH/DefaultWidth
#define Scale(size)                 (size)*ScreenScale

#define KFONTS11 [UIFont systemFontOfSize:kFontScale(11)]
#define KFONTS12 [UIFont systemFontOfSize:kFontScale(12)]
#define KFONTS13 [UIFont systemFontOfSize:kFontScale(13)]
#define KFONTS14 [UIFont systemFontOfSize:kFontScale(14)]
#define KFONTS15 [UIFont systemFontOfSize:kFontScale(15)]
#define Font(size) [UIFont systemFontOfSize:(size)]
#define navigationFont  16   //系统默认的导航栏左上角和右上角的字体大小
#define KFontSize(fontsize) ([UIFont fontWithName:@"SourceHanSansCN-Normal" size:fontsize])//字体
#define KDefaultFontSize(fontsize) ([UIFont systemFontOfSize:kFontScale(fontsize)])

#pragma mark - ====颜色====

#define RGB(r, g, b)  [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ColorRGB(r, g, b)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define ColorRGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Color_hex(hexString)   [UIColor colorWithHexString:hexString]
#define Color_hexA(hexString, a)   [UIColor colorWithHexString:hexString alpha:a]
#define BGGWhiteColor Color_hex(@"#ffffff")
#define BGGGrayColor Color_hex(@"#333333")
#define BGGredColor Color_hex(@"#fb4f4f")
#define BGGBlackColor Color_hex(@"#4a4948")
#define BGGLightGrayColor Color_hex(@"#c0c0c0")
#define BGGBigButtonHeight 45.0
#define BGGCornerRadius 3
#define BGGTFLeftSpace 10

#pragma mark - ====判断NSString是否为空====
#define isStrEmpty(str)  ((str) == nil || [(str) isKindOfClass:[NSNull class]] || [(str) isEqual:@""])


#pragma mark - ====判断机型====
#define KIs4_inch CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size) ? YES : NO
#define KIs4_7_inch CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size) ? YES : NO
#define KIs5_5_inch CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size) ? YES : NO
#define IS_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(414*3, 896*3), [[UIScreen mainScreen] currentMode].size) : NO)
#define KIsIphone_X_series [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0



#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DLog(...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];\
printf("%s %s 第%d行:%s\n\n",[dateString UTF8String],[LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);}
#else
#define DLog(...)
#endif
#endif /* BGGPCH_h */
