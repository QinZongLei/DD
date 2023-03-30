//
//  SimpleSDK_UpdatePwdView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_UpdatePwdView.h"
#import "SimpleSDK_ApiManager.h"

@interface SimpleSDK_UpdatePwdView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_oldPwd;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_newPwd;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_determinePwd;
@property (nonatomic, strong) UIButton *btn_updatePwd;
@end

@implementation SimpleSDK_UpdatePwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        [self  func_addNotification];
        [self func_setUpdatePwdView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


-(void)func_setUpdatePwdView{
    self.bgImgVStr = updatePwdBgImgV;
  
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width -kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_oldPwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_line.bottom+kWidth(35), kWidth(300), kWidth(35))];
        self.view_oldPwd.iconPath = kSetBundleImage(inputUpdatePwdIcon);
        self.view_oldPwd.leftTitleLbStr = @"旧密码:";
        self.view_oldPwd.placeholderStr = @"请输入旧密码";

        self.view_oldPwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_newPwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_oldPwd.left, self.view_oldPwd.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_newPwd.iconPath = kSetBundleImage(inputUpdatePwdIcon);
        self.view_newPwd.placeholderStr = @"请输入新密码";
        self.view_newPwd.leftTitleLbStr = @"新密码:";

        self.view_newPwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_determinePwd =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_oldPwd.left, self.view_newPwd.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_determinePwd.iconPath = kSetBundleImage(inputUpdatePwdIcon);
        self.view_determinePwd.placeholderStr = @"请在再次输入密码";
        self.view_determinePwd.leftTitleLbStr = @"新密码";
        self.view_determinePwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_updatePwd = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_updatePwd.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.view_determinePwd.bottom+kWidth(20), kWidth(180), kWidth(45));

        self.btn_updatePwd.tag = 20211202;
        [self.btn_updatePwd setBackgroundImage:kSetBundleImage(determineBtn) forState:UIControlStateNormal];
        self.btn_updatePwd.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_updatePwd addTarget:self action:@selector(func_updatePwdAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_updatePwd;
    })];
}

- (void)func_blackAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showAccountMenuView];
        [self removeFromSuperview];
    });
}


- (void)func_updatePwdAction:(UIButton *)sender {
        //修改密码。调用接口
        [self func_updataPwdValidation];
}

-(void)func_updataPwdValidation{
    NSString *oldPwd =  [self.view_oldPwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newPwd =  [self.view_newPwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *determinePwd = [self.view_determinePwd.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (oldPwd.length <6 || newPwd .length <6 || determinePwd.length <6) {
        [SimpleSDK_Toast showToast:@"密码长度不能低于六位数！" location:@"center" showTime:2.5];
        return;
    }
    NSString * oldPwdErrorStr =[SimpleSDK_Tools func_validationInputText:oldPwd];
    if(oldPwdErrorStr != nil){
       [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"旧密码",oldPwdErrorStr] location:@"center" showTime:2.5f];
        return;
    }
    NSString * newPwdErrorStr =[SimpleSDK_Tools func_validationInputText:newPwd];
    if (newPwdErrorStr != nil) {
        [SimpleSDK_Toast showToast:[NSString stringWithFormat:@"%@%@",@"新密码",newPwdErrorStr] location:@"center" showTime:2.5f];
         return;
        
    }
    if (![newPwd isEqualToString:determinePwd]) {
        [SimpleSDK_Toast showToast:@"两次输入的密码不一致哦" location:@"center" showTime:2.5f];
        return;
    }
    
    [SimpleSDK_ApiManager func_updatapwd:oldPwd newPwd:newPwd FuncBlock:^(BOOL status) {
        if (status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SimpleSDK_ViewManager func_showUserCenterView];
                [self removeFromSuperview];
            });
        }
    }];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setUpdatePwdView];
}


@end
