//
//  SimpleSDK_MenuCollectionViewCell.m
//  SimpleSDK
//
//  Created by admin on 2021/12/22.
//

#import "SimpleSDK_MenuCollectionViewCell.h"

@interface SimpleSDK_MenuCollectionViewCell()
@property (nonatomic, strong) UIImageView *iv_menuImg;
@property (nonatomic, strong) UILabel *lb_menuName;
@end

@implementation SimpleSDK_MenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  func_addNotification];
        [self func_setMenuCollectionView];
    }
    return self;
}

- (void)func_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(void)func_setMenuCollectionView{
    [self.contentView addSubview:({
        self.iv_menuImg = [[UIImageView alloc] init];
        self.iv_menuImg.frame =CGRectMake(self.width/2-kWidth(20), kWidth(2), kWidth(40), kWidth(40));
        
        self.iv_menuImg;
    })];
    [self.contentView addSubview:({
        self.lb_menuName = [[UILabel alloc] init];
        self.lb_menuName.frame = CGRectMake(0, self.iv_menuImg.bottom+kWidth(5), self.width, kWidth(20));
        self.lb_menuName.textAlignment = NSTextAlignmentCenter;
        self.lb_menuName.textColor = color_login_tip;
        self.lb_menuName.font = [UIFont systemFontOfSize:kWidth(16)];
        self.lb_menuName;
    })];
}

- (void)setCellDic:(NSDictionary *)cellDic{
    _cellDic = cellDic;
    self.lb_menuName.text = [NSString stringWithFormat:@"%@",[_cellDic valueForKey:@"name"]];
    NSString *imgPath = [NSString stringWithFormat:@"%@",[_cellDic valueForKey:@"img"]];
    [self.iv_menuImg setImage:kSetBundleImage(imgPath)];
}

#pragma mark ---- Notification ----
- (void)func_didChangeRotate:(NSNotification *)notice {
    [self setNeedsLayout];
    [self func_setMenuCollectionView];
}

@end
