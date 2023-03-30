//
//  SimpleSDK_GiftFloatView.m
//  SimpleSDK
//
//  Created by admin on 2022/3/1.
//

#import "SimpleSDK_GiftFloatView.h"
#import "SimpleSDK_DataTools.h"

@interface SimpleSDK_GiftFloatView()
@property (nonatomic, strong) UIImageView *iv_giftFlaot;
@end

@implementation SimpleSDK_GiftFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(func_TapAction:)];
        [self addGestureRecognizer:tapAction];
       
        [self func_setGiftFloatView];
    }
    return self;
}


-(void)func_setGiftFloatView{
    NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
    NSString *zongRead=[[NSUserDefaults standardUserDefaults] objectForKey:accountStr];
    
    [self addSubview:({
        self.iv_giftFlaot = [[UIImageView alloc] init];
        self.iv_giftFlaot.frame =CGRectMake(kWidth(5), kWidth(5), kWidth(70), kWidth(70));
        self.iv_giftFlaot;
    })];
    
    if (![@"GiftFloatReadHiden" isEqualToString:zongRead]) {
        self.iv_giftFlaot.image = kSetBundleImage(commentsRedImg);
    } else {
        self.iv_giftFlaot.image = kSetBundleImage(commentsImg);
    }
    
    //十秒自动关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)func_TapAction:(UITapGestureRecognizer *)sender {
    
    //返回
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [SimpleSDK_ViewManager func_showGiftCommentAlterView];
        NSString *accountStr = [[SimpleSDK_DataTools manager].userInfo objectForKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults]setObject:@"GiftFloatReadHiden" forKey:accountStr];
        [[NSUserDefaults standardUserDefaults]synchronize];
    });
}

@end
