//
//  BGGSMRZView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/5/26.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGSMRZView.h"
#import "BGGPCH.h"
@interface BGGSMRZView()
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *IDCardTextField;
@property(nonatomic,strong)BGGButton *queRenButton;
@property(nonatomic,strong)UILabel  *authNoticeLab;
@end

@implementation BGGSMRZView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           if ([BGGDataModel sharedInstance].forceRealName) {
               self.rightButton.hidden = YES;
           }else{
               self.rightButton.hidden = NO;
           }
           self.titView.hidden = NO;
           self.titlabel.text = @"实名认证";
           self.logoImageView.hidden = YES;
           [self createUI];
          
       }
       return self;
}


-(void)createUI{
    
    [BGGDataModel sharedInstance].isShowingRealName = true;
//    [self noOtherTouch];
    
    NSString *str = @"根据国家相关规定，网络游戏用户需进行实名认证，请先进行实名认证后再进入游戏！实名信息仅用于认证且绝对保密！\n\n实名信息提交后不可修改，请谨慎填写！";
    self.authNoticeLab = [BGGView labelWithTextColor:[UIColor blackColor] backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:0 text:str font:Font(13)];
    [self addSubview:self.authNoticeLab];
    [self.authNoticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.nameTextField = [[UITextField alloc] init];
//    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    self.nameTextField.layer.cornerRadius = 4;
    self.nameTextField.layer.masksToBounds = YES;
    self.nameTextField.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.nameTextField.layer.borderWidth = 1;
    self.nameTextField.textAlignment = NSTextAlignmentLeft;
    self.nameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入真实姓名" attributes:@{NSForegroundColorAttributeName: Color_hex(@"#767676")}];
    self.nameTextField.font =[UIFont systemFontOfSize:14];
    //self.phoneTextF.delegate = self;
    self.nameTextField.textColor = Color_hex(@"#333333");
    self.nameTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(155);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.IDCardTextField = [[UITextField alloc] init];
//    self.IDCardTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.IDCardTextField.backgroundColor = [UIColor whiteColor];
    self.IDCardTextField.layer.cornerRadius = 4;
    self.IDCardTextField.layer.masksToBounds = YES;
    self.IDCardTextField.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.IDCardTextField.layer.borderWidth = 1;
    self.IDCardTextField.textAlignment = NSTextAlignmentLeft;
    self.IDCardTextField.keyboardType = UIKeyboardTypeDefault;
    self.IDCardTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入真实身份证号码" attributes:@{NSForegroundColorAttributeName: Color_hex(@"#767676")}];
    self.IDCardTextField.font =[UIFont systemFontOfSize:14];
    //self.phoneTextF.delegate = self;
    self.IDCardTextField.textColor = Color_hex(@"#333333");
    self.IDCardTextField.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.IDCardTextField];
    [self.IDCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(15);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.queRenButton = [BGGView buttonWithFrame:CGRectZero title:@"确认" titleColor:Color_hex(@"#ffffff") selTitle:nil selTitlecColor:nil backColor:Color_hex(@"#fb4f4f") font:Font(20) target:self sel:@selector(queRenButton:) action:nil];
    self.queRenButton.layer.cornerRadius = BGGCornerRadius;
    [self addSubview:self.queRenButton];
    [self.queRenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.IDCardTextField.mas_bottom).offset(15);
    }];
    
    self.rightBtnClickBlock = ^(BGGMainBaseView * _Nonnull keyboardView, UIButton * _Nonnull button) {
        [[BGGDataModel sharedInstance] showPoviewAfterLogin];
    };
}


-(void)queRenButton:(BGGButton *)button{
    if (!self.nameTextField.text.length) {
        [self popNotice:@"请输入姓名"];
        return;
    }
    if (!self.IDCardTextField.text.length) {
        [self popNotice:@"请输入身份证号"];
        return;
    }
    [BGGHTTPRequest BGGrealNameAuthWithName:self.nameTextField.text IDCard:self.IDCardTextField.text SsuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if (returnCode == 0) {
            [self dismiss];
            [BGGDataModel sharedInstance].isShowingRealName = false;
            [[BGGDataModel sharedInstance] showPoviewAfterLogin];
        }else{
            [self popNotice:returnMsg];
        }
      
    } failBlock:^(NSError *error) {
        
    }];

}


/**
 防止其他点事件覆盖
 */
-(void)noOtherTouch{
    
   UIViewController * con =  [[self class] findBelongViewControllerForView:self];
    
    if ([con isKindOfClass:NSClassFromString(@"SYPopupController")]) {
        SYPopupController *paCon = con;
        paCon.dismissOnMaskTouched = true;
    }
    
}


+ (nullable UIViewController *)findBelongViewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)responder;
        }
    return nil;
}


@end
