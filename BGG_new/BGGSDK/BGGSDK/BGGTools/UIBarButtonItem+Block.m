//
//  UIBarButtonItem+Block.m
//  LCProject
//
//  Created by liangrongchang on 2017/5/26.
//  Copyright © 2017年 Rochang. All rights reserved.
//

#import "UIBarButtonItem+Block.h"
#import <objc/runtime.h>

static char *UIButtonBlockKey;

@implementation UIBarButtonItem (Block)

- (instancetype)initWithImage:(UIImage *)image action:(void (^)(id))action {
    self = [self initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handAction:)];
    if (!self) {
        return nil;
    }
    objc_setAssociatedObject(self, UIButtonBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(id))action {
    self = [self initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(handAction:)];
    if (!self) {
        return nil;
    }
    objc_setAssociatedObject(self, UIButtonBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}

- (void)handAction:(UIBarButtonItem *)sender {
    void (^block)(id) = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) block(sender);
}

@end
