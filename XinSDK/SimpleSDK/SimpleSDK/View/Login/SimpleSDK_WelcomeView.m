//
//  SimpleSDK_WelcomeView.m
//  SimpleSDK
//
//  Created by admin on 2022/1/21.
//

#import "SimpleSDK_WelcomeView.h"
#import "SimpleSDK_DataTools.h"

#define kHidenWelcomeView @"HIDENWELCOMEVIEW"
@interface SimpleSDK_WelcomeView()
@property (nonatomic, strong) UIImageView *weclomeBg;
@property (nonatomic, strong) UIImageView *iv_weclomeIcon;
@property (nonatomic, strong) UILabel *lb_weclomeName;
@property (nonatomic, strong) UILabel *lb_weclomeTip;

@end

@implementation SimpleSDK_WelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self func_setWelcomeView];
        [self func_startHiden];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setWelcomeView{
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
  
    NSString *welcomeTip = [NSString stringWithFormat:@"亲爱的 %@", accountStr];
    NSRange accountRange = [welcomeTip rangeOfString:accountStr];
  
    
    
    self.frame = CGRectMake((SCREENWIDTH - kWidth(320)) / 2, kWidth(60) , kWidth(320), kWidth(100));
    
    
    [self addSubview:({
        self.weclomeBg = [[UIImageView alloc] initWithImage:kSetBundleImage(dialogBg)];
        self.weclomeBg.frame= CGRectMake(0, 0, kWidth(320), kWidth(100));
        self.weclomeBg;
    })];
    
    [self addSubview:({
        self.iv_weclomeIcon = [[UIImageView alloc] initWithImage:kSetBundleImage(accountLoginBtn)];
        self.iv_weclomeIcon.frame = CGRectMake(kWidth(70), kWidth(25), kWidth(50), kWidth(50));
        self.iv_weclomeIcon;
    })];
    
    [self addSubview:({
        self.lb_weclomeName = [[UILabel alloc] init];
        self.lb_weclomeName.textColor = color_welcomeNormalHex;
        NSMutableAttributedString *yiLeObj_tncString = [[NSMutableAttributedString alloc] initWithString:welcomeTip];
        [yiLeObj_tncString addAttribute:NSForegroundColorAttributeName value:color_welcomeAccountHex range:accountRange];
        self.lb_weclomeName.attributedText = yiLeObj_tncString;
        self.lb_weclomeName.font = [UIFont systemFontOfSize:kWidth(14)];
        self.lb_weclomeName.frame = CGRectMake(self.iv_weclomeIcon.right + kWidth(5), kWidth(30), kWidth(194), kWidth(20));
        self.lb_weclomeName;
    })];
    
    [self addSubview:({
        self.lb_weclomeTip = [[UILabel alloc] init];
        self.lb_weclomeTip.text = @"欢迎进入游戏!";
        self.lb_weclomeTip.textColor = color_welcomeNormalHex;
        self.lb_weclomeTip.textAlignment = NSTextAlignmentCenter;
        self.lb_weclomeTip.font = [UIFont systemFontOfSize:kWidth(12)];
        self.lb_weclomeTip.frame = CGRectMake(self.iv_weclomeIcon.right + kWidth(5), self.lb_weclomeName.bottom+kWidth(5), kWidth(100), kWidth(20));
        self.lb_weclomeTip;
    })];
}

- (void)func_startHiden {
    [self performSelector:@selector(func_hiddenWelcomeView) withObject:kHidenWelcomeView afterDelay:3.0];
}

- (void)func_hiddenWelcomeView {
    [self removeFromSuperview];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setWelcomeView];
}
@end
