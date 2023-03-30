//
//  BGGDeleteAccountBtn.m
//  BGGSDK
//
//  Created by 李胜 on 2021/7/28.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGDeleteAccountBtn.h"
#import "BGGPCH.h"
@interface BGGDeleteAccountBtn()
@property(nonatomic,strong)UIColor *col;
@end
@implementation BGGDeleteAccountBtn

- (void)setupStyle:(UIColor *)color{
    self.col = color;
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect
{
    
    
    UIBezierPath *line1 = [[UIBezierPath alloc] init];
    //设置线宽
    line1.lineWidth = 1;
    [line1 moveToPoint:CGPointMake(10, 10)];
    [line1 addLineToPoint:CGPointMake(20, 20)];
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
    [line2 moveToPoint:CGPointMake(20, 10)];
    [line2 addLineToPoint:CGPointMake(10, 20)];
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
