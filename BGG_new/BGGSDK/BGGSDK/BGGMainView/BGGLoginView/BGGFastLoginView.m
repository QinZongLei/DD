//
//  BGGFastLoginView.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGFastLoginView.h"
#import "BGGPCH.h"
@interface BGGFastLoginView(){
    dispatch_source_t _timer;
}
@property(nonatomic,strong)UILabel *registSuccessNoticeLab;
@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)UILabel *accountLab;
@property(nonatomic,strong)UILabel *passwordLab;
@property(nonatomic,strong)BGGButton *enterGameBtn;
@end

@implementation BGGFastLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = NO;
           self.titView.hidden = NO;
           self.logoImageView.hidden = NO;
           [self createUI];
           [self request];
       }
       return self;
}


-(void)createUI{
    
    self.registSuccessNoticeLab = [BGGView labelWithTextColor:Color_hex(@"#fb4f4f") backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:@"注册成功,请截图保存账号出信息" font:Font(18)];
    [self addSubview:self.registSuccessNoticeLab];
    [self.registSuccessNoticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titView.mas_bottom).offset(32);
        make.height.equalTo(@25);
    }];
    
    self.accountLab = [BGGView labelWithTextColor:Color_hex(@"#4a4948") backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:nil font:Font(15)];
    [self addSubview:self.accountLab];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.top.equalTo(self.registSuccessNoticeLab.mas_bottom).offset(18);
    }];
    
    self.passwordLab = [BGGView labelWithTextColor:Color_hex(@"#4a4948") backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:nil font:Font(15)];
    [self addSubview:self.passwordLab];
    [self.passwordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.top.equalTo(self.accountLab.mas_bottom).offset(18);
    }];
    
    self.enterGameBtn = [BGGView buttonWithFrame:CGRectZero title:@"进入游戏" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(22) target:self sel:@selector(enterGame:) action:nil];
    [self addSubview:self.enterGameBtn];
    self.enterGameBtn.layer.cornerRadius = BGGCornerRadius;
    [self.enterGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.passwordLab.mas_bottom).offset(30);
    }];
   
}
-(void)request{
    [self popLoadingView:@""];
    [BGGHTTPRequest BGGGetFastLoginAccountAndPassSsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        [self hideNotice];
        NSDictionary *dic = data;
        if (returnCode == 0) {
            self.account = [dic objectForKey:@"userName"];
            self.password = [dic objectForKey:@"password"];
            self.accountLab.text = [NSString stringWithFormat:@"账号：%@",self.account];
            self.passwordLab.text = [NSString stringWithFormat:@"密码：%@",self.password];
            [[BGGDataModel sharedInstance] insertDataWithAccount:self.account andPassword:self.password];
            
            NSDictionary *dic = data;
            
            [BGGDataModel sharedInstance].sdkUserToken = [dic objectForKey:@"token"];
            [BGGDataModel sharedInstance].userName = [dic objectForKey:@"userName"];
            [BGGDataModel sharedInstance].nickName = [dic objectForKey:@"nickName"];
            [BGGDataModel sharedInstance].isLogin = YES;
            [BGGDataModel sharedInstance].autoLogin = YES;
            [[BGGDataModel sharedInstance] getUserInfoByToken];
            
            [BGGDataModel sharedInstance].isBind = [[dic objectForKey:@"isBind"] boolValue];
            [BGGDataModel sharedInstance].isRealName = [[dic objectForKey:@"isRealName"] boolValue];
            [BGGDataModel sharedInstance].forceRealName = [[dic objectForKey:@"forceRealName"] boolValue];
            [BGGDataModel sharedInstance].forceBindPhone = [[dic objectForKey:@"forceBindPhone"] boolValue];
            
           
            //登录成功十分钟后进行心跳检测
            [self performSelector:@selector(heartBeat) withObject:nil afterDelay: [[BGGDataModel sharedInstance].heartInterval intValue]*60];
           
         
            [self countDown:self.enterGameBtn];
            [self loadImageFinished:[self captureImageFromView:self]];
            
            
           
        }else{
           
            [self popNotice:returnMsg];
        }
        
    } failBlock:^(NSError *error) {
        [self hideNotice];
        
    }];
}
-(void)heartBeat{
    [[BGGDataModel sharedInstance] stopHeartBeat];
    [[BGGDataModel sharedInstance] heartBeatTest];
}

-(void)enterGame:(UIButton *)button{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:BGGLoginNotify object:BGGSuccessResult userInfo:@{@"token": [BGGDataModel sharedInstance].sdkUserToken}];
    [BGGAPI sharedAPIManeger].hideDragBtn = NO;
    [[BGGDataModel sharedInstance] welcomeGameWithAccount:self.account];
    [self performSelector:@selector(popAfterLogin) withObject:nil afterDelay: 2];
  
    
}

-(void)popAfterLogin
{
    [[BGGDataModel sharedInstance] dealPopViewIsExistAfterLogin];
    [[BGGDataModel sharedInstance] showPoviewAfterLogin];
}
-(void)countDown:(UIButton *)sender{
    __block NSInteger timeout = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    SYWeakObject(_timer);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(weak__timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"进入游戏" forState:UIControlStateNormal];
                [self enterGame:self.enterGameBtn];

            });
        }else{
            //            int minutes = timeout / 60;
            NSInteger seconds = timeout % (10 + 1);
            NSString *strTime = [NSString stringWithFormat:@"%.1zi", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:[NSString stringWithFormat:@"进入游戏%@",strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self popNotice:@"截图保存成功"];
}
#pragma mark - === 截图功能 ===
-(UIImage *)captureImageFromView:(UIView *)view
{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size,YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}
@end
