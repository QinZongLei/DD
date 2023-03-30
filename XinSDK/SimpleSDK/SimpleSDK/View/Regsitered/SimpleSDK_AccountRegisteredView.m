//
//  SimpleSDK_AccountRegisteredView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_AccountRegisteredView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Network.h"

@interface SimpleSDK_AccountRegisteredView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_account;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_pwd;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_determinePwd;
@property (nonatomic, strong) UIButton *btn_agreement;
@property (nonatomic, strong) UIButton *btn_agreementTip;
@property (nonatomic, assign) BOOL  agreementState;
@property (nonatomic, assign) BOOL  agreementOpenState;
@property (nonatomic, strong) UIButton *btn_registered;
@property (nonatomic, strong) UIButton *btn_toPhoneRegistered;
@end

@implementation SimpleSDK_AccountRegisteredView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self func_setAccountRegisteredView];
    }
    return self;
}


-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setAccountRegisteredView{
    
//    self.bgImgVStr = fastRegBgImgV;
    self.agreementOpenState = [[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"user_agree"] integerValue] == 1 ? YES : NO;
    
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211205;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_account =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(15), kWidth(300), kWidth(35))];
        self.view_account.leftTitleLbStr = @"账 号:";
        self.view_account.iconPath = kSetBundleImage(inputAccountIcon);
        self.view_account.placeholderStr = @"请输入您需要注册的账号";
        self.view_account;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_pwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_account.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_pwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_pwd.placeholderStr = @"请输入您要设置的密码";
        self.view_pwd.leftTitleLbStr = @"密 码:";
//        self.view_pwd.tf_input.secureTextEntry = YES;
        self.view_pwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_determinePwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_pwd.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_determinePwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_determinePwd.leftTitleLbStr = @"密 码:";
        self.view_determinePwd.placeholderStr = @"请再次输入您的密码";
        self.view_determinePwd;
    })];
    
    if (self.agreementOpenState) {
        [self.iv_viewBg addSubview:({
            self.btn_agreement = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_agreement.frame = CGRectMake(self.view_pwd.left+kWidth(20), self.view_determinePwd.bottom+kWidth(10), kWidth(20), kWidth(20));
            self.btn_agreement.selected = YES;
            self.btn_agreement.tag = 20211201;
            self.btn_agreement.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.btn_agreement setBackgroundImage:kSetBundleImage(radioBtnCheckImg) forState:UIControlStateNormal];
            [self.btn_agreement setBackgroundImage:kSetBundleImage(radioBtnSelectedImg) forState:UIControlStateSelected];
            [self.btn_agreement addTarget:self action:@selector(func_chooseAgreementAction:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_agreement;
        })];
        //默认选中状态
        self.agreementState = YES;
        
        NSString *userTip = @"我已阅读并同意用户协议及隐私协议";
        NSRange userRange = [userTip rangeOfString:@"用户协议及隐私协议"];
        NSMutableAttributedString *btnTip = [[NSMutableAttributedString alloc] initWithString:userTip];
        [btnTip addAttribute:NSForegroundColorAttributeName value:color_agreement range:userRange];
        [btnTip addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:userRange];
        
        [self.iv_viewBg addSubview:({
            self.btn_agreementTip = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_agreementTip.titleLabel.textColor = color_agreement_tip;
            self.btn_agreementTip.tag = 20211202;
            self.btn_agreementTip.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
            self.btn_agreementTip.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.btn_agreementTip.frame = CGRectMake(self.btn_agreement.right, self.btn_agreement.top, kWidth(220), kWidth(20));
            [self.btn_agreementTip setAttributedTitle:btnTip forState:0];
            [self.btn_agreementTip addTarget:self action:@selector(func_showAgreementAction:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_agreementTip;
        })];
    }
    
    
    [self.iv_viewBg addSubview:({
        self.btn_toPhoneRegistered = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.agreementOpenState) {
            self.btn_toPhoneRegistered.frame = CGRectMake(self.btn_agreementTip.right+kWidth(5), self.btn_agreement.top, kWidth(60), kWidth(20));
        }else{
            self.btn_toPhoneRegistered.frame = CGRectMake(self.view_determinePwd.left+kWidth(5), self.view_determinePwd.bottom+kWidth(10), kWidth(60), kWidth(20));
        }
        self.btn_toPhoneRegistered.tag = 20211203;
        self.btn_toPhoneRegistered.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        [self.btn_toPhoneRegistered setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"手机登录" UnderLineColor:color_findPwd] forState: 0];
        [self.btn_toPhoneRegistered addTarget:self action:@selector(func_toPhoneRegisteredAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_toPhoneRegistered;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_registered = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.agreementOpenState) {
            self.btn_registered.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_agreement.bottom+kWidth(10), kWidth(180), kWidth(45));
        }else{
            self.btn_registered.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_toPhoneRegistered.bottom+kWidth(15), kWidth(180), kWidth(45));
        }
        self.btn_registered.tag = 20211204;
        [self.btn_registered setBackgroundImage:kSetBundleImage(quickRegisteredBtn) forState:UIControlStateNormal];
        self.btn_registered.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_registered addTarget:self action:@selector(func_registerAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_registered;
    })];
    
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showAccountLoginView];
        [self removeFromSuperview];
    });
}

- (void)func_chooseAgreementAction:(UIButton *)sender {
    //单选框勾选
     [self endEditing:YES];
     sender.selected = !sender.selected;
     self.agreementState = sender.selected;
}

- (void)func_showAgreementAction:(UIButton *)sender {
    //弹出协议
    NSString * urlStr = [[SimpleSDK_DataTools manager].switchInfo objectForKey:@"privacy_agreement_url"];
    if (!kStringIsNull(urlStr)) {
        [SimpleSDK_ViewManager func_showHelpView:urlStr];
    }
}

- (void)func_toPhoneRegisteredAction:(UIButton *)sender {
    //去手机注册界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showPhoneLoginOrRegisteredView];
        [self removeFromSuperview];
    });
}

- (void)func_registerAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //注册
        [self func_accountRegisteredValidation];
    });
}





-(void)func_accountRegisteredValidation{
    if (self.agreementOpenState) {
        if (!self.agreementState) {
            [SimpleSDK_Toast showToast:@"注册前需同意用户及隐私协议哦！" location:@"center" showTime:2.5];
            return;
        }
    }
    
    NSString *accountStr  =  [self.view_account.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr =  [self.view_pwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *determinePwdStr =  [self.view_determinePwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (accountStr.length <6 || passwordStr .length <6 || determinePwdStr.length <6) {
        [SimpleSDK_Toast showToast:@"账号密码长度不能低于六位数！" location:@"center" showTime:2.5];
        return;
    }
    
    NSString * pwdErrorStr =[SimpleSDK_Tools func_validationInputText:passwordStr];
    if (pwdErrorStr != nil) {
        [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"密码",pwdErrorStr] location:@"center" showTime:2.5f];
        return;
    }
    NSString * accoutErrorStr =[SimpleSDK_Tools func_validationInputText:accountStr];
    if (accoutErrorStr != nil) {
        [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"账号",accoutErrorStr] location:@"center" showTime:2.5f];
        return;
    }
    
    NSString *determinPwdError = [SimpleSDK_Tools func_validationInputText:determinePwdStr];
    if (determinPwdError != nil) {
        [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"密码",determinPwdError] location:@"center" showTime:2.5f];
        return;
    }
    
    if (![passwordStr isEqualToString:determinePwdStr]) {
        [SimpleSDK_Toast showToast:@"两次输入的密码不一致哦" location:@"center" showTime:2.5f];
        return;
    }
    [SimpleSDK_ApiManager func_accountRegistered:accountStr passwordStr:passwordStr FuncBlock:^(BOOL status) {
        if (status) {
            [self removeFromSuperview];
            //去截图
            [SimpleSDK_ViewManager func_showScreenshotsView];
        }
    }];
    
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setAccountRegisteredView];
}

@end
