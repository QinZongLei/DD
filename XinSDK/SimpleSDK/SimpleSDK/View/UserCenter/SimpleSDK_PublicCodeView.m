//
//  SimpleSDK_ PublicCodeView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_PublicCodeView.h"
#import "UIImageView+WebCache.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_PublicCodeView()
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UILabel *lb_prompt;
@property (nonatomic, strong) UIImageView *iv_codeBgImg;
@property (nonatomic, strong) UIImageView *iv_codeImg;
@property (nonatomic, strong) UILabel *lb_codeName;
@property (nonatomic, strong) UIButton *btn_copyImg;
@property (nonatomic, strong) NSString *codeNameStr ;
@property (nonatomic, strong) NSString *codeImgPathStr;
@end

@implementation SimpleSDK_PublicCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setPublicCodeView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}


-(void)func_setPublicCodeView{
    
    self.bgImgVStr = publicBgImgV;
    
    self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(450), kWidth(340));
    self.iv_viewBg.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    
    self.codeNameStr = [[SimpleSDK_DataTools manager].publicCodeInfo objectForKey:@"wx_public_name"];
    self.codeImgPathStr = [[SimpleSDK_DataTools manager].publicCodeInfo objectForKey:@"wx_public_url"];
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString *newsID = [NSString stringWithFormat:@"%@%@",self.codeNameStr,accountStr];
    [[NSUserDefaults standardUserDefaults] setObject:@"openPublicCode" forKey:newsID];
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_blackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_prompt = [[UILabel alloc] init];
        self.lb_prompt.text = @"关注官方公众号，领取福利礼包";
        self.lb_prompt.textColor = color_publicTopHex;
        self.lb_prompt.font = [UIFont systemFontOfSize:kWidth(16)];
        self.lb_prompt.textAlignment = NSTextAlignmentCenter;
        self.lb_prompt.frame = CGRectMake((self.iv_viewBg.width-kWidth(260))/2, self.iv_line.bottom + kWidth(25), kWidth(260), kWidth(20));

        self.lb_prompt;
    })];
    
    [self.iv_viewBg addSubview:({
        self.iv_codeBgImg = [[UIImageView alloc] init];
        self.iv_codeBgImg.frame = CGRectMake((self.iv_viewBg.width-kWidth(100))/2, self.lb_prompt.bottom+kWidth(10), kWidth(100), kWidth(100));

            self.iv_codeBgImg.image =kSetBundleImage(qrCodeImgBg);
   
        self.iv_codeBgImg;
    })];
    
    
    
    
    [self.iv_codeBgImg addSubview:({
        self.iv_codeImg = [[UIImageView alloc] init];
        self.iv_codeImg.frame = CGRectMake(kWidth(3), kWidth(3), kWidth(94), kWidth(94));

        if (kStringIsNull(self.codeImgPathStr)) {
            self.iv_codeImg.image =kSetBundleImage(@"");
        }else{
            [self.iv_codeImg sd_setImageWithURL:[NSURL URLWithString:self.codeImgPathStr]];
        }
        self.iv_codeImg;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.lb_codeName = [[UILabel alloc] init];
        if (kStringIsNull(self.codeNameStr)) {
            self.lb_codeName.text = @"公众号:";
        } else {
            self.lb_codeName.text = [NSString stringWithFormat:@"公众号: %@",self.codeNameStr] ;
        }
        self.lb_codeName.textAlignment = NSTextAlignmentCenter;
        self.lb_codeName.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_codeName.textColor = [UIColor ZNWinObj_colorWithHexString:@"#fff0ac"];
        self.lb_codeName.frame = CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_codeBgImg.bottom+kWidth(10), kWidth(300), kWidth(20));
        self.lb_codeName;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_copyImg = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btn_copyImg setBackgroundImage:kSetBundleImage(copyImg) forState:UIControlStateNormal];
        [self.btn_copyImg addTarget:self action:@selector(func_copyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_copyImg.frame = CGRectMake((self.iv_viewBg.width-kWidth(180))/2, self.lb_codeName.bottom+kWidth(5), kWidth(180), kWidth(45));
        self.btn_copyImg.tag = 20211202;

        self.btn_copyImg;
    })];
}


- (void)func_blackAction:(UIButton *)sender {
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_ViewManager func_showUserCenterView];
        [self removeFromSuperview];
    });
}

- (void)func_copyCodeAction:(UIButton *)sender {
        //拷贝
        [self func_copyCodeName];
}

-(void)func_copyCodeName{
    UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
    if (kStringIsNull(self.codeNameStr)) {
        [appPasteBoard setString:@"掌玩手游"];
    }else{
        [appPasteBoard setString:self.codeNameStr];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_Toast showToast:@"复制成功" location:@"center" showTime:2.5f];
    });
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setPublicCodeView];
}


@end
