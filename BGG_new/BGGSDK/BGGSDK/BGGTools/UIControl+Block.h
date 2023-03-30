//
//  UIControl+Block.h
//  LCProject
//
//  Created by liangrongchang on 2017/5/26.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionBlock)(id sender);

@interface UIControl (Block)

- (void)addAction:(actionBlock)action forControlEvents:(UIControlEvents)controlEvents;

@end
