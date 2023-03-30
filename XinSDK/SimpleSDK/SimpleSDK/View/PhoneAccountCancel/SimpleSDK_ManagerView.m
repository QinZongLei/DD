//
//  SimpleSDK_ManagerView.m
//  SimpleSDK
//
//  Created by Mac on 2022/6/30.
//

#import "SimpleSDK_ManagerView.h"


@interface SimpleSDK_ManagerView()

@property (nonatomic, strong) UIButton *btn_back;

@property (nonatomic, strong) UIImageView *forget_Img;
@property (nonatomic, strong) UILabel *forget_Lb;
@property (nonatomic, strong) UIImageView *cancel_accountImg;
@property (nonatomic, strong) UILabel *cancel_accountLb;
@property (nonatomic, strong) UIImageView *cancel_phoneImg;
@property (nonatomic, strong) UILabel *cancel_phoneLb;
@property (nonatomic, strong) UIButton *btn_forget;
@property (nonatomic, strong) UIButton *btn_account;
@property (nonatomic, strong) UIButton *btn_phone;

@end

@implementation SimpleSDK_ManagerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self  func_addNotification];
        [self func_setFastRegisteredView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setFastRegisteredView{
 
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width -kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.forget_Img = [[UIImageView alloc] init];
        self.forget_Img.frame = CGRectMake(kWidth(70), self.lb_title.bottom + kWidth(55), kWidth(25), kWidth(25));
        self.forget_Img.image = kSetBundleImage(inputPwdIcon);
        self.forget_Img;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.forget_Lb = [[UILabel alloc] init];
        self.forget_Lb.frame = CGRectMake(self.forget_Img.right + kWidth(10), self.forget_Img.top, kWidth(85), kWidth(25));
        self.forget_Lb.text = @"忘记密码";
        self.forget_Lb.font = [UIFont systemFontOfSize:kWidth(16)];
        self.forget_Lb.textColor = color_lbTfLeftTextHex;
        self.forget_Lb;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.btn_forget = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_forget.frame = CGRectMake(self.iv_viewBg.width - kWidth(130), self.forget_Img.top - kWidth(5), kWidth(70), kWidth(35));
        [self.btn_forget setBackgroundImage:kSetBundleImage(qinwangBtn) forState:UIControlStateNormal];
        [self.btn_forget addTarget:self action:@selector(func_forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_forget;
    })];
    
    
    
    [self.iv_viewBg addSubview:({
        self.cancel_accountImg = [[UIImageView alloc] init];
        self.cancel_accountImg.frame = CGRectMake(self.forget_Img.left, self.forget_Img.bottom + kWidth(30), self.forget_Img.width, self.forget_Img.height);
        self.cancel_accountImg.image = kSetBundleImage(inputAccountIcon);
        self.cancel_accountImg;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.cancel_accountLb = [[UILabel alloc] init];
        self.cancel_accountLb.frame = CGRectMake(self.forget_Lb.left, self.cancel_accountImg.top, self.forget_Lb.width, self.forget_Lb.height);
        self.cancel_accountLb.text = @"账号注销";
        self.cancel_accountLb.textColor = self.forget_Lb.textColor;
        self.cancel_accountLb.font = self.forget_Lb.font;
        self.cancel_accountLb;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.btn_account = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_account.frame = CGRectMake(self.btn_forget.left, self.cancel_accountImg.top - kWidth(5), self.btn_forget.width, self.btn_forget.height);
        [self.btn_account setBackgroundImage:kSetBundleImage(qinwangBtn) forState:UIControlStateNormal];
        [self.btn_account addTarget:self action:@selector(func_accountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_account;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.cancel_phoneImg = [[UIImageView alloc] init];
        self.cancel_phoneImg.frame = CGRectMake(self.forget_Img.left, self.cancel_accountImg.bottom + kWidth(30), self.forget_Img.width, self.forget_Img.height);
        self.cancel_phoneImg.image = kSetBundleImage(inputPhoneIcon);
        self.cancel_phoneImg;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.cancel_phoneLb = [[UILabel alloc] init];
        self.cancel_phoneLb.frame = CGRectMake(self.forget_Lb.left, self.cancel_phoneImg.top, self.forget_Lb.width, self.forget_Lb.height);
        self.cancel_phoneLb.text = @"手机号注销";
        self.cancel_phoneLb.textColor = self.forget_Lb.textColor;
        self.cancel_phoneLb.font = self.forget_Lb.font;
        self.cancel_phoneLb;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.btn_phone = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_phone.frame = CGRectMake(self.btn_forget.left, self.cancel_phoneImg.top - kWidth(5), self.btn_forget.width, self.btn_forget.height);
        [self.btn_phone setBackgroundImage:kSetBundleImage(qinwangBtn) forState:UIControlStateNormal];
        [self.btn_phone addTarget:self action:@selector(func_phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_phone;
    })];
    
 
}


- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showAccountLoginView];
        [self removeFromSuperview];
    });
}

- (void)func_forgetBtnClick:(UIButton *)sender {
    
    //找客服
    NSString * urlStr = [[SimpleSDK_DataTools manager].customerInfo objectForKey:@"service_url"];
    if (!kStringIsNull(urlStr)) {
        [SimpleSDK_ViewManager func_showHelpView:urlStr];
    }
    

    
}

- (void)func_accountBtnClick:(UIButton *)sender {
    //账号注销
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showCancelAccountView];
        [self removeFromSuperview];
    });
}

- (void)func_phoneBtnClick:(UIButton *)sender {
    //手机号注销
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showCancelPhoneView];
        [self removeFromSuperview];
    });
    
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setFastRegisteredView];
}

@end
