//
//  UIView+LCLayout.m
//  LCPlayer
//
//  Created by liangrongchang on 2017/3/8.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import "UIView+LCLayout.h"
#import "BGGPCH.h"
@implementation UIView (LCLayout)

#pragma mark - setter / getter
- (CGFloat)x_gs {
    return self.frame.origin.x;
}

- (void)setX_gs:(CGFloat)x_gs {
    CGRect frame = self.frame;
    frame.origin.x = x_gs;
    self.frame = frame;
}

- (CGFloat)y_gs {
    return self.frame.origin.y;
}

- (void)setY_gs:(CGFloat)y_gs {
    CGRect frame = self.frame;
    frame.origin.y = y_gs;
    self.frame = frame;
}

- (CGFloat)width_gs {
    return self.frame.size.width;
}

- (void)setWidth_gs:(CGFloat)width_gs {
    CGRect frame = self.frame;
    frame.size.width = width_gs;
    self.frame = frame;
}

- (CGFloat)height_gs {
    return self.frame.size.height;
}

- (void)setHeight_gs:(CGFloat)height_gs {
    CGRect frame = self.frame;
    frame.size.height = height_gs;
    self.frame = frame;
}

- (CGFloat)left_gs {
    return self.x_gs;
}

- (void)setLeft_gs:(CGFloat)left_gs {
    self.x_gs = left_gs;
}

- (CGFloat)top_gs {
    return self.y_gs;
}

- (void)setTop_gs:(CGFloat)top_gs {
    self.y_gs = top_gs;
}

- (CGFloat)right_X_gs {
    return self.x_gs + self.width_gs;
}

- (CGFloat)right_W_gs {
    return self.right_X_gs;
}

- (void)setRight_W_gs:(CGFloat)right_W_gs {
    self.width_gs = right_W_gs - self.x_gs;
}

- (void)setRight_X_gs:(CGFloat)right_X_gs {
    self.x_gs = right_X_gs - self.width_gs;
}

- (CGFloat)bottom_Y_gs {
    return self.y_gs + self.height_gs;
}

- (void)setBottom_H_gs:(CGFloat)bottom_H_gs {
    self.height_gs = bottom_H_gs - self.y_gs;
}

- (CGFloat)bottom_H_gs {
    return self.bottom_Y_gs;
}

- (void)setBottom_Y_gs:(CGFloat)bottom_H_gs {
    self.y_gs = bottom_H_gs - self.height_gs;
}

- (CGFloat)centerX_gs {
    return self.width_gs / 2 + self.x_gs;
}

- (void)setCenterX_gs:(CGFloat)centerX_gs {
    CGPoint center = self.center;
    center.x = centerX_gs;
    self.center = center;
}

- (CGFloat)centerY_gs {
    return self.height_gs / 2 + self.y_gs;
}

- (void)setCenterY_gs:(CGFloat)centerY_gs {
    CGPoint center = self.center;
    center.y = centerY_gs;
    self.center = center;
}

- (CGSize)size_gs {
    return self.frame.size;
}

- (void)setSize_gs:(CGSize)size_gs {
    CGRect frame = self.frame;
    frame.size = size_gs;
    self.frame = frame;
}

- (CGPoint)orgin_gs {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y);
}

- (void)setOrgin_gs:(CGPoint)orgin_gs {
    CGRect frame = self.frame;
    frame.origin = orgin_gs;
    self.frame = frame;
}

- (void)addSubViews_lc:(NSArray<UIView *> *)subViews {
    if (subViews.count) {
        [subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:obj];
        }];
    }
}

#pragma mark - 链式
- (layoutValueBlock)x_lc {
    return ^(CGFloat value){
        self.x_gs = value;
        return self;
    };
}

- (layoutValueBlock)y_lc {
    return ^(CGFloat value){
        self.y_gs = value;
        return self;
    };
}

- (layoutValueBlock)width_lc {
    return ^(CGFloat value){
        self.width_gs = value;
        return self;
    };
}

- (layoutValueBlock)height_lc {
    return ^(CGFloat value){
        self.height_gs = value;
        return self;
    };
}

- (layoutValueBlock)top_lc {
    return ^(CGFloat value){
        self.y_lc(value);
        return self;
    };
}

- (layoutValueBlock)bottom_lc {
    return ^(CGFloat value){
        self.height_gs = value - self.y_gs;
        return self;
    };
}

- (layoutValueBlock)bottom_out_lc {
    return ^(CGFloat value){
        self.height_gs = self.superview.bottom_Y_gs + value;
        return self;
    };
}

- (layoutValueBlock)left_lc {
    return ^(CGFloat value){
        self.x_lc(value);
        return self;
    };
}

- (layoutPointBlock)center_lc {
    return ^(CGPoint point) {
        self.center = point;
        return self;
    };
}

- (layoutSizeBlock)size_lc {
    return ^(CGSize size) {
        self.size_gs = size;
        return self;
    };
}

- (layoutValueBlock)centerX_lc {
    return ^(CGFloat value){
        self.center = CGPointMake(value, self.center.y);
        return self;
    };
}

- (layoutValueBlock)centerY_lc {
    return ^(CGFloat value){
        self.center = CGPointMake(self.center.x, value);
        return self;
    };
}

- (layoutValueBlock)right_lc {
    return ^(CGFloat value){
        self.width_gs = value - self.x_gs;
        return self;
    };
}

- (layoutValueBlock)right_out_lc {
    return ^(CGFloat value){
        self.right_lc(self.superview.right_X_gs + value);
        return self;
    };
}

- (layoutEdgeBlock)edge_lc {
    return ^(UIEdgeInsets edge){
        self.top_gs = edge.top;
        self.left_gs = edge.left;
        self.bottom_H_gs = self.superview.bottom_H_gs + edge.bottom;
        self.right_W_gs = self.superview.width_gs + edge.right;
        return self;
    };
}

- (void)lc_scaleWithType:(ScaleType)type exceptClass:(NSArray<Class> *)exceptClass {
    if ([self isExceptViewClassInClassArray:exceptClass]) {
        return;
    }
    // 是否要对约束进行等比例
    BOOL scaleConstraint = ((type & ScaleTypeConstraint) || type == ScaleTypeAll);
    
    // 是否对字体大小进行等比例
    BOOL scaleFontSize = ((type & ScaleTypeFontSize) || type == ScaleTypeAll);
    
    // 是否对圆角大小进行等比例
    BOOL scaleCornerRadius = ((type & ScaleTypeCornerRadius) || type == ScaleTypeAll);
    
    // 约束
    if (scaleConstraint) {
        [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull subConstraint, NSUInteger idx, BOOL * _Nonnull stop) {
            subConstraint.constant = Scale(subConstraint.constant);
        }];
    }
    
    // 字体大小
    if (scaleFontSize) {
        
        if ([self isKindOfClass:[UILabel class]] && ![self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
            UILabel *labelSelf = (UILabel *)self;
            labelSelf.font = [UIFont fontWithName:labelSelf.font.fontName size:Scale(labelSelf.font.pointSize)];
        }
        else if ([self isKindOfClass:[UITextField class]]) {
            UITextField *textFieldSelf = (UITextField *)self;
            textFieldSelf.font = [UIFont fontWithName:textFieldSelf.font.fontName size:Scale(textFieldSelf.font.pointSize)];
        }
        else  if ([self isKindOfClass:[UIButton class]]) {
            UIButton *buttonSelf = (UIButton *)self;
            buttonSelf.titleLabel.font = [UIFont fontWithName:buttonSelf.titleLabel.font.fontName size:Scale(buttonSelf.titleLabel.font.pointSize)];
            
        }
        else  if ([self isKindOfClass:[UITextView class]]) {
            UITextView *textViewSelf = (UITextView *)self;
            textViewSelf.font = [UIFont fontWithName:textViewSelf.font.fontName size:Scale(textViewSelf.font.pointSize)];
        }
    }
    
    // 圆角
    if (scaleCornerRadius) {
        if (self.layer.cornerRadius) {
            self.layer.cornerRadius = Scale(self.layer.cornerRadius);
        }
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        // 继续对子view操作
        [subView lc_scaleWithType:type exceptClass:exceptClass];
    }];
    
}

// view 是否除外
- (BOOL)isExceptViewClassInClassArray:(NSArray<Class> *)exceptClass {
    __block BOOL isExcept = NO;
    [exceptClass enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:obj]) {
            isExcept = YES;
            *stop = YES;
        }
    }];
    return isExcept;
}

/** 取消按钮highlight */
- (void)lc_BtnCancelHighlight {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            ((UIButton *)obj).adjustsImageWhenHighlighted = NO;
            ((UIButton *)obj).highlighted = NO;
            ((UIButton *)obj).showsTouchWhenHighlighted = NO;
        } 
    }];
}


@end
