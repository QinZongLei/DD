//
//  UIControl+Block.m
//  LCProject
//
//  Created by liangrongchang on 2017/5/26.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import "UIControl+Block.h"
#import <objc/runtime.h>

static char *UIControlBlockKey;

@implementation UIControl (Block)

- (void)addAction:(actionBlock)action forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, &UIControlBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:controlEvents];
}

- (void)buttonClick:(UIControl *)sender {
    actionBlock blockClick = objc_getAssociatedObject(self, &UIControlBlockKey);
    if (blockClick != nil) {
        blockClick(sender);
    }
}

@end
