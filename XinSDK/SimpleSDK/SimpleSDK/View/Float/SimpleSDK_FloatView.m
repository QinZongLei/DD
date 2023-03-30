//
//  SimpleSDK_FloatView.m
//  SimpleSDK
//
//  Created by admin on 2021/12/21.
//

#import "SimpleSDK_FloatView.h"
#import "SimpleSDK_DataTools.h"
#define kIconWidth kWidth(35)
#define kIconHeight kWidth(35)
#define kDuration 0.3
#define kHidenFloatView @"HIDENFLOATVIEW"

@interface SimpleSDK_FloatView()
@property (nonatomic, strong) UIImageView *iv_flaot;
@end


@implementation SimpleSDK_FloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self func_setFloatView];
        
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func_tapAction:)];
        [self addGestureRecognizer:tapAction];
        
        UIPanGestureRecognizer *panAction = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(func_panAction:)];
        [self addGestureRecognizer:panAction];
        
        [self performSelector:@selector(func_hiddenFloatViewWithFrame:) withObject:kHidenFloatView afterDelay:3.0];
    }
    return self;
}

-(void)func_setFloatView{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    [self addSubview:({
        self.iv_flaot = [[UIImageView alloc] init];
        self.iv_flaot.frame = CGRectMake(kWidth(5), kWidth(5), kWidth(60), kWidth(60));
        self.iv_flaot;
    })];
    //根据实名。绑定手机。我的消息列表，公众号是否查看
    NSString * idCard = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"idCard"];
    NSString * mobile = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"mobile"];
    
    NSString * oneClickStr = @"oneClick";
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString *newsAccountID = [NSString stringWithFormat:@"%@%@",oneClickStr,accountStr];
    NSUserDefaults *wayforloginAccount = [NSUserDefaults standardUserDefaults];
    NSString *openStateAccount = [wayforloginAccount objectForKey:newsAccountID];
    
    
    NSString *codeNameStr = [[SimpleSDK_DataTools manager].publicCodeInfo objectForKey:@"wx_public_name"];
    NSString *newsCodeID = [NSString stringWithFormat:@"%@%@",codeNameStr,accountStr];
    NSUserDefaults *wayforloginCode = [NSUserDefaults standardUserDefaults];
    NSString *openStateCode = [wayforloginCode objectForKey:newsCodeID];
    

    //没有认证。 没有绑定手机。  有消息没读。显示红点
    if ((kStringIsNull(idCard) || kStringIsNull(mobile))&& ([SimpleSDK_DataTools func_isMsgRed]||![@"openAccountMenu" isEqualToString:openStateAccount]||![@"openPublicCode" isEqualToString:openStateCode])) {
        self.iv_flaot.image = kSetBundleImage(floatRedImg);
    }else{
        
        if ([SimpleSDK_DataTools func_isMsgRed]||![@"openPublicCode" isEqualToString:openStateCode]) {
            self.iv_flaot.image = kSetBundleImage(floatRedImg);
        } else{
       
            self.iv_flaot.image = kSetBundleImage(floatImg);
        }
        
        
    }
}


- (void)func_tapAction:(UITapGestureRecognizer *)sender {
    if (self.alpha != 1) {
        [self func_cancelHiddenFloatView];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            CGPoint YYJLObj_NewCenter = self.center;
            YYJLObj_NewCenter.x = YYJLObj_NewCenter.x == kWidth(15) ? kIconWidth : SCREENWIDTH - kIconWidth;
            self.center = CGPointMake(YYJLObj_NewCenter.x, YYJLObj_NewCenter.y);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(func_hiddenFloatViewWithFrame:) withObject:kHidenFloatView afterDelay:3.0];
        });
    } else {
//        self.hidden = YES;
        //点击跳转用户中心界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showUserCenterView];
            [self removeFromSuperview];
        });
    }
}



- (void)func_panAction:(UIPanGestureRecognizer *)sender {
    CGPoint panPoint = [sender locationInView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.15f animations:^{
        self.center = CGPointMake(panPoint.x, panPoint.y);
        
    }];
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
        [self func_cancelHiddenFloatView];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self func_changBoundsabovePanPoint:panPoint];
        [self performSelector:@selector(func_hiddenFloatViewWithFrame:) withObject:kHidenFloatView afterDelay:3.0];
    }
}


- (void)func_changBoundsabovePanPoint:(CGPoint)panPoint{
    if(panPoint.x <= SCREENWIDTH / 2) {
        if (panPoint.x < kIconWidth && panPoint.y > SCREENHEIGHT - kIconHeight) {
            [UIView animateWithDuration:kDuration animations:^{
                self.center = CGPointMake(kIconWidth, SCREENHEIGHT - kIconHeight);
            }];
        } else {
            CGFloat pointy = panPoint.y < kIconHeight ? kIconHeight : (panPoint.y >= SCREENHEIGHT - kIconHeight ? SCREENHEIGHT - kIconHeight : panPoint.y);
            [UIView animateWithDuration:kDuration animations:^{
                self.center = CGPointMake(kIconWidth, pointy);
            }];
        }
    } else if(panPoint.x > SCREENWIDTH / 2) {
        if (panPoint.x > SCREENWIDTH - kIconWidth && panPoint.y < kIconHeight) {
            [UIView animateWithDuration:kDuration animations:^{
                self.center = CGPointMake(SCREENWIDTH - kIconWidth, kIconHeight);
            }];
        } else {
            CGFloat pointy = panPoint.y > SCREENHEIGHT - kIconHeight ? SCREENHEIGHT - kIconHeight : (panPoint.y <= kIconHeight ? kIconHeight : panPoint.y);
            [UIView animateWithDuration:kDuration animations:^{
                self.center = CGPointMake(SCREENWIDTH - kIconWidth, pointy);
            }];
        }
    }
    NSUserDefaults *FLObj_iconPosition = [NSUserDefaults standardUserDefaults];
    [FLObj_iconPosition setObject:[NSString stringWithFormat:@"%lf",self.frame.origin.x] forKey:@"FLObj_iocnX"];
    [FLObj_iconPosition setObject:[NSString stringWithFormat:@"%lf",self.frame.origin.y] forKey:@"FLObj_iocnY"];
}

// 增加延迟方法
- (void)func_hiddenFloatViewWithFrame:(CGRect *)frame {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.3;
        CGPoint YYJLObj_NewCenter = self.center;
        YYJLObj_NewCenter.x = YYJLObj_NewCenter.x <= 100.00 ? kWidth(15) : SCREENWIDTH;
        self.center = CGPointMake(YYJLObj_NewCenter.x, YYJLObj_NewCenter.y);
    }];
    
}

// 取消延迟
- (void)func_cancelHiddenFloatView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenFloatViewWithFrame:) object:kHidenFloatView];
}

@end
