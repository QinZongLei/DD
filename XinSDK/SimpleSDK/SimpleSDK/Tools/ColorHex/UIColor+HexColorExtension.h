//
//  UIColor+HexColorExtension.h
//  ZwinSimpSDK
//
//  Created by mac on 2021/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZNWinObj_HexColor)

+ (UIColor *)ZNWinObj_colorWithHexString:(NSString *)color;
+ (UIColor *)ZNWinObj_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
