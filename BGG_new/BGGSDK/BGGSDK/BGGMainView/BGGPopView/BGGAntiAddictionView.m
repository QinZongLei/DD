//
//  BGGAntiAddictionView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/3.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGAntiAddictionView.h"
#import "BGGPCH.h"
#import "BGGSMRZView.h"
@interface BGGAntiAddictionView()
@property(nonatomic,strong)UILabel *noticeLabel;
@property(nonatomic,strong)BGGButton *IKownButton;
@property(nonatomic,strong)BGGButton *cancelButton;
@property(nonatomic,strong)BGGButton *SMRZButton;
@property(nonatomic,strong)BGGButton *QZSMRZButton;
@end
@implementation BGGAntiAddictionView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.titView.hidden = NO;
           self.logoImageView.hidden = YES;
           self.titlabel.text =@"温馨提示";
           self.titlabel.textColor = BGGredColor;
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.noticeLabel =[BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:0 text:@"亲爱的玩家，根据国家法律规定，未实名认证的用户只能体验一个小时" font:Font(16)];
    [self addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@60);
        make.top.equalTo(self.titView.mas_bottom);
    }];
    
    self.IKownButton =[BGGView buttonWithFrame:CGRectZero title:@"我知道了" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGLightGrayColor font:Font(15) target:self sel:@selector(kownButton:) action:nil];
    [self addSubview:self.IKownButton];
    self.IKownButton.layer.cornerRadius = BGGCornerRadius;
    [self.IKownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.QZSMRZButton =[BGGView buttonWithFrame:CGRectZero title:@"立即实名" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(15) target:self sel:@selector(QZSMRZBButton:) action:nil];
    [self addSubview:self.QZSMRZButton];
    self.QZSMRZButton.layer.cornerRadius = BGGCornerRadius;
    [self.QZSMRZButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.cancelButton =[BGGView buttonWithFrame:CGRectZero title:@"取消" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGLightGrayColor font:Font(16) target:self sel:@selector(cancelButton:) action:nil];
    [self addSubview:self.cancelButton];
    self.cancelButton.layer.cornerRadius = BGGCornerRadius;
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    
    self.SMRZButton =[BGGView buttonWithFrame:CGRectZero title:@"去实名" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(16) target:self sel:@selector(SMRZButton:) action:nil];
    [self addSubview:self.SMRZButton];
    self.SMRZButton.layer.cornerRadius = BGGCornerRadius;
    [self.SMRZButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
}
-(void)setIsKnowm:(BOOL)isKnowm{
    _isKnowm = isKnowm;
    if (_isKnowm) {
        self.IKownButton.hidden = NO;
        self.cancelButton.hidden = YES;
        self.SMRZButton.hidden = YES;
        self.QZSMRZButton.hidden = YES;
    }else{
        self.IKownButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.SMRZButton.hidden = NO;
        self.QZSMRZButton.hidden = YES;
    }
}
-(void)setContinueGame:(BOOL)continueGame{
    _continueGame = continueGame;
    if (_continueGame) {
        self.IKownButton.hidden = YES;
        self.cancelButton.hidden = NO;
        self.SMRZButton.hidden = NO;
        self.QZSMRZButton.hidden = YES;
    }else{
        self.QZSMRZButton.hidden = NO;
        self.IKownButton.hidden = YES;
        self.cancelButton.hidden = YES;
        self.SMRZButton.hidden = YES;
    }
}
-(void)setMsg:(NSString *)msg{
    _msg = msg;
    self.noticeLabel.text = _msg;
}
-(void)kownButton:(BGGButton *)button{
    [self dismiss];
   
}
-(void)QZSMRZBButton:(BGGButton *)button{
    [self dismiss];
    BGGSMRZView *smrzView = [[BGGSMRZView alloc] initWithFrame:KBGGSMRZRect];
    [[BGGDataModel sharedInstance] BGGPresentView:smrzView];
}
-(void)cancelButton:(BGGButton *)button{
    [self dismiss];
}
-(void)SMRZButton:(BGGButton *)button{
    [self dismiss];
    [BGGAPI sharedAPIManeger].hideDragBtn = YES;
    BGGSMRZView *smrzView = [[BGGSMRZView alloc] initWithFrame:KBGGSMRZRect];
    [[BGGDataModel sharedInstance] BGGPresentView:smrzView];
    
}
@end
