//
//  SYPopupController.m
//  SYSDK
//
//  Created by 黄晓丹 on 2017/11/29.
//  Copyright © 2017年 qianhai. All rights reserved.
//


#import "SYPopupController.h"
#import <objc/runtime.h>

@interface SYPopupController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIView *superview;
@property (nonatomic, strong, readonly) UIView *maskView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign, readonly) CGFloat dropAngle;
@property (nonatomic, assign, readonly) CGPoint markerCenter;
@property (nonatomic, assign, readonly) syPopupMaskType maskType;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@end

static void *syPopupControllerParametersKey = &syPopupControllerParametersKey;
static void *syPopupControllerNSTimerKey = &syPopupControllerNSTimerKey;

@implementation SYPopupController

+ (instancetype)popupControllerWithMaskType:(syPopupMaskType)maskType {
    return [[self alloc] initWithMaskType:maskType];
}

- (instancetype)init {
    return [self initWithMaskType:syPopupMaskTypeBlackTranslucent];
}

- (instancetype)initWithMaskType:(syPopupMaskType)maskType {
    if (self = [super init]) {
        _isPresenting = NO;
        _maskType = maskType;
        _layoutType = syPopupLayoutTypeCenter;
        _dismissOnMaskTouched = YES;
        
        // setter
        self.maskAlpha = 0.5f;
        self.slideStyle = syPopupSlideStyleFade;
        self.dismissOppositeDirection = NO;
        self.allowPan = NO;
        
        // superview
        _superview = [self frontWindow];
        
        // maskView
        if (maskType == syPopupMaskTypeBlackBlur || maskType == syPopupMaskTypeWhiteBlur) {
            if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
                _maskView = [[UIToolbar alloc] initWithFrame:_superview.bounds];
            } else {
                _maskView = [[UIView alloc] initWithFrame:_superview.bounds];
                UIVisualEffectView *visualEffectView;
                visualEffectView = [[UIVisualEffectView alloc] init];
                visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                visualEffectView.frame = _superview.bounds;
                self.visualEffectView = visualEffectView;
                [_maskView insertSubview:visualEffectView atIndex:0];
            }
        } else {
            _maskView = [[UIView alloc] initWithFrame:_superview.bounds];
        }
        
        switch (maskType) {
            case syPopupMaskTypeBlackBlur: {
                if ([_maskView isKindOfClass:[UIToolbar class]]) {
                    [(UIToolbar *)_maskView setBarStyle:UIBarStyleBlack];
                } else {
                    UIVisualEffectView *effectView = (UIVisualEffectView *)_maskView.subviews.firstObject;
                    effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                }
            } break;
            case syPopupMaskTypeWhiteBlur: {
                if ([_maskView isKindOfClass:[UIToolbar class]]) {
                    [(UIToolbar *)_maskView setBarStyle:UIBarStyleDefault];
                } else {
                    UIVisualEffectView *effectView = (UIVisualEffectView *)_maskView.subviews.firstObject;
                    effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                }
            } break;
            case syPopupMaskTypeWhite:
                _maskView.backgroundColor = [UIColor whiteColor];
                break;
            case syPopupMaskTypeClear:
                _maskView.backgroundColor = [UIColor clearColor];
                break;
            default: // syPopupMaskTypeBlackTranslucent
                _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
                break;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        
        // popupView
        _popupView = [[UIView alloc] init];

        // addSubview
        [_maskView addSubview:_popupView];
        [_superview addSubview:_maskView];
        
        // Observer statusBar orientation changes.
        [self bindNotificationEvent];
    }
    return self;
}

#pragma mark - Setter

- (void)setDismissOppositeDirection:(BOOL)dismissOppositeDirection {
    _dismissOppositeDirection = dismissOppositeDirection;
    objc_setAssociatedObject(self, _cmd, @(dismissOppositeDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSlideStyle:(syPopupSlideStyle)slideStyle {
    _slideStyle = slideStyle;
    objc_setAssociatedObject(self, _cmd, @(slideStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMaskAlpha:(CGFloat)maskAlpha {
    if (_maskType != syPopupMaskTypeBlackTranslucent) return;
    _maskAlpha = maskAlpha;
    _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
}

- (void)setAllowPan:(BOOL)allowPan {
    if (!allowPan) return;
    if (_allowPan != allowPan) {
        _allowPan = allowPan;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_popupView addGestureRecognizer:pan];
    }
}

#pragma mark - Present

- (void)presentContentView:(UIView *)contentView {
    [self presentContentView:contentView duration:0.25 springAnimated:NO];
}

- (void)presentContentView:(UIView *)contentView displayTime:(NSTimeInterval)displayTime {
    [self presentContentView:contentView duration:0.25 springAnimated:NO inView:nil displayTime:displayTime];
}

- (void)presentContentView:(UIView *)contentView duration:(NSTimeInterval)duration springAnimated:(BOOL)isSpringAnimated {
    [self presentContentView:contentView duration:duration springAnimated:isSpringAnimated inView:nil];
}

- (void)presentContentView:(UIView *)contentView
                  duration:(NSTimeInterval)duration
            springAnimated:(BOOL)isSpringAnimated
                    inView:(UIView *)sView {
    [self presentContentView:contentView duration:duration springAnimated:isSpringAnimated inView:sView displayTime:0];
}

- (void)presentContentView:(UIView *)contentView
                  duration:(NSTimeInterval)duration
            springAnimated:(BOOL)isSpringAnimated
                    inView:(UIView *)sView
               displayTime:(NSTimeInterval)displayTime {
    
    if (self.isPresenting) return;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:@(duration) forKey:@"zh_duration"];
    [parameters setValue:@(isSpringAnimated) forKey:@"zh_springAnimated"];
    objc_setAssociatedObject(self, syPopupControllerParametersKey, parameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (nil != self.willPresent) {
        self.willPresent(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillPresent:)]) {
            [self.delegate popupControllerWillPresent:self];
        }
    }
    
    if (nil != sView) {
        _superview = sView;
        _maskView.frame = _superview.frame;
    }
    [self addContentView:contentView];
    if (![_superview.subviews containsObject:_maskView]) {
        [_superview addSubview:_maskView];
    }
    
    [self prepareDropAnimated];
    [self prepareBackground];
    _popupView.userInteractionEnabled = NO;
    _popupView.center = [self prepareCenter];
    
    void (^presentCompletion)(void) = ^() {
        _isPresenting = YES;
        _popupView.userInteractionEnabled = YES;
        if (nil != self.didPresent) {
            self.didPresent(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
                [self.delegate popupControllerDidPresent:self];
            }
        }
        
        if (displayTime) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:displayTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            objc_setAssociatedObject(self, syPopupControllerNSTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    };
    
    if (isSpringAnimated) {
        [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self finishedDropAnimated];
            [self finishedBackground];
            _popupView.center = [self finishedCenter];
            
        } completion:^(BOOL finished) {
            
            if (finished) presentCompletion();
            
        }];
    } else {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self finishedDropAnimated];
            [self finishedBackground];
            _popupView.center = [self finishedCenter];
            
        } completion:^(BOOL finished) {
            
            if (finished) presentCompletion();
            
        }];
    }
    
}

#pragma mark - Dismiss

- (void)fadeDismiss {
    objc_setAssociatedObject(self, _cmd, @(_slideStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _slideStyle = syPopupSlideStyleFade;
    [self dismiss];
}

- (void)dismiss {
    id object = objc_getAssociatedObject(self, syPopupControllerParametersKey);
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        NSTimeInterval duration = 0.0;
        NSNumber *durationNumber = [object valueForKey:@"zh_duration"];
        if (nil != durationNumber) duration = durationNumber.doubleValue;
        BOOL flag = NO;
        NSNumber *flagNumber = [object valueForKey:@"zh_springAnimated"];
        if (nil != flagNumber) flag = flagNumber.boolValue;
        [self dismissWithDuration:duration springAnimated:flag];
    }
}

- (void)dismissWithDuration:(NSTimeInterval)duration springAnimated:(BOOL)isSpringAnimated {
    [self destroyTimer];
    
    if (!self.isPresenting) return;
    
    if (nil != self.willDismiss) {
        self.willDismiss(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(popupControllerWillDismiss:)]) {
            [self.delegate popupControllerWillDismiss:self];
        }
    }
    
    void (^dismissCompletion)(void) = ^() {
        _slideStyle = [objc_getAssociatedObject(self, @selector(fadeDismiss)) integerValue];
        [self removeSubviews];
        _isPresenting = NO;
        _popupView.transform = CGAffineTransformIdentity;
        if (nil != self.didDismiss) {
            self.didDismiss(self);
        } else {
            if ([self.delegate respondsToSelector:@selector(popupControllerDidDismiss:)]) {
                [self.delegate popupControllerDidDismiss:self];
            }
        }
    };
    
    UIViewAnimationOptions (^animOpts)(syPopupSlideStyle) = ^(syPopupSlideStyle slide){
        if (slide != syPopupSlideStyleShrinkInOut1) {
            return UIViewAnimationOptionCurveLinear;
        }
        return UIViewAnimationOptionCurveEaseInOut;
    };
    
    if (isSpringAnimated) {
        duration *= 0.75;
        NSTimeInterval duration1 = duration * 0.25, duration2 = duration - duration1;
        
        [UIView animateWithDuration:duration1 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self bufferBackground];
            _popupView.center = [self bufferCenter:30];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration2 delay:0.f options:animOpts(self.slideStyle) animations:^{
                
                [self dismissedDropAnimated];
                [self dismissedBackground];
                _popupView.center = [self dismissedCenter];
                
            } completion:^(BOOL finished) {
                if (finished) dismissCompletion();
            }];
            
        }];
        
    } else {
        [UIView animateWithDuration:duration delay:0.f options:animOpts(self.slideStyle) animations:^{
            
            [self dismissedDropAnimated];
            [self dismissedBackground];
            _popupView.center = [self dismissedCenter];
            
        } completion:^(BOOL finished) {
            if (finished) dismissCompletion();
        }];
    }
}

#pragma mark - Add contentView

- (void)addContentView:(UIView *)contentView {
    if (!contentView) {
        if (nil != _popupView.superview) [_popupView removeFromSuperview];
        return;
    }
    _contentView = contentView;
    if (_contentView.superview != _popupView) {
        _contentView.frame = (CGRect){.origin = CGPointZero, .size = contentView.frame.size};
        _contentView.center = _superview.center;
        _popupView.frame = _superview.frame;//_contentView.frame;
        _popupView.backgroundColor = _contentView.backgroundColor;
        if (_contentView.layer.cornerRadius) {
            _popupView.layer.cornerRadius = _contentView.layer.cornerRadius;
            _popupView.clipsToBounds = NO;
        }
        [_popupView addSubview:_contentView];
    }
}

- (void)removeSubviews {
    if (_popupView.subviews.count > 0) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    [_maskView removeFromSuperview];
}

#pragma mark - Drop animated

- (void)dropAnimatedWithRotateAngle:(CGFloat)angle {
    _dropAngle = angle;
    _slideStyle = syPopupSlideStyleFromTop;
}

- (BOOL)dropSupport {
    return (_layoutType == syPopupLayoutTypeCenter && _slideStyle == syPopupSlideStyleFromTop);
}

static CGFloat zh_randomValue(int i, int j) {
    if (arc4random() % 2) return i;
    return j;
}

- (void)prepareDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        _dismissOppositeDirection = YES;
        CGFloat ty = (_maskView.bounds.size.height + _popupView.frame.size.height) / 2;
        CATransform3D transform = CATransform3DMakeTranslation(0, -ty, 0);
        transform = CATransform3DRotate(transform,
                                        zh_randomValue(_dropAngle, -_dropAngle) * M_PI / 180,
                                        0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

- (void)finishedDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        _popupView.layer.transform = CATransform3DIdentity;
    }
}

- (void)dismissedDropAnimated {
    if (_dropAngle && [self dropSupport]) {
        CGFloat ty = _maskView.bounds.size.height;
        CATransform3D transform = CATransform3DMakeTranslation(0, ty, 0);
        transform = CATransform3DRotate(transform,
                                        zh_randomValue(_dropAngle, -_dropAngle) * M_PI / 180,
                                        0, 0, 1.0);
        _popupView.layer.transform = transform;
    }
}

#pragma mark - Mask view background

- (void)prepareBackground {
    switch (_maskType) {
        case syPopupMaskTypeBlackBlur:
        case syPopupMaskTypeWhiteBlur:
            _maskView.alpha = 1;
            break;
        default:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
            break;
    }
}

- (void)finishedBackground {
    switch (_maskType) {
        case syPopupMaskTypeBlackTranslucent:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha];
            break;
        case syPopupMaskTypeWhite:
            _maskView.backgroundColor = [UIColor whiteColor];
            break;
        case syPopupMaskTypeClear:
            _maskView.backgroundColor = [UIColor clearColor];
            break;
        default: break;
    }
}

- (void)bufferBackground {
    switch (_maskType) {
        case syPopupMaskTypeBlackBlur:
        case syPopupMaskTypeWhiteBlur: break;
        case syPopupMaskTypeBlackTranslucent:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:_maskAlpha - _maskAlpha * 0.15];
            break;
        default: break;
    }
}

- (void)dismissedBackground {
    switch (_maskType) {
        case syPopupMaskTypeBlackBlur:
        case syPopupMaskTypeWhiteBlur:
            _maskView.alpha = 0;
            break;
        default:
            _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
            break;
    }
}

#pragma mark - Center point

- (CGPoint)prepareCenterFrom:(NSInteger)type viewRef:(UIView *)viewRef{
    switch (type) {
        case 0: // top
            return CGPointMake(viewRef.center.x,
                               -_popupView.bounds.size.height / 2) ;
        case 1: // bottom
            return CGPointMake(viewRef.center.x,
                               _maskView.bounds.size.height + _popupView.bounds.size.height / 2);
        case 2: // left
            return CGPointMake(-_popupView.bounds.size.width / 2,
                               viewRef.center.y);
        case 3: // right
            return CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                               viewRef.center.y);
        default: // center
            return _maskView.center;
    }
}

- (CGPoint)prepareCenter {
    if (_layoutType == syPopupLayoutTypeCenter) {
        CGPoint point = _maskView.center;
        if (_slideStyle == syPopupSlideStyleShrinkInOut1) {
            _popupView.transform = CGAffineTransformMakeScale(0.15, 0.15);
        } else if (_slideStyle == syPopupSlideStyleShrinkInOut2) {
            _popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } else if (_slideStyle == syPopupSlideStyleFade) {
            _maskView.alpha = 0;
        } else {
            point = [self prepareCenterFrom:_slideStyle viewRef:_maskView];
        }
        return point;
    }
    return [self prepareCenterFrom:_layoutType viewRef:_maskView];
}

- (CGPoint)finishedCenter {
    CGPoint point = _maskView.center;
    switch (_layoutType) {
        case syPopupLayoutTypeTop:
            return CGPointMake(point.x,
                               _popupView.bounds.size.height / 2);
        case syPopupLayoutTypeBottom:
            return CGPointMake(point.x,
                               _maskView.bounds.size.height - _popupView.bounds.size.height / 2);
        case syPopupLayoutTypeLeft:
            return CGPointMake(_popupView.bounds.size.width / 2,
                               point.y);
        case syPopupLayoutTypeRight:
            return CGPointMake(_maskView.bounds.size.width - _popupView.bounds.size.width / 2,
                               point.y);
        default: // syPopupLayoutTypeCenter
        {
            if (_slideStyle == syPopupSlideStyleShrinkInOut1 ||
                _slideStyle == syPopupSlideStyleShrinkInOut2) {
                _popupView.transform = CGAffineTransformIdentity;
            } else if (_slideStyle == syPopupSlideStyleFade) {
                _maskView.alpha = 1;
            }
        }
            return point;
    }
}

- (CGPoint)dismissedCenter {
    if (_layoutType != syPopupLayoutTypeCenter) {
        return [self prepareCenterFrom:_layoutType viewRef:_popupView];
    }
    switch (_slideStyle) {
        case syPopupSlideStyleFromTop:
            return _dismissOppositeDirection ?
            CGPointMake(_popupView.center.x,
                        _maskView.bounds.size.height + _popupView.bounds.size.height / 2) :
            CGPointMake(_popupView.center.x,
                        -_popupView.bounds.size.height / 2);
            
        case syPopupSlideStyleFromBottom:
            return _dismissOppositeDirection ?
            CGPointMake(_popupView.center.x,
                        -_popupView.bounds.size.height / 2) :
            CGPointMake(_popupView.center.x,
                        _maskView.bounds.size.height + _popupView.bounds.size.height / 2);
            
        case syPopupSlideStyleFromLeft:
            return _dismissOppositeDirection ?
            CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                        _popupView.center.y) :
            CGPointMake(-_popupView.bounds.size.width / 2,
                        _popupView.center.y);
            
        case syPopupSlideStyleFromRight:
            return _dismissOppositeDirection ?
            CGPointMake(-_popupView.bounds.size.width / 2,
                        _popupView.center.y) :
            CGPointMake(_maskView.bounds.size.width + _popupView.bounds.size.width / 2,
                        _popupView.center.y);
            
        case syPopupSlideStyleShrinkInOut1:
            _popupView.transform = _dismissOppositeDirection ?
            CGAffineTransformMakeScale(1.75, 1.75) :
            CGAffineTransformMakeScale(0.25, 0.25);
            break;
            
        case syPopupSlideStyleShrinkInOut2:
            _popupView.transform = _dismissOppositeDirection ?
            CGAffineTransformMakeScale(1.2, 1.2) :
            CGAffineTransformMakeScale(0.75, 0.75);
            
        case syPopupSlideStyleFade:
            _maskView.alpha = 0;
        default: break;
    }
    return _popupView.center;
}

#pragma mark - Buffer point

- (CGPoint)bufferCenter:(CGFloat)move {
    CGPoint point = _popupView.center;
    switch (_layoutType) {
        case syPopupLayoutTypeTop:
            point.y += move;
            break;
        case syPopupLayoutTypeBottom:
            point.y -= move;
            break;
        case syPopupLayoutTypeLeft:
            point.x += move;
            break;
        case syPopupLayoutTypeRight:
            point.x -= move;
            break;
        case syPopupLayoutTypeCenter: {
            switch (_slideStyle) {
                case syPopupSlideStyleFromTop:
                    point.y += _dismissOppositeDirection ? -move : move;
                    break;
                case syPopupSlideStyleFromBottom:
                    point.y += _dismissOppositeDirection ? move : -move;
                    break;
                case syPopupSlideStyleFromLeft:
                    point.x += _dismissOppositeDirection ? -move : move;
                    break;
                case syPopupSlideStyleFromRight:
                    point.x += _dismissOppositeDirection ? move : -move;
                    break;
                case syPopupSlideStyleShrinkInOut1:
                case syPopupSlideStyleShrinkInOut2:
                    _popupView.transform = _dismissOppositeDirection ?
                    CGAffineTransformMakeScale(0.95, 0.95) :
                    CGAffineTransformMakeScale(1.05, 1.05);
                    break;
                default: break;
            }
        } break;
        default: break;
    }
    return point;
}

#pragma mark - Destroy timer

- (void)destroyTimer {
    id value = objc_getAssociatedObject(self, syPopupControllerNSTimerKey);
    if (value) {
        [(NSTimer *)value invalidate];
        objc_setAssociatedObject(self, syPopupControllerNSTimerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - FrontWindow

- (UIWindow *)frontWindow {
    NSEnumerator *enumerator = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in enumerator) {
        BOOL windowOnMainScreen = (window.screen == [UIScreen mainScreen]);
        BOOL windowIsVisible = !window.isHidden && window.alpha > 0;
        BOOL windowIsAlert   =  !(window.windowLevel == UIWindowLevelAlert);
        if (windowOnMainScreen && windowIsVisible && window.isKeyWindow && windowIsAlert) {
            return window;
        }
    }
    UIWindow *applicationWindow = [[UIApplication sharedApplication].delegate window];
    if (!applicationWindow) NSLog(@"** syPopupController ** Window is nil!");
    return applicationWindow;
}


#pragma mark - Notifications

- (void)bindNotificationEvent {
    [self unbindNotificationEvent];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willChangeStatusBarOrientation)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)unbindNotificationEvent {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationWillChangeStatusBarOrientationNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationDidChangeStatusBarOrientationNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

#pragma mark - Observing

- (void)keyboardWillChangeFrame:(NSNotification*)notification {
    
    _allowPan = NO; // The pan gesture will be invalid when the keyboard appears.
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [_maskView convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = CGRectGetHeight(_maskView.bounds) - CGRectGetMinY(keyboardRect);
    
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = curve << 16;
    
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        if (keyboardHeight > 0) {
            
            CGFloat offsetSpacing = self.offsetSpacingOfKeyboard, changeHeight = 0;
            
            switch (_layoutType) {
                case syPopupLayoutTypeTop:
                    break;
                case syPopupLayoutTypeBottom:
                    changeHeight = keyboardHeight + offsetSpacing;
                    break;
                default:
                   // changeHeight = (keyboardHeight / 2) +.
                    changeHeight = offsetSpacing;

                    break;
            }
            if (!CGPointEqualToPoint(CGPointZero, _markerCenter)) {
                _popupView.center = CGPointMake(_markerCenter.x, _markerCenter.y - changeHeight);
            } else {
                _popupView.center = CGPointMake(_popupView.center.x, _popupView.center.y - changeHeight);
            }
            
        } else {
            if (self.isPresenting) {
                _popupView.center = [self finishedCenter];
            }
        }
    } completion:^(BOOL finished) {
        _markerCenter = [self finishedCenter];
    }];
}

- (void)willChangeStatusBarOrientation {
    _maskView.frame = _superview.bounds;
    _popupView.center = [self finishedCenter];
    [self dismiss];
}

- (void)didChangeStatusBarOrientation {
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) { // must manually fix orientation prior to iOS 8
        CGFloat angle;
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationPortraitUpsideDown:
                angle = M_PI;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            default: // as UIInterfaceOrientationPortrait
                angle = 0.0;
                break;
        }
        _popupView.transform = CGAffineTransformMakeRotation(angle);
    }
    _maskView.frame = _superview.bounds;
    _visualEffectView.frame = _maskView.bounds;
//    _popupView.frame = _superview.bounds;
    _popupView.center = [self finishedCenter];
//    _contentView.center = [self finishedCenter];
    
    
//    DLog(@"_maskView %@  _popupView %@ ",NSStringFromCGRect(_maskView.frame),NSStringFromCGRect(_popupView.frame));
}

#pragma mark - Gesture Recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if (touch.view == _contentView || touch.view == _popupView) {
        [self.contentView endEditing:YES];
        [self.popupView endEditing:YES];
    }
    
    if ([touch.view isDescendantOfView:_popupView]){
        return NO;
    }
    
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)g {
    [self.contentView endEditing:YES];
    [self.popupView endEditing:YES];
    if (_dismissOnMaskTouched) {
        if (!_dropAngle) {
            id object = objc_getAssociatedObject(self, @selector(setSlideStyle:));
            _slideStyle = [object integerValue];
            id obj = objc_getAssociatedObject(self, @selector(setDismissOppositeDirection:));
            _dismissOppositeDirection = [obj boolValue];
        }
        if (nil != self.maskTouched) {
            self.maskTouched(self);
        } else {
            [self dismiss];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (!_allowPan || !_isPresenting || _dropAngle) {
        return;
    }
    CGPoint translation = [g translationInView:_maskView];
    switch (g.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_layoutType) {
                case syPopupLayoutTypeCenter: {
                    
                    BOOL isTransformationVertical = NO;
                    switch (_slideStyle) {
                        case syPopupSlideStyleFromLeft:
                        case syPopupSlideStyleFromRight: break;
                        default:
                            isTransformationVertical = YES;
                            break;
                    }
                    
                    NSInteger factor = 4; // set screen ratio `_maskView.bounds.size.height / factor`
                    CGFloat changeValue;
                    if (isTransformationVertical) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                        changeValue = g.view.center.y / (_maskView.bounds.size.height / factor);
                    } else {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                        changeValue = g.view.center.x / (_maskView.bounds.size.width / factor);
                    }
                    CGFloat alpha = factor / 2 - fabs(changeValue - factor / 2);
                    [UIView animateWithDuration:0.15 animations:^{
                        _maskView.alpha = alpha;
                    } completion:NULL];
                    
                } break;
                case syPopupLayoutTypeBottom: {
                    if (g.view.frame.origin.y + translation.y > _maskView.bounds.size.height - g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case syPopupLayoutTypeTop: {
                    if (g.view.frame.origin.y + g.view.frame.size.height + translation.y  < g.view.bounds.size.height) {
                        g.view.center = CGPointMake(g.view.center.x, g.view.center.y + translation.y);
                    }
                } break;
                case syPopupLayoutTypeLeft: {
                    if (g.view.frame.origin.x + g.view.frame.size.width + translation.x < g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                case syPopupLayoutTypeRight: {
                    if (g.view.frame.origin.x + translation.x > _maskView.bounds.size.width - g.view.bounds.size.width) {
                        g.view.center = CGPointMake(g.view.center.x + translation.x, g.view.center.y);
                    }
                } break;
                default: break;
            }
            [g setTranslation:CGPointZero inView:_maskView];
        } break;
        case UIGestureRecognizerStateEnded: {
            
            BOOL isWillDismiss = YES, isStyleCentered = NO;
            switch (_layoutType) {
                case syPopupLayoutTypeCenter: {
                    isStyleCentered = YES;
                    if (g.view.center.y != _maskView.center.y) {
                        if (g.view.center.y > _maskView.bounds.size.height * 0.25 &&
                            g.view.center.y < _maskView.bounds.size.height * 0.75) {
                            isWillDismiss = NO;
                        }
                    } else {
                        if (g.view.center.x > _maskView.bounds.size.width * 0.25 &&
                            g.view.center.x < _maskView.bounds.size.width * 0.75) {
                            isWillDismiss = NO;
                        }
                    }
                } break;
                case syPopupLayoutTypeBottom:
                    isWillDismiss = g.view.frame.origin.y > _maskView.bounds.size.height - g.view.frame.size.height * 0.75;
                    break;
                case syPopupLayoutTypeTop:
                    isWillDismiss = g.view.frame.origin.y + g.view.frame.size.height < g.view.frame.size.height * 0.75;
                    break;
                case syPopupLayoutTypeLeft:
                    isWillDismiss = g.view.frame.origin.x + g.view.frame.size.width < g.view.frame.size.width * 0.75;
                    break;
                case syPopupLayoutTypeRight:
                    isWillDismiss = g.view.frame.origin.x > _maskView.bounds.size.width - g.view.frame.size.width * 0.75;
                    break;
                default: break;
            }
            if (isWillDismiss) {
                if (isStyleCentered) {
                    switch (_slideStyle) {
                        case syPopupSlideStyleShrinkInOut1:
                        case syPopupSlideStyleShrinkInOut2:
                        case syPopupSlideStyleFade: {
                            if (g.view.center.y < _maskView.bounds.size.height * 0.25) {
                                _slideStyle = syPopupSlideStyleFromTop;
                            } else {
                                if (g.view.center.y > _maskView.bounds.size.height * 0.75) {
                                    _slideStyle = syPopupSlideStyleFromBottom;
                                }
                            }
                            _dismissOppositeDirection = NO;
                        } break;
                        case syPopupSlideStyleFromTop:
                            _dismissOppositeDirection = !(g.view.center.y < _maskView.bounds.size.height * 0.25);
                            break;
                        case syPopupSlideStyleFromBottom:
                            _dismissOppositeDirection = g.view.center.y < _maskView.bounds.size.height * 0.25;
                            break;
                        case syPopupSlideStyleFromLeft:
                            _dismissOppositeDirection = !(g.view.center.x < _maskView.bounds.size.width * 0.25);
                            break;
                        case syPopupSlideStyleFromRight:
                            _dismissOppositeDirection = g.view.center.x < _maskView.bounds.size.width * 0.25;
                            break;
                        default: break;
                    }
                }
                
                [self dismissWithDuration:0.25f springAnimated:NO];
                
            } else {
                // restore view location.
                id object = objc_getAssociatedObject(self, syPopupControllerParametersKey);
                NSNumber *flagNumber = [object valueForKey:@"zh_springAnimated"];
                BOOL flag = NO;
                if (nil != flagNumber) {
                    flag = flagNumber.boolValue;
                }
                NSTimeInterval duration = 0.25;
                NSNumber* durationNumber = [object valueForKey:@"zh_duration"];
                if (nil != durationNumber) {
                    duration = durationNumber.doubleValue;
                }
                if (flag) {
                    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.6f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        g.view.center = [self finishedCenter];
                    } completion:NULL];
                } else {
                    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        g.view.center = [self finishedCenter];
                    } completion:NULL];
                }
            }
            
        } break;
        case UIGestureRecognizerStateCancelled:
            break;
        default: break;
    }
}

- (void)dealloc {
    [self unbindNotificationEvent];
    [self removeSubviews];
}

@end

@implementation UIViewController (syPopupController)

- (SYPopupController *)zh_popupController {
    id popupController = objc_getAssociatedObject(self, _cmd);
    if (nil == popupController) {
        popupController = [[SYPopupController alloc] init];
        self.zh_popupController = popupController;
    }
    return popupController;
}

- (void)setZh_popupController:(SYPopupController *)zh_popupController {
    objc_setAssociatedObject(self, @selector(zh_popupController), zh_popupController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

