//
//  BGGPrivacyView.m
//  BGGSDK
//
//  Created by 李胜 on 2021/9/27.
//  Copyright © 2021 BGG. All rights reserved.
//

#import "BGGPrivacyView.h"
#import "BGGPCH.h"
#import "UILabel+LC.h"
#import "BGGWKWebview.h"
@interface BGGPrivacyView()
@property(nonatomic,strong)BGGButton *cancelButton;
@property(nonatomic,strong)BGGButton *QRButton;
@property(nonatomic,strong)BGGButton *privacyBtn;
@property(nonatomic,strong)UILabel *contentLabel;
@end


@implementation BGGPrivacyView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleString content:(NSString *)contentString{
    self = [super initWithFrame:frame];
       if (self) {
           self.leftButton.hidden = YES;
           self.rightButton.hidden = YES;
           self.titView.hidden = NO;
          // self.titlabel.text = @"用户协议及注册协议";
           self.logoImageView.hidden = YES;
           [self createUI];
//           [self requestData];
           self.titlabel.text = titleString;
           self.contentLabel.text = [self filterHTML:contentString];
           
           [self.contentLabel lc_setUnderLineColor:BGGredColor text:@"用户隐私协议"];
          
       }
       return self;
}


-(void)createUI{
    self.contentLabel = [BGGView labelWithTextColor:BGGBlackColor backColor:nil textAlignment:NSTextAlignmentLeft lineNumber:0 text:nil font:Font(14)];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@90);
        make.top.equalTo(self.titView.mas_bottom).offset(-10);
    }];
    
    self.privacyBtn = [BGGView buttonWithTarget:self sel:@selector(privacyBtn:) action:nil];
    [self addSubview:self.privacyBtn];
    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@90);
        make.top.equalTo(self.titView.mas_bottom).offset(-10);
    }];
    
   self.cancelButton =[BGGView buttonWithFrame:CGRectZero title:@"我在想想" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGLightGrayColor font:Font(16) target:self sel:@selector(cancelButton:) action:nil];
    [self addSubview:self.cancelButton];
    self.cancelButton.layer.cornerRadius = BGGCornerRadius;
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    self.QRButton =[BGGView buttonWithFrame:CGRectZero title:@"同意并进入" titleColor:BGGWhiteColor selTitle:nil selTitlecColor:nil backColor:BGGredColor font:Font(15) target:self sel:@selector(QRButton:) action:nil];
    [self addSubview:self.QRButton];
    self.QRButton.layer.cornerRadius = BGGCornerRadius;
    [self.QRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@125);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}

-(void)requestData{
    [BGGHTTPRequest BGGPrivacysuccessBlock:^(NSInteger returnCode, NSString *returnMsg, id data) {
        if(returnCode == 0){
            NSDictionary *dic = data;
            NSString *title = [dic objectForKey:@"title"];
            NSString *content = [dic objectForKey:@"content"];
            self.titlabel.text = title;
            self.contentLabel.text = [self filterHTML:content];
            
            [self.contentLabel lc_setUnderLineColor:BGGredColor text:@"用户隐私协议"];
    
            
        }else{
            [self popNotice:returnMsg];
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];

    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}
//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
-(void)cancelButton:(BGGButton *)button{
    exit(0);
}
-(void)QRButton:(BGGButton *)button{
    [self dismiss];
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}
-(void)privacyBtn:(BGGButton *)button{
    
    BGGWKWebview *weView = [[BGGWKWebview alloc] initWithFrame:KBGGRuleRect];
    weView.center = [self getPopControllerCenter];
    [self pushToView:weView currentView:self];
    weView.webUrl = [BGGDataModel sharedInstance].privacyUrl;
}
@end
