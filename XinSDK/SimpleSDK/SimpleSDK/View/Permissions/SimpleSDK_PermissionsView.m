//
//  SimpleSDK_PermissionsView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import "SimpleSDK_PermissionsView.h"
#import "SImpleSDK_ViewManager.h"


@interface SimpleSDK_PermissionsView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *iv_viewBg;
@property (nonatomic, strong) UILabel * lb_title;
@property (nonatomic, strong) UITextView *tv_content;
@property (nonatomic, strong) UILabel *lb_agree;
@property (nonatomic, strong) UILabel *lb_idfa;
@property (nonatomic, strong) UIButton *btn_agree;
@property (nonatomic, strong) UIButton *btn_agreeNot;


@end


@implementation SimpleSDK_PermissionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setPermissionsView];
    }
    return self;
}

//添加通知，横竖屏幕切换刷新界面
-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
//创建View
-(void)func_setPermissionsView{
   
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
        self.view.frame =  self.bounds;
        self.view.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.9];
        self.view;
    })];
    
    [self.view addSubview:({
        self.iv_viewBg = [[UIImageView alloc] init];
        self.iv_viewBg.userInteractionEnabled = YES;
        self.iv_viewBg.layer.cornerRadius = kWidth(5);
        self.iv_viewBg.clipsToBounds =YES;
        self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(320), kWidth(300));
        self.iv_viewBg.center = self.view.center;
        self.iv_viewBg.backgroundColor = [UIColor whiteColor];
        self.iv_viewBg;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_title = [[UILabel alloc] init];
        self.lb_title .text = @"个人信息保护提示";
        self.lb_title.frame = CGRectMake((self.iv_viewBg.width-kWidth(200))/2, kWidth(20), kWidth(200), kWidth(20));
        self.lb_title.textColor = RGBHEX(0x000000);
        self.lb_title.textAlignment =NSTextAlignmentCenter;
        self.lb_title.font = [UIFont boldSystemFontOfSize:kWidth(18)];
        self.lb_title;
    })];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle setLineSpacing:7];
    NSString *userTip = @"我们非常重视您的个人信息和隐私保护，为了保障您的个人权益，在使用前，请务必阅读《用户协议》和《隐私政策》";
   NSMutableAttributedString *linkStr = [[NSMutableAttributedString alloc] initWithString:userTip];
    //绑定标签跳转
        [linkStr addAttribute:NSLinkAttributeName
                      value:@"protocol://"
                      range:[[linkStr string] rangeOfString:@"《用户协议》"]];
    [linkStr addAttribute:NSLinkAttributeName
                  value:@"protocolPrivacy://"
                  range:[[linkStr string] rangeOfString:@"《隐私政策》"]];
    
    [self.iv_viewBg addSubview:({
        self.tv_content = [[UITextView alloc ] init];
        self.tv_content.delegate = self;
        self.tv_content.editable = NO;
        self.tv_content.scrollEnabled=NO;
        self.tv_content.attributedText = linkStr;
        self.tv_content.backgroundColor = [UIColor whiteColor];
        self.tv_content.linkTextAttributes = @{NSForegroundColorAttributeName: RGBHEX(0x000000)};
        self.tv_content.font = [UIFont systemFontOfSize:kWidth(15)];
        self.tv_content.frame = CGRectMake(kWidth(15), self.lb_title.bottom+kWidth(10), self.iv_viewBg.width-kWidth(20), kWidth(75));
        self.tv_content;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.lb_idfa = [[UILabel alloc] init];
        self.lb_idfa.text = @"IDFA: 设配标识，用于提供个性化服务，减少无关内容推荐";
        self.lb_idfa.textColor = [UIColor lightGrayColor];
        self.lb_idfa.numberOfLines = 0;
        self.lb_idfa.font = [UIFont systemFontOfSize:kWidth(14)];
        self.lb_idfa.frame = CGRectMake(self.tv_content.left, self.tv_content.bottom+kWidth(5), self.tv_content.width, kWidth(40));
        self.lb_idfa;
    })];
    
    
    [self.iv_viewBg addSubview:({
        self.lb_agree = [[UILabel alloc] init];
        self.lb_agree.text = @"如果您同意此协议，请点击”同意“按钮";
        self.lb_agree.font = [UIFont systemFontOfSize:kWidth(15)];
        self.lb_agree.frame = CGRectMake(self.tv_content.left, self.lb_idfa.bottom+kWidth(5), self.tv_content.width, kWidth(20));
        self.lb_agree;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_agree = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_agree.titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        self.btn_agree.layer.cornerRadius = kWidth(20);
        self.btn_agree.frame = CGRectMake(self.tv_content.left, self.lb_agree.bottom+kWidth(10), self.iv_viewBg.width-kWidth(30), kWidth(40));
        self.btn_agree.clipsToBounds = YES;
        self.btn_agree.tag = 202111;
        [self.btn_agree setTitle:@"同意" forState:UIControlStateNormal];
        [self.btn_agree setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:64.0/255.0 alpha:1.0f]];
        [self.btn_agree setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_agree addTarget:self action:@selector(func_agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_agree;
    })];
    
    [self.iv_viewBg addSubview:({
        self.btn_agreeNot = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_agreeNot.titleLabel.font = [UIFont systemFontOfSize:kWidth(15)];
        self.btn_agreeNot.layer.cornerRadius = kWidth(20);
        self.btn_agreeNot.clipsToBounds = YES;
        self.btn_agreeNot.frame = CGRectMake((self.iv_viewBg.width-kWidth(80))/2, self.btn_agree.bottom+kWidth(10), kWidth(80), kWidth(30));
        self.btn_agreeNot.tag = 202112;
        [self.btn_agreeNot setBackgroundColor:[UIColor clearColor]];
        [self.btn_agreeNot setTitle:@"不同意" forState:UIControlStateNormal];
        [self.btn_agreeNot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btn_agreeNot addTarget:self action:@selector(func_noAgreeAction:) forControlEvents:UIControlEventTouchUpInside];
    
        self.btn_agreeNot;
    })];
    
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return  YES;
}


- (void)func_agreeAction:(UIButton *)sender {
    //同意
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *wayforFirstLogin = [NSUserDefaults standardUserDefaults];
        [wayforFirstLogin setValue:@"firstLogin" forKey:@"firstLaunch"];
        [self removeFromSuperview];
    });
}

- (void)func_noAgreeAction:(UIButton *)sender {
        //不同意
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [SimpleSDK_ViewManager func_showPermissionsConfirmView];
        });
       
}


#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setPermissionsView];
}


@end
