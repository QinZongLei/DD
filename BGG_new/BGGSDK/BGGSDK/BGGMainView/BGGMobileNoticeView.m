//
//  BGGMobileNoticeView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/3.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGMobileNoticeView.h"
#import "BGGPCH.h"
#import "BGGAccountLoginView.h"

@interface BGGMobileNoticeView()
@property(nonatomic,strong)UILabel *notileLab;
@property(nonatomic,strong)BGGButton *cancelButton;
@property(nonatomic,strong)BGGButton *loginButton;
@end

@implementation BGGMobileNoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.titView.hidden = NO;
           self.logoImageView.hidden = YES;
           self.titlabel.text =@"提示";
           self.titlabel.textColor = BGGredColor;
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.notileLab = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentCenter lineNumber:1 text:@"注册失败,该手机号已经注册,是否立即登陆" font:Font(14)];
    [self addSubview:self.notileLab];
    [self.notileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(@20);
        make.top.equalTo(self.titView.mas_bottom).offset(21);
    }];
    
    self.cancelButton = [BGGView buttonWithFrame:CGRectZero title:@"取消" titleColor:BGGBlackColor selTitle:nil selTitlecColor:nil backColor:BGGLightGrayColor font:Font(16) target:self sel:@selector(cancelButton:)
        action:nil];
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(BGGBigButtonHeight));
        make.width.equalTo(@125);
        make.left.equalTo(self.mas_left).offset(40);
        make.top.equalTo(self.notileLab.mas_bottom).offset(40);
    }];
    self.cancelButton.layer.cornerRadius = BGGCornerRadius;
    
    self.loginButton = [BGGView buttonWithFrame:CGRectZero title:@"确定" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(16) target:self sel:@selector(cancelButton:)
        action:nil];
    [self addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(BGGBigButtonHeight));
        make.width.equalTo(@125);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.notileLab.mas_bottom).offset(40);
    }];
    self.loginButton.layer.cornerRadius = BGGCornerRadius;
}


-(void)cancelButton:(BGGButton *)button{
    [self dismiss];
    
}

-(void)loginButton:(BGGButton *)button{
    [self dismiss];
    BGGAccountLoginView *accountLoginView = [[BGGAccountLoginView alloc] initWithFrame:KBGGLoginRect];
    accountLoginView.registedPhone = self.registedPhone;
    [self BGGPresentView:accountLoginView];
    
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
@end
