//
//  BGGBangDingMobileView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGBangDingMobileView.h"
#import "BGGPCH.h"
@interface  BGGBangDingMobileView()
@property(nonatomic,strong)UILabel *securityNoticeLab;
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)BGGButton *queRenButton;
@property(nonatomic,strong)BGGButton *sendSMSCodeButton;
@end
@implementation BGGBangDingMobileView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           if ([BGGDataModel sharedInstance].forceBindPhone) {
               self.rightButton.hidden = YES;
           }else{
               self.rightButton.hidden = NO;
           }
           self.titView.hidden = NO;
           self.titlabel.text = @"账号安全提示";
           self.titlabel.textColor = Color_hex(@"#fb4f4f");
           self.logoImageView.hidden = YES;
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.securityNoticeLab = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:@"为了您的账号安全，请您绑定手机号" font:Font(16)];
    [self addSubview:self.securityNoticeLab];
    [self.securityNoticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.titView.mas_bottom).offset(10);
            make.height.equalTo(@20);
    }];
    
    self.mobileTextField = [[UITextField alloc] init];
//    self.mobileTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.mobileTextField.backgroundColor = [UIColor whiteColor];
    self.mobileTextField.layer.cornerRadius = 4;
    self.mobileTextField.layer.masksToBounds = YES;
    self.mobileTextField.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.mobileTextField.layer.borderWidth = 1;
    self.mobileTextField.textAlignment = NSTextAlignmentLeft;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: Color_hex(@"#767676")}];
    self.mobileTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.mobileTextField.textColor = Color_hex(@"#333333");
    self.mobileTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.securityNoticeLab.mas_bottom).offset(15);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.codeTextField = [[UITextField alloc] init];
//    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.backgroundColor = [UIColor whiteColor];
    self.codeTextField.layer.cornerRadius = 4;
    self.codeTextField.layer.masksToBounds = YES;
    self.codeTextField.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.codeTextField.layer.borderWidth = 1;
    self.codeTextField.textAlignment = NSTextAlignmentLeft;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: Color_hex(@"#767676")}];
    self.codeTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.codeTextField.textColor = Color_hex(@"#333333");
    self.codeTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mobileTextField.mas_bottom).offset(15);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.queRenButton = [BGGView buttonWithFrame:CGRectZero title:@"确定" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(20) target:self sel:@selector(queRenButton:) action:nil];
    self.queRenButton.layer.cornerRadius = BGGCornerRadius;
    self.queRenButton.layer.masksToBounds = YES;
    [self addSubview:self.queRenButton];
    [self.queRenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTextField.mas_left);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.codeTextField.mas_bottom).offset(15);
    }];
    
    self.sendSMSCodeButton = [BGGView buttonWithFrame:CGRectZero title:@"获取验证码" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(17) target:self sel:@selector(sendSMSCode:) action:nil];
    [self addSubview:self.sendSMSCodeButton];
    [self.sendSMSCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mobileTextField.mas_right);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.width.equalTo(@100);
        make.centerY.equalTo(self.mobileTextField.mas_centerY);
    }];
    self.sendSMSCodeButton.layer.cornerRadius = BGGCornerRadius;
    
    self.rightBtnClickBlock = ^(BGGMainBaseView * _Nonnull keyboardView, UIButton * _Nonnull button) {
        [[BGGDataModel sharedInstance] showPoviewAfterLogin];
    };
    
    self.rightBtnClickBlock = ^(BGGMainBaseView * _Nonnull keyboardView, UIButton * _Nonnull button) {
        [[BGGDataModel sharedInstance] showPoviewAfterLogin];
    };
    
}

-(void)sendSMSCode:(BGGButton *)button{
    if (!self.mobileTextField.text.length) {
        [self popNotice:@"请输入手机号"];
        return;
    }
    [BGGHTTPRequest BGGSendSMSWithMobile:self.mobileTextField.text successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [self countDown:button];
            
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
-(void)queRenButton:(BGGButton *)button{
    if (!self.mobileTextField.text.length) {
        [self popNotice:@"请输入手机号"];
        return;
    }
    if (!self.codeTextField.text.length) {
        [self popNotice:@"请输入验证码"];
        return;
    }
    [BGGHTTPRequest BGGBindingMobileWithMobile:self.mobileTextField.text code:self.codeTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [[BGGAPI sharedAPIManeger] BGGDismiss];
            [[BGGDataModel sharedInstance] showPoviewAfterLogin];
        }else{
            [self popNotice:returnMsg];
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}
-(void)countDown:(UIButton *)sender{
    __block NSInteger timeout = CUTDOWNTIME; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"重新发送" forState:UIControlStateNormal];
              
                
                sender.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            NSInteger seconds = timeout % (CUTDOWNTIME + 1);
            NSString *strTime = [NSString stringWithFormat:@"%.2zi", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
@end
