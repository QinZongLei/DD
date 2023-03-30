//
//  SimpleSDK_PhoneCancelView.m
//  SimpleSDK
//
//  Created by Mac on 2022/6/30.
//

#import "SimpleSDK_PhoneCancelView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_AlterCancelMsg.h"

@interface SimpleSDK_PhoneCancelView ()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_phone;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_code;
@property (nonatomic, strong) UIButton *btn_getCode;
@property (nonatomic, strong) UIButton *btn_cancelPhone;

@end


@implementation SimpleSDK_PhoneCancelView

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
    
    self.bgImgVStr = phoneCancelBgImgV;
   
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.view_phone =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(50), kWidth(300), kWidth(35))];
        self.view_phone.leftTitleLbStr = @"手机号:";
        self.view_phone.iconPath = kSetBundleImage(inputPhoneIcon);
       
        self.view_phone.placeholderStr = @"请输入您需要注销的手机号";
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
    

    [self.iv_viewBg addSubview:({
        self.btn_cancelPhone = [UIButton buttonWithType:UIButtonTypeCustom];
      
            self.btn_cancelPhone.frame = CGRectMake((self.iv_viewBg.width-kWidth(160))/2, self.view_code.bottom+kWidth(25), kWidth(180), kWidth(45));
        self.btn_cancelPhone.tag = 20211204;
        [self.btn_cancelPhone setBackgroundImage:kSetBundleImage(bindingBtn) forState:UIControlStateNormal];
        self.btn_cancelPhone.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_cancelPhone addTarget:self action:@selector(func_cancelPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_cancelPhone;
    })];
    
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showManagerView];
     
    });
}


- (void)func_getCodeAction:(UIButton *)sender {
    //获取验证码
    [self endEditing:YES];
    [self func_getPhonCode:sender];
}

- (void)func_cancelPhoneAction:(UIButton *)sender {
        //注销
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注销账号" message:[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"cancel_before_text"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"确认注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
               
          [self func_phoneCancelValidation];
            
        });
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:delAction];
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [topVC presentViewController:alert animated:YES completion:nil];

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

-(void)func_phoneCancelValidation{
   
    
    [SimpleSDK_ApiManager func_cancelAccounOrPhone:self.view_phone.tf_input.text passwordOrCodeStr:self.view_code.tf_input.text typeStr:@"2" FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dic) {
        
        if (status) {
            
            NSString *succesStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cancel_success_text"]];
            [self removeFromSuperview];
            [SimpleSDK_AlterCancelMsg func_showCancellationWithMsg:succesStr];
        }
    }];
    

}


#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setPhoneRegisteredView];
}


@end
