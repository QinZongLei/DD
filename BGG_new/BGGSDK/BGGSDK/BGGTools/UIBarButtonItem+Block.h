//
//  UIBarButtonItem+Block.h
//  LCProject
//
//  Created by liangrongchang on 2017/5/26.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Block)

- (instancetype)initWithImage:(UIImage *)image action:(void (^)(id sender))action;

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(id sender))action;

@end
