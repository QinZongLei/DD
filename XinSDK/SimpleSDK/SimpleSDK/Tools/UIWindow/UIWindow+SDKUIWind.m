//
//  UIWindow+SDKUIWind.m
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import "UIWindow+SDKUIWind.h"
#import <objc/message.h>

static NSMutableArray * clickArray;

@implementation UIWindow (SDKUIWind)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clickArray = [NSMutableArray array];
        [self exchangeMethod];
    });
}

+ (void)exchangeMethod{
    SEL originalSelector = @selector(hitTest:withEvent:);
    SEL exchangeSelector = @selector(oshitTest:withEvent:);
    Method originalMethod = class_getInstanceMethod(UIWindow.class, originalSelector);
    Method exchangeMethod = class_getInstanceMethod(UIWindow.class, exchangeSelector);
    BOOL is_exchange = class_addMethod(UIWindow.class, originalSelector, method_getImplementation(exchangeMethod), method_getTypeEncoding(exchangeMethod));
    if (is_exchange) {
        class_replaceMethod(UIWindow.class, exchangeSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, exchangeMethod);
    }
}

- (UIView *)oshitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [self handlerHitTest:point withEvent:event];
    return [self oshitTest:point withEvent:event];
}

-(void)handlerHitTest:(CGPoint) point withEvent: (UIEvent*) event{
    ///判断是否过审   上报界面点击状况
    if (CGSizeEqualToSize(self.bounds.size, [UIScreen mainScreen].bounds.size)) {
        [self saveClickPoint:point];
    }
}

- (void)saveClickPoint:(CGPoint) point {
    [clickArray addObject:@{
        ///保存XY
        @"ParamX": [NSString stringWithFormat:@"%d", (int)point.x],
       @"ParamY" : [NSString stringWithFormat:@"%d", (int)point.y],
        @"ParamTime": @((long long)[[NSDate date] timeIntervalSince1970])
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (clickArray.count > 0) {
            [self reportClick];
        }
    });
}
- (void)reportClick{
    //上报接口
    if (true) {
     
        
    }
    [clickArray removeAllObjects];
}

@end
