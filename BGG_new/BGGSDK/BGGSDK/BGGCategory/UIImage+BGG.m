//
//  UIImage+BGG.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "UIImage+BGG.h"




@implementation UIImage (BGG)
//加载图片
+ (UIImage *)BGGGetImage:(NSString *)imageName{
    NSBundle *bundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"BGGSDK.bundle"]];
       
       if (bundle == nil) return [UIImage imageNamed:imageName];
       UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
       if (image == nil) {
           image = [UIImage imageNamed:imageName];
       }
       return image;
}
@end
