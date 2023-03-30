//
//  SimpleSDK_LoginView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/17.
//

#import "SimpleSDK_LoginView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Network.h"
#import "SimpleSDK_MoreAccountView.h"

@interface SimpleSDK_LoginView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_account;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_pwd;
@property (nonatomic, strong) UIButton *btn_down;
@property (nonatomic, strong) UIButton *btn_pwdShowOrHidden;
@property (nonatomic, strong) UIButton *btn_agreement;
@property (nonatomic, strong) UIButton *btn_agreementTip;
@property (nonatomic, assign) BOOL  agreementState;
@property (nonatomic, assign) BOOL  agreementOpenState;
@property (nonatomic, strong) UIButton *btn_login;
@property (nonatomic, strong) UIButton *btn_accoutRegistered;
@property (nonatomic, strong) UILabel *lb_line;
@property (nonatomic, strong) UIButton *btn_findPwd;
@property (nonatomic, strong) UIButton *btn_customer;
@property (nonatomic, strong) SimpleSDK_MoreAccountView *moreAccountView;
@end

@implementation SimpleSDK_LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self func_setLoginView];
    }
    return self;
}


-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setLoginView{
    self.bgImgVStr= accountLoginBgImgV;
    
    self.agreementOpenState = [[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"user_agree"] integerValue] == 1 ? YES : NO;
    NSDictionary *userAccount = [[SimpleSDK_DataTools func_getAllAccount] lastObject];
    NSString *accountStr = @"";
    NSString *passwordStr = @"";
    if (kDictNotNull(userAccount)) {
        accountStr = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"account"]];
        passwordStr = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"password"]];
    }
    
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width -kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_account =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(30), kWidth(300), kWidth(40))];
        self.view_account.leftTitleLbStr = @"账 号:";
        if (!kStringIsNull(accountStr)) {
            self.view_account.tf_input.text = accountStr;
        }
        self.view_account.iconPath = kSetBundleImage(inputAccountIcon);
        self.view_account.placeholderStr = @"请输入您的账号";
        //添加下拉按钮
        self.btn_down = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn_down setBackgroundImage:kSetBundleImage(downDefaultImg) forState:UIControlStateNormal];
        [self.btn_down setBackgroundImage:kSetBundleImage(downOpenImg) forState:UIControlStateSelected];
        self.btn_down.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        self.btn_down.tag = 20211202;
        self.btn_down.frame = CGRectMake(self.view_account.iv_viewBg.width-kWidth(35),0, kWidth(25), kWidth(20));
        self.btn_down.centerY = self.view_account.iv_viewBg.centerY;
        [self.btn_down addTarget:self action:@selector(func_accountDwonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.view_account.btn_right = self.btn_down;
        self.view_account;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_pwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_account.bottom+kWidth(5), kWidth(300), kWidth(40))];
        self.view_pwd.leftTitleLbStr = @"密 码:";
        if (!kStringIsNull(passwordStr)) {
            self.view_pwd.tf_input.text = passwordStr;
        }
        self.view_pwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_pwd.placeholderStr = @"请输入您要设置的密码";
        self.view_pwd.tf_input.secureTextEntry = YES;
        //添加显示密码隐藏密码按钮
        self.btn_pwdShowOrHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn_pwdShowOrHidden setBackgroundImage:kSetBundleImage(pwdHiddenImg) forState:UIControlStateNormal];
        [self.btn_pwdShowOrHidden setBackgroundImage:kSetBundleImage(pwdShowImg) forState:UIControlStateSelected];
        
        self.btn_pwdShowOrHidden.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        self.btn_pwdShowOrHidden.tag = 20211203;
        self.btn_pwdShowOrHidden.frame = CGRectMake(self.view_account.iv_viewBg.width-kWidth(35),0, kWidth(25), kWidth(25));
        self.btn_pwdShowOrHidden.centerY = self.view_pwd.iv_viewBg.centerY;
        [self.btn_pwdShowOrHidden addTarget:self action:@selector(func_showOrHiadPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        self.view_pwd.btn_right = self.btn_pwdShowOrHidden;
        self.view_pwd;
    })];

   
    
    if (self.agreementOpenState) {
        [self.iv_viewBg addSubview:({
            self.btn_agreement = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_agreement.frame = CGRectMake(self.view_pwd.left + kWidth(20), self.view_pwd.bottom+kWidth(5), kWidth(20), kWidth(20));
            self.btn_agreement.selected = YES;
            self.btn_agreement.tag = 20211204;
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
            self.btn_agreementTip.tag = 20211205;
            self.btn_agreementTip.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
            self.btn_agreementTip.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.btn_agreementTip.frame = CGRectMake(self.btn_agreement.right, self.btn_agreement.top, kWidth(220), kWidth(20));
            [self.btn_agreementTip setAttributedTitle:btnTip forState:0];
            [self.btn_agreementTip addTarget:self action:@selector(func_showAgreementAction:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_agreementTip;
        })];
    }
    
   
    
    [self.iv_viewBg addSubview:({
        self.btn_login = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.agreementOpenState) {
            self.btn_login.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_agreement.bottom+kWidth(10), kWidth(180), kWidth(45));
        }else{
            self.btn_login.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.view_pwd.bottom+kWidth(20), kWidth(180), kWidth(45));
        }
        self.btn_login.tag = 20211206;
        [self.btn_login setBackgroundImage:kSetBundleImage(loginBtn) forState:UIControlStateNormal];
        self.btn_login.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_login addTarget:self action:@selector(func_loginAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_login;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_accoutRegistered = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_accoutRegistered.frame = CGRectMake(self.view_account.left + kWidth(25), self.btn_login.bottom+kWidth(10), kWidth(60), kWidth(20));
        self.btn_accoutRegistered.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        self.btn_accoutRegistered.tag = 20211207;
        [self.btn_accoutRegistered setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"账号注册" UnderLineColor:[UIColor ZNWinObj_colorWithHexString:@"#ffd800"]] forState: 0];
        [self.btn_accoutRegistered addTarget:self action:@selector(func_toAccountRegisteredAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_accoutRegistered;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_line = [[UILabel alloc] init];
        self.lb_line.backgroundColor  = color_agreement_tip;
        self.lb_line.frame = CGRectMake(self.btn_accoutRegistered.right+kWidth(5), self.btn_accoutRegistered.top+kWidth(5), kWidth(1), kWidth(10));
        self.lb_line;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_findPwd = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_findPwd.frame = CGRectMake(self.lb_line.right+kWidth(5), self.btn_accoutRegistered.top, self.btn_accoutRegistered.width+kWidth(8), self.btn_accoutRegistered.height);
        self.btn_findPwd.tag = 20211208;
        self.btn_findPwd.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        [self.btn_findPwd setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"账号注销" UnderLineColor:[UIColor ZNWinObj_colorWithHexString:@"#68d800"]] forState: 0];
//        [self.btn_findPwd setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btn_findPwd addTarget:self action:@selector(func_findPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_findPwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_customer = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_customer.frame = CGRectMake(self.btn_findPwd.right+kWidth(5), self.btn_accoutRegistered.top, kWidth(150), self.btn_accoutRegistered.height);
        self.btn_customer.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        [self.btn_customer setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"遇到问题？联系客服" UnderLineColor:[UIColor ZNWinObj_colorWithHexString:@"#ff6500"]] forState: 0];
        self.btn_customer.tag = 20211209;
        self.btn_customer.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.btn_customer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btn_customer addTarget:self action:@selector(func_findServiceAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_customer;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showLoginChoonseView];
    });
}


- (void)func_accountDwonAction:(UIButton *)sender {
    //账号下拉
    [self endEditing:YES];
    [self func_accountDownList:sender];
}

- (void)func_showOrHiadPwdAction:(UIButton *)sender {
    //密码显示隐藏
    [self endEditing:YES];
    self.view_pwd.tf_input.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}

- (void)func_loginAction:(UIButton *)sender {
    //登陆   调用接口
    [self func_loginValidation];
}

- (void)func_toAccountRegisteredAction:(UIButton *)sender {
    //账号注册
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showAccountRegisteredView];
        [self removeFromSuperview];
    });
}

- (void)func_findPwdAction:(UIButton *)sender {

    //账号管理
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showManagerView];
        [self removeFromSuperview];
    });
    
}


- (void)func_findServiceAction:(UIButton *)sender {
    //找客服
    NSString * urlStr = [[SimpleSDK_DataTools manager].customerInfo objectForKey:@"service_url"];
    if (!kStringIsNull(urlStr)) {
        [SimpleSDK_ViewManager func_showHelpView:urlStr];
    }
}

- (void)func_chooseAgreementAction:(UIButton *)sender {
    //单选框勾选
    [self endEditing:YES];
    sender.selected = !sender.selected;
    self.agreementState = sender.selected;
}

- (void)func_showAgreementAction:(UIButton *)sender {

        //弹出协议详细
    NSString * urlStr = [[SimpleSDK_DataTools manager].switchInfo objectForKey:@"privacy_agreement_url"];
        if (!kStringIsNull(urlStr)) {
            [SimpleSDK_ViewManager func_showHelpView:urlStr];
        }
    
}


-(void)func_accountDownList:(UIButton *)sender{
    NSArray *allAccount = [SimpleSDK_DataTools func_getAllAccount];
    if (allAccount.count == 0) {
        [SimpleSDK_Toast showToast:@"您暂无历史账号哦!" location:@"center" showTime:2.5f];
    } else{
        sender.selected = !sender.selected;
        if (sender.selected) {
            CGFloat height = 0;
            if (allAccount.count >= 3) {
                height = 3 * kWidth(38);
            } else {
                height = allAccount.count * kWidth(38);
            }
            //显示下拉列表
            self.moreAccountView = [[SimpleSDK_MoreAccountView alloc] initWithFrame: CGRectMake(self.view_account.left +kWidth(65), self.view_account.bottom, self.view_account.width - kWidth(65), height)];
            self.moreAccountView.layer.borderWidth = kWidth(1);
            self.moreAccountView.layer.borderColor = RGBHEX(0xBCBCBC).CGColor;
            self.moreAccountView.backgroundColor = RGBHEX(0xFFFFFF);
            __block typeof(self) weakSelf = self;
            self.moreAccountView.selectHandle = ^(NSDictionary * _Nonnull accountInfo) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *userName = [NSString stringWithFormat:@"%@",[accountInfo valueForKey:@"account"]];
                    NSString *password = [NSString stringWithFormat:@"%@",[accountInfo valueForKey:@"password"]];
                    weakSelf.view_account.tf_input.text = userName;
                    weakSelf.view_pwd.tf_input.text = password;
                    sender.selected = !sender.selected;
                });
            };
            
            self.moreAccountView.delHandle = ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat height = 0;
                    NSArray *allAccount = [SimpleSDK_DataTools func_getAllAccount];
                    if (allAccount.count >= 3) {
                        //大于三条。值现实三条的高度
                        height = 3 * kWidth(38);
                    } else if(allAccount.count >= 1){
                        //小于三条。根据条数显示
                        height = allAccount.count * kWidth(38);
                    }else{
                        //清零了
                         sender.selected = NO;
                         weakSelf.view_account.tf_input.text = @"";
                         weakSelf.view_pwd.tf_input.text = @"";
                         [weakSelf.moreAccountView removeFromSuperview];
                         weakSelf.moreAccountView = nil;
                    }
                    weakSelf.moreAccountView.frame = CGRectMake(weakSelf.view_account.left + kWidth(65), weakSelf.view_account.bottom, weakSelf.view_account.width - kWidth(65), height);
                    
                    NSDictionary *MObj_UserAccount = [allAccount lastObject];
                    
                    if (kDictNotNull(MObj_UserAccount)) {
                        
                        NSString *userName = [NSString stringWithFormat:@"%@",[MObj_UserAccount valueForKey:@"account"]];
                        NSString *password = [NSString stringWithFormat:@"%@",[MObj_UserAccount valueForKey:@"password"]];
                        weakSelf.view_account.tf_input.text = userName;
                        weakSelf.view_pwd.tf_input.text = password;
                    }
                    
                    
                    [weakSelf.moreAccountView setNeedsLayout];
                });
              
            };
            [self.iv_viewBg addSubview:self.moreAccountView];
        }else{
            //移除下拉列表
            [self.moreAccountView removeFromSuperview];
        }
    }
    
}

-(void)func_loginValidation{
    if (self.agreementOpenState) {
        if (!self.agreementState) {
            [SimpleSDK_Toast showToast:@"登录前需同意用户及隐私协议哦！" location:@"center" showTime:2.5];
            return;
        }
    }
    
    NSString *accountStr  =  [self.view_account.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr =  [self.view_pwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (accountStr.length <6 || passwordStr .length <6) {
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
    
    [SimpleSDK_ApiManager func_accountLogin:accountStr passwordStr:passwordStr FuncBlock:^(BOOL status){
        if (status) {
            //登陆成功直接关闭当前界面
            [self removeFromSuperview];
        }
    }];

}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setLoginView];
}

@end
