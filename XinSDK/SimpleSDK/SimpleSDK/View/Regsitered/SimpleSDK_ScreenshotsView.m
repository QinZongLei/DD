//
//  SimpleSDK_ScreenshotsView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/20.
//

#import "SimpleSDK_ScreenshotsView.h"
#import "SimpleSDK_DataTools.h"
#import "SimpleSDK_ApiManager.h"

@interface SimpleSDK_ScreenshotsView ()
@property(nonatomic,  copy) NSString *accountStr;
@property(nonatomic,  copy) NSString *passwordStr;
@property (nonatomic, strong) UIButton *btn_back;
@property (nonatomic, strong) UIImageView *iv_headImage;
@property (nonatomic, strong) UILabel *lb_account;
@property (nonatomic, strong) UILabel *lb_pwd;
@property (nonatomic, strong) UILabel *lb_savePrompt;
@property (nonatomic, strong) UILabel *lb_saveWarning;
@property (nonatomic, strong) UILabel *lb_closeTime;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation SimpleSDK_ScreenshotsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setScreenshotsView];
        
        UIImage *ivSave = [self func_snapshot:self.view];
        UIImageWriteToSavedPhotosAlbum(ivSave, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setScreenshotsView{
    self.titleStr = @"注册成功";
    self.lb_title.frame = CGRectMake((self.iv_viewBg.width-kWidth(120))/2, kWidth(75), kWidth(120), kWidth(30));
    NSDictionary *userAccount = [[SimpleSDK_DataTools func_getAllAccount] lastObject];
    if (kDictNotNull(userAccount)) {
        self.accountStr = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"account"]];
        self.passwordStr  = [NSString stringWithFormat:@"%@",[userAccount valueForKey:@"password"]];
    }
    
    [self.iv_viewBg addSubview:({
        self.btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_back.frame = CGRectMake(self.iv_viewBg.width - kWidth(40), kWidth(35), kWidth(30), kWidth(30));
        self.btn_back.tag = 20211201;
        [self.btn_back setImage:kSetBundleImage(backBtn) forState:UIControlStateNormal];
        [self.btn_back addTarget:self action:@selector(func_clickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_back;
    })];
    
    [self.iv_viewBg addSubview:({
        self.iv_headImage = [[UIImageView alloc] init];
        self.iv_headImage.frame = CGRectMake((self.iv_viewBg.width-kWidth(53))/2, self.lb_title.bottom+ kWidth(10), kWidth(53), kWidth(53));
        self.iv_headImage.image = kSetBundleImage(userIcon);
        self.iv_headImage;
    })];
    
    NSString *accountTip = [NSString stringWithFormat:@"账号: %@", self.accountStr];
    NSMutableAttributedString *accountColorArray = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"账号: %@", self.accountStr]];
    NSString *tip = [NSString stringWithFormat:@"%@",[accountTip substringToIndex:3]];
    NSRange tipColor = [[accountColorArray string] rangeOfString:tip];
    [accountColorArray addAttribute:NSForegroundColorAttributeName value:color_agreement range:tipColor];
    NSString *account = [NSString stringWithFormat:@"%@",[accountTip substringFromIndex:3]];
    NSRange accountColor = [[accountColorArray string] rangeOfString:account];
    [accountColorArray addAttribute:NSForegroundColorAttributeName value:color_agreement  range:accountColor];
    
    [self.iv_viewBg addSubview:({
        self.lb_account = [[UILabel alloc] init];
        self.lb_account.textAlignment = NSTextAlignmentCenter;
        self.lb_account.frame = CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.iv_headImage.bottom + kWidth(10), kWidth(300), kWidth(20));
        [self.lb_account setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
       self.lb_account.attributedText = accountColorArray;
        self.lb_account;
    })];
    
    NSString *pwdTip = [NSString stringWithFormat:@"密码: %@", self.passwordStr];
    NSMutableAttributedString *pwdColorArray = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"密码: %@", self.passwordStr]];
    NSString *tipPwd = [NSString stringWithFormat:@"%@",[pwdTip substringToIndex:3]];
    NSRange tipPwdColor = [[pwdColorArray string] rangeOfString:tipPwd];
    [pwdColorArray addAttribute:NSForegroundColorAttributeName value:color_agreement range:tipPwdColor];
    NSString *pwd = [NSString stringWithFormat:@"%@",[pwdTip substringFromIndex:3]];
    NSRange pwdColor = [[pwdColorArray string] rangeOfString:pwd];
    [pwdColorArray addAttribute:NSForegroundColorAttributeName value:color_agreement  range:pwdColor];
    
    [self.iv_viewBg addSubview:({
        self.lb_pwd = [[UILabel alloc] init];
        self.lb_pwd.frame = CGRectMake(self.lb_account.left, self.lb_account.bottom+kWidth(5), self.lb_account.width,self.lb_account.height);
        self.lb_pwd.textAlignment = NSTextAlignmentCenter;
        [self.lb_pwd setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
       self.lb_pwd.attributedText = pwdColorArray;
        self.lb_pwd;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_savePrompt = [[UILabel alloc] init];
        self.lb_savePrompt.frame = CGRectMake((self.iv_viewBg.width-kWidth(240))/2, self.lb_pwd.bottom+kWidth(10), kWidth(240), kWidth(20));
        self.lb_savePrompt.textAlignment = NSTextAlignmentCenter;
    
        self.lb_savePrompt.text = @"*账号密码已经截图保存手机相册";
        self.lb_savePrompt.font = [UIFont systemFontOfSize:kWidth(13)];
        self.lb_savePrompt.textColor = color_agreement;
        self.lb_savePrompt;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_saveWarning = [[UILabel alloc] init];
        self.lb_saveWarning.frame = CGRectMake((self.iv_viewBg.width-kWidth(300))/2, self.lb_savePrompt.bottom, kWidth(300), kWidth(20));
        self.lb_saveWarning.textAlignment = NSTextAlignmentCenter;
        self.lb_saveWarning.text = @"请妥善保存好自己的账号密码,勿与他人分享*";
  
        self.lb_saveWarning.textColor = color_agreement;
        self.lb_saveWarning.font = [UIFont systemFontOfSize:kWidth(13)];
        self.lb_saveWarning;
    })];
    
    [self.iv_viewBg addSubview:({
        self.lb_closeTime = [[UILabel alloc] init];
        self.lb_closeTime.textColor = color_findPwd;
        self.lb_closeTime.font = [UIFont systemFontOfSize:kWidth(13)];
        self.lb_closeTime.frame = CGRectMake((self.iv_viewBg.width-kWidth(120))/2, self.lb_saveWarning.bottom+kWidth(5), kWidth(120), kWidth(20));
        self.lb_closeTime;
    })];
    [self func_getTime];
    
}

- (UIImage *)func_snapshot:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)func_clickAction:(UIButton *)sender {
    
    if (self.timer) {
        
        dispatch_source_cancel(self.timer);
    }
    [SimpleSDK_ApiManager func_accountLogin:self.accountStr passwordStr:self.passwordStr FuncBlock:^(BOOL status){
        if (status) {
            //登陆成功直接关闭当前界面
            [self removeFromSuperview];
        }
    }];
    [self removeFromSuperview];
}

-(void)func_getTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        __block NSInteger timeLine = 5;
        __block NSInteger timeOut = timeLine;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行一次
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            //倒计时结束，关闭
            if (timeOut <= 0) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeFromSuperview];
                    [SimpleSDK_ApiManager func_accountLogin:self.accountStr passwordStr:self.passwordStr FuncBlock:^(BOOL status){
                        if (status) {
                            //登陆成功直接关闭当前界面
                            [self removeFromSuperview];
                            }
                        }];
                    });
            } else {
                int allTime = (int)timeLine + 1;
                int seconds = timeOut % allTime;
                NSString *timeStr = [NSString stringWithFormat:@"%0.2ds", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.lb_closeTime.text = [NSString stringWithFormat:@"%@秒后自动关闭",timeStr];
                });
                timeOut--;
            }
        });
        dispatch_resume(_timer);
        self.timer = _timer;
    });
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"保存失败";
    if (!error) {
        message = @"成功保存到相册";
    }
    [SimpleSDK_Toast showToast:message location:@"center" showTime:1.5f];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setScreenshotsView];
}

@end
