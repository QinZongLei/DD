//
//  UIView+LCLayout.h
//  LCPlayer
//
//  Created by liangrongchang on 2017/3/8.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ScaleType) {
    ScaleTypeConstraint = 1<<0, // 对约束的constant等比例
    ScaleTypeFontSize = 1<<1, // 对字体等比例
    ScaleTypeCornerRadius = 1<<2, // 对圆角等比例
    ScaleTypeAll = ~0UL, // 对现有支持的属性等比例
};

typedef UIView *(^layoutValueBlock)(CGFloat value);
typedef UIView *(^layoutEdgeBlock)(UIEdgeInsets edge);
typedef UIView *(^layoutPointBlock)(CGPoint point);
typedef UIView *(^layoutSizeBlock)(CGSize size);


@interface UIView (LCLayout)

#pragma mark - setter / getter
@property (assign, nonatomic) CGFloat x_gs;
@property (assign, nonatomic) CGFloat y_gs;
@property (assign, nonatomic) CGFloat width_gs;
@property (assign, nonatomic) CGFloat height_gs;

@property (assign, nonatomic) CGFloat top_gs;
@property (assign, nonatomic) CGFloat left_gs;
@property (assign, nonatomic) CGFloat bottom_H_gs;
@property (assign, nonatomic) CGFloat bottom_Y_gs;
@property (assign, nonatomic) CGFloat right_W_gs;
@property (assign, nonatomic) CGFloat right_X_gs;

@property (assign, nonatomic) CGFloat centerX_gs;
@property (assign, nonatomic) CGFloat centerY_gs;
@property (assign, nonatomic) CGSize size_gs;
@property (assign, nonatomic) CGPoint orgin_gs;

- (void)addSubViews_lc:(NSArray <UIView *>*)subViews;

#pragma mark - 链式

- (layoutValueBlock)x_lc;
- (layoutValueBlock)y_lc;
- (layoutValueBlock)width_lc;
- (layoutValueBlock)height_lc;

- (layoutValueBlock)top_lc;
- (layoutValueBlock)bottom_lc;
/** 必须先 add superView */
- (layoutValueBlock)bottom_out_lc;
- (layoutValueBlock)left_lc;
- (layoutValueBlock)right_lc;
/** 必须先 add superView */
- (layoutValueBlock)right_out_lc;

- (layoutPointBlock)center_lc;
- (layoutValueBlock)centerX_lc;
- (layoutValueBlock)centerY_lc;
- (layoutSizeBlock)size_lc;

/** 跟父控件的edge,传入UIEdgeInsets */
- (layoutEdgeBlock)edge_lc;

/** 控件 / 字体缩放 */
- (void)lc_scaleWithType:(ScaleType)type exceptClass:(NSArray<Class> *)exceptClass;

/** 取消按钮highlight */
- (void)lc_BtnCancelHighlight;

@end
