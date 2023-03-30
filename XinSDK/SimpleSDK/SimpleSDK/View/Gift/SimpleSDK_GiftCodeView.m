//
//  SimpleSDK_GiftCodeView.m
//  SimpleSDK
//
//  Created by admin on 2022/3/1.
//

#import "SimpleSDK_GiftCodeView.h"
#import "UIImageView+WebCache.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_GiftCodeView()

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIImageView *iv_doce;

@end

@implementation SimpleSDK_GiftCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self  func_setGiftCodeView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setGiftCodeView{
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
//        self.view.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.view;
    })];
    
    [self.view addSubview:({
        self.iv_doce = [[UIImageView alloc] init];
        self.iv_doce.userInteractionEnabled = YES;
        self.iv_doce.frame = CGRectMake(0, 0, kWidth(320), kWidth(340));
        self.iv_doce.center = self.view.center;
        NSString * commentImgVStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].reviewInfo objectForKey:@"code_img"] ];
        if (!kStringIsNull(commentImgVStr)) {
            [self.iv_doce sd_setImageWithURL:[NSURL URLWithString:commentImgVStr]];
        }
        self.iv_doce;
    })];
    
    UITapGestureRecognizer *imageTapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func_ImageTapAction:)];
    [self.iv_doce addGestureRecognizer:imageTapAction];
}


- (void)func_ImageTapAction:(UITapGestureRecognizer*)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"HidenGiftCodeFloat" forKey:kFlagHidenGiftCodeFloat];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString * codeStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].reviewInfo objectForKey:@"code"]];
    UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
    [appPasteBoard setString:codeStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SimpleSDK_Toast showToast:@"复制成功" location:@"center" showTime:2.5f];
    });
   
    [self removeFromSuperview];
    
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setGiftCodeView];
}
@end
