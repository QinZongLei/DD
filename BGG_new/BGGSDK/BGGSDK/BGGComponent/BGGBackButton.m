//
//  BGGBackButton.m
//  NEWXLS_Game_MDFZ
//
//  Created by 卢祥庭 on 2018/4/17.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "BGGBackButton.h"
#import "BGGPCH.h"


@interface BGGBackButton ()

@property (nonatomic) kNEWXLS_BackButtonStyle buttonStyle;

@end

@implementation BGGBackButton

- (void)setStyle:(kNEWXLS_BackButtonStyle)style
{
    self.buttonStyle = style;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.buttonStyle == kNEWXLS_BackButtonStyleGray)
    {
        [self setNEWXLS_BackButtonIsGray:YES];
    }
    else if (self.buttonStyle == kNEWXLS_BackButtonStyleOrange)
    {
        [self setNEWXLS_BackButtonIsGray:NO];
    }
}

- (void)setNEWXLS_BackButtonIsGray:(BOOL)isGray
{
    UIColor* fillColor = isGray ? BGGLightGrayColor:BGGBlackColor;
    
    
//    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
//    [bezierPath moveToPoint: CGPointMake(21.36, 6.97)];
//    [bezierPath addLineToPoint: CGPointMake(20, 5.62)];
//    [bezierPath addLineToPoint: CGPointMake(7.5, 18.12)];
//    [bezierPath addLineToPoint: CGPointMake(20, 30.62)];
//    [bezierPath addLineToPoint: CGPointMake(21.36, 29.27)];
//    [bezierPath addLineToPoint: CGPointMake(10.21, 18.12)];
//    [bezierPath addLineToPoint: CGPointMake(21.36, 6.97)];
//    [bezierPath closePath];
//    bezierPath.miterLimit = 4;
//
//    [fillColor setFill];
//    [bezierPath fill];
    
    UIBezierPath *line1 = [[UIBezierPath alloc] init];
    //设置线宽
    line1.lineWidth = 1;
    [line1 moveToPoint:CGPointMake(15, 25)];
    [line1 addLineToPoint:CGPointMake(25, 15)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [fillColor setStroke];
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
    [line2 moveToPoint:CGPointMake(15, 25)];
    [line2 addLineToPoint:CGPointMake(25, 35)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [fillColor setStroke];
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
