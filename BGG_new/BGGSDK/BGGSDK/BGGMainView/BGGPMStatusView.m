//
//  BGGPMStatusView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/7/15.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGPMStatusView.h"
#import "BGGPCH.h"
#import "UILabel+LC.h"
#import "TYAttributedLabel.h"
#import "BGGWKWebview.h"
@interface BGGPMStatusView()<TYAttributedLabelDelegate>
@property(nonatomic,strong)BGGButton *cancelBtn;
@property(nonatomic,strong)BGGButton *comfirmBtn;
@property(nonatomic,strong)TYAttributedLabel *desLab1;
@property(nonatomic,strong)UILabel *desLab2;
@property(nonatomic,strong)NSDictionary *pmStatusDic;

@end
@implementation BGGPMStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.rightButton.hidden = YES;
           self.titView.hidden = YES;
           self.logoImageView.hidden = YES;
           [self createUI];
           self.pmStatusDic = @{@"1":@"未支付",@"2":@"支付中",@"3":@"第三方处理中",@"4":@"支付成功",@"5":@"到账成功",@"6":@"支付超时",@"7":@"支付失败",@"8":@"关闭支付"};
       }
       return self;
}

-(void)setPmType:(NSInteger)pmType{
    _pmType = pmType;
    
}

-(void)createUI{
    self.cancelBtn = [BGGView buttonWithFrame:CGRectZero title:@"取消支付" titleColor:Color_hex(@"#FFFFFF") selTitle:nil selTitlecColor:nil backColor:BGGLightGrayColor font:Font(20) target:self sel:@selector(cancelBtn:) action:nil];
    [self addSubview:self.cancelBtn];
    self.cancelBtn.layer.cornerRadius = BGGCornerRadius;
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];


    self.comfirmBtn = [BGGView buttonWithFrame:CGRectZero title:@"已支付完成" titleColor:Color_hex(@"#FFFFFF") selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(20) target:self sel:@selector(comfirmBtn:) action:nil];
    [self addSubview:self.comfirmBtn];
    self.comfirmBtn.layer.cornerRadius = BGGCornerRadius;
    [self.comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(BGGBigButtonHeight));
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-15);
    }];

    self.statuLab = [BGGView labelWithTextColor:BGGGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"支付状态：支付中" font:Font(18)];
    [self addSubview:self.statuLab];
    [self.statuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    self.orderNumLab = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"订单号:20210714569873612" font:Font(18)];
    [self addSubview:self.orderNumLab];
    [self.orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.height.equalTo(@20);
        make.top.equalTo(self.statuLab.mas_bottom).offset(10);
    }];
    
    
    self.desLab1 = [[TYAttributedLabel alloc]init];
    self.desLab1.textColor= BGGLightGrayColor;
    self.desLab1.delegate=self;
    self.desLab1.font = Font(16);
    self.desLab1.numberOfLines=0;
    [self addSubview:self.desLab1];
    [self.desLab1 appendText:@"1,如果您已支付成功,但是查询结果一直处于未成功状态,请长按订单号复制,然后点击"];
    
    [self.desLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@60);
        make.top.equalTo(self.orderNumLab.mas_bottom).offset(8);
    }];
   __block NSString *linkStr;
    [[BGGDataModel sharedInstance].floatWindowsVoList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if ([[dic objectForKey:@"type"] integerValue] == 4) {
            linkStr = [dic objectForKey:@"h5Url"];
        }
    }];
    [self.desLab1 appendLinkWithText:@"支付遇到问题" linkFont:Font(16) linkColor:BGGredColor underLineStyle:kCTUnderlineStyleSingle linkData:linkStr];
        
    [self.desLab1 appendText:@"联系客服"];
    
    [self.desLab1 setLinesSpacing:-4];

    
    self.desLab2 = [BGGView labelWithTextColor:BGGLightGrayColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:1 text:@"2,如您已完成付款,请点击[已完成付款]" font:Font(16)];
    [self addSubview:self.desLab2];
    [self.desLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@20);
        make.top.equalTo(self.desLab1.mas_bottom).offset(0);
    }];
    
    
}
-(void)cancelBtn:(BGGButton *)button{
    [self popView];
    [BGGAPI sharedAPIManeger].hideDragBtn = NO;
}
-(void)comfirmBtn:(BGGButton *)button{
    
    [self popView];
    [BGGAPI sharedAPIManeger].hideDragBtn = NO;
    return;
    
    
    if (_pmType == 1) {
        [BGGHTTPRequest BGGPM1WithRecordNUmber:[BGGDataModel sharedInstance].orderNumber successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
            if (returnCode == 0) {
                NSDictionary *dic = data;
                NSString *orderNumber = [dic objectForKey:@"payRecordNumber"];
                NSString *stuStr =  [self.pmStatusDic objectForKey:[[dic objectForKey:@"status"] stringValue]];
                self.statuLab.text = [NSString stringWithFormat:@"支付状态:%@",stuStr];
                self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",orderNumber];
            }else{
                [self popNotice:returnMsg];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }else{
        [BGGHTTPRequest BGGPM2WithRecordNUmber:[BGGDataModel sharedInstance].orderNumber successBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
            if (returnCode == 0) {
                NSDictionary *dic = data;
                NSString *orderNumber = [dic objectForKey:@"payRecordNumber"];
                NSString *stuStr =  [self.pmStatusDic objectForKey:[[dic objectForKey:@"status"] stringValue]];
                self.statuLab.text = [NSString stringWithFormat:@"支付状态:%@",stuStr];
                self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",orderNumber];
            }else{
                [self popNotice:returnMsg];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if (linkStr.length) {
            BGGWKWebview *weView = [[BGGWKWebview alloc]initWithFrame:KBGGRuleRect];
            weView.center = [self getPopControllerCenter];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [BGGDataModel sharedInstance].sdkUserToken;
            dict[@"appNumber"] = [BGGDataModel sharedInstance].appNumber;
            dict[@"teamCompanyNumber"] = [BGGDataModel sharedInstance].teamCompanyNumber;
            dict[@"channelNumber"] = [BGGDataModel sharedInstance].channelNumber;
            dict[@"number"] = [BGGDataModel sharedInstance].number;
            dict[@"deviceType"] = @"Ios";
            weView.paramDic = dict;
            weView.webUrl = linkStr;
            [self pushToView:weView currentView:self];
        }
        
        
       
    }
}

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageLongPressed:(id<TYTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point
{
    NSLog(@"textStorageLongPressed");
}
@end
