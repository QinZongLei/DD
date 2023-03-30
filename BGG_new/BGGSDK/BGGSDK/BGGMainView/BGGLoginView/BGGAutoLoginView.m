//
//  BGGAutoLoginView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGAutoLoginView.h"
#import "BGGPCH.h"
#import "UILabel+LC.h"
@interface BGGAutoLoginView()
@property(nonatomic,strong)UILabel *accountLab;
@property(nonatomic,strong)BGGButton *qieHuanBtn;

@end

@implementation BGGAutoLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
          
           [self createUI];
       }
       return self;
}
-(void)createUI{
    self.backgroundColor = BGGWhiteColor;
    self.layer.cornerRadius = BGGCornerRadius;
    self.accountLab = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"账号：123456" font:Font(15)];
    [self addSubview:self.accountLab];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@30);
    }];
    
    self.qieHuanBtn = [BGGView buttonWithFrame:CGRectZero title:@"切换账号" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(16) target:self sel:@selector(qiehuanBtn:) action:nil];
    [self addSubview:self.qieHuanBtn];
    self.qieHuanBtn.layer.cornerRadius = BGGCornerRadius;
    [self.qieHuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(BGGBigButtonHeight));
            make.width.equalTo(@100);
            make.right.equalTo(self.mas_right).offset(-15);
    }];
}
-(void)setAccount:(NSString *)account{
    _account = account;
    self.accountLab.text = [NSString stringWithFormat:@"%@ 欢迎回来",_account];
    [self.accountLab lc_setColor:BGGGrayColor text:_account];
    [self.accountLab lc_setColor:[UIColor grayColor] text:@"欢迎回来"];
}
-(void)qiehuanBtn:(BGGButton *)button{
    [[BGGAPI sharedAPIManeger] BGGDismiss];
    [[BGGAPI sharedAPIManeger] BGGSDKLogout];
    if (self.qieHuanBlock) {
        self.qieHuanBlock();
    }
}
@end
