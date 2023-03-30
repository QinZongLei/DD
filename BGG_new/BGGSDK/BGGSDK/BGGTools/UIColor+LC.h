//
//  UIColor+LC.h
//  Unicorn_iOS_OC
//
//  Created by Qz on 2019/1/11.
//  Copyright © 2019 Liangrc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColorType) {
    ColorTypeTopBottom,
    ColorTypeLeftRight
};

@interface UIColor (LC)

/** 颜色渐变 */
+ (CAGradientLayer *)lc_gradientLayerFrame:(CGRect)frame colorType:(ColorType)type fromColor:(UIColor *)color toColor:(UIColor *)toColor;

/** 16进制颜色 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/** 16进制颜色 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/* 获取图片某点像素颜色 */
+ (UIColor *)colorAtPixel:(CGPoint)point imageView:(UIImageView *)imageView;

@end
