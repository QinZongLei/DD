//
//  SimpleSDK_IdCardCertificationView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_IdCardCertificationView.h"
#import "SimpleSDK_ApiManager.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_Expose.h"
@interface SimpleSDK_IdCardCertificationView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UILabel *lb_prompt;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_nikeNmae;
@property (nonatomic, strong) SimpleSDK_CustomUITextFieldView *view_idCard;
@property (nonatomic, strong) UIButton *btn_certification;

@property (nonatomic, strong) UIButton *btn_changeAcount;

@end

@implementation SimpleSDK_IdCardCertificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self  func_setIdCardCertificationView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setIdCardCertificationView{
    
    self.bgImgVStr = idCardBgImgV;
    
    self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(450), kWidth(340));
    self.iv_viewBg.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2); 
    
    NSString *trueNameSwitchStr  = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"trueNameSwitch"];
    
    if (![@"1" isEqualToString:trueNameSwitchStr]) {
        //根据后台配置。是否显示这个跳过按钮
        [self.iv_viewBg addSubview:({
            self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
            self.btn_back.tag = 20211201;
            [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
            [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_back;
        })];
    }
     
    [self.iv_viewBg addSubview:({
        self.lb_prompt= [[UILabel alloc] init];
        self.lb_prompt.frame = CGRectMake((self.iv_viewBg.width-(self.iv_viewBg.width-kWidth(120)))/2, self.iv_line.bottom + kWidth(30), self.iv_viewBg.width-kWidth(100), kWidth(0));
        if (!kStringIsNull([SimpleSDK_DataTools manager].nameTextStr)) {
            self.lb_prompt.text = [SimpleSDK_DataTools manager].nameTextStr;
            
        } else {
            
        self.lb_prompt.text = @"根据国家相关规定，网络游戏用户需要进行实名认证。为保证流畅游戏体验，享受健康游戏生活，请您尽快完成实名认证。";
        }
        
        self.lb_prompt.font = [UIFont systemFontOfSize: kWidth(12)];
        self.lb_prompt.numberOfLines = 0;
        self.lb_prompt.textColor = color_idCrad_tip;
        self.lb_prompt;
    })];
    
    [self.lb_prompt sizeToFit];
    
    
    [self.iv_viewBg addSubview:({
        self.view_nikeNmae =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.lb_prompt.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_nikeNmae.tf_input.delegate = self;
        self.view_nikeNmae.leftTitleLbStr = @"姓 名:";
        self.view_nikeNmae.iconPath = kSetBundleImage(inputNameIcon);
        self.view_nikeNmae.placeholderStr = @"请输入真实姓名";
       
        self.view_nikeNmae;
    })];
    
    [self.iv_viewBg addSubview:({
        self.view_idCard =[[SimpleSDK_CustomUITextFieldView alloc] initWithFrame:CGRectMake(self.view_nikeNmae.left, self.view_nikeNmae.bottom+kWidth(10), kWidth(300), kWidth(35))];
        self.view_idCard.leftTitleLbStr = @"身份证:";
        self.view_idCard.iconPath = kSetBundleImage(inputIdCardIcon);
        self.view_idCard.placeholderStr = @"请输入您的身份证号码";
        self.view_idCard.tf_input.delegate = self;
        self.view_idCard;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_certification = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_certification.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.view_idCard.bottom+kWidth(15), kWidth(180), kWidth(45));

        self.btn_certification.tag = 20211202;
        [self.btn_certification setBackgroundImage:kSetBundleImage(idCareRealNameBtn) forState:UIControlStateNormal];
        self.btn_certification.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.btn_certification addTarget:self action:@selector(func_realNameAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_certification;
    })];
    
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

   return YES;
}

- (void)setShowType:(NSString *)showType
{
    _showType = showType;
    
    //用户中心-账号 过来的不显示
    if (![@"3" isEqualToString: self.showType]) {
        [self.iv_viewBg addSubview:({
            self.btn_changeAcount = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btn_changeAcount.frame = CGRectMake(self.iv_viewBg.width-kWidth(100), self.btn_certification.bottom - kWidth(20), kWidth(80), kWidth(20));
            [self.btn_changeAcount setTitle:@"切换账号" forState:0];
            self.btn_changeAcount.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.btn_changeAcount setAttributedTitle:[SimpleSDK_Tools func_strAddUnderline:@"切换账号" UnderLineColor:color_findPwd] forState:0];

            self.btn_changeAcount.titleLabel.font = [UIFont systemFontOfSize:kWidth(17)];
            self.btn_changeAcount.tag = 20211203;
            [self.btn_changeAcount addTarget:self action:@selector(func_changeAction:) forControlEvents:UIControlEventTouchUpInside];
            self.btn_changeAcount;
        })];
        
    }
}


- (void)func_blackAction:(UIButton *)sender {
    
    
    if ([@"2" isEqualToString: self.showType] ) {
        //登录弹出可以关闭的认证。直接关闭当前界面即可
        [self removeFromSuperview];
        //弹出可关闭的实名认证框。关闭认证弹出分享
        [SimpleSDK_ViewManager func_showGiftFloatView];
        
    }else if([@"3" isEqualToString: self.showType]){
        //用户中心-账号 实名过来的返回用户中心账号
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showAccountMenuView];
            [self removeFromSuperview];
        });
    }
}

//切换账号
- (void)func_changeAction:(UIButton *)sender {
    
    //切换账号
    [SimpleSDK_ViewManager func_removeFloatView];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SimpleSDK_ApiManager func_logout:^(BOOL status) {
            if (self) {
                [self removeFromSuperview];
                [[SimpleSDK_Expose sharedInstance] func_startLoginWithBlock:[SimpleSDK_Expose sharedInstance].loginHandle HandleLogout:[SimpleSDK_Expose sharedInstance].logoutHandle];
            }
        }];
    });
    
}

- (void)func_realNameAction:(UIButton *)sender {
        //认证
        [self func_realNameValidation];
}



-(void)func_realNameValidation{
    NSString *nickName  =  [self.view_nikeNmae.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *idCard =  [self.view_idCard.tf_input.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![SimpleSDK_Tools func_isVaildRealName:nickName]) {
        [SimpleSDK_Toast showToast:@"请输入正确的名字" location:@"center" showTime:2.5f];
        return;
    }
    if (![SimpleSDK_Tools func_verifyIDCard:idCard]) {
        [SimpleSDK_Toast showToast:@"请输入正确的身份证号码" location:@"center" showTime:2.5f];
        return;
    }
    [SimpleSDK_ApiManager func_realNameAuthentication:nickName idCard:idCard FuncBlock:^(BOOL status) {
        if (status) {
            //实名认证之后直接弹出
            [SimpleSDK_ViewManager func_showGiftFloatView];
            
            if ([@"2" isEqualToString: self.showType] ) {
                //登录弹出可以关闭的认证。直接关闭当前界面即可
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeFromSuperview];
                });
            }else if([@"3" isEqualToString: self.showType]){
                //用户中心-账号 实名过来的返回用户中心账号
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SimpleSDK_ViewManager func_showAccountMenuView];
                    [self removeFromSuperview];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeFromSuperview];
                });
            }
        }
    }];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setIdCardCertificationView];
}

@end
