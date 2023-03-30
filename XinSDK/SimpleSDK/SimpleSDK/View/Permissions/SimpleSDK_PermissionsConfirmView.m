//
//  SimpleSDK_PermissionsConfirmView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import "SimpleSDK_PermissionsConfirmView.h"

@interface SimpleSDK_PermissionsConfirmView ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *iv_viewBg;
@property (nonatomic, strong) UILabel * lb_title;
@property (nonatomic, strong) UILabel *lb_agree;
@property (nonatomic, strong) UIButton *btn_agree;
@property (nonatomic, strong) UIButton *btn_agreeNot;

@end

@implementation SimpleSDK_PermissionsConfirmView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setPermissionsConfirmView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setPermissionsConfirmView{
    
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
        self.view.frame =  self.bounds;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.view.alpha = 0.9;
        self.view;
    })];
    
    [self.view addSubview:({
        self.iv_viewBg = [[UIImageView alloc] init];
        self.iv_viewBg.userInteractionEnabled = YES;
        self.iv_viewBg.layer.cornerRadius = kWidth(5);
        self.iv_viewBg.clipsToBounds =YES;
        self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(320), kWidth(250));
        self.iv_viewBg.center = self.view.center;
        self.iv_viewBg.backgroundColor = [UIColor whiteColor];
        self.iv_viewBg;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_title = [[UILabel alloc] init];
        self.lb_title .text = @"温馨提示";
        self.lb_title.frame = CGRectMake((self.iv_viewBg.width-kWidth(200))/2, kWidth(20), kWidth(200), kWidth(20));
        self.lb_title.textColor = RGBHEX(0x000000);
        self.lb_title.textAlignment =NSTextAlignmentCenter;
        self.lb_title.font = [UIFont boldSystemFontOfSize:kWidth(18)];
        self.lb_title;
    })];
    
    NSString *userTip = @"若您选择不同意协议，我们将无法为您提供游戏服务";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为15
    [paragraphStyle setLineSpacing:7];
    
    NSMutableAttributedString *linkStr = [[NSMutableAttributedString alloc] initWithString:userTip];
    [linkStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, linkStr.length)];
    
    [self.iv_viewBg addSubview:({
        self.lb_agree = [[UILabel alloc ] init];
        self.lb_agree.attributedText = linkStr;
        self.lb_agree.numberOfLines = 0;
        self.lb_agree.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_agree.frame = CGRectMake(kWidth(15), self.lb_title.bottom+kWidth(10), self.iv_viewBg.width-kWidth(20), kWidth(50));
        self.lb_agree;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_agree = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_agree.titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        self.btn_agree.layer.cornerRadius = kWidth(20);
        self.btn_agree.frame = CGRectMake(self.lb_agree.left, self.lb_agree.bottom+kWidth(10), self.iv_viewBg.width-kWidth(30), kWidth(40));
        self.btn_agree.clipsToBounds = YES;
        self.btn_agree.tag = 202111;
        [self.btn_agree setTitle:@"同意" forState:UIControlStateNormal];
        [self.btn_agree setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:64.0/255.0 alpha:1.0f]];
        [self.btn_agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_agree addTarget:self action:@selector(func_agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_agree;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_agreeNot = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_agreeNot.titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        self.btn_agreeNot.layer.cornerRadius = kWidth(20);
        self.btn_agreeNot.clipsToBounds = YES;
        self.btn_agreeNot.frame = CGRectMake((self.iv_viewBg.width-kWidth(80))/2, self.btn_agree.bottom+kWidth(10), kWidth(80), kWidth(30));
        self.btn_agreeNot.tag = 202112;
        [self.btn_agreeNot setBackgroundColor:[UIColor clearColor]];
        [self.btn_agreeNot setTitle:@"不同意" forState:UIControlStateNormal];
        [self.btn_agreeNot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btn_agreeNot addTarget:self action:@selector(func_exitAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_agreeNot;
    })];
    
}


- (void)func_agreeAction:(UIButton *)sender {
    //同意
    NSUserDefaults *wayforFirstLogin = [NSUserDefaults standardUserDefaults];
    [wayforFirstLogin setValue:@"firstLogin" forKey:@"firstLaunch"];
    [self removeFromSuperview];
}

- (void)func_exitAction:(UIButton *)sender {
  
        //不同意   直接退出游戏
        [UIView beginAnimations:@"exitApplication" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
           self.view.window.bounds = CGRectMake(0, 0, 0, 0);
           [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
     if ([animationID compare:@"exitApplication"] == 0) {
        //退出代码
        exit(0);
    }
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setPermissionsConfirmView];
}
@end
