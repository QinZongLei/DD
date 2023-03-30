//
//  BGGLogionView.m
//  BGGSDK
//
//  Created by lisheng on 2021/5/25.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGLogionView.h"
#import "BGGPCH.h"
#import "BGGSMSCodeView.h"
#import "BGGFastLoginView.h"
#import "BGGAccountLoginView.h"
#import "BGGSMRZView.h"
#import "BGGBangDingMobileView.h"
#import "BGGWKWebview.h"
#import "BGGUnSelRuleButton.h"
#import "BGGSelRuleButton.h"
#import "BGGShowAccountView.h"
#import "BGGMobileNoticeView.h"
#import "SaveInKeyChain.h"

@interface BGGLogionView()
@property(nonatomic,strong)UITextField *phoneTextF;
@property(nonatomic,strong)BGGButton *nextStepBtn;
@property(nonatomic,strong)BGGButton *fastEnterBtn;
@property(nonatomic,strong)BGGButton *accountLoginButton;
@property(nonatomic,strong)UILabel *ruleNoticeLab;
@property(nonatomic,strong)BGGButton *ruleButton;
@property(nonatomic,strong)BGGButton *areaBtn;
//@property(nonatomic,strong)BGGUnSelRuleButton *unSelBtn;
//@property(nonatomic,strong)BGGSelRuleButton *selBtn;
@property(nonatomic,strong)BGGButton *selRuleButton;
@property(assign,nonatomic)BOOL isAgreeRule;
@end

@implementation BGGLogionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = NO;
           self.rightButton.hidden = NO;
           self.titView.hidden = NO;
           self.logoImageView.hidden = NO;
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.phoneBackView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.phoneBackView];
   
    [self.phoneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(35);
        make.right.equalTo(self.mas_right).offset(-35);
        make.height.equalTo(@45);
        make.top.equalTo(self.mas_top).offset(78);
    }];
    self.phoneBackView.layer.cornerRadius = BGGCornerRadius;
       self.phoneBackView.layer.borderWidth = 0.5;
       self.phoneBackView.layer.borderColor = Color_hex(@"#bababa").CGColor;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Color_hex(@"#bababa");
    [self.phoneBackView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.top.equalTo(self.phoneBackView.mas_top);
        make.bottom.equalTo(self.phoneBackView.mas_bottom);
        make.left.equalTo(self.phoneBackView.mas_left).offset(65);
    }];
    
    
    
       self.phoneTextF = [[UITextField alloc] init];
       self.phoneTextF.borderStyle = UITextBorderStyleRoundedRect;
       self.phoneTextF.textAlignment = NSTextAlignmentLeft;
       self.phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
       self.phoneTextF.placeholder = @"请输入手机号";
       self.phoneTextF.font =[UIFont systemFontOfSize:16];
       //self.phoneTextF.delegate = self;
       self.phoneTextF.textColor = Color_hex(@"#333333");
       self.phoneTextF.backgroundColor = [UIColor whiteColor];
       [self.phoneBackView addSubview:self.phoneTextF];
       [self.phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.phoneBackView.mas_right);
           make.top.equalTo(self.phoneBackView.mas_top);
           make.bottom.equalTo(self.phoneBackView.mas_bottom);
           make.left.equalTo(line.mas_right).offset(0);//BGGTFLeftSpace
       }];
    
    
    self.areaBtn = [BGGView buttonWithFrame:CGRectZero title:@"+86" titleColor:Color_hex(@"#4a4948") selTitle:nil selTitlecColor:nil image:[UIImage BGGGetImage:@"LOPArrowDown"] selImage:[UIImage BGGGetImage:@"LOPArrowUp"] backColor:nil font:Font(15) target:self sel:@selector(areaButton:) action:nil];
    [self.phoneBackView addSubview:self.areaBtn];
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneBackView.mas_left);
        make.top.equalTo(self.phoneBackView.mas_top);
        make.bottom.equalTo(self.phoneBackView.mas_bottom);
        make.right.equalTo(line.mas_left).offset(0);
    }];
    self.areaBtn.spacing = 7;
    self.areaBtn.type = BGGButtonTypeImageRight;
    
    self.nextStepBtn = [BGGView buttonWithFrame:CGRectZero title:@"下一步" titleColor:Color_hex(@"#FFFFFF") selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(20) target:self sel:@selector(nextStepButton:) action:nil];
    [self addSubview:self.nextStepBtn];
    self.nextStepBtn.layer.cornerRadius = BGGCornerRadius;
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneBackView.mas_left);
        make.right.equalTo(self.phoneBackView.mas_right);
        make.height.equalTo(@45);
        make.top.equalTo(self.phoneBackView.mas_bottom).offset(15);
    }];
    
    self.fastEnterBtn = [BGGView buttonWithFrame:CGRectZero image:[UIImage BGGGetImage:@"MAINFastLogin"] selImage:nil target:self sel:@selector(fastEnter:) action:nil];
    [self.fastEnterBtn setTitle:@"快速游戏" forState:UIControlStateNormal];
   
    [self.fastEnterBtn setTitleColor:BGGGrayColor forState:UIControlStateNormal];
    [self addSubview:self.fastEnterBtn];
    [self.fastEnterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextStepBtn.mas_right).offset(-10);
        make.top.equalTo(self.nextStepBtn.mas_bottom).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    [self.fastEnterBtn setImageSize:CGSizeMake(28, 28)];
    [self.fastEnterBtn setType:BGGButtonTypeImageLeft];
    [self.fastEnterBtn setSpacing:3];
    
    self.accountLoginButton = [BGGView buttonWithFrame:CGRectZero image:[UIImage BGGGetImage:@"MAINAccountLogin"] selImage:nil target:self sel:@selector(accountLogion:) action:nil];
       [self.accountLoginButton setTitle:@"账号登录" forState:UIControlStateNormal];
       [self.accountLoginButton setTitleColor:BGGGrayColor forState:UIControlStateNormal];
       [self addSubview:self.accountLoginButton];
       [self.accountLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.nextStepBtn.mas_left).offset(10);
           make.top.equalTo(self.nextStepBtn.mas_bottom).offset(15);
           make.height.equalTo(@30);
           make.width.equalTo(@100);
       }];
    [self.accountLoginButton setImageSize:CGSizeMake(28, 28)];
    [self.accountLoginButton setType:BGGButtonTypeImageLeft];
    [self.accountLoginButton setSpacing:3];
    

    self.selRuleButton = [BGGView buttonWithFrame:CGRectZero image:[UIImage BGGGetImage:@"GPUnSelAgree"] selImage:[UIImage BGGGetImage:@"GPSelAgree"] target:self sel:@selector(selRuleBUtton:) action:nil];
    [self addSubview:self.selRuleButton];
    [self.selRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.left.equalTo(self.phoneBackView.mas_left).offset(0);
        make.top.equalTo(self.fastEnterBtn.mas_bottom).offset(18);
    }];
    [self.selRuleButton setImageSize:CGSizeMake(20, 20)];
    [self.selRuleButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];

    self.ruleNoticeLab = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"我已详细阅读并同意" font:Font(13)];
    [self addSubview:self.ruleNoticeLab];
    [self.ruleNoticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selRuleButton.mas_centerY);
        make.left.equalTo(self.selRuleButton.mas_right).offset(-3);
        make.height.equalTo(@40);
    }];
    
    
    self.ruleButton = [BGGView buttonWithFrame:CGRectZero title:@"用户隐私协议" titleColor:Color_hex(@"#333333") selTitle:nil selTitlecColor:nil backColor:nil font:Font(13) target:self sel:@selector(ruleButton:) action:nil];
    [self addSubview:self.ruleButton];
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selRuleButton.mas_centerY);
        make.left.equalTo(self.ruleNoticeLab.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@82);
    }];
    [self.ruleButton lc_setUnderLineColor:Color_hex(@"#333333") text:@"用户隐私协议"];\

    
    
}
-(void)areaButton:(BGGButton *)button{
    
}

-(void)nextStepButton:(id)sender{
    if (!self.phoneTextF.text.length) {
        [self popNotice:@"请输入手机号码"];
        return;
    }
    if (!self.isAgreeRule) {
        [self popNotice:@"请先同意协议"];
        return;
    }
    [BGGHTTPRequest BGGCheckMobile:self.phoneTextF.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {

        if (returnCode == 0) {
            [BGGAPI sharedAPIManeger].phoneNumStr = self.phoneTextF.text;
            [self MobileExist];
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {

    }];
}

-(void)MobileExist{
    [BGGHTTPRequest BGGPanDuanMobileExistMobile:self.phoneTextF.text successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            NSDictionary *dic = data;
            if ([dic[@"existMobile"] boolValue]) {
                [self dismiss];
                BGGMobileNoticeView *mobileView = [[BGGMobileNoticeView alloc] initWithFrame:KBGGNoticeRect];
                mobileView.registedPhone = self.phoneTextF.text;
                [self BGGPresentView:mobileView];
            }else{
                [self sendCode];
                BGGSMSCodeView *codeView = [[BGGSMSCodeView alloc] initWithFrame:KBGGLoginRect];
                codeView.center = [self getPopControllerCenter];
                codeView.codeMobile = self.phoneTextF.text;
                [self pushToView:codeView currentView:self];
            }
        }else{
            [self popNotice:returnMsg];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
-(void)BGGPresentView:(UIView *)endView{
    endView.hidden = NO;
    [[BGGDataModel sharedInstance].viewArray addObject:endView];
      endView.center = [self getPopControllerCenter];
      SYPopupController *popupController =  [SYPopupController popupControllerWithMaskType:syPopupMaskTypeBlackBlur];
      popupController.layoutType = syPopupLayoutTypeCenter;
      [popupController presentContentView:endView duration:0.25 springAnimated:NO];
      popupController.dismissOnMaskTouched = NO;
      popupController.popupView.backgroundColor = [UIColor clearColor];
      [BGGDataModel sharedInstance].popupController = popupController;
}
-(void)sendCode{
    [BGGHTTPRequest BGGSendSMSWithMobile:self.phoneTextF.text successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [self popNotice:@"验证码发送成功"];
        }else{
            [self popNotice:returnMsg];
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - === 快速游戏 ===
-(void)fastEnter:(id)sender{
    if (!self.isAgreeRule) {
        [self popNotice:@"请先同意协议"];
        return;
    }
    self.selRuleButton.selected = YES;
//    self.isAgreeRule = YES;
    BGGFastLoginView *fastLogin = [[BGGFastLoginView alloc] initWithFrame:KBGGLoginRect];
    fastLogin.center = [self getPopControllerCenter];
    [self pushToView:fastLogin currentView:self];
}
-(void)accountLogion:(UIButton *)button{
    BGGAccountLoginView *accountLogin = [[BGGAccountLoginView alloc] initWithFrame:KBGGLoginRect];
    accountLogin.center = [self getPopControllerCenter];
    [self pushToView:accountLogin currentView:self];
}

-(void)ruleButton:(id)sender{
    
    BGGWKWebview *weView = [[BGGWKWebview alloc] initWithFrame:KBGGRuleRect];
    weView.center = [self getPopControllerCenter];
    [self pushToView:weView currentView:self];
    weView.webUrl = [BGGDataModel sharedInstance].privacyUrl;
}

-(void)selRuleBUtton:(BGGButton *)button{
    button.selected = !button.selected;
    self.isAgreeRule = button.selected;
}

//-(void)unSelBtn:(id)sender{
//    self.unSelBtn.hidden = YES;
//    self.selBtn.hidden = NO;
//    self.isAgreeRule = YES;
//
//}
//-(void)selBtn:(id)sender{
//    self.unSelBtn.hidden = NO;
//    self.selBtn.hidden = YES;
//    self.isAgreeRule = NO;
//}

-(void)checkIFAccountLogin{
    
    NSString *account = [SaveInKeyChain load:@"BGGAccount"];
    NSString *password = [SaveInKeyChain load:@"BGGPassword"];
    if (account && password) {
        [self accountLogion:nil];
    }
    
}
@end
