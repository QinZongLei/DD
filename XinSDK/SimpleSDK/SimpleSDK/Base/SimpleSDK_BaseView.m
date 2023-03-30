//
//  SimpleSDK_BaseView.m
//  SimpleSDK
//
//  Created by mac on 2021/12/15.
//

#import "SimpleSDK_BaseView.h"
#import "SimpleSDK_Tools.h"

@implementation SimpleSDK_BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
        //所有界面设置暗黑模式
        if (@available(iOS 13.0, *)) {
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            } else {
                  
            }
        
        [self func_setBaseView];
    }
    return self;
}


-(void)func_setBaseView{
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.view.backgroundColor = [UIColor clearColor];
        self.view;
    })] ;
    
    [self.view addSubview:({
        self.iv_viewBg = [[UIImageView alloc] init];
        self.iv_viewBg.userInteractionEnabled = YES;
        self.iv_viewBg.frame = CGRectMake(0, 0, kWidth(450), kWidth(340));
        self.iv_viewBg.image = kSetBundleImage(dialogBg);
        self.iv_viewBg.center = self.view.center;
        self.iv_viewBg;
    })];
    

    [self.iv_viewBg addSubview:({
        self.lb_title = [[UILabel alloc] init];
        self.lb_title.frame = CGRectMake((self.iv_viewBg.width-kWidth(120))/2, kWidth(45), kWidth(120), kWidth(15));
        self.lb_title.textAlignment = NSTextAlignmentCenter;
        self.lb_title.textColor = color_title_tip;
        [self.lb_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        self.lb_title;
    })];
    
    [self.iv_viewBg addSubview:({
        self.iv_line = [[UIImageView alloc] init];
        self.iv_line.image = kSetBundleImage(lineImg);
        self.iv_line.frame = CGRectMake((self.iv_viewBg.width - (self.iv_viewBg.width-kWidth(100)))/2, self.lb_title.bottom+kWidth(5), self.iv_viewBg.width-kWidth(100), kWidth(2));
        self.iv_line;
    })];
    
}

- (void)setBgImgVStr:(NSString *)bgImgVStr
{
    
    _bgImgVStr = bgImgVStr;
   
    self.iv_viewBg.image = kSetBundleImage(bgImgVStr);
  
}


-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.lb_title.text = _titleStr;
}

#pragma mark ---- Notification ----
- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        if (self.center.y == kScreen_Height / 2) {
            self.center = CGPointMake(self.center.x, self.center.y - kWidth(80));
        }
    }];
}

- (void)keyBoardDidHideWithNotification:(NSNotification *)notification {
    //取出键盘弹出需要花费的时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
