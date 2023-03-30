//
//  SimpleSDK_MsgDetailsView.m
//  SimpleSDK
//
//  Created by admin on 2021/12/30.
//

#import "SimpleSDK_MsgDetailsView.h"
#import "UIImageView+WebCache.h"

@interface SimpleSDK_MsgDetailsView()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UILabel *lb_msgTitle;
@property (nonatomic, strong) UITextView *tv_content;
@property (nonatomic, strong) UIImageView *iv_publicCode;
@end

@implementation SimpleSDK_MsgDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setMsgDetailsView];
    }
    return self;
}

-(void)func_addNotification{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setMsgDetailsView{
   
    self.bgImgVStr = noticeDetailBgImgV;
    
    self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(450), kWidth(340));
    self.iv_viewBg.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.lb_title= [[UILabel alloc] init];
        self.lb_title.font = [UIFont systemFontOfSize: kWidth(16)];
        self.lb_title.textColor = [UIColor redColor];
        self.lb_title.frame =  CGRectMake(kWidth(55),self.iv_line.bottom+kWidth(30),self.iv_viewBg.width - kWidth(90), kWidth(20));

        self.lb_title;
    })];
    
    [self.iv_viewBg addSubview:({
        self.tv_content= [[UITextView alloc] init];
        self.tv_content.font = [UIFont systemFontOfSize: kWidth(16)];
        self.tv_content.textColor = color_msgContentHex;
        self.tv_content.backgroundColor = [UIColor clearColor];
        self.tv_content.delegate = self;
        self.tv_content.editable = YES;
        self.tv_content.frame = CGRectMake(kWidth(50), self.lb_title.bottom+kWidth(5), self.iv_viewBg.width - kWidth(115), kWidth(115));

        self.tv_content;
    })];
    
  
    [self.iv_viewBg addSubview:({
        self.iv_publicCode = [[UIImageView alloc] init];
        self.iv_publicCode.backgroundColor = [UIColor clearColor];
        self.iv_publicCode.frame =  CGRectMake((self.iv_viewBg.width-kWidth(80))/2, self.tv_content.bottom+kWidth(5), kWidth(80), kWidth(80));

        self.iv_publicCode;
    })];
    
}

- (void)func_clickAction:(UIButton *)sender {
        //返回
        dispatch_async(dispatch_get_main_queue(), ^{
            [SimpleSDK_ViewManager func_showMsgListView];
            [self removeFromSuperview];
        });
}


- (void)setDetailedDict:(NSMutableDictionary *)detailedDict{
    _detailedDict = detailedDict;
    NSString *title = [_detailedDict objectForKey:@"title"];
    NSString *content = [_detailedDict objectForKey:@"content"];
    NSString *codeUrl = [_detailedDict objectForKey:@"wx_public_url"];
    if (!kStringIsNull(title)) {
        self.lb_title.text = [NSString stringWithFormat:@"%@",title];
    }
    if (!kStringIsNull(content)) {
        self.tv_content.text = [NSString stringWithFormat:@"%@",content];
       
    }
    if (!kStringIsNull(codeUrl)) {
        [self.iv_publicCode sd_setImageWithURL:[NSURL URLWithString:codeUrl]];
        self.iv_publicCode.backgroundColor = [UIColor clearColor];
    }else{
        self.tv_content.frame = CGRectMake(kWidth(50), self.lb_title.bottom+kWidth(5), self.iv_viewBg.width - kWidth(100), kWidth(185));;

        self.iv_publicCode.frame = CGRectMake((self.iv_viewBg.width-kWidth(100))/2, self.tv_content.bottom + kWidth(5), kWidth(5), kWidth(5));
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
     return NO;
}
#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setMsgDetailsView];
}


@end
