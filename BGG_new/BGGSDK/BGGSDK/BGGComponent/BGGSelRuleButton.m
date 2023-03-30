//
//  BGGSelRuleButton.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/1.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGSelRuleButton.h"
#import "BGGPCH.h"
@implementation BGGSelRuleButton
- (void)setupStyle
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    UIBezierPath *line1 = [[UIBezierPath alloc] init];
    //设置线宽
    line1.lineWidth = 1;
    [line1 moveToPoint:CGPointMake(1, 10)];
    [line1 addLineToPoint:CGPointMake(7, 18)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [BGGWhiteColor setStroke];
    /*
    *线条形状
    *kCGLineCapButt,   //不带端点
    *kCGLineCapRound,  //端点带圆角
    *kCGLineCapSquare  //端点是正方形
    */
    line1.lineCapStyle = kCGLineCapRound;
    [line1 stroke];
    
    UIBezierPath *line2 = [[UIBezierPath alloc] init];
    //设置线宽
    line2.lineWidth = 1;
    [line2 moveToPoint:CGPointMake(7, 18)];
    [line2 addLineToPoint:CGPointMake(18, 3)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [BGGWhiteColor setStroke];
    /*
    *线条形状
    *kCGLineCapButt,   //不带端点
    *kCGLineCapRound,  //端点带圆角
    *kCGLineCapSquare  //端点是正方形
    */
    line2.lineCapStyle = kCGLineCapRound;
    [line2 stroke];
    
}



@end
