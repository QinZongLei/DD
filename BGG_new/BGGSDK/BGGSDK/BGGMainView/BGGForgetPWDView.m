//
//  BGGForgetPWDView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGForgetPWDView.h"
#import "BGGPCH.h"
@interface BGGForgetPWDView()
@property(nonatomic,strong)UIView *phoneView;
@property(nonatomic,strong)UIView *codeView;
@property(nonatomic,strong)UIView *PWDView;
@property(nonatomic,strong)BGGButton *lijizhaohuiButton;
@property(nonatomic,strong)BGGButton *huoquCodeButton;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UITextField *PWDTextField;
@end
@implementation BGGForgetPWDView
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
    self.phoneView = [[UIView alloc] init];
    self.phoneView.backgroundColor = [UIColor whiteColor];
    self.phoneView.layer.borderWidth = 0.5;
    self.phoneView.layer.borderColor =  Color_hex(@"#bababa").CGColor;
    self.phoneView.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.phoneView];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.titView.mas_bottom).offset(10);
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.textAlignment = NSTextAlignmentLeft;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.phoneTextField.textColor = Color_hex(@"#333333");
    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    [self.phoneView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneView.mas_left).offset(0);//BGGTFLeftSpace
        make.top.equalTo(self.phoneView.mas_top);
        make.bottom.equalTo(self.phoneView.mas_bottom);
        make.right.equalTo(self.phoneView.mas_right).offset(-82);
    }];
    
    self.codeView = [[UIView alloc] init];
    self.codeView.backgroundColor = [UIColor whiteColor];
    self.codeView.layer.borderWidth = 0.5;
    self.codeView.layer.borderColor =  Color_hex(@"#bababa").CGColor;
    self.codeView.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.phoneView.mas_bottom).offset(15);
    }];
    
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextField.textAlignment = NSTextAlignmentLeft;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.codeTextField.textColor = Color_hex(@"#333333");
    self.codeTextField.backgroundColor = [UIColor whiteColor];
    [self.codeView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeView.mas_left).offset(BGGTFLeftSpace);
        make.top.equalTo(self.codeView.mas_top);
        make.bottom.equalTo(self.codeView.mas_bottom);
        make.right.equalTo(self.codeView.mas_right);
    }];
    
    self.PWDView = [[UIView alloc] init];
    self.PWDView.backgroundColor = [UIColor whiteColor];
    self.PWDView.layer.borderWidth = 0.5;
    self.PWDView.layer.borderColor =  Color_hex(@"#bababa").CGColor;
    self.PWDView.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.PWDView];
    [self.PWDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.codeView.mas_bottom).offset(15);
    }];
    
    self.PWDTextField = [[UITextField alloc] init];
    self.PWDTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.PWDTextField.textAlignment = NSTextAlignmentLeft;
    self.PWDTextField.keyboardType = UIKeyboardTypeDefault;
    self.PWDTextField.placeholder = @"设置新的密码(6-18位)";
    self.PWDTextField.font =[UIFont systemFontOfSize:16];
    //self.phoneTextF.delegate = self;
    self.PWDTextField.textColor = Color_hex(@"#333333");
    self.PWDTextField.backgroundColor = [UIColor whiteColor];
    [self.PWDView addSubview:self.PWDTextField];
    [self.PWDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PWDView.mas_left).offset(BGGTFLeftSpace);
        make.top.equalTo(self.PWDView.mas_top);
        make.bottom.equalTo(self.PWDView.mas_bottom);
        make.right.equalTo(self.PWDView.mas_right);
    }];
    
    self.huoquCodeButton = [BGGView buttonWithFrame:CGRectZero title:@"获取验证码" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(14) target:self sel:@selector(huoquCode:) action:nil];
    [self.phoneView addSubview:self.huoquCodeButton];
    self.huoquCodeButton.layer.cornerRadius = BGGCornerRadius;
    [self.huoquCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneView.mas_right);
        make.centerY.equalTo(self.phoneView.mas_centerY);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.width.equalTo(@100);
    }];
    
    self.lijizhaohuiButton = [BGGView buttonWithFrame:CGRectZero title:@"立即找回" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(20) target:self sel:@selector(lijizhaohuiButton:) action:nil];
    [self addSubview:self.lijizhaohuiButton];
    self.lijizhaohuiButton.layer.cornerRadius = BGGCornerRadius;
    [self.lijizhaohuiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.top.equalTo(self.PWDView.mas_bottom).offset(15);
    }];
    
}

-(void)huoquCode:(BGGButton *)button{
    if (!self.phoneTextField.text.length) {
        [self popNotice:@"请输入手机号"];
        return;
    }
    [BGGHTTPRequest BGGCheckMobile:self.phoneTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [BGGHTTPRequest BGGSendSMSWithMobile:self.phoneTextField.text successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
                if (returnCode == 0) {
                    [self countDown:button];
                }else{
                    [self popNotice:returnMsg];
                }
            } failBlock:^(NSError *error) {
                
            }];
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {

    }];
}
-(void)lijizhaohuiButton:(BGGButton *)button{
    if (!self.phoneTextField.text.length) {
        [self popNotice:@"请输入手机号"];
        return;
    }
    if (!self.codeTextField.text.length) {
        [self popNotice:@"请输入验证码"];
        return;
    }
    if (!self.PWDTextField.text.length) {
        [self popNotice:@"请输入新的密码"];
        return;
    }
    [BGGHTTPRequest BGGGetNewPWDWithMobile:self.phoneTextField.text code:self.codeTextField.text newPWD:self.PWDTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            
            self.setPWDSuccessBlock(self.phoneTextField.text, self.PWDTextField.text);
            [self popView];
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
