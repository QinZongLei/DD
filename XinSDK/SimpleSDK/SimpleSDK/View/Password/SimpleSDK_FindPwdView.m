//
//  SimpleSDK_FindPwdView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_FindPwdView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_NetWork.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_FindPwdView ()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_account;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_phone;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_code;
@property (nonatomic, strong) UIButton *btn_getCode;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_pwd;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_determinePwd;
@property (nonatomic, strong) UIButton *btn_determine;

@end

@implementation SimpleSDK_FindPwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setFindPwdView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setFindPwdView{
    self.titleStr = @"找回密码";

    self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(360), kWidth(300));
    self.iv_viewBg.center = self.view.center;
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.lb_title.right+kWidth(50), self.lb_title.top, kWidth(25), kWidth(25));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_account =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(240))/2, self.iv_line.bottom+kWidth(5), kWidth(240), kWidth(30))];
        self.view_account.iconPath = kSetBundleImage(inputAccountIcon);
        self.view_account.placeholderStr = @"请输入您需要找回的账号";
        self.view_account;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_phone =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_account.bottom+kWidth(10), kWidth(240), kWidth(30))];
        self.view_phone.iconPath = kSetBundleImage(inputPhoneIcon);
        self.view_phone.placeholderStr = @"请输入您的手机号";
        
        self.view_phone;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_code =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_phone.bottom+kWidth(10), kWidth(240), kWidth(30))];
        //添加获取验证码按钮
        self.view_code.iconPath = kSetBundleImage(inputPwdIcon);
        self.btn_getCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btn_getCode setTitleColor:color_getcode forState:0];
        self.btn_getCode.titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        self.btn_getCode.tag = 20211202;
        self.btn_getCode.frame = CGRectMake(self.view_code.iv_viewBg.width-kWidth(85),0, kWidth(75), kWidth(25));
        self.btn_getCode.centerY = self.view_code.iv_viewBg.centerY;
        [self.btn_getCode addTarget:self action:@selector(func_getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.view_code.btn_right = self.btn_getCode;
        self.view_code.placeholderStr = @"请输入验证码";
        self.view_code;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_pwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_code.bottom+kWidth(10), kWidth(240), kWidth(30))];
        self.view_pwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_pwd.placeholderStr = @"请输入您要设置的密码";
//        self.view_pwd.tf_input.secureTextEntry = YES;
       
        self.view_pwd;
    })];
    
    
//    [self.iv_viewBg addSubview:({
//        self.view_determinePwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_pwd.bottom+kWidth(5), kWidth(270), kWidth(35))];
//        self.view_determinePwd.iconPath = kSetBundleImage(inputPwdIcon);
//        self.view_determinePwd.placeholderStr = @"请再次输入您的密码";
////        self.view_determinePwd.tf_input.secureTextEntry = YES;
//
//        self.view_determinePwd;
//    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_determine = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_determine = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_determine.frame = CGRectMake((self.iv_viewBg.width-kWidth(120))/2, self.view_pwd.bottom+kWidth(15), kWidth(120), kWidth(35));
        self.btn_determine.tag = 20211203;
        [self.btn_determine setBackgroundImage:kSetBundleImage(determineBtn) forState:UIControlStateNormal];
        self.btn_determine.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_determine addTarget:self action:@selector(func_findPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_determine;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showAccountLoginView];
        [self removeFromSuperview];
    });
}

- (void)func_getCodeAction:(UIButton *)sender {
    //获取验证码
    [self func_getPhoneCode:sender];
}

- (void)func_findPwdAction:(UIButton *)sender {
        //找回密码
        [self func_findPwdValidation];
}


-(void)func_getPhoneCode:(UIButton *)sender{
    NSString *phoneStr = [self.view_phone.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![SimpleSDK_Tools func_isMobileNumber:phoneStr]) {
        [SimpleSDK_Toast  showToastCenter:@"请输入正确的手机号！" location:@"center" showTime:2.5];
        return;
    }
    sender.enabled = NO;
   
    [SimpleSDK_ApiManager func_getPhoneCode:phoneStr type:@"findpwd" FuncBlock:^(BOOL status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            if (status) {
                [SimpleSDK_Toast showToast:@"验证码已发送到您手机" location:@"center" showTime:2.5f];
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
                            NSString *timeStr = [NSString stringWithFormat:@"%0.2ds", seconds];
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
        });
    }];
}

-(void)func_findPwdValidation{
    NSString *accountStr  =  [self.view_account.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordStr =  [self.view_pwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString *determinePwdStr =  [self.view_determinePwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *codeStr =  [self.view_code.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * phoneStr = [self.view_phone.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (accountStr.length <6 || passwordStr .length <6 ) {
        [SimpleSDK_Toast showToast:@"账号密码长度不能低于六位数！" location:@"center" showTime:2.5];
        return;
    }
    if (codeStr.length<4) {
        [SimpleSDK_Toast showToast:@"请输入正确的验证码" location:@"center" showTime:2.5f];
        return;
    }
    
    if (![SimpleSDK_Tools func_isMobileNumber:phoneStr]) {
        [SimpleSDK_Toast  showToastCenter:@"请输入正确的手机号！" location:@"center" showTime:2.5];
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
    
//    NSString *determinPwdError = [SimpleSDK_Tools func_validationInputText:determinePwdStr];
//    if (determinPwdError != nil) {
//        [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"密码",determinPwdError] location:@"center" showTime:2.5f];
//        return;
//    }
    
//    if (![passwordStr isEqualToString:determinePwdStr]) {
//        [SimpleSDK_Toast showToast:@"两次输入的密码不一致哦" location:@"center" showTime:2.5f];
//        return;
//    }
    
  
    [SimpleSDK_ApiManager func_findPwd:accountStr PhoneStr:phoneStr CodeStr:codeStr PasswordStr:passwordStr FuncBlock:^(BOOL status) {
        if (status) {
            //跳转到登陆界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [SimpleSDK_ViewManager func_showAccountLoginView];
                [self removeFromSuperview];
            });
        }
    }];
    
}
#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setFindPwdView];
}

@end
