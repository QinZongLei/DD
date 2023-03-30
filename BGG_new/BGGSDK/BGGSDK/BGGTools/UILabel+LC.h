//
//  UILabel+LC.h
//  Unicorn_iOS_OC
//
//  Created by Qz on 2019/1/15.
//  Copyright © 2019 Liangrc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LC)

/** 指定text font */
- (void)lc_setFont:(UIFont *)font text:(NSString *)text;

/** 指定text color */
- (void)lc_setColor:(UIColor *)color text:(NSString *)text;
- (void)lc_setColor:(UIColor *)color texts:(NSArray <NSString *>*)texts;

/** 指定text 文字间距 */
- (void)lc_setTextSpace:(CGFloat)space text:(NSString *)text;

/** 指定text 删除线 color */
- (void)lc_setthroughLineColor:(UIColor *)color text:(NSString *)text;

/** 指定text 下划线 color */
- (void)lc_setUnderLineColor:(UIColor *)color text:(NSString *)text;

/**  段落 文本字间距,行间距 lineSpace - itemSpace | */
- (void)lc_setLineSpace:(CGFloat)lineSpace interItemSpace:(CGFloat)itemSpace text:(NSString *)text;

/** 计算文字行数 */
- (NSUInteger)lc_linesWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
