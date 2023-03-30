//
//  BGGCancelAccountView.m
//  BGGSDK
//
//  Created by 李胜 on 2023/3/23.
//  Copyright © 2023 BGG. All rights reserved.
//

#import "BGGCancelAccountView.h"
#import "BGGPCH.h"
#import "BGGAccountLoginView.h"

@interface BGGCancelAccountView ()

@property (nonatomic,strong)UITextField *accountTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,strong)BGGButton *cancelButton;

@end

@implementation BGGCancelAccountView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.titView.hidden = NO;
        self.logoImageView.hidden = YES;
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    self.accountTextField = [[UITextField alloc] init];
    self.accountTextField.borderStyle = UITextBorderStyleRoundedRect;//UITextBorderStyleNone;
    self.accountTextField.textAlignment = NSTextAlignmentLeft;
    self.accountTextField.keyboardType = UIKeyboardTypeDefault;
    self.accountTextField.placeholder = @"请输入您要注销的游戏账号或手机号";
    self.accountTextField.font =[UIFont systemFontOfSize:16];
    self.accountTextField.textColor = Color_hex(@"#333333");
    self.accountTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.titView.mas_bottom).offset(15);
    }];
    
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.textAlignment = NSTextAlignmentLeft;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font =[UIFont systemFontOfSize:16];
    self.passwordTextField.textColor = Color_hex(@"#333333");
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.accountTextField.mas_bottom).offset(15);
    }];
    
    
    
    self.cancelButton = [BGGView buttonWithFrame:CGRectZero title:@"注销" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(20) target:self sel:@selector(cancelButton:) action:nil];
    [self addSubview:self.cancelButton];
    self.cancelButton.layer.cornerRadius = BGGCornerRadius;
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.mas_left).offset(25);
       make.centerX.equalTo(self.mas_centerX);
       make.height.equalTo(@(BGGBigButtonHeight));
       make.top.equalTo(self.passwordTextField.mas_bottom).offset(30);
    }];
    
    
}

- (void)cancelButton:(UIButton *)button {
    
    if (!self.accountTextField.text.length) {
        [self popNotice:@"游戏账号或手机号不能为空"];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [self popNotice:@"密码不能为空"];
        return;
    }
    
    [BGGHTTPRequest BGGCancleWithAccountOrPhone:self.accountTextField.text password:self.passwordTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
      
        if (returnCode == 0) {
           
            //成功
            [self popNotice:returnMsg];
            //延时2.5秒后返回登录界面
            SYWeakObject(self);
            [self performSelector:@selector(popAfterLogin) withObject:nil afterDelay: 2.5];
            
               double delay1=2.5;//设置延时时间

                dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, delay1 * NSEC_PER_SEC);

                dispatch_after(popTime, dispatch_get_main_queue(), ^{

                    [weak_self popAfterLogin];

                });
            
        } else {

            [self popNotice:returnMsg];
        }

    } failBlock:^(NSError *error) {

    }];
    
}

-(void)popAfterLogin {
    
    if ([BGGDataModel sharedInstance].viewArray.count < 2) {
        [self dismiss];
        return ;
    }
    NSInteger count = [BGGDataModel sharedInstance].viewArray.count;
    UIView *lastView = [[BGGDataModel sharedInstance].viewArray lastObject];
    UIView *toView = [BGGDataModel sharedInstance].viewArray[count - 2];
    toView.hidden = NO;
    [lastView removeFromSuperview];
    [[BGGDataModel sharedInstance].viewArray removeLastObject];
    
}

@end
