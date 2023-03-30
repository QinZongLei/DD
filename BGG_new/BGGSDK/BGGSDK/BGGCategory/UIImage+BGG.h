//
//  UIImage+BGG.h
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BGG)
//加载图片
+ (UIImage *)BGGGetImage:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
