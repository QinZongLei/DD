//
//  BGGUpdateNoticeView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/7/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGUpdateNoticeView.h"
#import "BGGPCH.h"

@interface BGGUpdateNoticeView ()
@property(nonatomic,strong)UILabel *versionLab;
@property(nonatomic,strong)UILabel *sizeLab;
@property(nonatomic,strong)UILabel *updateInfoLab;
@property(nonatomic,strong)BGGButton *updateBtn;

@end
@implementation BGGUpdateNoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.rightButton.hidden = NO;
           self.titView.hidden = NO;
           self.titlabel.text = @"更新提示";
           self.logoImageView.hidden = YES;
           [self createUI];
           
          
       }
       return self;
}
-(void)createUI{
    self.versionLab = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"最新版本:1.9.6" font:Font(16)];
    [self addSubview:self.versionLab];
    [self.versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(20);
            make.top.equalTo(self.titView.mas_bottom).offset(15);
    }];
    
    self.sizeLab = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"游戏大小:284.0MB" font:Font(16)];
    [self addSubview:self.sizeLab];
    [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(20);
            make.top.equalTo(self.versionLab.mas_bottom).offset(15);
    }];
    
    self.updateInfoLab = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"更新信息:更新可体验双人模式" font:Font(16)];
    [self addSubview:self.updateInfoLab];
    [self.updateInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(20);
            make.top.equalTo(self.sizeLab.mas_bottom).offset(15);
    }];
    
    
    self.updateBtn = [BGGView buttonWithFrame:CGRectZero title:@"更新" titleColor:Color_hex(@"#FFFFFF") selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(20) target:self sel:@selector(updateBtn:) action:nil];
    [self addSubview:self.updateBtn];
    self.updateBtn.layer.cornerRadius = BGGCornerRadius;
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@(BGGBigButtonHeight));
            make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    

}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.versionLab.text = [NSString stringWithFormat:@"最新版本:%@",dic[@"versionName"]];
    self.sizeLab.text = [NSString stringWithFormat:@"游戏大小:%@",[dic[@"size"] stringValue]];
    self.updateInfoLab.text = dic[@"versionDesc"];
    
    
}
#pragma mark - 跳转到appstore更新
-(void)updateBtn:(BGGButton *)button{
    //去appstore更新
    NSURL*url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dic[@"downloadUrl"]]];
    [[UIApplication sharedApplication]openURL:url];
   if ([BGGDataModel sharedInstance].viewArray.count == 1) {
        [self dismiss];
        return;
    }
    [self popView];
    
}
-(void)rightbuttonClick:(UIButton *)sender{
        if (self.rightBtnClickBlock) {
            self.rightBtnClickBlock(self, sender);
        }
        if ([BGGDataModel sharedInstance].viewArray.count == 1) {
            [self dismiss];
            return;
        }
        [self popView];
    }

@end
