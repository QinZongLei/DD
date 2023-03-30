//
//  BGGShowAccountView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/6/3.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGShowAccountView.h"
#import "BGGPCH.h"
@interface BGGShowAccountView()
@property(nonatomic,strong)UILabel *noticeLabel;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)UILabel *mobileLabel;
@property(nonatomic,strong)BGGButton *queDingButton;
@end
@implementation BGGShowAccountView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.titView.hidden = NO;
           self.logoImageView.hidden = YES;
           self.titlabel.text =@"提示";
           [self createUI];
       }
       return self;
}


-(void)createUI{
    self.backgroundColor = BGGWhiteColor;
    NSString *str = @"手机号注册成功,以下为您的账号信息,应用会自动截图保存到相册,为了避免自动保存失败,建议您手动截图保存一份";
    self.noticeLabel = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:0 text:str font:Font(14)];
    [self addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.titView.mas_bottom).offset(-3);
            make.height.equalTo(@65);
    }];
    
    self.accountLabel = [BGGView labelWithTextColor:BGGredColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:[BGGDataModel sharedInstance].userName font:Font(16)];
    [self addSubview:self.accountLabel];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.height.equalTo(@20);
            make.top.equalTo(self.noticeLabel.mas_bottom).offset(6);
    }];
    
    self.passwordLabel = [BGGView labelWithTextColor:BGGredColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:[BGGDataModel sharedInstance].passWord font:Font(16)];
    [self addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.height.equalTo(@20);
            make.top.equalTo(self.accountLabel.mas_bottom).offset(6);
    }];
    
    self.mobileLabel = [BGGView labelWithTextColor:BGGredColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:[BGGDataModel sharedInstance].mobile font:Font(16)];
    [self addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.height.equalTo(@20);
            make.top.equalTo(self.passwordLabel.mas_bottom).offset(6);
    }];
    
    self.queDingButton = [BGGView buttonWithFrame:CGRectZero title:@"确定" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(15) target:self sel:@selector(queDingButton:) action:nil];
    [self addSubview:self.queDingButton];
    [self.queDingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@(BGGBigButtonHeight));
            make.top.equalTo(self.mobileLabel.mas_bottom).offset(15);
    }];
    self.queDingButton.layer.cornerRadius = BGGCornerRadius;
    
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",[BGGDataModel sharedInstance].userName];
    self.passwordLabel.text = [NSString stringWithFormat: @"密码：%@",[BGGDataModel sharedInstance].passWord];
    self.mobileLabel.text = [NSString stringWithFormat: @"手机号：%@",[BGGDataModel sharedInstance].mobile];
    [[BGGDataModel sharedInstance] insertDataWithAccount:[BGGDataModel sharedInstance].mobile andPassword:[BGGDataModel sharedInstance].passWord];
}


-(void)queDingButton:(BGGButton *)button{
    [self loadImageFinished:[self captureImageFromView:self]];
    [self dismiss];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}


//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{

    UIGraphicsBeginImageContextWithOptions(self.frame.size,YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}
@end
