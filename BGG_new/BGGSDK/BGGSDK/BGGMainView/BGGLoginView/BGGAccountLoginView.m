//
//  BGGAccountLoginView.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGAccountLoginView.h"
#import "BGGPCH.h"
#import "BGGForgetPWDView.h"
#import "BGGPopAccountView.h"
#import "BGGFastLoginView.h"
#import "SaveInKeyChain.h"
#import "BGGCancelAccountView.h"
@interface BGGAccountLoginView()
@property (nonatomic,strong)UIView *accountView;
@property (nonatomic,strong)UIView *passwordView;
@property (nonatomic,strong)UITextField *accountTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,strong)BGGButton *loginButton;
@property (nonatomic,strong)BGGButton *registNowButton;
@property (nonatomic,strong)BGGButton *wangjiMimaButton;
@property (nonatomic,strong)BGGButton *showHistoryAccountButton;
@property (nonatomic,strong)UILabel *meiyouAccountButton;
@property (nonatomic,strong)BGGPopAccountView *popAccountView;
@property (nonatomic,strong)BGGButton *showPasswordBtn;
@property (nonatomic,strong)BGGButton *cancelAccountBtn;

@end
@implementation BGGAccountLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = NO;
           self.titView.hidden = NO;
           self.logoImageView.hidden = YES;
           [self createUI];
          
       }
       return self;
}


-(void)createUI{
    self.accountView = [[UIView alloc] init];
    self.accountView.backgroundColor = [UIColor whiteColor];
    self.accountView.layer.borderWidth = 0.5;
    self.accountView.layer.borderColor = Color_hex(@"#bababa").CGColor;
    self.accountView.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.titView.mas_bottom).offset(10);
    }];
    
    
   
    
    self.accountTextField = [[UITextField alloc] init];
    self.accountTextField.borderStyle = UITextBorderStyleRoundedRect;//UITextBorderStyleNone;
    self.accountTextField.textAlignment = NSTextAlignmentLeft;
    self.accountTextField.keyboardType = UIKeyboardTypeDefault;
    self.accountTextField.placeholder = @"请输入游戏账号或手机号";
    self.accountTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.accountTextField.textColor = Color_hex(@"#333333");
    self.accountTextField.backgroundColor = [UIColor whiteColor];
    [self.accountView addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountView.mas_left).offset(0); //BGGTFLeftSpace
        make.top.equalTo(self.accountView.mas_top).offset(1);
        make.bottom.equalTo(self.accountView.mas_bottom);
        make.right.equalTo(self.accountView.mas_right).offset(-40);
    }];
    
    self.showHistoryAccountButton = [BGGView buttonWithFrame:CGRectZero image:[UIImage BGGGetImage:@"LOPArrowDown"] selImage:[UIImage BGGGetImage:@"LOPArrowUp"] target:self sel:@selector(showHistoryAccount:) action:nil];
    [self addSubview:self.showHistoryAccountButton];
    [self.showHistoryAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(BGGBigButtonHeight));
        make.width.equalTo(@20);
        make.right.equalTo(self.accountView.mas_right);
        make.centerY.equalTo(self.accountView.mas_centerY);
    }];
    
    self.passwordView = [[UIView alloc] init];
    self.passwordView.backgroundColor = [UIColor whiteColor];
    self.passwordView.layer.borderWidth = 0.5;
    self.passwordView.layer.borderColor = Color_hex(@"#bababa").CGColor;
    self.passwordView.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.accountView.mas_bottom).offset(15);
    }];
    
   
    
    self.showPasswordBtn = [BGGView buttonWithFrame:CGRectZero image:[UIImage BGGGetImage:@"PWDCloseEye"] selImage:[UIImage BGGGetImage:@"PWDOpenEye"] target:self sel:@selector(showPassButtonclick:) action:nil];
    [self.passwordView addSubview:self.showPasswordBtn];
    [self.showPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordView.mas_centerY);
        make.right.equalTo(self.passwordView.mas_right);
        make.width.height.equalTo(@20);
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.textAlignment = NSTextAlignmentLeft;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextField.placeholder = @"请输入登录密码";
    self.passwordTextField.font =[UIFont systemFontOfSize:16];
    self.passwordTextField.secureTextEntry = YES;
    //self.phoneTextF.delegate = self;
    self.passwordTextField.textColor = Color_hex(@"#333333");
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    [self.passwordView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordView.mas_left).offset(0);//BGGTFLeftSpace
        make.top.equalTo(self.passwordView.mas_top).offset(1);
        make.bottom.equalTo(self.passwordView.mas_bottom);
        make.right.equalTo(self.passwordView.mas_right).offset(-40);
    }];
    
    self.loginButton = [BGGView buttonWithFrame:CGRectZero title:@"登录" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(20) target:self sel:@selector(loginButton:) action:nil];
    [self addSubview:self.loginButton];
    self.loginButton.layer.cornerRadius = BGGCornerRadius;
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.mas_left).offset(25);
       make.centerX.equalTo(self.mas_centerX);
       make.height.equalTo(@(BGGBigButtonHeight));
       make.top.equalTo(self.passwordView.mas_bottom).offset(15);
    }];
    
    self.meiyouAccountButton = [BGGView labelWithTextColor:Color_hex(@"#333333") backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"没有账号?" font:Font(15)];
    [self addSubview:self.meiyouAccountButton];
    [self.meiyouAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_left).offset(-5);
        make.height.equalTo(@20);
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.width.equalTo(@70);
    }];
    
    self.registNowButton = [BGGView buttonWithFrame:CGRectZero title:@"立即注册" titleColor:Color_hex(@"#fb4f4f") selTitle:nil selTitlecColor:nil backColor:nil font:Font(15) target:self sel:@selector(registerNow:) action:nil];
    [self addSubview:self.registNowButton];
    [self.registNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.meiyouAccountButton.mas_centerY);
        make.left.equalTo(self.meiyouAccountButton.mas_right);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    
    self.cancelAccountBtn = [BGGView buttonWithFrame:CGRectZero title:@"账号注销" titleColor:Color_hex(@"#fb4f4f") selTitle:nil selTitlecColor:nil backColor:nil font:Font(15) target:self sel:@selector(cancelAccount:) action:nil];
    [self addSubview:self.cancelAccountBtn];
    [self.cancelAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.meiyouAccountButton.mas_centerY);
        make.left.equalTo(self.registNowButton.mas_right).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    self.wangjiMimaButton = [BGGView buttonWithFrame:CGRectZero title:@"忘记密码" titleColor:Color_hex(@"#fb4f4f") selTitle:nil selTitlecColor:nil backColor:nil font:Font(15) target:self sel:@selector(wangjimima:) action:nil];
    [self addSubview:self.wangjiMimaButton];
    [self.wangjiMimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.meiyouAccountButton.mas_centerY);
        make.right.equalTo(self.loginButton.mas_right).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    
    
    if ([BGGDataModel sharedInstance].accountArray.count) {
        NSDictionary *dic = [[BGGDataModel sharedInstance].accountArray firstObject];
        NSString *account = [dic objectForKey:@"account"];
        NSString *password = [dic objectForKey:@"password"];
        self.accountTextField.text = account;
        self.passwordTextField.text = password;
    }else{
        NSString *account = [SaveInKeyChain load:@"BGGAccount"];
        NSString *password = [SaveInKeyChain load:@"BGGPassword"];
        self.accountTextField.text = account;
        self.passwordTextField.text = password;
    }
    
    
}
-(void)setRegistedPhone:(NSString *)registedPhone{
    _registedPhone = registedPhone;
    [[BGGDataModel sharedInstance].accountArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
        NSString *account = [dic objectForKey:@"account"];
        if ([account isEqualToString:self.registedPhone]) {
            self.accountTextField.text = account;
            self.passwordTextField.text =  [dic objectForKey:@"password"];
        }
    }];
}

- (void)showPassButtonclick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        _passwordTextField.secureTextEntry = NO;
    }else{
        _passwordTextField.secureTextEntry = YES;
    }
}
-(void)showHistoryAccount:(BGGButton *)button{
    button.selected = !button.selected;
    if (![BGGDataModel sharedInstance].accountArray.count) {
        return;
    }
    if (button.selected) {
        [self addSubview:self.popAccountView];
        SYWeakObject(self)
        self.popAccountView.selAccountBlock = ^(NSDictionary * _Nonnull accountDic) {
            weak_self.accountTextField.text = accountDic[@"account"];
            weak_self.passwordTextField.text = accountDic[@"password"];
            [weak_self hidehistoryAccount];
        };
        [self.popAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.accountView.mas_left);
                make.right.equalTo(self.accountView.mas_right);
                make.bottom.equalTo(self.mas_bottom).offset(-1);
                make.top.equalTo(self.accountView.mas_bottom);
        }];
    }else{
        [self hidehistoryAccount];
    }
    
    
}

-(void)hidehistoryAccount{
    if ([self.subviews containsObject:self.popAccountView]) {
        self.showHistoryAccountButton.selected = NO;
        [self.popAccountView removeFromSuperview];
        
    }
}
#pragma mark - === 登录 ===
-(void)loginButton:(UIButton *)button{
   [BGGHTTPRequest BGGAccountPasswordLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
       
        NSDictionary *dic = data;
        if (returnCode == 0) {
            [BGGDataModel sharedInstance].autoLogin = YES;
            [[BGGDataModel sharedInstance] insertDataWithAccount:self.accountTextField.text andPassword:self.passwordTextField.text];
            [BGGAPI sharedAPIManeger].hideDragBtn = NO;
            [BGGDataModel sharedInstance].sdkUserToken = [dic objectForKey:@"token"];
            [BGGDataModel sharedInstance].mobile = [dic objectForKey:@"mobile"];
            [BGGDataModel sharedInstance].userName = [dic objectForKey:@"userName"];
            [BGGDataModel sharedInstance].nickName = [dic objectForKey:@"nickName"];
            [BGGDataModel sharedInstance].isLogin = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BGGLoginNotify object:BGGSuccessResult userInfo:@{@"token": [BGGDataModel sharedInstance].sdkUserToken}];
            [self dismiss];
            [[BGGDataModel sharedInstance] getUserInfoByToken];
            
            [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
            [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
            [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
            [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
            
          
            
            
            
            //登录成功十分钟后进行心跳检测
            [self performSelector:@selector(heartBeat) withObject:nil afterDelay: [[BGGDataModel sharedInstance].heartInterval intValue]*60];
           
            [[BGGDataModel sharedInstance] welcomeGameWithAccount:self.accountTextField.text];
            
            [self performSelector:@selector(popNOticeView) withObject:nil afterDelay:3];
            
           
        }else{
            [self popNotice:returnMsg];
        }
       } failBlock:^(NSError *error) {
           
       }];
}
-(void)popNOticeView{
    [[BGGDataModel sharedInstance] dealPopViewIsExistAfterLogin];
    [[BGGDataModel sharedInstance] showPoviewAfterLogin];
}
-(void)heartBeat{
    [[BGGDataModel sharedInstance] stopHeartBeat];
    [[BGGDataModel sharedInstance] heartBeatTest];
}
-(void)registerNow:(UIButton *)button{
    BGGFastLoginView *fastLogin = [[BGGFastLoginView alloc] initWithFrame:KBGGLoginRect];
    fastLogin.center = [self getPopControllerCenter];
    [self pushToView:fastLogin currentView:self];
    
   
}

-(void)cancelAccount:(UIButton *)button {
    
    BGGCancelAccountView *cancelAccount = [[BGGCancelAccountView alloc] initWithFrame:KBGGLoginRect];
    cancelAccount.center = [self getPopControllerCenter];
    [self pushToView:cancelAccount currentView:self];
    
}

-(void)wangjimima:(UIButton *)button{
    BGGForgetPWDView *forPwdView = [[BGGForgetPWDView alloc] initWithFrame:KBGGForgetPWD];
    SYWeakObject(self);
    forPwdView.setPWDSuccessBlock = ^(NSString * _Nonnull phone, NSString * _Nonnull pwd) {
        weak_self.accountTextField.text = phone;
        weak_self.passwordTextField.text = pwd;
    };
    forPwdView.center = [self getPopControllerCenter];
    [self pushToView:forPwdView currentView:self];
}
-(BGGPopAccountView *)popAccountView{
    if (!_popAccountView) {
        _popAccountView = [[BGGPopAccountView alloc] initWithFrame:CGRectZero];
    }
    return _popAccountView;
}
@end
