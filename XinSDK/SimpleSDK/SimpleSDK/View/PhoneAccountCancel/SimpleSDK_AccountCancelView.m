//
//  SimpleSDK_AccountCancelView.m
//  SimpleSDK
//
//  Created by Mac on 2022/6/30.
//

#import "SimpleSDK_AccountCancelView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_AlterCancelMsg.h"

@interface SimpleSDK_AccountCancelView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_account;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_pwd;

@property (nonatomic, strong) UIButton *btn_cancelLogin;

@end

@implementation SimpleSDK_AccountCancelView

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
    
    self.bgImgVStr= accountCancelBgImgV;

    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width -kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_account =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(50), kWidth(300), kWidth(40))];
        self.view_account.leftTitleLbStr = @"账 号:";
       
        self.view_account.iconPath = kSetBundleImage(inputAccountIcon);
        self.view_account.placeholderStr = @"请输入您需要注销的账号";
        self.view_account;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_pwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_account.left, self.view_account.bottom+kWidth(5), kWidth(300), kWidth(40))];
        self.view_pwd.leftTitleLbStr = @"密 码:";
       
        self.view_pwd.iconPath = kSetBundleImage(inputPwdIcon);
        self.view_pwd.placeholderStr = @"请输入您需要注销账号的密码";
        self.view_pwd;
    })];
   
    
    [self.iv_viewBg addSubview:({
        self.btn_cancelLogin = [UIButton buttonWithType:UIButtonTypeCustom];
      
            self.btn_cancelLogin.frame = CGRectMake((self.iv_viewBg.width-kWidth(160))/2, self.view_pwd.bottom+kWidth(20), kWidth(180), kWidth(45));
        self.btn_cancelLogin.tag = 20211206;
        [self.btn_cancelLogin setBackgroundImage:kSetBundleImage(bindingBtn) forState:UIControlStateNormal];
        self.btn_cancelLogin.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_cancelLogin addTarget:self action:@selector(func_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_cancelLogin;
    })];
    
    
   
}

- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showManagerView];
    });
}


- (void)func_cancelAction:(UIButton *)sender {
    //注销   调用接口
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注销账号" message:[[SimpleSDK_DataTools manager].switchInfo  objectForKey:@"cancel_before_text"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"确认注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
               
            [self func_cancelValidation];
            
        });
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:delAction];
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [topVC presentViewController:alert animated:YES completion:nil];
}


- (void)func_cancelValidation {
    
    [SimpleSDK_ApiManager func_cancelAccounOrPhone:self.view_account.tf_input.text passwordOrCodeStr:self.view_pwd.tf_input.text typeStr:@"1" FuncBlock:^(BOOL status, NSString * _Nonnull msg, NSDictionary * _Nonnull dic) {
        
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
    [self func_setLoginView];
}

@end
