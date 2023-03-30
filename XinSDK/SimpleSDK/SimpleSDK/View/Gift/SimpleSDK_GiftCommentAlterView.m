//
//  SimpleSDK_GiftCommentAlterView.m
//  SimpleSDK
//
//  Created by admin on 2022/3/1.
//

#import "SimpleSDK_GiftCommentAlterView.h"
#import "SimpleSDK_DataTools.h"
#import "UIImageView+WebCache.h"


@interface SimpleSDK_GiftCommentAlterView()

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIImageView *iv_comment;

@property (nonatomic, strong) UIButton *btn_close;

@end

@implementation SimpleSDK_GiftCommentAlterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  func_addNotification];
        [self func_setGiftCommentAlterView];
    }
    return self;
}

-(void)func_addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setGiftCommentAlterView{
    
    [self addSubview:({
        self.view = [[UIView alloc] init];
        self.view.layer.masksToBounds = YES;
//        self.view.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.view;
    })];
    

    
    [self.view addSubview:({
        self.iv_comment = [[UIImageView alloc] init];
        self.iv_comment.userInteractionEnabled = YES;
        self.iv_comment.frame = CGRectMake(0, 0, kWidth(320), kWidth(340));
        self.iv_comment.center = self.view.center;
        NSString * commentImgVStr = [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].reviewInfo objectForKey:@"comment_img"] ];
        if (!kStringIsNull(commentImgVStr)) {
            [self.iv_comment sd_setImageWithURL:[NSURL URLWithString:commentImgVStr]];
        }
        self.iv_comment;
    })];
    
    [self addSubview:({
        self.btn_close = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn_close.backgroundColor = [UIColor clearColor];
//        [self.btn_close setBackgroundImage:kSetBundleImage(close) forState:UIControlStateNormal];
        self.btn_close.frame = CGRectMake(self.iv_comment.right-kWidth(25), self.iv_comment.top, kWidth(25), kWidth(25));
        [self.btn_close addTarget:self action:@selector(func_clossClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_close;
    })];
    
    UITapGestureRecognizer *imageTapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func_ImageTapAction:)];
    [self.iv_comment addGestureRecognizer:imageTapAction];
}

- (void)func_clossClick:(UIButton *)sender {
    [self removeFromSuperview];

}

- (void)func_ImageTapAction:(UITapGestureRecognizer*)sender {
    NSString *App_ID =  [NSString stringWithFormat:@"%@",[[SimpleSDK_DataTools manager].reviewInfo objectForKey:@"appStoreID"]];
 
    NSString *ratingsUrl = [NSString string];
        if (@available(iOS 11, *)){
            // iOS 11以后跳转方法
            ratingsUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",App_ID];
        }else{
            // iOS 11跳转方法
            ratingsUrl = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",App_ID];
        }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ratingsUrl]];
    [SimpleSDK_ViewManager func_showGiftCommentAlterCodeView];
    [self removeFromSuperview];
    
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
//    [self func_setGiftCommentAlterView];
}
@end
