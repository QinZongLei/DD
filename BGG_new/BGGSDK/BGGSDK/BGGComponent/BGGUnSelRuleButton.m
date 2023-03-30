//
//  BGGUnSelRuleButton.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/1.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGUnSelRuleButton.h"
#import "BGGPCH.h"
@implementation BGGUnSelRuleButton

- (void)setupStyle
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:CGRectMake(1, 1, 18, 18)];
    //边框线宽
    rectangle.lineWidth = 1;
    //边框线颜色
    [BGGLightGrayColor setStroke];
    /*
    *线条之间连接点形状
    *kCGLineJoinMiter,      //内斜接
    *kCGLineJoinRound,     //圆角
    *kCGLineJoinBevel      //外斜接
    */
    rectangle.lineJoinStyle = kCGLineJoinRound;
    //绘制边框
    [rectangle stroke];
    //设置填充颜色
    [[UIColor whiteColor] setFill];
    //绘制矩形内部填充部分
    [rectangle fill];
    
}

@end
