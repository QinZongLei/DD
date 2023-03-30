//
//  BGGSMSCodeView.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGSMSCodeView.h"
#import "BGGPCH.h"
#import "HWTFCursorView.h"
#import "BGGDataModel.h"
#import "BGGShowAccountView.h"
@interface BGGSMSCodeView()
@property(strong,nonatomic)UILabel *desLabel;
@property(strong,nonatomic)UILabel *phoneLabel;
@property(strong,nonatomic)BGGButton *resendBtn;
@property(strong,nonatomic)HWTFCursorView *cursorView;
@end


@implementation BGGSMSCodeView
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
    self.desLabel = [BGGView labelWithFrame:CGRectZero textColor:Color_hex(@"#4a4948") backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:@"请填写手机短信验证码" font:Font(20)];
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@25);
        make.top.equalTo(self.titView.mas_bottom).offset(10);
    }];
    
    self.phoneLabel = [BGGView labelWithFrame:CGRectZero textColor:Color_hex(@"#4a4948") backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:[NSString stringWithFormat:@"发送至:%@",[BGGAPI sharedAPIManeger].phoneNumStr] font:Font(17)];
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.height.equalTo(@20);
        make.top.equalTo(self.desLabel.mas_bottom).offset(12);
    }];
    
    self.resendBtn = [BGGView buttonWithFrame:CGRectZero title:@"重新发送" titleColor:Color_hex(@"#fb4f4f") selTitle:nil selTitlecColor:nil backColor:nil font:Font(17) target:self sel:@selector(resendBtn:) action:nil];
    [self addSubview:self.resendBtn];
    [self.resendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneLabel.mas_centerY);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-28);
        make.width.equalTo(@80);
    }];
    
    [self countDown:self.resendBtn];
    [self addSubview:self.cursorView];
    [self.cursorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(20);
        make.height.equalTo(@50);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    [self.cursorView showGuangbiao];
    SYWeakObject(self);
    self.cursorView.codeBlock = ^(NSString * _Nonnull code) {
        [weak_self loginwithCode:code];
    };
        
}
-(void)loginwithCode:(NSString *)code{
    [BGGHTTPRequest BGGMobileAndCodeRegister:self.codeMobile code:code SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            if (returnCode == 0) {
                NSDictionary *dic = data;
                
                [BGGDataModel sharedInstance].isLogin = YES;
                [BGGDataModel sharedInstance].sdkUserToken = [dic objectForKey:@"token"];
                [BGGDataModel sharedInstance].mobile = [dic objectForKey:@"mobile"];
                [BGGDataModel sharedInstance].userName = [dic objectForKey:@"userName"];
                [BGGDataModel sharedInstance].nickName = [dic objectForKey:@"nickName"];
                [BGGDataModel sharedInstance].passWord = [dic objectForKey:@"password"];
                [[NSNotificationCenter defaultCenter] postNotificationName:BGGLoginNotify object:BGGSuccessResult userInfo:@{@"token": [BGGDataModel sharedInstance].sdkUserToken}];
                BGGShowAccountView *showAccountView = [[BGGShowAccountView alloc] initWithFrame:KBGGLoginRect];
                showAccountView.center = [self getPopControllerCenter];
                [self pushToView:showAccountView currentView:self];
                [[BGGDataModel sharedInstance] getUserInfoByToken];
                [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
                [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
                [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
                [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
                
//                [[BGGDataModel sharedInstance] dealPopViewIsExistAfterLogin];
//                
//                [[BGGDataModel sharedInstance] showPoviewAfterLogin];
                
              //  [[BGGDataModel sharedInstance] welcomeGameWithAccount:self.codeMobile];
                //登录成功十分钟后进行心跳检测
                [self performSelector:@selector(heartBeat) withObject:nil afterDelay: [[BGGDataModel sharedInstance].heartInterval intValue]*60];
            }else{
                [self popNotice:returnMsg];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
    
   
//    [BGGHTTPRequest BGGMobileAndCodeLogin:self.codeMobile code:code SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
//        if (returnCode == 0) {
//            NSDictionary *dic = data;
//            NSLog(@"%@",dic);
//            [BGGDataModel sharedInstance].isLogin = YES;
//            [BGGDataModel sharedInstance].sdkUserToken = [dic objectForKey:@"token"];
//            [BGGDataModel sharedInstance].mobile = [dic objectForKey:@"mobile"];
//            [BGGDataModel sharedInstance].userName = [dic objectForKey:@"userName"];
//            [BGGDataModel sharedInstance].nickName = [dic objectForKey:@"nickName"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:BGGLoginNotify object:BGGSuccessResult userInfo:@{@"token": [BGGDataModel sharedInstance].sdkUserToken}];
//
//            BGGShowAccountView *showAccountView = [[BGGShowAccountView alloc] initWithFrame:KBGGLoginRect];
//            showAccountView.center = [self getPopControllerCenter];
//            [self pushToView:showAccountView currentView:self];
//
//            [[BGGDataModel sharedInstance] getUserInfoByToken];
//
//            [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
//            [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
//            [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
//            [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
//
//            [[BGGDataModel sharedInstance] dealPopViewIsExistAfterLogin];
//
//            [[BGGDataModel sharedInstance] showPoviewAfterLogin];
//
//            [[BGGDataModel sharedInstance] welcomeGameWithAccount:self.codeMobile];
//
//            //登录成功十分钟后进行心跳检测
//            [self performSelector:@selector(heartBeat) withObject:nil afterDelay: [[BGGDataModel sharedInstance].heartInterval intValue]*60];
//
//
//
//        }else{
//            [self popNotice:returnMsg];
//        }
//    } failBlock:^(NSError *error) {
//
//    }];
}


-(void)heartBeat{
    [[BGGDataModel sharedInstance] stopHeartBeat];
    [[BGGDataModel sharedInstance] heartBeatTest];
}
-(void)resendBtn:(id)sender{
    [BGGHTTPRequest BGGSendSMSWithMobile:self.codeMobile successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [self popNotice:@"验证码发送成功"];
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


-(HWTFCursorView *)cursorView{
    if (!_cursorView) {
        _cursorView = [[HWTFCursorView alloc] initWithCount:6 margin:20];
    }
    return _cursorView;
}
@end
