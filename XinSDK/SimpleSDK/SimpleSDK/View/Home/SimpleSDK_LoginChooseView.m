//
//  SimpleSDK_LoginChooseView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/16.
//

#import "SimpleSDK_LoginChooseView.h"
#import "SimpleSDK_ViewManager.h"

@interface SimpleSDK_LoginChooseView()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *iv_viewBg;
@property (nonatomic, strong) UIButton *btn_fastRegistered;
@property (nonatomic, strong) UIButton *btn_phoneLogin;
@property (nonatomic, strong) UIButton *btn_acountLogin;
@property (nonatomic, strong) UIView *YYJLObj_bgView;
@end

@implementation SimpleSDK_LoginChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self  func_setLoginChonseView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setLoginChonseView{
    
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.view;
    })];
    
    [self.view addSubview:({
        self.iv_viewBg = [[UIImageView alloc] init];
        self.iv_viewBg.userInteractionEnabled = YES;
        self.iv_viewBg.image = kSetBundleImage(dialogBg);
        self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(400), kWidth(250));
        self.iv_viewBg.center = self.view.center;
        self.iv_viewBg;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.btn_phoneLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_phoneLogin.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kWidth(15)];
        self.btn_phoneLogin.tag = 20211201;
        self.btn_phoneLogin.frame = CGRectMake((self.iv_viewBg.width - kWidth(60))/2, self.iv_viewBg.height/2- kWidth(35), kWidth(60), kWidth(60));
        self.btn_phoneLogin.titleEdgeInsets =  UIEdgeInsetsMake(kWidth(5), kWidth(-18), kWidth(-90), kWidth(-20));
        [self.btn_phoneLogin setTitle:@"手机登录" forState:0];
        [self.btn_phoneLogin setTitleColor:color_login_tip forState:UIControlStateNormal];
        [self.btn_phoneLogin setBackgroundImage:kSetBundleImage(phoneLoginBtn) forState:UIControlStateNormal];
        [self.btn_phoneLogin addTarget:self action:@selector(func_phoneLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_phoneLogin;
    })];
    
 
    [self.iv_viewBg addSubview:({
        self.btn_fastRegistered = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_fastRegistered.titleLabel.font = self.btn_phoneLogin.titleLabel.font;
        self.btn_fastRegistered.tag = 20211202;
        self.btn_fastRegistered.frame = CGRectMake(self.btn_phoneLogin.left-kWidth(100), self.btn_phoneLogin.top, kWidth(60), kWidth(60));
        self.btn_fastRegistered.titleEdgeInsets = self.btn_phoneLogin.titleEdgeInsets;

        [self.btn_fastRegistered setTitle:@"快速注册" forState:0];
        [self.btn_fastRegistered setTitleColor:color_login_tip forState:UIControlStateNormal];
        [self.btn_fastRegistered setBackgroundImage:kSetBundleImage(quickRegistered) forState:UIControlStateNormal];
        [self.btn_fastRegistered addTarget:self action:@selector(func_showFastViewAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_fastRegistered;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_acountLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_acountLogin.titleLabel.font = self.btn_phoneLogin.titleLabel.font;
        self.btn_acountLogin.tag = 20211203;
        self.btn_acountLogin.frame = CGRectMake(self.btn_phoneLogin.right+kWidth(40), self.btn_phoneLogin.top, kWidth(60), kWidth(60));
        self.btn_acountLogin.titleEdgeInsets =  self.btn_phoneLogin.titleEdgeInsets;
        [self.btn_acountLogin setTitle:@"账号登录" forState:UIControlStateNormal];
        [self.btn_acountLogin setTitleColor:color_login_tip forState:0];
        [self.btn_acountLogin setBackgroundImage:kSetBundleImage(accountLoginBtn) forState:UIControlStateNormal];
        [self.btn_acountLogin addTarget:self action:@selector(func_accountLoginViewAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_acountLogin;
    })];
}

- (void)func_phoneLoginAction:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        //跳转手机登陆
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showPhoneLoginOrRegisteredView];
       
    });
}

- (void)func_showFastViewAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //跳转手机登陆
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showFastRegisteredView];
       
    });
}

- (void)func_accountLoginViewAction:(UIButton *)sender {
        //跳转账号登陆
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [SimpleSDK_ViewManager func_showAccountLoginView];
        });
       
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setLoginChonseView];
}
@end
