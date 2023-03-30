//
//  SimpleSDK_FastRegisteredView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/16.
//

#import "SimpleSDK_FastRegisteredView.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_ApiManager.h"

@interface SimpleSDK_FastRegisteredView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_account;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_pwd;
@property (nonatomic, strong) UIButton *btn_pwdShowOrHidden;
@property (nonatomic, strong) UIButton *btn_agreement;
@property (nonatomic, strong) UIButton *btn_agreementTip;
@property (nonatomic, assign) BOOL  agreementState;
@property (nonatomic, assign) BOOL  agreementOpenState;
@property (nonatomic, strong) UIButton *btn_regsitered;

@end

@implementation SimpleSDK_FastRegisteredView

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
 
    self.bgImgVStr = fastRegBgImgV;
    self.agreementOpenState = [[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"user_agree"] integerValue] == 1 ? YES : NO;
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width -kWidth(40), kWidth(35), kWidth(30), kWidth(30));
       
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_account =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(35), kWidth(300), kWidth(35))];
        self.view_account.leftTitleLbStr = @"账 号:";
        self.view_account.iconPath = kSetBundleImage(inputAccountIcon);
        self.view_account.placeholderStr = @"请输入您需要注册的账号";
        self.view_account.tf_input.text = [SimpleSDK_Tools func_getRandomStrWithNum:6];
        
        self.view_account;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.view_pwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_account.bottom+kWidth(15), kWidth(300), kWidth(35))];
        self.view_pwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_pwd.leftTitleLbStr = @"密 码:";
        self.view_pwd.placeholderStr = @"请输入您要设置的密码";
        self.view_pwd.tf_input.text = [SimpleSDK_Tools func_getRandomStrWithNum:6];
        self.btn_pwdShowOrHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn_pwdShowOrHidden setBackgroundImage:kSetBundleImage(pwdShowImg) forState:UIControlStateNormal];
        [self.btn_pwdShowOrHidden setBackgroundImage:kSetBundleImage(pwdHiddenImg) forState:UIControlStateSelected];
        self.btn_pwdShowOrHidden.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        self.btn_pwdShowOrHidden.tag = 20211204;
        self.btn_pwdShowOrHidden.frame = CGRectMake(self.view_account.iv_viewBg.width-kWidth(35),0, kWidth(20), kWidth(20));
        self.btn_pwdShowOrHidden.centerY = self.view_pwd.iv_viewBg.centerY;
        [self.btn_pwdShowOrHidden addTarget:self action:@selector(func_showOrHiadPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        self.view_pwd.btn_right = self.btn_pwdShowOrHidden;
        
        self.view_pwd;
    })];
    
    if (self.agreementOpenState) {

    [self.iv_viewBg addSubview:({
        self.btn_agreement = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_agreement.frame = CGRectMake(self.view_pwd.left + kWidth(20), self.view_pwd.bottom+kWidth(15), kWidth(20), kWidth(20));
        self.btn_agreement.selected = YES;
        self.btn_agreement.tag = 20211202;
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
        self.btn_agreementTip.tag = 20211203;
        self.btn_agreementTip.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        self.btn_agreementTip.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.btn_agreementTip.frame = CGRectMake(self.btn_agreement.right, self.btn_agreement.top, kWidth(220), kWidth(20));
        [self.btn_agreementTip setAttributedTitle:btnTip forState:0];
        [self.btn_agreementTip addTarget:self action:@selector(func_showAgreementAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_agreementTip;
    })];
        
 }
    
    [self.iv_viewBg addSubview:({
        self.btn_regsitered = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (self.agreementOpenState) {
            
            self.btn_regsitered.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_agreement.bottom+kWidth(20), kWidth(180), kWidth(45));
            
        }else {
            
            self.btn_regsitered.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.view_pwd.bottom+kWidth(30), kWidth(180), kWidth(45));
        }
        

        self.btn_regsitered.tag = 20211205;
        [self.btn_regsitered setBackgroundImage:kSetBundleImage(quickRegisteredBtn) forState:UIControlStateNormal];
        self.btn_regsitered.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_regsitered addTarget:self action:@selector(func_registerAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_regsitered;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showLoginChoonseView];
        [self removeFromSuperview];
    });
}

- (void)func_chooseAgreementAction:(UIButton *)sender {
    //勾选
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

- (void)func_showOrHiadPwdAction:(UIButton *)sender {
    //显示隐藏密码
    [self endEditing:YES];
    sender.selected = !sender.selected;
    self.view_pwd.tf_input.secureTextEntry = sender.selected;
}

- (void)func_registerAction:(UIButton *)sender {
        //注册
        dispatch_async(dispatch_get_main_queue(), ^{
            [self func_registerValidation];
        });
}

-(void)func_registerValidation{
    
    if (self.agreementOpenState) {
        if (!self.agreementState) {
            [SimpleSDK_Toast showToast:@"注册前需同意用户及隐私协议哦！" location:@"center" showTime:2.5];
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
   
    [SimpleSDK_ApiManager func_accountRegistered:accountStr passwordStr:passwordStr FuncBlock:^(BOOL status) {
        if (status) {
            //注册成功直接关闭当前界面
            [self removeFromSuperview];
            //去截图
            [SimpleSDK_ViewManager func_showScreenshotsView];
        }
    }];
    
}


#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setFastRegisteredView];
}
@end
