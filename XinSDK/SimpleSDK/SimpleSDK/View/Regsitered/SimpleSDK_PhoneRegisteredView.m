//
//  SimpleSDK_PhoneRegisteredView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/17.
//

#import "SimpleSDK_PhoneRegisteredView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Network.h"

@interface SimpleSDK_PhoneRegisteredView ()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_phone;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_code;
@property (nonatomic, strong) UIButton *btn_getCode;
@property (nonatomic, strong) UIButton *btn_agreement;
@property (nonatomic, strong) UIButton *btn_agreementTip;
@property (nonatomic, assign) BOOL  agreementState;
@property (nonatomic, assign) BOOL  agreementOpenState;
@property (nonatomic, strong) UIButton *btn_regsiteredOrLogin;

@end

@implementation SimpleSDK_PhoneRegisteredView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self func_setPhoneRegisteredView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


-(void)func_setPhoneRegisteredView{
    
    self.bgImgVStr = phoneLoginBgImgV;
    self.agreementOpenState = [[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"user_agree"] integerValue] == 1 ? YES : NO;
    
    NSUserDefaults *phonenum = [NSUserDefaults standardUserDefaults];
    NSString *phonestr = [phonenum objectForKey:@"phonenum"];
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.view_phone =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(35), kWidth(300), kWidth(35))];
        self.view_phone.leftTitleLbStr = @"手机号:";
        self.view_phone.iconPath = kSetBundleImage(inputPhoneIcon);
        if (!kStringIsNull(phonestr)) {
            self.view_phone.tf_input.text = phonestr;
        }
        self.view_phone.placeholderStr = @"请输入您的手机号";
        self.view_phone;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.view_code =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_phone.left, self.view_phone.bottom+kWidth(15), kWidth(215), kWidth(35))];
        self.view_code.leftTitleLbStr = @"验证码:";
        //添加获取验证码按钮
        self.view_code.iconPath = kSetBundleImage(InputPhoneCodeIcon);
        
        self.view_code.placeholderStr = @"请输入验证码";
       
        self.view_code;
    })];
    
    [self.iv_viewBg addSubview:({
    self.btn_getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btn_getCode setBackgroundImage:kSetBundleImage(getCodeBg) forState:0];

    [self.btn_getCode setTitleColor:color_getcode forState:0];
    self.btn_getCode.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
    self.btn_getCode.tag = 20211205;
    self.btn_getCode.frame = CGRectMake(self.view_code.right+kWidth(5),self.view_code.top, kWidth(80), self.view_code.height);
    
    [self.btn_getCode addTarget:self action:@selector(func_getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_getCode;
    
    })];
    
    if (self.agreementOpenState) {
        [self.iv_viewBg addSubview:({
            self.btn_agreement = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_agreement.frame = CGRectMake(self.view_code.left + kWidth(20), self.view_code.bottom+kWidth(15), kWidth(20), kWidth(20));
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
        self.btn_regsiteredOrLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.agreementOpenState) {
            self.btn_regsiteredOrLogin.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.btn_agreement.bottom+kWidth(20), kWidth(180), kWidth(45));
        }else{
            self.btn_regsiteredOrLogin.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.view_code.bottom+kWidth(25), kWidth(180), kWidth(45));
        }
       
        self.btn_regsiteredOrLogin.tag = 20211204;
        [self.btn_regsiteredOrLogin setBackgroundImage:kSetBundleImage(loginPhoneBtn) forState:UIControlStateNormal];
        self.btn_regsiteredOrLogin.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_regsiteredOrLogin addTarget:self action:@selector(func_registerAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_regsiteredOrLogin;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showLoginChoonseView];
     
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

- (void)func_getCodeAction:(UIButton *)sender {
    //获取验证码
    [self endEditing:YES];
    [self func_getPhonCode:sender];
}

- (void)func_registerAction:(UIButton *)sender {
        //注册
        dispatch_async(dispatch_get_main_queue(), ^{
            [self func_phoneLoginOrRegisteredValidation];
        });
}


-(void)func_getPhonCode:(UIButton *)sender{
    NSString *phoneStr = [self.view_phone.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![SimpleSDK_Tools func_isMobileNumber:phoneStr]) {
        [SimpleSDK_Toast  showToastCenter:@"请输入正确的手机号！" location:@"center" showTime:2.5];
        return;
    }
    sender.enabled = NO;

    [SimpleSDK_ApiManager func_getPhoneCode:phoneStr type:@"get_phone_login_code" FuncBlock:^(BOOL status) {
        sender.enabled = YES;
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __block NSInteger timeLine = 60;
                __block NSInteger timeOut = timeLine;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                //每秒执行一次
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
                dispatch_source_set_event_handler(_timer, ^{
                    //倒计时结束，关闭
                    if (timeOut <= 0) {
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.btn_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                            self.btn_getCode.userInteractionEnabled = YES;
                        });
                    } else {
                        int allTime = (int)timeLine + 1;
                        int seconds = timeOut % allTime;
                        NSString *timeStr = [NSString stringWithFormat:@"%0.2ds后重发", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.btn_getCode setTitle:[NSString stringWithFormat:@"%@",timeStr] forState:UIControlStateNormal];
                            self.btn_getCode.userInteractionEnabled = NO;
                        });
                        timeOut--;
                    }
                });
                dispatch_resume(_timer);
            });
        }
    }];
}

-(void)func_phoneLoginOrRegisteredValidation{
    if (self.agreementOpenState) {
        if (!self.agreementState) {
            [SimpleSDK_Toast showToast:@"登录前需同意用户及隐私协议哦！" location:@"center" showTime:2.5];
            return;
        }
    }
    
    NSString * phoneStr = [self.view_phone.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * codeStr = [self.view_code.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![SimpleSDK_Tools func_isMobileNumber:phoneStr]) {
        [SimpleSDK_Toast  showToastCenter:@"请输入正确的手机号！" location:@"center" showTime:2.5];
        return;
    }
    if (codeStr.length<4) {
        [SimpleSDK_Toast showToast:@"请输入正确的验证码" location:@"center" showTime:2.5f];
        return;
    }
    [SimpleSDK_ApiManager func_phoneloginOrRegistered:phoneStr codeStr:codeStr FuncBlock:^(BOOL status){
        if (status) {
            //登陆成功移除当前界面
            [self removeFromSuperview];

        }
    }];
}


#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setPhoneRegisteredView];
}

@end
