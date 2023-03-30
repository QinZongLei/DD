//
//  BGGCloseButton.m
//  NEWXLS_Game_MDFZ
//
//  Created by 卢祥庭 on 2018/4/17.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "BGGCloseButton.h"
#import "BGGPCH.h"
@interface BGGCloseButton()
@property(nonatomic,strong)UIColor *col;
@end

@implementation BGGCloseButton

- (void)setupStyle:(UIColor *)color{
    self.col = color;
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect
{
    UIColor* fillColor = self.col;
    


    
    UIBezierPath *line1 = [[UIBezierPath alloc] init];
    //设置线宽
    line1.lineWidth = 1;
    [line1 moveToPoint:CGPointMake(17, 17)];
    [line1 addLineToPoint:CGPointMake(32, 32)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [self.col setStroke];
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
    [line2 moveToPoint:CGPointMake(32, 17)];
    [line2 addLineToPoint:CGPointMake(17, 32)];
    //设置绘制线条颜色，这个地方需要注意！UIBezierPath本身类中不包含设置颜色的属性，它是通过UIColor来直接设置。
    [self.col setStroke];
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
